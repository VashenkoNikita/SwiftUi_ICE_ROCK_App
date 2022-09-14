//
//  SignIn.swift
//  TestProjectSwiftUI
//
//  Created by NikitaV on 05.07.2022.
//

import SwiftUI
import Firebase


struct SignUp: View {
    @Binding var index: Int
    
    @State private var isSecurePass = false
    @State private var isSecureConfirmPass = false
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
                
                EntryFieldPassword(placeHolder: "Password", prompt: vm.passwordPrompt, field: $vm.password, isSecure: $isSecurePass)
                    .padding(.horizontal)
                    .padding(.top, 30)
                
                EntryFieldPassword(placeHolder: "Confirm password", prompt: vm.confirmPwPrompt, field: $vm.confirmPw, isSecure: $isSecureConfirmPass)
                    .padding(.horizontal)
                    .padding(.top, 30)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color.theme.colorOverBackground)
            .clipShape(CShape1())
            .contentShape(CShape1())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal, 30)
            
            signUpButton
                .offset(y: 30)
                .opacity(index == 1 ? 1 : 0)
            
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.errorMessage), dismissButton: .default(Text("Ok")))
        }
    }
}


struct ContentViewss_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthScreen()
                .environmentObject(AuthViewModel())
        }
    }
}

extension SignUp {
    
    private var topTitle: some View {
        HStack {
            Spacer(minLength: 0)
            VStack(spacing: 10) {
                Text("Sign up")
                    .foregroundColor(index == 1 ? Color.theme.accent : .gray)
                    .font(Font.myFont.poppins28)
                Capsule()
                    .fill(index == 1 ? Color.theme.red : Color.clear)
                    .frame(width: 100, height: 5)
            }
            
        }
    }
    
    private var errorMessageText: some View {
        Text("Failed create account: \(errorMessage)")
            .foregroundColor(Color.theme.red)
            .font(Font.myFont.poppins13)
            .padding(.top, 20)
    }
    
    private var signUpButton: some View {
        Button {
            vm.signUpUser(viewRouter: viewRouter, userEmail: vm.email, userPassword: vm.password){ (verified, status) in
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
            if vm.isSignUpProcessing {
                ProgressView()
            } else {
                Text("SIGN UP")
                    .foregroundColor(Color.theme.background)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color.theme.accent.opacity(0.8))
                    .clipShape(Capsule())
                    .shadow(color: Color.theme.accent.opacity(0.3), radius: 5, x: 0, y: -5)
                    .font(Font.myFont.poppins20)
            }
        }
        .disabled(!vm.isSignUpComplete)
        .opacity(vm.isSignUpComplete ? 1 : 0.5)
    }
}
