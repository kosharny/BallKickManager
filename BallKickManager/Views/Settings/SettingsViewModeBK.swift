import SwiftUI

struct SettingsViewModeBK: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelModeBK
    @StateObject private var store = StoreManagerModeBK.shared
    
    // Local state for paywall
    @State private var selectedThemeForPaywall: ThemeModeBK?
    
    // Alert state for restore
    @State private var showRestoreAlert = false
    @State private var restoreMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomHeaderModeBK(title: "Settings", showBack: true, backAction: {
                        dismiss()
                    })
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            
                            // Theme Selector
                            VStack(alignment: .leading, spacing: 16) {
                                Text("THEMES")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(ThemeModeBK.allCases, id: \.self) { theme in
                                            let locked = isLocked(theme)
                                            // Pass binding or state? ThemeCard expects explicit values
                                            ThemeCard(theme: theme, isSelected: viewModel.currentTheme == theme, isLocked: locked)
                                                .onTapGesture {
                                                    if locked {
                                                        selectedThemeForPaywall = theme
                                                    } else {
                                                        viewModel.selectTheme(theme)
                                                    }
                                                }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Premium Banner
                            // Only show if user doesn't have all access? Or always show?
                            // Let's show specific banner if current theme is default, promoting premium
                            if !viewModel.premiumEnabled {
                                Button(action: {
                                    // Default to first premium theme for paywall preview
                                    selectedThemeForPaywall = .premiumTheme1
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("UNLOCK PREMIUM")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            Text("Get all themes & support the app")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        Spacer()
                                        Image(systemName: "crown.fill")
                                            .font(.title)
                                            .foregroundColor(viewModel.currentTheme.mainColor)
                                    }
                                    .padding()
                                    .background(
                                        LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                                }
                            }
                            
                            // General Settings
                            VStack(alignment: .leading, spacing: 16) {
                                Text("GENERAL")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                
                                
                                
                                Button(action: {
                                    Task {
                                        await store.restorePurchases()
                                        restoreMessage = "Purchases restored."
                                        showRestoreAlert = true
                                    }
                                }) {
                                    SettingsRowContent(icon: "arrow.clockwise", title: "Restore Purchases")
                                }
                                NavigationLink(destination: AboutViewModeBK()) {
                                    SettingsRowContent(icon: "info.circle", title: "About App")
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationBarHidden(true)
            // Trigger Paywall
            .sheet(item: $selectedThemeForPaywall) { theme in
                PaywallViewModeBK(theme: theme)
            }
            // Restore Alert
            .alert("Restore", isPresented: $showRestoreAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(restoreMessage)
            }
        }
    }
    
    func isLocked(_ theme: ThemeModeBK) -> Bool {
        return theme.isPremium && !store.hasAccess(to: theme)
    }
}

// Subcomponents mostly unchanged, but ensuring compatibility
struct ThemeCard: View {
    let theme: ThemeModeBK
    let isSelected: Bool
    let isLocked: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.mainColor.opacity(0.2))
                .frame(width: 100, height: 140)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                )
            
            VStack {
                ZStack {
                    Circle()
                        .fill(theme.mainColor)
                        .frame(width: 40, height: 40)
                        .shadow(radius: 5)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
                
                Text(theme.name) // Use the new 'name' property
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)
                
                if isLocked {
                    HStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                            .font(.caption2)
                        Text("PREMIUM")
                            .font(.caption2)
                    }
                    .foregroundColor(theme.mainColor) // Use the card's theme color
                    .padding(.top, 4)
                }
            }
        }
    }
}

struct SettingsRowContent: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 24)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
