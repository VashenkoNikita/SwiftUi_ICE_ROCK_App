//
//  EditProfileView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 15.09.2022.
//

import SwiftUI

struct EditProfileView: View {
    @StateObject var vmAuth = AuthViewModel()
    @StateObject private var vm = ProfileViewModel()
    @StateObject private var vmHome = CryptoCoreViewModel()
    @StateObject var viewRouter = ViewRouter()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var errorMessage = ""
    @State private var showErrorAlert = false
    @State private var showDeleteUserAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top){
            Color.theme.background
            VStack(spacing: 12) {
                CustomNavBar(rightButtonName: "Trash_Full", isPresentedEditButton: true) {
                    Text("Edit")
                        .foregroundColor(Color.theme.accent)
                        .font(Font.myFont.poppins20)
                } action: {
                    showDeleteUserAlert = true
                }
                .alert(isPresented: $showDeleteUserAlert) {
                    Alert(title:
                            Text("Do you want to deletethis account?"),
                          message:
                            Text("You cannot undo this action"),
                          primaryButton:
                            .cancel(),
                          secondaryButton:
                            .default(Text("Delete").foregroundColor(Color.theme.red), action: {
                                deleteUser()
                            }))
                }
                userInfo
                bottomSaveButton
                    .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Error"), message: Text(self.errorMessage), dismissButton: .default(Text("Ok")))
                    }
                Spacer()
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(AuthViewModel())
    }
}

extension EditProfileView {
    private var userInfo: some View {
        VStack {
            ZStack {
                Image(uiImage: (inputImage != nil ? inputImage! : UIImage(named: "avatar")!))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 116, height: 116)
                    .clipShape(Circle())
                    .opacity(0.5)
                CircleButtonView(iconName: "camera", opacityBackground: 0)
                    .onTapGesture {
                        showingImagePicker = true
                    }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            VStack {
                TextField("Name", text: $name)
                    .keyboardType(.webSearch)
                    .padding(.horizontal, 12)
                    .frame(height: 48)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.tfColor.opacity(0.74)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 0.1)
                    )
                TextField("Email", text: $email)
                    .keyboardType(.webSearch)
                    .padding(.horizontal, 12)
                    .frame(height: 48)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.tfColor.opacity(0.74)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 0.1)
                    )
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .foregroundColor(Color.theme.tintColor)
        }
        .padding(.vertical, 12)
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(32)
    }

    private var bottomSaveButton: some View {
        VStack {
            Button {
                if !vm.isEmailValid(email: email) {
                    errorMessage = "Enter a valid email address"
                    showErrorAlert = true
                } else if !vm.isUserNameValid(username: name) {
                    errorMessage = "Username the match must be alphanumeric with at least one number, one letter, and be between 6-15 character in length."
                    showErrorAlert = true
                } else {
                    vm.persistImageToStorage(image: inputImage ?? UIImage(), email: email, nameUser: name)
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Save")
                    .font(Font.myFont.poppins18)
                    .foregroundColor(Color.theme.backgroundAuth)
            }
            .frame(width: UIScreen.main.bounds.width - 32, height: 56)
            .background(Color.theme.backgroundElements)
            .cornerRadius(16)
        }
        .frame(width: UIScreen.main.bounds.width, height: 88)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(32)
    }
    
    private func deleteUser() {
        vmHome.deletePortfolio()
        vm.deleteUserData()
        vmAuth.deleteCurrentUser()
        
        if vm.currentGoogleUser?.profile?.email != nil {
            vmAuth.googleSignOut(viewRouter: viewRouter)
        } else {
            vmAuth.signOut(viewRouter: viewRouter)
        }
    }
}
