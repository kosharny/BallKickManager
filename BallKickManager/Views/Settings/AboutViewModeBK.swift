import SwiftUI

struct AboutViewModeBK: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelModeBK
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomHeaderModeBK(title: "About", showBack: true, backAction: {
                    dismiss()
                })
                
                ScrollView {
                    VStack(spacing: 24) {
                        Image("mainLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                        
                        Text("BallKick Manager")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("The ultimate offline training companion for football enthusiasts. Master your kick, track your stats, and improve your game.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.8))
                            .padding()
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
