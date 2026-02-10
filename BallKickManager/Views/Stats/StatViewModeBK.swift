import SwiftUI
import Charts // iOS 16+

struct StatViewModeBK: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderModeBK(title: "Statistics", showSettings: true)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            
                            // Overview Cards
                            HStack(spacing: 16) {
                                StatCard(title: "Time", value: String(format: "%.0f m", viewModel.stats.totalTrainingTime / 60), icon: "clock.fill", color: .blue)
                                StatCard(title: "Tasks", value: "\(viewModel.stats.completedTasksCount)", icon: "checkmark.seal.fill", color: .green)
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 16) {
                                StatCard(title: "Streak", value: "\(viewModel.stats.streakDays)", icon: "flame.fill", color: .orange)
                                StatCard(title: "Calories", value: "\(viewModel.stats.completedTasksCount * 150)", icon: "bolt.heart.fill", color: .red) 
                            }
                            .padding(.horizontal)
                            
                            // Activity Chart (Mock Data for Visual)
                            VStack(alignment: .leading, spacing: 10) {
                                Text("ACTIVITY")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Chart {
                                    BarMark(x: .value("Day", "Mon"), y: .value("Mins", 30))
                                    BarMark(x: .value("Day", "Tue"), y: .value("Mins", 45))
                                    BarMark(x: .value("Day", "Wed"), y: .value("Mins", 20))
                                    BarMark(x: .value("Day", "Thu"), y: .value("Mins", 60))
                                    BarMark(x: .value("Day", "Fri"), y: .value("Mins", viewModel.stats.totalTrainingTime / 60)) // Real data
                                    BarMark(x: .value("Day", "Sat"), y: .value("Mins", 90))
                                    BarMark(x: .value("Day", "Sun"), y: .value("Mins", 15))
                                }
                                .frame(height: 200)
                                .foregroundColor(viewModel.currentTheme.mainColor)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(16)
                            .padding(.horizontal)
                            
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

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .padding(8)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}
