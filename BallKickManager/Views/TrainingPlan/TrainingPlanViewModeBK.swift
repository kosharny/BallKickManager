import SwiftUI
import Charts

struct TrainingPlanViewModeBK: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelModeBK
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomHeaderModeBK(title: "Training Plan", showBack: true, backAction: {
                    dismiss()
                })
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // User Goals Summary
                        VStack(alignment: .leading, spacing: 10) {
                            Text("YOUR GOAL: \(viewModel.userGoal.uppercased())")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.currentTheme.mainColor)
                            
                            HStack {
                                StatBadge(icon: "figure.soccer", label: viewModel.userDominantLeg)
                                StatBadge(icon: "scalemass", label: "\(viewModel.userWeight) kg")
                                StatBadge(icon: "ruler", label: "\(viewModel.userHeight) cm")
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Progress Chart
                        VStack(alignment: .leading, spacing: 10) {
                            Text("PERFORMANCE PROJECTION")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            Chart {
                                ForEach(0..<4, id: \.self) { week in
                                    LineMark(
                                        x: .value("Week", "Week \(week + 1)"),
                                        y: .value("Performance", (week + 1) * 20 + Int.random(in: -5...5))
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .symbol(by: .value("Type", "Expected"))
                                }
                            }
                            .frame(height: 200)
                            .foregroundColor(viewModel.currentTheme.mainColor)
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        
                        // Upcoming Schedule
                        VStack(alignment: .leading, spacing: 16) {
                            Text("UPCOMING PHASE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            ForEach(1...4, id: \.self) { week in
                                HStack {
                                    Circle()
                                        .fill(week == 1 ? viewModel.currentTheme.mainColor : Color.gray)
                                        .frame(width: 10, height: 10)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Week \(week)")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Text(week == 1 ? "Focus: Fundamentals" : "Locked")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    if week == 1 {
                                        Image(systemName: "play.circle.fill")
                                            .foregroundColor(viewModel.currentTheme.mainColor)
                                    } else {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(.gray)
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
                    .padding(.top)
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

struct StatBadge: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK // Inject ViewModel
    let icon: String
    let label: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(viewModel.currentTheme.mainColor)
            Text(label)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.3))
        .cornerRadius(20)
    }
}
