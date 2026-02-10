import SwiftUI

enum ThemeModeBK: String, CaseIterable, Codable {
    case defaultTheme
    case premiumTheme1
    case premiumTheme2

    var mainColor: Color {
        switch self {
        case .defaultTheme: return Color.yellow
        case .premiumTheme1: return Color.orange
        case .premiumTheme2: return Color.red
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .defaultTheme: return Color.black
        case .premiumTheme1: return Color.black
        case .premiumTheme2: return Color.white
        }
    }
    
    var isPremium: Bool {
        switch self {
        case .defaultTheme: return false
        case .premiumTheme1, .premiumTheme2: return true
        }
    }
    
    var productID: String? {
        switch self {
        case .defaultTheme: return nil
        case .premiumTheme1: return "premium_theme_orange"
        case .premiumTheme2: return "premium_theme_red"
        }
    }
    
    var name: String {
        switch self {
        case .defaultTheme: return "Default Yellow"
        case .premiumTheme1: return "Sunset Orange"
        case .premiumTheme2: return "Battle Red"
        }
    }
    
    var backgroundGradient: LinearGradient {
        switch self {
        case .defaultTheme:
            return LinearGradient(colors: [Color.black, Color.yellow.opacity(0.2)], startPoint: .top, endPoint: .bottom)
        case .premiumTheme1:
             return LinearGradient(colors: [Color.black, Color.orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
        case .premiumTheme2:
             return LinearGradient(colors: [Color.black, Color.red.opacity(0.2)], startPoint: .top, endPoint: .bottom)
        }
    }
}

extension ThemeModeBK: Identifiable {
    var id: String { rawValue }
}
