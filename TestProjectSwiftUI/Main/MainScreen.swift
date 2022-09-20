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
                    if vmAuth.googleUser != nil {
                        NavigationView {
                            CryptoCoreScreen()
                                .navigationViewStyle(StackNavigationViewStyle())
                                .navigationBarHidden(true)
                                .onAppear {
                                    vmAuth.googleSignIn(viewRouter: viewRouter)
                                }
                        }
                        .environmentObject(vm)
                        .transition(.move(edge: .trailing))
                    } else if vmAuth.emailUser != nil {
                        NavigationView {
                            CryptoCoreScreen()
                                .navigationViewStyle(StackNavigationViewStyle())
                                .navigationBarHidden(true)
                        }
                        .environmentObject(vm)
                        .transition(.move(edge: .trailing))
                    } else {
                        AuthScreen()
                            .environmentObject(vmAuth)
                            .transition(.move(edge: .trailing))
                    }
                }
                else{
                    AuthScreen()
                        .environmentObject(vmAuth)
                        .transition(.move(edge: .trailing))
                }
                
            }.animation(.spring())
                .onAppear {
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                        
                        let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                        self.status = status
                    }
                }
            
        case .homePage:
            
                NavigationView {
                    CryptoCoreScreen()
                        .navigationViewStyle(StackNavigationViewStyle())
                        .navigationBarHidden(true)
                }
                .environmentObject(vm)
                .transition(.move(edge: .trailing))
            
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .environmentObject(ViewRouter())
    }
}
