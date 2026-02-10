import SwiftUI

struct BootRecommendationViewModeBK: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelModeBK
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomHeaderModeBK(title: "Boot Guide", showBack: true, backAction: {
                    dismiss()
                })
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Hero Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "shoe.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(viewModel.currentTheme.mainColor)
                                Spacer()
                            }
                            
                            Text("CHOOSING THE RIGHT BOOTS")
                                .font(.system(size: 28, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Your boots are your most important tool. Wearing the wrong type can lead to poor performance and even injury.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(4)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(20)
                        
                        // Surface Types
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "1. KNOW YOUR SURFACE")
                            
                            SurfaceCard(
                                title: "Firm Ground (FG)",
                                code: "FG",
                                description: "For natural grass pitches that are dry or slightly wet. The most common stud type.",
                                icon: "leaf.fill"
                            )
                            
                            SurfaceCard(
                                title: "Artificial Grass (AG)",
                                code: "AG",
                                description: "Designed for modern synthetic turf. Shorter, hollow studs to prevent sticking and injury.",
                                icon: "circle.grid.hex.fill"
                            )
                            
                            SurfaceCard(
                                title: "Soft Ground (SG)",
                                code: "SG",
                                description: "For wet, muddy natural grass. Metal studs provide deep penetration for traction.",
                                icon: "drop.fill"
                            )
                            
                            SurfaceCard(
                                title: "Turf (TF)",
                                code: "TF",
                                description: "For carpet-like astro turf or concrete. Many small rubber studs.",
                                icon: "carpet.fill"
                            )
                            
                            SurfaceCard(
                                title: "Indoor (IC)",
                                code: "IC",
                                description: "Flat rubber sole for indoor courts or street football.",
                                icon: "building.2.fill"
                            )
                        }
                        
                        // Materials
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "2. CHOOSE MATERIAL")
                            
                            MaterialCard(
                                title: "Leather",
                                description: "Molds to your foot, offers great touch and comfort. Heavier and absorbs water.",
                                cons: "Requires maintenance."
                            )
                            
                            MaterialCard(
                                title: "Synthetic",
                                description: "Lightweight, durable, and water-resistant. Doesn't stretch as much.",
                                cons: "Less natural feel initially."
                            )
                            
                            MaterialCard(
                                title: "Knitted",
                                description: "Sock-like fit, extremely comfortable and lightweight.",
                                cons: "Less protection, expensive."
                            )
                        }
                        
                        // Sizing Tips
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "ruler.fill")
                                    .foregroundColor(viewModel.currentTheme.mainColor)
                                Text("SIZING TIP")
                                    .font(.headline)
                                    .foregroundColor(viewModel.currentTheme.mainColor)
                            }
                            
                            Text("There should be about a thumb's width (or slightly less) of space between your toes and the end of the boot. Football boots should feel snug, not tight.")
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding()
                        .background(viewModel.currentTheme.mainColor.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.currentTheme.mainColor.opacity(0.3), lineWidth: 1)
                        )
                        
                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.isTabBarHidden = true
        }
        .onDisappear {
            viewModel.isTabBarHidden = false
        }
    }
    
    @ViewBuilder
    func SectionHeader(title: String) -> some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(viewModel.currentTheme.mainColor)
            .padding(.top, 8)
    }
    
    @ViewBuilder
    func SurfaceCard(title: String, code: String, description: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Text(code)
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(viewModel.currentTheme.mainColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.white.opacity(0.03))
        .cornerRadius(12)
    }
    
    @ViewBuilder
    func MaterialCard(title: String, description: String, cons: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Note: \(cons)")
                .font(.caption)
                .foregroundColor(viewModel.currentTheme.mainColor)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.03))
        .cornerRadius(12)
    }
}
