//
//  BallKickManagerApp.swift
//  BallKickManager
//
//  Created by Maksim Kosharny on 10.02.2026.
//

import SwiftUI

@main
struct BallKickManagerApp: App {
    @StateObject private var mainViewModel = MainViewModelModeBK()
    
    var body: some Scene {
        WindowGroup {
            SplashViewModeBK()
                .environmentObject(mainViewModel)
                .preferredColorScheme(.dark) // Enforce dark mode for the theme
        }
    }
}
