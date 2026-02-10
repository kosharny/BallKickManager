import SwiftUI

struct PurchaseCardViewModeBK: View {
    let title: String
    let price: String
    let description: String
    let isLocked: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                }
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                Spacer()
                Text(price)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isLocked ? Color.gray : Color.yellow, lineWidth: 1)
        )
    }
}
