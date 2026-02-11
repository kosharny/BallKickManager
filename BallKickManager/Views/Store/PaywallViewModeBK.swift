import SwiftUI
import StoreKit

struct PaywallViewModeBK: View {
    let theme: ThemeModeBK
    
    @StateObject private var store = StoreManagerModeBK.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var showConfirmAlert = false
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    @State private var resultTitle = ""
    @State private var isSuccess = false
    @State private var selectedProduct: Product?
    
    // Fallback if no specific theme is passed (e.g. from generic locked feature)
    init(theme: ThemeModeBK = .premiumTheme1) {
        self.theme = theme
    }
    
    var body: some View {
        ZStack {
            // Main Content
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 20) {
                    // Theme Preview
                    ZStack {
                        Circle()
                            .fill(theme.mainColor.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .shadow(color: theme.mainColor.opacity(0.5), radius: 20)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 50))
                            .foregroundColor(theme.mainColor)
                    }
                    .padding(.top, 40)
                    
                    Text(theme.name)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(theme.mainColor)
                    
                    Text("Unlock this exclusive premium theme")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                
                // Features
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRowModeBK(
                        icon: "paintpalette.fill",
                        title: "Unique Color Palette",
                        description: "Experience the app in stunning new colors",
                        theme: theme
                    )
                    
                    FeatureRowModeBK(
                        icon: "sparkles",
                        title: "Exclusive Visuals",
                        description: "Enhanced UI elements and accents",
                        theme: theme
                    )
                    
                    FeatureRowModeBK(
                        icon: "heart.fill",
                        title: "Support Development",
                        description: "Help us create more amazing content",
                        theme: theme
                    )
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Purchase Section
                if let product = store.products.first(where: { $0.id == theme.productID }) {
                    VStack(spacing: 16) {
                        // Purchase Button
                        Button {
                            selectedProduct = product
                            showConfirmAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "crown.fill")
                                Text("Unlock for \(product.displayPrice)")
                                    .fontWeight(.bold)
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(theme.buttonGradient)
                            .cornerRadius(16)
                            .shadow(color: theme.mainColor.opacity(0.3), radius: 10)
                        }
                        
                        // Restore Button
                        Button {
                            Task {
                                await store.restorePurchases()
                                if store.hasAccess(to: theme) {
                                    resultTitle = "Success"
                                    resultMessage = "Your purchases have been restored!"
                                    isSuccess = true
                                    showResultAlert = true
                                } else {
                                    resultTitle = "No Purchases Found"
                                    resultMessage = "We couldn't find any previous purchases for this theme."
                                    isSuccess = false
                                    showResultAlert = true
                                }
                            }
                        } label: {
                            Text("Restore Purchases")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 24)
                } else {
                    VStack(spacing: 10) {
                        if store.isLoading {
                            ProgressView()
                                .tint(theme.mainColor)
                            Text("Loading products...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(theme.mainColor)
                            Text("Product not found")
                                .foregroundColor(.gray)
                            Text("ID: \(theme.productID ?? "nil")")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            
                            Button("Retry") {
                                Task { await store.fetchProducts() }
                            }
                            .foregroundColor(theme.mainColor)
                            .padding(.top, 5)
                        }
                    }
                    .padding()
                }
                
                // Close Button
                Button {
                    dismiss()
                } label: {
                    Text("Not Now")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .background(Color.black.ignoresSafeArea())
            
            // Custom Alerts Overlay
            if showConfirmAlert {
                CustomAlertViewModeBK(
                    title: "Unlock Theme",
                    message: "Unlock \(theme.name) for \(selectedProduct?.displayPrice ?? "price")? This is a one-time purchase.",
                    primaryButtonTitle: "Purchase",
                    primaryAction: {
                        showConfirmAlert = false
                        Task {
                            await performPurchase()
                        }
                    },
                    secondaryButtonTitle: "Cancel",
                    secondaryAction: {
                        showConfirmAlert = false
                    },
                    themeColor: theme.mainColor
                )
            }
            
            if showResultAlert {
                CustomAlertViewModeBK(
                    title: resultTitle,
                    message: resultMessage,
                    primaryButtonTitle: "OK",
                    primaryAction: {
                        showResultAlert = false
                        if isSuccess && store.hasAccess(to: theme) {
                            dismiss()
                        }
                    },
                    secondaryButtonTitle: nil,
                    secondaryAction: nil,
                    themeColor: isSuccess ? theme.mainColor : .red
                )
            }
        }
        .task {
            if store.products.isEmpty {
                await store.fetchProducts()
            }
        }
        .onAppear {
             // Basic fetch just in case
             Task { await store.fetchProducts() }
        }
    }

    func performPurchase() async {
        guard let product = selectedProduct else { return }
        
        // Simulating async delay if real purchase
        let status = await store.purchase(product)
        
        switch status {
        case .success:
            if store.hasAccess(to: theme) {
                resultTitle = "Success!"
                resultMessage = "\(theme.name) has been unlocked. Enjoy!"
                isSuccess = true
                showResultAlert = true
            }
            
        case .cancelled:
            print("User cancelled purchase")
            // No alert needed
            
        case .pending:
            resultTitle = "Pending"
            resultMessage = "Your purchase is pending approval."
            isSuccess = false
            showResultAlert = true
            
        case .failed:
            resultTitle = "Purchase Failed"
            resultMessage = "We couldn't complete your purchase. Please try again."
            isSuccess = false
            showResultAlert = true
        }
    }
}

struct FeatureRowModeBK: View {
    let icon: String
    let title: String
    let description: String
    let theme: ThemeModeBK
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(theme.mainColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
