import SwiftUI

struct ArticleDetailsViewModeBK: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelModeBK
    let article: ArticleModeBK
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header with Back Button
                CustomHeaderModeBK(title: "Article", showBack: true, backAction: {
                    dismiss()
                })
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Header Image
                        if let _ = UIImage(named: article.image) {
                            Image(article.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(20)
                        }
                        
                        // Title Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text(article.title.uppercased())
                                .font(.system(size: 28, weight: .heavy, design: .rounded))
                                .foregroundColor(viewModel.currentTheme.mainColor)
                            
                            Text(article.subtitle)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top)
                        
                        // Action Bar (Favorite)
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.toggleFavorite(articleId: article.id)
                            }) {
                                HStack {
                                    Image(systemName: article.isFavorite ? "star.fill" : "star")
                                        .foregroundColor(article.isFavorite ? viewModel.currentTheme.mainColor : .gray)
                                    Text(article.isFavorite ? "SAVED" : "SAVE TO FAVORITES")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(20)
                            }
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        // Body Content
                        VStack(spacing: 16) {
                            ForEach(article.body, id: \.self) { paragraph in
                                Text(paragraph)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .lineSpacing(6)
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            }
                        }
                        
                        // Tips / Motivation Box (Simulated)
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(viewModel.currentTheme.mainColor)
                                Text("PRO TIP")
                                    .font(.headline)
                                    .foregroundColor(viewModel.currentTheme.mainColor)
                            }
                            
                            Text("Consistency is key. Even 15 minutes a day can make a huge difference in your technique over time.")
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding()
                        .background(viewModel.currentTheme.mainColor.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.currentTheme.mainColor.opacity(0.3), lineWidth: 1)
                        )
                        
                        // Mark as Read Button
                        Button(action: {
                            viewModel.markArticleViewed(articleId: article.id)
                        }) {
                            Text(article.isViewed ? "READ" : "MARK AS READ")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.currentTheme.buttonGradient)
                                .cornerRadius(16)
                                .opacity(article.isViewed ? 0.6 : 1.0)
                        }
                        .disabled(article.isViewed)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.isTabBarHidden = true
        }
        .onDisappear {
            viewModel.isTabBarHidden = false
        }
    }
}

