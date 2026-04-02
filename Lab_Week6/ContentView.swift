//
//  ContentView.swift
//  Lab_Week6
//
//  Created by Jason TIo on 03/04/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        TabView {
            LogbookView()
                .tabItem {
                    Label("Logbook", systemImage: "book")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .environmentObject(appViewModel)
        .preferredColorScheme(appViewModel.isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
