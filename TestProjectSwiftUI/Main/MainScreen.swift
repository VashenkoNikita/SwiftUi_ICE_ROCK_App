//
//  MainScreen.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 12.09.2022.
//

import SwiftUI

struct MainScreen: View {
    
    @StateObject private var vm = CryptoCoreViewModel()
    @StateObject private var vmAuth = AuthViewModel()
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        switch viewRouter.currentPage {
        case .signInPage:
            
            VStack{
                
                if status {
                    
                    NavigationView {
                        CryptoCoreScreen()
                            .navigationViewStyle(StackNavigationViewStyle())
                            .navigationBarHidden(true)
                    }
                    .environmentObject(vm)
                }
                else{
                    AuthScreen()
                        .environmentObject(vmAuth)
                }
                
            }.animation(.spring())
                .onAppear {
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                        
                        let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                        self.status = status
                    }
                }
            
            
        case .homePage:
            
            withAnimation(.easeInOut) {
                NavigationView {
                    CryptoCoreScreen()
                        .navigationViewStyle(StackNavigationViewStyle())
                        .navigationBarHidden(true)
                }
                .environmentObject(vm)
            }
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen().environmentObject(ViewRouter())
    }
}
