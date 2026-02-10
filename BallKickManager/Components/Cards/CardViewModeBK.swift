import SwiftUI

struct CardViewModeBK: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    let title: String
    let subtitle: String?
    let image: String
    var fallbackSystemImage: String? = nil
    var color: Color? = nil // Optional override
    
    var effectiveColor: Color {
        color ?? viewModel.currentTheme.mainColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section
            if let _ = UIImage(named: image) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipped()
            } else {
                ZStack {
                    effectiveColor.opacity(0.1)
                    Image(systemName: fallbackSystemImage ?? image) // Fallback to system name
                        .font(.largeTitle)
                        .foregroundColor(effectiveColor)
                }
                .frame(height: 100)
            }
            
            // Text Section
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .padding(12)
        }
        .background(Color(UIColor.systemGray6).opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Color.black
        CardViewModeBK(title: "Master the Kick", subtitle: "Training Module", image: "figure.soccer")
            .padding()
    }
}
