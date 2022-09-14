//
//  CryptoCoreScreen.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 07.07.2022.
//

import SwiftUI
import GoogleSignIn

struct CryptoCoreScreen: View {
    @EnvironmentObject private var vm: CryptoCoreViewModel
    @StateObject private var vmProfile = ProfileViewModel()
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetail: Bool = false
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
            
            VStack {
                homeHeader
                
                Spacer(minLength: 12)
                
                HomeStatistView()
                
                Spacer(minLength: 12)
                
                VStack {
                    Spacer(minLength: 16)
                    SearchBarView(searchText: $vm.searchText)
                        .padding(.horizontal, 16)
                    Spacer(minLength: 20)
                    colomnsNames
                    allCryptoCoin
                        .background(
                            NavigationLink(isActive: $showDetail, destination: {
                                DetailLoadView(coin: $selectedCoin)
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarHidden(true)
                            }, label: {
                                EmptyView()
                            })
                        )
                }
                .background(Color.theme.colorOverBackground)
                .cornerRadius(32)
                Spacer(minLength: 0)
            }
        }
        .ignoresSafeArea()
    }
}
struct CryptoCodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CryptoCoreScreen()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.cryptoViewModel)
    }
}

extension CryptoCoreScreen {
    
    private var homeHeader: some View {
        HStack {
            NavigationLink(isActive: $showSettingsView, destination:{
                ProfileView()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                    .environmentObject(AuthViewModel())
            }, label: {
                Image(uiImage: (vmProfile.image != nil ? vmProfile.image! : UIImage(named: "avatar")!))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 46, height: 46)
                    .clipShape(Circle())
                    .padding(.all, 2)
                    .overlay(Circle().stroke(Color.gragient.linearGradient, lineWidth: 2))
                    .padding(.leading)
                    .padding(.trailing, 6)
            })
         
            VStack(alignment: .leading) {
                Text("\(vmProfile.user?.profile?.name != nil ? "Hello," : "Hello!") \(vmProfile.user?.profile?.name.components(separatedBy: [" "]).first ?? "")")
                    .padding(.bottom, 0.9)
                    .font(Font.myFont.poppins20)
                    .foregroundColor(Color.theme.accent)
                Text("\(Date().asShortDateString())")
                    .font(Font.myFont.poppins12)
                    .foregroundColor(Color.theme.secondaryTint)
            }
            .frame(alignment: .bottom)
            
            Spacer()
        
            NavigationLink(isActive: $showPortfolio, destination:{
                CryptoPortfolioScreen()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
            }, label: {
                CircleButtonView(iconName:"Suitcase", opacityBackground: 1)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showPortfolio.toggle()
                        }
                    }
                    .frame(alignment: .trailing)
                    .padding()
            })
        }
        .frame(width: UIScreen.main.bounds.width ,height: 104, alignment: .bottom)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(32)
    }
    
    private var colomnsNames: some View {
        HStack {
            HStack(spacing: 4) {
              Text("Coin (\(vm.allCryptoCoins.count))")
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            HStack(spacing: 4) {
                Text("Price")
                Image("ArrowUp")
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 180 : 0))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
            
        }.font(Font.myFont.poppins15)
            .foregroundColor(.theme.secondaryTint)
            .padding(.horizontal)
    }
    
    private var allCryptoCoin: some View {
        ScrollView {
            ForEach(vm.allCryptoCoins) { coin in
                Divider()
                    .background(Color.theme.accent)
                    .opacity(0.1)
                CryptoRowView(coin: coin, showHoldingColomn: false)
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
    }

    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetail.toggle()
    }
}
