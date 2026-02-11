import SwiftUI

struct TaskFinishAppModeBK: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelModeBK
    let task: TaskModeBK
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.green)
                    .shadow(color: .green.opacity(0.5), radius: 20)
                
                VStack(spacing: 10) {
                    Text("TRAINING COMPLETE!")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("Great job on finishing '\(task.title)'")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 20) {
                    FinishStatRow(label: "Time", value: "\(Int(task.totalTime / 60)) min")
                    FinishStatRow(label: "Steps", value: "\(task.steps.count)")
                    FinishStatRow(label: "XP Earned", value: "+100")
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(20)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    // Navigate back to root or Home (dismiss all)
                    // Since we are in a NavStack, usually we pop to root.
                    // For now, dismiss works if we are presented modally or pushed.
                    // A better way is binding to root path.
                    // But standard dismiss pop one level back.
                    // We need to pop all the way back.
                    // Simplest is usually using a binding to isActive or similar from the parent.
                    // Or Environment toggle.
                    dismiss()
                }) {
                    Text("FINISH")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.currentTheme.buttonGradient)
                        .cornerRadius(16)
                        .shadow(color: viewModel.currentTheme.mainColor.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.completeTask(taskId: task.id, duration: task.totalTime)
        }
        .onAppear {
            viewModel.isTabBarHidden = true
        }
    }
}

struct FinishStatRow: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK // Inject ViewModel
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundColor(viewModel.currentTheme.mainColor)
        }
    }
}

