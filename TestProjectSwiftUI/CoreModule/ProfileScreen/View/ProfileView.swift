//
//  SettingsView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 01.08.2022.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ProfileView: View {
    @StateObject private var vm = ProfileViewModel()
    @EnvironmentObject  var vmAuth: AuthViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    
    var profileInfoLabel: [Profile] = [Profile(text: "Privacy policy"), Profile(text: "Security"), Profile(text: "Links")]
    
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                CustomNavBar(isPresentedEditButton: true) {
                    Text("Profile")
                        .foregroundColor(Color.theme.accent)
                        .font(Font.myFont.poppins20)
                }
                Spacer(minLength: 12)
                userInfo
                Spacer(minLength: 12)
                settings
                Spacer()
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileView()
                .environmentObject(AuthViewModel())
        }
    }
}

extension ProfileView {
    private var userInfo: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
               
                Image(uiImage: (vm.image != nil ? vm.image! : UIImage(named: "avatar")!))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 116, height: 116)
                    .clipShape(Circle())
                    .padding(.all, 5)
                    .overlay(Circle().stroke(Color.gragient.linearGradient, lineWidth: 4))
                    .padding(.leading)
                    .padding(.trailing, 6)
                CircleButtonView(iconName: "camera", opacityBackground: 0.9)
                    .onTapGesture {
                        showingImagePicker = true
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $inputImage)
                    }
            }
            .padding(.top, 16)
            .onChange(of: inputImage) { _ in
                loadImage()
            }
            
            Spacer(minLength: 12)
            
            VStack {
                Text(vm.user?.profile?.name ?? "Enter your name")
                    .font(Font.myFont.poppins20)
                    .foregroundColor(Color.theme.accent)
                    .padding(.vertical, 5)
                Text(vm.user?.profile?.email ?? "Enter your email")
                    .font(Font.myFont.poppins16)
                    .foregroundColor(Color.theme.secondaryTint)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3.5)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(32)
    }
    
    private var settings: some View {
        VStack {
            ScrollView {
                ForEach(profileInfoLabel) { profile in
                    RowProfile(text: profile.text)
                        .padding(.all, 8)
                    if profile.text != profileInfoLabel.last?.text{
                        Divider()
                            .background(Color.theme.accent)
                            .opacity(0.1)
                            .padding(.leading, 16)
                    }
                }
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3.9)
                .background(Color.theme.colorOverBackground)
                .cornerRadius(32)
            }
            Spacer(minLength: 12)
            Button {
                if vm.user?.profile?.email != nil {
                    vmAuth.googleSignOut(viewRouter: viewRouter)
                } else {
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    vmAuth.signOut(viewRouter: viewRouter)
                }
            } label: {
                Text("Sign out")
                    .font(Font.myFont.poppins15)
                    .foregroundColor(Color.theme.accent)
            }
            .frame(width: UIScreen.main.bounds.width, height: 60)
            .background(Color.theme.colorOverBackground)
            .cornerRadius(32)
        }
    }
       
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        vm.savedImage(imageProfile: inputImage)
    }
}

