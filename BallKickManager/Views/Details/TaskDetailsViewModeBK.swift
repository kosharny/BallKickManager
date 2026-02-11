import SwiftUI

struct TaskDetailsViewModeBK: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelModeBK
    let task: TaskModeBK
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomHeaderModeBK(title: "Training Plan", showBack: true, backAction: {
                    dismiss()
                })
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Header Image
                        if let _ = UIImage(named: task.image) {
                            Image(task.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(20)
                        } else {
                            // Fallback
                            Image(systemName: "figure.soccer")
                                .font(.system(size: 60))
                                .foregroundColor(viewModel.currentTheme.mainColor)
                                .frame(height: 150)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(20)
                        }
                        
                        // Header Info
                        VStack(alignment: .leading, spacing: 10) {
                            Text(task.title.uppercased())
                                .font(.system(size: 32, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            
                            HStack {
                                Label("\(Int(task.totalTime / 60)) min", systemImage: "clock")
                                    .foregroundColor(viewModel.currentTheme.mainColor)
                                Spacer()
                                ForEach(0..<3) { i in
                                    Image(systemName: i < task.difficulty ? "bolt.fill" : "bolt")
                                        .foregroundColor(i < task.difficulty ? viewModel.currentTheme.mainColor : .gray)
                                }
                            }
                            .font(.headline)
                            
                            Text(task.description)
                                .foregroundColor(.gray)
                                .padding(.top, 5)
                        }
                            .padding()
                        
                        // Action Bar (Favorite)
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.toggleTaskFavorite(taskId: task.id)
                            }) {
                                HStack {
                                    Image(systemName: task.isFavorite ? "star.fill" : "star")
                                        .foregroundColor(task.isFavorite ? viewModel.currentTheme.mainColor : .gray)
                                    Text(task.isFavorite ? "SAVED" : "SAVE TO FAVORITES")
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
                        .padding(.horizontal)
                        
                        // Steps List
                        VStack(alignment: .leading, spacing: 16) {
                            Text("SESSION BREAKDOWN")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            ForEach(Array(task.steps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 16) {
                                    Text("\(index + 1)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .frame(width: 40, height: 40)
                                        .background(Circle().fill(viewModel.currentTheme.mainColor))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(step.title)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text(step.description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .lineLimit(2)
                                        
                                        Text("\(Int(step.duration)) sec")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(viewModel.currentTheme.mainColor)
                                            .padding(.top, 2)
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
                
                // Start Button Wrapper
                VStack {
                    NavigationLink(destination: TaskFlowViewModeBK(task: task)) {
                        Text("START TRAINING")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.currentTheme.buttonGradient)
                            .cornerRadius(16)
                            .shadow(color: viewModel.currentTheme.mainColor.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                    .padding()
                }
                .background(Color.black.blur(radius: 20))
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.isTabBarHidden = true
        }
    }
}

