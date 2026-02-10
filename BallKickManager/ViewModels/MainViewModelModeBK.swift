import SwiftUI
import Combine

class MainViewModelModeBK: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var selectedTab: TabModeBK = .home
    @Published var currentTheme: ThemeModeBK = .defaultTheme
    @Published var isOnboardingCompleted: Bool = false
    @Published var isTabBarHidden: Bool = false
    
    // User Profile
    @Published var userDominantLeg: String = "Right"
    @Published var userHeight: String = ""
    @Published var userWeight: String = ""
    @Published var userGoal: String = "Technique"
    
    @Published var articles: [ArticleModeBK] = []
    @Published var tasks: [TaskModeBK] = []
    @Published var stats: StatModeBK = StatModeBK()
    
    @Published var navigationPath = NavigationPath()
    
    // MARK: - Dependencies
    let storeManager = StoreManagerModeBK()
    private let storageService = StorageService.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Premium Logic
    @Published var premiumEnabled: Bool = false
    
    // MARK: - Initialization
    
    init() {
        loadData()
        loadPreferences() // Load preferences first to get saved theme
        setupStore()      // Then setup store to validate theme
    }
    
    private func setupStore() {
        // Combine purchased IDs and loaded state to ensure we don't revert prematurely
        StoreManagerModeBK.shared.$purchasedProductIDs
            .combineLatest(StoreManagerModeBK.shared.$isPurchasesLoaded)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] purchasedIDs, isLoaded in
                guard let self = self else { return }
                
                // Only validate if we are actually loaded
                guard isLoaded else { return }
                
                let isPremium = !purchasedIDs.isEmpty
                self.premiumEnabled = isPremium
                
                // Validate current theme access
                if self.currentTheme.isPremium {
                    if !StoreManagerModeBK.shared.hasAccess(to: self.currentTheme) {
                        // Revert to default if lost access
                        print("🔒 Theme access revoked or not found. Reverting to default.")
                        self.currentTheme = .defaultTheme
                        UserDefaults.standard.set(ThemeModeBK.defaultTheme.rawValue, forKey: "selectedTheme")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Loading
    
    private func loadData() {
        // Load Articles
        if let loadedArticles = storageService.load([ArticleModeBK].self, forKey: "saved_articles") {
            self.articles = loadedArticles
        } else {
            // Load from JSON if not saved in defaults
            if let jsonArticles = storageService.loadJSON("articles", type: [ArticleModeBK].self) {
                self.articles = jsonArticles
                // Sychronize immediately to ensure we have a baseline in persistence
                storageService.save(articles, forKey: "saved_articles")
            }
        }
        
        // Load Tasks
        if let loadedTasks = storageService.load([TaskModeBK].self, forKey: "saved_tasks") {
            self.tasks = loadedTasks
        } else {
            if let jsonTasks = storageService.loadJSON("tasks", type: [TaskModeBK].self) {
                self.tasks = jsonTasks
                storageService.save(tasks, forKey: "saved_tasks")
            }
        }
        
        // Load Stats
        if let loadedStats = storageService.load(StatModeBK.self, forKey: "user_stats") {
            self.stats = loadedStats
        }
        
        // Load User Profile
        userDominantLeg = UserDefaults.standard.string(forKey: "userDominantLeg") ?? "Right"
        userHeight = UserDefaults.standard.string(forKey: "userHeight") ?? ""
        userWeight = UserDefaults.standard.string(forKey: "userWeight") ?? ""
        userGoal = UserDefaults.standard.string(forKey: "userGoal") ?? "Technique"
    }
    
    private func loadPreferences() {
        self.isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
        
        if let savedThemeRaw = UserDefaults.standard.string(forKey: "selectedTheme"),
           let savedTheme = ThemeModeBK(rawValue: savedThemeRaw) {
            self.currentTheme = savedTheme
        }
    }
    
    // MARK: - Persistence
    
    func saveData() {
        storageService.save(articles, forKey: "saved_articles")
        storageService.save(tasks, forKey: "saved_tasks")
        storageService.save(stats, forKey: "user_stats")
        
        UserDefaults.standard.set(userDominantLeg, forKey: "userDominantLeg")
        UserDefaults.standard.set(userHeight, forKey: "userHeight")
        UserDefaults.standard.set(userWeight, forKey: "userWeight")
        UserDefaults.standard.set(userGoal, forKey: "userGoal")
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
        UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
        saveData()
    }
    
    func selectTheme(_ theme: ThemeModeBK) {
        if theme.isPremium {
            if !StoreManagerModeBK.shared.hasAccess(to: theme) {
                return
            }
        }

        self.currentTheme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
    }
    
    // Deprecated: Alias for existing calls, route to selectTheme
    func setTheme(_ theme: ThemeModeBK) {
        selectTheme(theme)
    }
    
    // MARK: - Logic
    
    func toggleFavorite(articleId: String) {
        if let index = articles.firstIndex(where: { $0.id == articleId }) {
            articles[index].isFavorite.toggle()
            storageService.save(articles, forKey: "saved_articles")
        }
    }
    
    func toggleTaskFavorite(taskId: String) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].isFavorite.toggle()
            storageService.save(tasks, forKey: "saved_tasks")
        }
    }
    
    func markArticleViewed(articleId: String) {
        if let index = articles.firstIndex(where: { $0.id == articleId }) {
            if !articles[index].isViewed {
                articles[index].isViewed = true
                storageService.save(articles, forKey: "saved_articles")
            }
        }
    }
    
    func completeTask(taskId: String, duration: TimeInterval) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            let now = Date()
            
            // simple debounce: prevent double counting if called within 5 seconds
            if let lastDate = stats.lastTrainingDate, now.timeIntervalSince(lastDate) < 5 {
                return
            }
            
            tasks[index].isCompleted = true
            
            stats.completedTasksCount += 1
            stats.totalTrainingTime += duration
            
            // Streak logic
            if let last = stats.lastTrainingDate, !Calendar.current.isDateInToday(last) {
                // If last was yesterday (or before), increment streak?
                // For simplicity, just increment if it's a new day or first time
                stats.streakDays += 1
            } else if stats.streakDays == 0 {
                stats.streakDays = 1
            }
            
            stats.lastTrainingDate = now
            saveData()
        }
    }
}

enum TabModeBK {
    case home, journal, search, favorites, stats
}
