//
//  TestProjectSwiftUIApp.swift
//  TestProjectSwiftUI
//
//  Created by NikitaV on 02.07.2022.
//

import SwiftUI

@main
struct TestProjectSwiftUIApp: App {
    @StateObject private var vm = CryptoCoreViewModel()
    @State var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    CryptoCoreScreen()
                        .navigationViewStyle(StackNavigationViewStyle())
                        .navigationBarHidden(true)
                }
                .environmentObject(vm)
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchScreen: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
