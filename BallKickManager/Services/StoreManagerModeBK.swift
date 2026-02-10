import Combine
import StoreKit
import SwiftUI

@MainActor
final class StoreManagerModeBK: ObservableObject {
    static let shared = StoreManagerModeBK()
    
    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isLoading = false
    @Published var isPurchasesLoaded = false // New flag to track initial load
    
    // IDs matching the mock IDs in ThemeModeBK
    private let productIDs: Set<String> = [
        "premium_theme_orange",
        "premium_theme_red"
    ]
    
    init() {
        // Start observing transactions immediately
        Task {
            await updatePurchasedProducts()
            await observeTransactions()
            // Fetch products
            await fetchProducts()
            
            // Mark as loaded after initial checks
            await MainActor.run {
                self.isPurchasesLoaded = true
            }
        }
    }
    
    func fetchProducts() async {
        isLoading = true
        
        do {
            let fetchedProducts = try await Product.products(for: productIDs)
            self.products = fetchedProducts
            
            if fetchedProducts.isEmpty {
                print("🔴 ATTENTION: StoreKit returned empty list! Check .storekit file configuration.")
            }
            
        } catch {
            print("🔴 Error loading products: \(error)")
        }
        
        isLoading = false
    }
    
    func purchase(_ product: Product) async -> PurchaseStatus {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                
                purchasedProductIDs.insert(transaction.productID)
                
                await transaction.finish()
                
                return .success
                
            case .userCancelled:
                return .cancelled
                
            case .pending:
                return .pending
                
            @unknown default:
                return .failed
            }
        } catch {
            print("Purchase failed:", error)
            return .failed
        }
    }
    
    func restorePurchases() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }
    
    private func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }
    
    private func observeTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreError.failedVerification
        }
    }
    
    nonisolated func paymentQueue(_ queue: SKPaymentQueue,
                                  shouldAddStorePayment payment: SKPayment,
                                  for product: SKProduct) -> Bool {
        return true
    }
}

extension StoreManagerModeBK {
    func hasAccess(to theme: ThemeModeBK) -> Bool {
        guard theme.isPremium else { return true }
        guard let productID = theme.productID else { return false }
        return purchasedProductIDs.contains(productID)
    }
}

enum StoreError: Error {
    case failedVerification
}

enum PurchaseStatus {
    case success
    case pending
    case cancelled
    case failed
}
