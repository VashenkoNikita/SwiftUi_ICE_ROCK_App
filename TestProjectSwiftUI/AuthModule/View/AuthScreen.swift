//
//  ContentView.swift
//  TestProjectSwiftUI
//
//  Created by NikitaV on 02.07.2022.
//

import SwiftUI
import Firebase

struct AuthScreen: View {
    
    @EnvironmentObject  var vm: AuthViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var index = 0
    
    var body: some View {
        VStack {
            Spacer()
            Image("LogoIce")
                .resizable()
                .frame(width: 150, height: 30)
            ZStack {
                SignUp(index: $index)
                    .zIndex(Double(index))
                Login(index: $index)
            }
            .padding(.top, 30)
            
            HStack(spacing: 15) {
                Rectangle()
                    .fill(Color.theme.backgroundAuth)
                    .frame(height: 1)
                Text("OR")
                    .foregroundColor(Color.theme.backgroundAuth)
                    .font(Font.myFont.poppins16)
                Rectangle()
                    .fill(Color.theme.backgroundAuth)
                    .frame(height: 1)
            }
            .padding(.horizontal, 30)
            .padding(.top, 50)
            
            HStack(spacing: 25) {
                Button {
                    
                } label: {
                    Image("apple")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                Button {
                    vm.googleSignIn(viewRouter: viewRouter)
                } label: {
                    Image("google")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
            }
            .padding(.top, 40)
            Spacer()
        }
        .padding(.vertical)
        .background(Color.theme.background.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthScreen()
                .environmentObject(AuthViewModel())
        }
    }
}

