import SwiftUI

struct BackgroundViewModeBK: View {
    var theme: ThemeModeBK = .defaultTheme
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            theme.backgroundGradient
                .ignoresSafeArea()
            
            // Add subtle noise or texture if needed
            // For now, clean gradient
        }
    }
}

#Preview {
    BackgroundViewModeBK()
}
