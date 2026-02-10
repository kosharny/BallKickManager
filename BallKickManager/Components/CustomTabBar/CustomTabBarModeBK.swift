import SwiftUI

struct CustomTabBarModeBK: View {
    @Binding var selectedTab: TabModeBK
    @EnvironmentObject var viewModel: MainViewModelModeBK
    @Namespace var animation // Add Namespace
    
    var body: some View {
        HStack {
            TabBarItem(icon: "house.fill", title: "Home", tab: .home, selectedTab: $selectedTab, selectedColor: viewModel.currentTheme.mainColor, animation: animation)
            TabBarItem(icon: "book.fill", title: "Journal", tab: .journal, selectedTab: $selectedTab, selectedColor: viewModel.currentTheme.mainColor, animation: animation)
            TabBarItem(icon: "magnifyingglass", title: "Search", tab: .search, selectedTab: $selectedTab, selectedColor: viewModel.currentTheme.mainColor, animation: animation)
            TabBarItem(icon: "star.fill", title: "Favs", tab: .favorites, selectedTab: $selectedTab, selectedColor: viewModel.currentTheme.mainColor, animation: animation)
            TabBarItem(icon: "chart.bar.fill", title: "Stats", tab: .stats, selectedTab: $selectedTab, selectedColor: viewModel.currentTheme.mainColor, animation: animation)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(viewModel.currentTheme.mainColor, lineWidth: 2)
                )
                .shadow(color: viewModel.currentTheme.mainColor.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .padding(.bottom, 10) // Adjust for safe area in parent view
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let tab: TabModeBK
    @Binding var selectedTab: TabModeBK
    let selectedColor: Color
    var animation: Namespace.ID // Accept Namespace.ID
    
    var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? selectedColor : .gray)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                
                if isSelected {
                    Circle()
                        .fill(selectedColor)
                        .frame(width: 4, height: 4)
                        .matchedGeometryEffect(id: "tab_dot", in: animation) // Use passed namespace
                } else {
                    Color.clear.frame(height: 4)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
