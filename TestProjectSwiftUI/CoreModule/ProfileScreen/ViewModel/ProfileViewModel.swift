//
//  ProfileViewModel.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 07.09.2022.
//

import SwiftUI
import GoogleSignIn
import FirebaseStorage
import Firebase

class ProfileViewModel: ObservableObject {
    let currentGoogleUser = GIDSignIn.sharedInstance.currentUser
    let currentEmailAuthUser = Auth.auth().currentUser
    
    let storage = Storage.storage()
    let firestore: Firestore
    
    @Published var currentUserData: UserModel?
    
    init() {
        firestore = Firestore.firestore()
        fetchCurrentUser()
    }
    
    func persistImageToStorage(image: UIImage, email: String, nameUser: String) {
        guard let uid = currentEmailAuthUser?.uid else { return }
        let ref = storage.reference(withPath: uid)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to Storage: \(err)")
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                    return
                }
                
                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                guard let url = url else {
                    return
                }

                self.storeUserInformation(imageProfileUrl: url, email: email, nameUser: nameUser, uid: uid)
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL, email: String, nameUser: String, uid: String) {
        let userData = ["username": nameUser, "email": email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    return
                }
                print("Success")
            }
    }
    
    func fetchCurrentUser() {
        guard let uid = currentEmailAuthUser?.uid else {
            print("Could not find firebase uid")
            return
        }
        
        firestore.collection("users").document(uid).getDocument { snapShot, error in
            if let error = error {
                print("Failed to fetch current user:", error.localizedDescription as Any)
                return
            }
            
            guard let data = snapShot?.data() else {
                print("No data found")
                return
            }
            
            let userName = data["username"] as? String ?? ""
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileImageUrl = data["profileImageUrl"] as? String ?? ""
            
            self.currentUserData = UserModel(username: userName, uid: uid, email: email, profileImageUrl: profileImageUrl)
        }
    }
    
    func deleteUserData() {
        guard let uid = currentEmailAuthUser?.uid else { return }
        
        firestore.collection("users")
            .document(uid).delete()
        storage.reference(withPath: uid).delete { error in
            print("Failed delete image")
        }
    }
    
    func isEmailValid(email: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: email)
    }
    
    func isUserNameValid(username: String) -> Bool {
        let usernameTest = NSPredicate(format: "SELF MATCHES %@",
                                       "(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{6,15})$")
        return usernameTest.evaluate(with: username)
    }
}
