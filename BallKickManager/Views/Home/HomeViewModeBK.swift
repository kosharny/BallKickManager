import SwiftUI

struct HomeViewModeBK: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background handles by parent ZStack usually, but safe to add transparently if needed
                
                ScrollView {
                    VStack(spacing: 24) {
                        CustomHeaderModeBK(title: "Dashboard", showSettings: true, settingsAction: {
                            showSettings = true
                        })
                        
                        // Training Plan Card
                        NavigationLink(destination: TrainingPlanViewModeBK()) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("YOUR TRAINING PLAN")
                                        .font(.headline)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                    
                                    Text("Focus: \(viewModel.userGoal)")
                                        .font(.subheadline)
                                        .foregroundColor(.black.opacity(0.7))
                                    
                                    HStack {
                                        Image(systemName: "chart.xyaxis.line")
                                        Text("View Progress")
                                    }
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.top, 4)
                                }
                                Spacer()
                                Image(systemName: "figure.run.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(viewModel.currentTheme.mainColor)
                            .cornerRadius(20)
                            .shadow(color: viewModel.currentTheme.mainColor.opacity(0.3), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                        }
                        
                        // Hero Section / Personalized Daily Focus
                        VStack(alignment: .leading, spacing: 16) {
                            Text("DAILY FOCUS FOR YOU")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.currentTheme.mainColor)
                                .tracking(1)
                            
                            // Filter tasks based on goal if possible, else random
                            let recommendedTasks = viewModel.tasks.filter { $0.description.contains(viewModel.userGoal) || $0.title.contains(viewModel.userGoal) }
                            let taskToShow = recommendedTasks.first ?? viewModel.tasks.first
                            
                            if let featuredTask = taskToShow {
                                NavigationLink(destination: TaskDetailsViewModeBK(task: featuredTask)) {
                                    FeaturedCardView(task: featuredTask)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Recommended Workouts
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("RECOMMENDED WORKOUTS")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.currentTheme.mainColor)
                                    .tracking(1)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.tasks.prefix(4)) { task in
                                        NavigationLink(destination: TaskDetailsViewModeBK(task: task)) {
                                            CardViewModeBK(title: task.title, subtitle: "\(Int(task.totalTime/60)) min", image: task.image, fallbackSystemImage: "figure.run")
                                                .frame(width: 160)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Boot Recommendation Card
                        NavigationLink(destination: BootRecommendationViewModeBK()) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("SELECT YOUR BOOTS")
                                        .font(.headline)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                    
                                    Text("Find the perfect pair for your game and surface.")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                                Image(systemName: "shoe.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(
                                LinearGradient(colors: [viewModel.currentTheme.mainColor, viewModel.currentTheme.mainColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(20)
                            .shadow(color: viewModel.currentTheme.mainColor.opacity(0.3), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                        }
                        
                        // Recent Articles Grid
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("LATEST INSIGHTS")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.currentTheme.mainColor)
                                    .tracking(1)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(viewModel.articles.prefix(4)) { article in
                                    NavigationLink(destination: ArticleDetailsViewModeBK(article: article)) {
                                        CardViewModeBK(title: article.title, subtitle: article.category, image: article.image, fallbackSystemImage: "doc.text.fill")
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showSettings) {
                SettingsViewModeBK()
            }
            .onAppear {
                viewModel.isTabBarHidden = false
            }
        }
    }
}

// Subcomponents for HomeView locally scoped or moved if needed
struct FeaturedCardView: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    let task: TaskModeBK
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            if let _ = UIImage(named: task.image) {
                Image(task.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 220)
                    .clipped()
                    .overlay(
                        LinearGradient(colors: [.clear, .black.opacity(0.9)], startPoint: .center, endPoint: .bottom)
                    )
            } else {
                viewModel.currentTheme.mainColor.opacity(0.8)
                    .frame(height: 220)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("FEATURED WORKOUT")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(viewModel.currentTheme.mainColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                    Spacer()
                }
                
                Text(task.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(viewModel.currentTheme.mainColor)
                        .font(.caption)
                    Text("\(Int(task.totalTime / 60)) min")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.caption)
                    
                    Spacer()
                }
            }
            .padding()
        }
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct StatBox: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// Stubs removed - using global definitions
