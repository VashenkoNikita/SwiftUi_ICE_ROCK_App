//
//  CryptoCoreScreen.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 07.07.2022.
//

import SwiftUI

struct CryptoCoreScreen: View {
    @EnvironmentObject  var vm: CryptoCoreViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetail: Bool = false
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            VStack {
                homeHeader
                Spacer(minLength: 20)
                HomeStatistView(showPortfolio: $showPortfolio)
                
                Spacer(minLength: 20)
                SearchBarView(searchText: $vm.searchText)
                    .padding(.horizontal, 20)
                Spacer(minLength: 20)
                colomnsNames
                    .padding(.horizontal, 20)
                if !showPortfolio {
                    allCryptoCoin
                        .transition(.move(edge: .leading))
                } else {
                    portfolioCryptoCoin
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
            
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
            
        }
        
        .background(
            NavigationLink(isActive: $showDetail, destination: {
                DetailLoadView(coin: $selectedCoin)
            }, label: {
                EmptyView()
            })
        )
        
        
    }
}
struct CryptoCodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CryptoCoreScreen()
                .navigationBarHidden(true)
                .preferredColorScheme(.dark)
        }
        .environmentObject(dev.cryptoViewModel)
    }
}

extension CryptoCoreScreen {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background (
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName:"chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                        
                }
        }
        .padding(.horizontal)
    }
    
    private var colomnsNames: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .rank || vm.sortOption == .rankReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            
            
        }.font(.caption)
            .foregroundColor(.theme.secondaryTint)
            .padding(.horizontal)
    }
    
    private var allCryptoCoin: some View {
        List {
            ForEach(vm.allCryptoCoins) { coin in
                CryptoRowView(coin: coin, showHoldingColomn: false)
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }.listStyle(PlainListStyle())
            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
    }
    private var portfolioCryptoCoin: some View {
        List {
            ForEach(vm.cryptoCurrencyPortfolio) { coin in
                CryptoRowView(coin: coin, showHoldingColomn: true)
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }.listStyle(PlainListStyle())
            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetail.toggle()
    }
}
