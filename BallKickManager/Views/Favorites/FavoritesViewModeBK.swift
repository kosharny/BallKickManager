import SwiftUI

struct FavoritesViewModeBK: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderModeBK(title: "Favorites", showSettings: true)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            let favoriteArticles = viewModel.articles.filter { $0.isFavorite }
                            let favoriteTasks = viewModel.tasks.filter { $0.isFavorite }
                            
                            if favoriteArticles.isEmpty && favoriteTasks.isEmpty {
                                EmptyFavoritesView()
                            } else {
                                // Articles Section
                                if !favoriteArticles.isEmpty {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("SAVED ARTICLES")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal)
                                        
                                        ForEach(favoriteArticles) { article in
                                            NavigationLink(destination: ArticleDetailsViewModeBK(article: article)) {
                                                CardViewModeBK(title: article.title, subtitle: article.category, image: article.image, fallbackSystemImage: "doc.text.fill")
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                
                                // Tasks Section
                                if !favoriteTasks.isEmpty {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("SAVED WORKOUTS")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal)
                                        
                                        ForEach(favoriteTasks) { task in
                                            NavigationLink(destination: TaskDetailsViewModeBK(task: task)) {
                                                CardViewModeBK(title: task.title, subtitle: "\(Int(task.totalTime/60)) min", image: task.image, fallbackSystemImage: "figure.run")
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.top)
                    }
                }
            }
            .onAppear {
                viewModel.isTabBarHidden = false
            }
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No favorites yet")
                .font(.title3)
                .foregroundColor(.gray)
            Text("Tap the star icon on articles or workouts to save them here.")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 100)
    }
}
