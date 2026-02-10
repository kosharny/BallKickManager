import SwiftUI

struct ContentViewModeBK: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // Background
            viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
            
            // Main Content Area
            VStack(spacing: 0) {
                switch viewModel.selectedTab {
                case .home:
                    HomeViewModeBK()
                case .journal:
                    JournalViewModeBK()
                case .search:
                    SearchViewModeBK()
                case .favorites:
                    FavoritesViewModeBK()
                case .stats:
                    StatViewModeBK()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            if !viewModel.isTabBarHidden {
                CustomTabBarModeBK(selectedTab: $viewModel.selectedTab)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    ContentViewModeBK()
        .environmentObject(MainViewModelModeBK())
}
