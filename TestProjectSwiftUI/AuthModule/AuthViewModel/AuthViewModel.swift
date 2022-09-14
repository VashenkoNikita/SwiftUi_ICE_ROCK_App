//
//  AuthViewModel.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 13.09.2022.
//

import SwiftUI
import Firebase
import GoogleSignIn

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPw = ""
    @Published var isSignInProcessing = false
    @Published var isSignUpProcessing = false
    
    //MARK: - Google auth
    @Published var googleSignInState: StateGoogleSignIn = .signedOut
    
    enum StateGoogleSignIn {
        case signedIn
        case signedOut
    }
    
    func googleSignIn(viewRouter: ViewRouter) {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                self?.authenticateUser(for: user, with: error, viewRouter: viewRouter)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let congiguration = GIDConfiguration(clientID: clientID)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(with: congiguration, presenting: rootViewController) { [weak self] user, error in
                self?.authenticateUser(for: user, with: error, viewRouter: viewRouter)
            }
        }
    }
    
    func googleSignOut(viewRouter: ViewRouter) {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            
            viewRouter.currentPage = .signInPage
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?, viewRouter: ViewRouter) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                viewRouter.currentPage = .homePage
            }
        }
    }
    
    
    //MARK: Email and Password auth
    func signInUser(viewRouter: ViewRouter, email: String, password: String, comletion: @escaping (Bool, String) -> Void) {
        isSignInProcessing = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil else {
                comletion(false, error?.localizedDescription ?? "")
                self?.isSignInProcessing = false
                return
            }
            
            switch authResult {
                
            case .none:
                self?.isSignInProcessing = false
                comletion(true, authResult?.user.email ?? "")
            case .some(_):
                self?.isSignInProcessing = false
                comletion(true, authResult?.user.email ?? "")
                withAnimation {
                    viewRouter.currentPage = .homePage
                }
            }
            
        }
    }
    
    func signUpUser(viewRouter: ViewRouter, userEmail: String, userPassword: String, comletion: @escaping (Bool, String) -> Void) {
        isSignUpProcessing = true
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
            guard error == nil else {
                comletion(true, error?.localizedDescription ?? "")
                self?.isSignUpProcessing = false
                return
            }
            
            switch authResult {
                
            case .none:
                self?.isSignUpProcessing = false
            case .some(_):
                self?.isSignUpProcessing = false
                withAnimation {
                    viewRouter.currentPage = .homePage
                }
            }
        }
    }
    
    func signOut(viewRouter: ViewRouter) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error sign out: \(error.localizedDescription)")
        }
        
        withAnimation {
            viewRouter.currentPage = .signInPage
        }
    }
    
    // MARK: - Validation Functions
    
    func passwordsMatch() -> Bool {
        password == confirmPw
    }
    
    func isPasswordValid() -> Bool {
        // criteria in regex.  See http://regexlib.com
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$")
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid() -> Bool {
        // criteria in regex.  See http://regexlib.com
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: email)
    }
    
    var isSignUpComplete: Bool {
        if !passwordsMatch() ||
        !isPasswordValid() ||
        !isEmailValid() {
            return false
        }
        return true
    }
    
    var isSignInComplete: Bool {
        if !isPasswordValid() ||
        !isEmailValid() {
            return false
        }
        return true
    }
    
    // MARK: - Validation Prompt Strings
    
    var confirmPwPrompt: String {
        if passwordsMatch() {
            return ""
        } else {
            return "Password fields do not match"
        }
    }
    
    var emailPrompt: String {
        if isEmailValid() {
            return ""
        } else {
            return "Enter a valid email address"
        }
    }
    
    var passwordPrompt: String {
        if isPasswordValid() {
            return ""
        } else {
            return "Must be between 8 and 15 characters containing at least one number and one capital letter"
        }
    }
    
}
