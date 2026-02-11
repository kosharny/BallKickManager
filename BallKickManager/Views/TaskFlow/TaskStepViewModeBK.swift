import SwiftUI
import Combine

struct TaskStepViewModeBK: View {
    let step: StepModeBK
    let stepIndex: Int
    let totalSteps: Int
    let onNext: () -> Void
    var theme: ThemeModeBK
    
    @State private var timeRemaining: TimeInterval
    @State private var isRunning = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(step: StepModeBK, stepIndex: Int, totalSteps: Int, theme: ThemeModeBK, onNext: @escaping () -> Void) {
        self.step = step
        self.stepIndex = stepIndex
        self.totalSteps = totalSteps
        self.theme = theme
        self.onNext = onNext
        _timeRemaining = State(initialValue: step.duration)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            // Progress
            HStack {
                Text("STEP \(stepIndex) / \(totalSteps)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal)
            
            // Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Text(step.title.uppercased())
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(step.description)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                    
                    // Timer if applicable
                    if step.isTimer {
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 20)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(timeRemaining / step.duration))
                                .stroke(theme.mainColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: 1), value: timeRemaining)
                            
                            VStack {
                                Text("\(Int(timeRemaining))")
                                    .font(.system(size: 60, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                Text("SECONDS")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 200, height: 200)
                        .padding()
                        .onReceive(timer) { _ in
                            if isRunning && timeRemaining > 0 {
                                timeRemaining -= 1
                            } else if timeRemaining <= 0 {
                                // Manual advance
                                isRunning = false
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            
            // Controls
            HStack(spacing: 20) {
                if step.isTimer {
                    Button(action: { isRunning.toggle() }) {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                            .background(theme.mainColor)
                            .clipShape(Circle())
                    }
                }
                
                Button(action: onNext) {
                    Text("NEXT STEP")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .onAppear {
            isRunning = true // Auto-start timer
        }
    }
}
