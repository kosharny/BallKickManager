import SwiftUI

struct CustomHeaderModeBK: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK // Inject ViewModel
    let title: String
    var showBack: Bool = false
    var showSettings: Bool = false
    var backAction: (() -> Void)?
    var settingsAction: (() -> Void)?
    
    var body: some View {
        HStack {
            if showBack {
                Button(action: {
                    backAction?()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(viewModel.currentTheme.mainColor)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
            } else {
                Spacer().frame(width: 44) // Balance layout
            }
            
            Spacer()
            
            Text(title.uppercased())
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .tracking(2)
            
            Spacer()
            
            if showSettings {
                Button(action: {
                    settingsAction?()
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(viewModel.currentTheme.mainColor)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
            } else {
                Spacer().frame(width: 44) // Balance layout
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.5)) // Semi-transparent header background
    }
}

#Preview {
    ZStack {
        Color.gray
        CustomHeaderModeBK(title: "Home", showBack: true, showSettings: true)
    }
}
