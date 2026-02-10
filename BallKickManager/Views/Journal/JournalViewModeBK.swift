import SwiftUI

struct JournalViewModeBK: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderModeBK(title: "Journal", showSettings: true)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            
                            // History (Completed Tasks)
                            let completedTasks = viewModel.tasks.filter { $0.isCompleted }
                            
                            if !completedTasks.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("TRAINING HISTORY")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                    
                                    ForEach(completedTasks) { task in
                                        // Since it's history, we might just want to show it, or allow navigation to details again?
                                        // Favorites allows navigation. Let's allow navigation here too.
                                        NavigationLink(destination: TaskDetailsViewModeBK(task: task)) {
                                            CardViewModeBK(title: task.title, subtitle: "Completed", image: task.image, fallbackSystemImage: "checkmark.seal.fill", color: .green)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            } else {
                                VStack(spacing: 20) {
                                    Text("No completed sessions yet.")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 20)
                            }
                            
                            // Read Articles
                            let viewedArticles = viewModel.articles.filter { $0.isViewed }
                            
                            if !viewedArticles.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("RECENTLY READ")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal)
                                    
                                    ForEach(viewedArticles) { article in
                                        NavigationLink(destination: ArticleDetailsViewModeBK(article: article)) {
                                            CardViewModeBK(title: article.title, subtitle: "Read", image: article.image, fallbackSystemImage: "doc.text.fill")
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
            .onAppear {
                viewModel.isTabBarHidden = false
            }
        }
    }
}
