//
//  SignIn.swift
//  TestProjectSwiftUI
//
//  Created by NikitaV on 05.07.2022.
//

import SwiftUI

struct SignIn: View {
    @State var email = ""
    @State var pass = ""
    @State var confirmPass = ""
    @Binding var index: Int
    
    @State private var isSecurePass = false
    @State private var isSecurePassConf = false
    @State private var isPresentedSignUp = false

    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    Spacer(minLength: 0)
                    VStack(spacing: 10) {
                        Text("Sign up")
                            .foregroundColor(index == 1 ? Color.theme.accent : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        Capsule()
                            .fill(index == 1 ? Color.theme.red : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                }.padding(.top, 30)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(email.isEmpty ? Color.theme.secondaryTint.opacity(0.8) : Color.theme.accent.opacity(0.8))
                        TextField("Email address", text: $email)
                            .foregroundColor(email.isEmpty ? Color.theme.secondaryTint : Color.theme.accent)
                    }
                    Divider()
                        .background(Color.theme.tintColor.opacity(0.5))
                }.padding(.horizontal)
                    .padding(.top, 40)
                VStack {
                    HStack(spacing: 15) {
                        Button(action: {
                            isSecurePass.toggle()
                        }, label: {
                            if isSecurePass {
                                Image(systemName: "eye.fill")
                                    .foregroundColor(pass.isEmpty ? Color.theme.secondaryTint.opacity(0.8) : Color.theme.accent)
                            } else {
                                Image(systemName: "eye.slash.fill")
                                    .foregroundColor(pass.isEmpty ? Color.theme.secondaryTint : Color.theme.accent)
                            }
                        })
                        .foregroundColor(Color.theme.accent.opacity(0.8))
                        if isSecurePass {
                            TextField("Password", text: $pass)
                                .foregroundColor(pass.isEmpty ? Color.theme.secondaryTint : Color.theme.accent)
                        } else {
                            SecureField("Password", text: $pass)
                                .foregroundColor(pass.isEmpty ? Color.theme.secondaryTint : Color.theme.accent)
                        }
                    }
                    Divider()
                        .background(Color.theme.tintColor.opacity(0.5))
                }.padding(.horizontal)
                    .padding(.top, 30)
                VStack {
                    HStack(spacing: 15) {
                        Button(action: {
                            isSecurePassConf.toggle()
                        }, label: {
                            if isSecurePassConf {
                                Image(systemName: "eye.fill")
                                    .foregroundColor(confirmPass.isEmpty ? Color.theme.secondaryTint.opacity(0.8) : Color.theme.accent)
                            } else {
                                Image(systemName: "eye.slash.fill")
                                    .foregroundColor(confirmPass.isEmpty ? Color.theme.secondaryTint.opacity(0.8) : Color.theme.accent)
                            }
                        })
                        .foregroundColor(Color.theme.accent.opacity(0.8))
                        
                        if isSecurePassConf {
                            TextField("Confirm password", text: $confirmPass)
                                .foregroundColor(confirmPass.isEmpty ? Color.theme.secondaryTint : Color.theme.accent)
                        } else {
                            SecureField("Confirm password", text: $confirmPass)
                                .foregroundColor(confirmPass.isEmpty ? Color.theme.secondaryTint : Color.theme.accent)
                        }
                    }
                    Divider()
                        .background(Color.theme.accent.opacity(0.5))
                }.padding(.horizontal)
                    .padding(.top, 30)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color.black)
            .clipShape(CShape1())
            .contentShape(CShape1())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal, 30)
            
            Button {
                self.isPresentedSignUp.toggle()
            } label: {
                Text("SIGN UP")
                    .foregroundColor(Color.theme.background)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color.theme.accent.opacity(0.8))
                    .clipShape(Capsule())
                    .shadow(color: Color.theme.accent.opacity(0.3), radius: 5, x: 0, y: -5)
            }
            .fullScreenCover(isPresented: $isPresentedSignUp, content: {
                CryptoCoreScreen()
            })
            .offset(y: 30)
            .opacity(index == 1 ? 1 : 0)
            
        }
    }
}


