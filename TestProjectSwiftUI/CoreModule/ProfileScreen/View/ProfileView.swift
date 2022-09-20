//
//  SettingsView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 01.08.2022.
//

import SwiftUI
import Firebase
import GoogleSignIn
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject private var vm = ProfileViewModel()
    @StateObject private var vmHome = CryptoCoreViewModel()
    @EnvironmentObject  var vmAuth: AuthViewModel
    @StateObject var viewRouter = ViewRouter()
    @State private var showingEditProfile = false
    @Environment(\.presentationMode) var presentationMode

    
    var profileInfoLabel: [Profile] = [Profile(text: "Privacy policy"), Profile(text: "Security"), Profile(text: "Links")]
    
    var body: some View {
        ZStack(alignment: .top){
            Color.theme.background
            VStack(spacing: 12) {
                CustomNavBar(rightButtonName: "Edit_Pencil", isPresentedEditButton: true) {
                    Text("Profile")
                        .foregroundColor(Color.theme.accent)
                        .font(Font.myFont.poppins20)
                } action: {
                    showingEditProfile = true
                }
                userInfo
                settings
                bottomSignOutButton
                Spacer()
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .onAppear {
            vm.fetchCurrentUser()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileView()
        }
    }
}

extension ProfileView {
    private var userInfo: some View {
        VStack {
            ZStack(alignment: vm.currentUserData?.profileImageUrl != nil ? .bottomTrailing : .center) {
                if let url = vm.currentUserData?.profileImageUrl {
                    WebImage(url: URL(string: url))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 116, height: 116)
                        .clipShape(Circle())
                        .padding(.all, 5)
                        .overlay(Circle().stroke(Color.gragient.linearGradient, lineWidth: 3) )
                }
                CircleButtonView(iconName: "camera", opacityBackground: vm.currentUserData?.profileImageUrl != nil ? 1 : 0.6)
            }
            .padding(.top, 16)
            .onTapGesture {
                showingEditProfile = true
            }
            .fullScreenCover(isPresented: $showingEditProfile) {
                EditProfileView()
                    .environmentObject(AuthViewModel())
            }
            VStack {
                Text(vm.currentUserData?.username != nil &&  vm.currentUserData?.username != "" ? vm.currentUserData!.username : "username")
                    .font(Font.myFont.poppins20)
                    .foregroundColor(Color.theme.accent)
                    .padding(.vertical, 5)
                Text(vm.currentUserData?.email ?? "email")
                    .font(Font.myFont.poppins16)
                    .foregroundColor(Color.theme.secondaryTint)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(32)
    }
    
    private var settings: some View {
        VStack {
            ForEach(profileInfoLabel) { profile in
                RowProfile(text: profile.text)
                if profile.text != profileInfoLabel.last?.text{
                    Divider()
                        .background(Color.theme.accent)
                        .opacity(0.1)
                }
            }
        }
        .padding(.all, 16)
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(32)
        
    }
    
    private var bottomSignOutButton: some View {
        VStack {
            Button {
                vmHome.deletePortfolio()
                if vm.currentGoogleUser?.profile?.email != nil {
                    vmAuth.googleSignOut(viewRouter: viewRouter)
                } else {
                    vmAuth.signOut(viewRouter: viewRouter)
                }
            } label: {
                Text("Sign out")
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
}

