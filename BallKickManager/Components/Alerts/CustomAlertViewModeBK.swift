import SwiftUI

struct CustomAlertViewModeBK: View {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    let secondaryButtonTitle: String?
    let secondaryAction: (() -> Void)?
    
    // Default theme color if not provided, or passed via environment
    var themeColor: Color = .yellow
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    // Optional: dismiss on background tap if desired
                }
            
            // Alert Content
            VStack(spacing: 20) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    Button(action: primaryAction) {
                        Text(primaryButtonTitle)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeColor)
                            .cornerRadius(12)
                    }
                    
                    if let secondaryTitle = secondaryButtonTitle, let secondaryAction = secondaryAction {
                        Button(action: secondaryAction) {
                            Text(secondaryTitle)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.top, 10)
            }
            .padding(24)
            .background(
                ZStack {
                    Color.black
                    Color.white.opacity(0.05)
                }
            )
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(themeColor.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 40)
            .shadow(color: themeColor.opacity(0.2), radius: 20)
        }
    }
}

// Preview Provider
struct CustomAlertViewModeBK_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertViewModeBK(
            title: "Unlock Theme",
            message: "Purchase 'Sunset Orange' for $1.99? This is a one-time purchase.",
            primaryButtonTitle: "Purchase",
            primaryAction: {},
            secondaryButtonTitle: "Cancel",
            secondaryAction: {},
            themeColor: .orange
        )
    }
}
