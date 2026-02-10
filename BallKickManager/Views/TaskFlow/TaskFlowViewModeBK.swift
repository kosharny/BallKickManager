import SwiftUI

struct TaskFlowViewModeBK: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelModeBK
    let task: TaskModeBK
    
    @State private var currentStepIndex = 0
    @State private var isFinished = false
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
            
            if isFinished {
                TaskFinishAppModeBK(task: task) // Shows finish screen
            } else {
                VStack {
                    // Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text(task.title.uppercased())
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // Placeholder for symmetry
                        Color.clear.frame(width: 44, height: 44)
                    }
                    .padding()
                    
                    // Current Step View
                    if currentStepIndex < task.steps.count {
                        TaskStepViewModeBK(
                            step: task.steps[currentStepIndex],
                            stepIndex: currentStepIndex + 1,
                            totalSteps: task.steps.count,
                            theme: viewModel.currentTheme,
                            onNext: {
                                withAnimation {
                                    if currentStepIndex < task.steps.count - 1 {
                                        currentStepIndex += 1
                                    } else {
                                        isFinished = true
                                        viewModel.completeTask(taskId: task.id, duration: task.totalTime)
                                    }
                                }
                            }
                        )
                        .id(currentStepIndex) // Force transitions
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.isTabBarHidden = true
        }
    }
}

