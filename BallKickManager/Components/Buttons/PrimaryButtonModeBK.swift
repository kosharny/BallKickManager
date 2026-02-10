import SwiftUI

struct PrimaryButtonModeBK: View {
    let title: String
    let action: () -> Void
    var color: Color = .yellow
    
    var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
                )
        }
    }
}

#Preview {
    ZStack {
        Color.black
        PrimaryButtonModeBK(title: "Start Training", action: {})
            .padding()
    }
}
