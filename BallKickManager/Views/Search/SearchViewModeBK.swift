import SwiftUI

struct SearchViewModeBK: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    @State private var searchText = ""
    @State private var showSettings = false
    @State private var selectedCategory: String = "All"
    
    // Derive unique categories from articles
    var categories: [String] {
        var cats = Set(viewModel.articles.map { $0.category })
        cats.insert("All") // Add default
        return Array(cats).sorted()
    }
    
    var filteredArticles: [ArticleModeBK] {
        let textFiltered = searchText.isEmpty ? viewModel.articles : viewModel.articles.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        
        if selectedCategory == "All" {
            return textFiltered
        } else {
            return textFiltered.filter { $0.category == selectedCategory }
        }
    }
    
    var filteredTasks: [TaskModeBK] {
        // Tasks don't have categories in this model, so we only filter by text
        // If a category is selected (other than All), we might want to hide tasks or show all? 
        // Let's assume we hide tasks if a specific Article Category is selected, or we could just ignore category for tasks.
        // User request: "Add filters to SearchViewModeBK for searching by category."
        // Given tasks don't have categories, let's only show tasks when "All" is selected or if we map difficulty/title to category? 
        // Safer approach: Only show tasks if "All" is selected OR filter tasks by text regardless. 
        // Let's stick to: Tasks appear in "All", but if a specific Article Category is chosen, maybe hide them to reduce noise?
        // Actually, let's just keep tasks filtering by text only, effectively ignoring the category filter (since it applies to articles).
        // OR better: Hide tasks if specific Article category is selected to be strict.
        
        if selectedCategory != "All" {
            return []
        }
        
        if searchText.isEmpty { return viewModel.tasks }
        return viewModel.tasks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderModeBK(title: "Search", showSettings: true, settingsAction: {
                        showSettings = true
                    })
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Find articles or drills...", text: $searchText)
                            .foregroundColor(.white)
                            .accentColor(viewModel.currentTheme.mainColor)
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Category Filter Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    withAnimation {
                                        selectedCategory = category
                                    }
                                }) {
                                    Text(category)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(selectedCategory == category ? viewModel.currentTheme.mainColor : Color.white.opacity(0.1))
                                        .foregroundColor(selectedCategory == category ? .black : .white)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            
                            // TASKS SECTION
                            if !filteredTasks.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("TASKS")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray) // Matching Favorites style
                                        .padding(.horizontal)
                                    
                                    ForEach(filteredTasks) { task in
                                        NavigationLink(destination: TaskDetailsViewModeBK(task: task)) {
                                            CardViewModeBK(title: task.title, subtitle: "\(Int(task.totalTime/60)) min", image: task.image, fallbackSystemImage: "figure.run")
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // ARTICLES SECTION
                            if !filteredArticles.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("ARTICLES")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                    
                                    ForEach(filteredArticles) { article in
                                        NavigationLink(destination: ArticleDetailsViewModeBK(article: article)) {
                                            CardViewModeBK(title: article.title, subtitle: article.category, image: article.image, fallbackSystemImage: "doc.text.fill")
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.top)
                    }
                }
            }
            .fullScreenCover(isPresented: $showSettings) {
                SettingsViewModeBK()
            }
            .onAppear {
                viewModel.isTabBarHidden = false
            }
        }
    }
}
