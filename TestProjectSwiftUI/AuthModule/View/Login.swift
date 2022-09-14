//
//  Login.swift
//  TestProjectSwiftUI
//
//  Created by NikitaV on 05.07.2022.
//

import SwiftUI
import Firebase

struct Login: View {
    @Binding var index: Int
    @State private var isSecurePass = false
    @State private var errorMessage = ""
    @State private var alert = false
    @EnvironmentObject  var vm: AuthViewModel
    @EnvironmentObject var viewRouter: ViewRouter
        
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                topTitle
                    .padding(.top, 30)
                
                EntryFieldEmail(prompt: vm.emailPrompt, field: $vm.email)
                    .padding(.horizontal)
                    .padding(.top, 40)
                EntryFieldPassword(placeHolder: "Passsword", prompt: vm.passwordPrompt, field: $vm.password, isSecure: $isSecurePass)
                    .padding(.horizontal)
                    .padding(.top, 30)
                forgotPasswordButton
                    .padding(.horizontal)
                    .padding(.top, 20)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color.theme.colorOverBackground)
            .clipShape(CShape())
            .contentShape(CShape())
            .onTapGesture {
                index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal, 30)
                        
            loginButton
                .offset(y: 30)
                .opacity(index == 0 ? 1 : 0)
            
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.errorMessage), dismissButton: .default(Text("Ok")))
        }
    }
}


struct ContentViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthScreen()
                .environmentObject(AuthViewModel())
        }
    }
}

extension Login {
    private var topTitle: some View {
        HStack {
            VStack(spacing: 10) {
                Text("Login")
                    .foregroundColor(index == 0 ? Color.theme.accent : .gray)
                    .font(Font.myFont.poppins28)
                Capsule()
                    .fill(index == 0 ? Color.theme.red : Color.clear)
                    .frame(width: 100, height: 5)
            }
            Spacer()
        }
    }
    
    
    private var forgotPasswordButton: some View {
        HStack {
            Spacer(minLength: 0)
            
            Button  {
                
            } label: {
                Text("Forget password")
                    .foregroundColor(Color.theme.accent.opacity(0.6))
                    .font(Font.myFont.poppins16)
            }
            
        }
    }
    
    private var loginButton: some View {
        Button {
            vm.signInUser(viewRouter: viewRouter, email: vm.email, password: vm.password) { (verified, status) in
                if !verified{
                    
                    self.errorMessage = status
                    self.alert.toggle()
                    
                }
                else{
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                }
            }
        } label: {
            
            if vm.isSignInProcessing {
                ProgressView()
            } else {
                Text("LOGIN")
                    .foregroundColor(Color.theme.background)
                    .font(Font.myFont.poppins20)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color.theme.accent.opacity(0.8))
                    .clipShape(Capsule())
                    .shadow(color: Color.theme.accent.opacity(0.3), radius: 5, x: 0, y: -5)
            }
        }
        .disabled(!vm.isSignInComplete)
        .opacity(vm.isSignInComplete ? 1 : 0.5)
    }
    
}
