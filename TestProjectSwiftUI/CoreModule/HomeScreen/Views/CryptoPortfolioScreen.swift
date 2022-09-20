//
//  CryptoPortfolioScreen.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 30.08.2022.
//

import SwiftUI

struct CryptoPortfolioScreen: View {
    @EnvironmentObject  var vm: CryptoCoreViewModel
    @State private var showPortfolioView: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetail: Bool = false
    @State private var showSettingsView: Bool = false
        
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                
                homeHeader
                
                ScrollView {
                    Spacer(minLength: 4)
                    PortfolioChartView(values: returnCurrentHoldingPrice())
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    Spacer(minLength: 12)
                    
                    VStack {
                        Spacer(minLength: 12)
                        searchBarAndPlusButton
                        Spacer(minLength: 20)
                        colomnsNames
                        portfolioCryptoCoin
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
                }
                
                Spacer(minLength: 0)
            }
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showPortfolioView) {
            PortfolioView()
                .environmentObject(vm)
        }
    }
}
struct CryptoPortfolioScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CryptoPortfolioScreen()
                .navigationBarHidden(true)
                .preferredColorScheme(.dark)
        }
        .environmentObject(dev.cryptoViewModel)
    }
}

extension CryptoPortfolioScreen {
    
    private var homeHeader: some View {
        CustomNavBar(rightButtonName: "Edit_Pencil", isPresentedEditButton: true) {
            Text("Portfolio")
                .foregroundColor(Color.theme.accent)
                .font(Font.myFont.poppins20)
        } action: {
            showPortfolioView.toggle()
        }
    }
    
    private var colomnsNames: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin (\(vm.cryptoCurrencyPortfolio.count))")
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            HStack(spacing: 4) {
                Text("Holdings")
                Image("ArrowUp")
                    .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image("ArrowUp")
                    .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1.0 : 0.0)
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
    
    private var searchBarAndPlusButton: some View {
        HStack {
            SearchBarView(searchText: $vm.searchText)
            CircleButtonView(iconName:"Add_Plus", opacityBackground: 1)
                .onTapGesture {
                    showPortfolioView.toggle()
                }
        }
        .padding(.horizontal, 16)
    }
    
    private var portfolioCryptoCoin: some View {
        ScrollView {
            ForEach(vm.cryptoCurrencyPortfolio) { coin in
                Divider()
                    .background(Color.theme.accent)
                    .opacity(0.1)
                CryptoRowView(coin: coin, showHoldingColomn: true)
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
    }
    
    private func returnCurrentHoldingPrice() -> [Double] {
        var valuesPortfolio: [Double] = []

        for coin in vm.cryptoCurrencyPortfolio.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue }).prefix(7) {
            valuesPortfolio.append(coin.currentHoldingsValue)
        }
        
        return valuesPortfolio
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetail.toggle()
    }
}

