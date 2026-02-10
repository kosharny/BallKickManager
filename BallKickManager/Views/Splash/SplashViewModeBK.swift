import SwiftUI

struct SplashViewModeBK: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    @State private var isActive: Bool = false
    @State private var opacity: Double = 0.0
    
    @State private var rotation: Double = 0.0
    @State private var trimValue: CGFloat = 0.0
    @State private var shimmerOffset: CGFloat = -1.0
    
    var body: some View {
        if isActive {
            if viewModel.isOnboardingCompleted {
                ContentViewModeBK()
            } else {
                OnboardingViewModeBK()
            }
        } else {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: trimValue)
                            .stroke(
                                LinearGradient(colors: [.yellow.opacity(0.5), .yellow, .clear], startPoint: .leading, endPoint: .trailing),
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(-90))
                        
                        Image("mainLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .rotationEffect(.degrees(rotation))
                    }
                    
                    Text("BALLKICK\nMANAGER")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .overlay(
                            Text("BALLKICK\nMANAGER")
                                .font(.system(size: 32, weight: .heavy, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .mask(
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.clear, .white, .clear]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .scaleEffect(x: 0.5)
                                        .offset(x: shimmerOffset * 200)
                                )
                        )
                }
                .opacity(opacity)
            }
            .onAppear {
                withAnimation(.easeIn(duration: 0.8)) {
                    self.opacity = 1.0
                }
                
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    rotation = 15
                }
                
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    trimValue = 1.0
                }
                
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    shimmerOffset = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashViewModeBK()
        .environmentObject(MainViewModelModeBK())
}
