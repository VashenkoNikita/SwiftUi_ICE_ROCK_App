//
//  PortfolioView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 26.07.2022.
//

import SwiftUI
import BottomSheet

struct PortfolioView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var vm: CryptoCoreViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var portfolioCoin: CoinModel? = nil
    @State private var quantity: String = ""
    @State private var isCoinContainsPortfolio: Bool = false
    @State private var bottomSheetPosition: BottomSheetPosition = .absolute(UIScreen.main.bounds.height / 1.85)
    
    var body: some View {
        ZStack {
            Color.theme.background
            VStack {
                CustomNavBar(isPresentedEditButton: false) {
                    Text("Edit")
                        .foregroundColor(Color.theme.accent)
                        .font(Font.myFont.poppins20)
                }
                
                Spacer(minLength: 12)
                
                ScrollView {
                    myCryptoViewList
                    Spacer(minLength: 12)
                    allCryptoViewList
                }
                .onChange(of: vm.searchText) { newValue in
                    if newValue == "" {
                        removeSelectedCoin()
                    }
                }
            }
            
            if selectedCoin != nil {
                Color.clear
                    .bottomSheet( bottomSheetPosition: $bottomSheetPosition, switchablePositions: [.dynamicBottom, .absolute(UIScreen.main.bounds.height / 1.85)]) {
                        portfolioInputView
                    }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.cryptoViewModel)
    }
}

extension PortfolioView {
    
    private var allCryptoViewList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add coin")
                .font(Font.myFont.poppins20)
                .foregroundColor(Color.theme.accent)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            SearchBarView(searchText: $vm.searchText)
                .padding(.trailing, 16)
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack(spacing: 8) {
                    ForEach(vm.allCryptoCoins) {coin in
                        CoinLogoView(coin: coin)
                            .onTapGesture {
                                withAnimation(.linear) {
                                    updatePortfolioValue(coin: coin)
                                }
                            }
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(radius: 32, corners: [.topLeft, .bottomLeft])
    }
    
    private var myCryptoViewList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My coin")
                .font(Font.myFont.poppins20)
                .foregroundColor(Color.theme.accent)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHStack(spacing: 8) {
                    ForEach(vm.cryptoCurrencyPortfolio) {coin in
                        CoinLogoView(coin: coin)
                            .onTapGesture {
                                withAnimation(.linear) {
                                    updatePortfolioValue(coin: coin)
                                }
                            }
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .background(Color.theme.colorOverBackground)
        .cornerRadius(radius: 32, corners: [.topLeft, .bottomLeft])
    }
    
    private var portfolioInputView: some View {
        VStack(spacing: 20) {
            VStack(spacing: isCoinContainsPortfolio ? 20 : 25){
                HStack {
                    if let coin = selectedCoin {
                        CryptoImageView(coin: coin)
                            .frame(width: 25, height: 25)
                        Text(coin.name)
                            .font(Font.myFont.poppins20)
                            .foregroundColor(Color.theme.accent)
                    }
                    if isCoinContainsPortfolio {
                        Spacer()
                        Button {
                            cellCoin()
                        } label: {
                            Text("Cell")
                                .font(Font.myFont.poppins20)
                                .foregroundColor(Color.theme.accent)
                        }
                    } else {
                        Spacer()
                        Button {
                            selectedCoin = nil
                            UIApplication.shared.endEditing()
                        } label: {
                            Text("Cancel")
                                .font(Font.myFont.poppins20)
                                .foregroundColor(Color.theme.accent)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 32,alignment: .leading)
                
                VStack(alignment: .leading) {
                    Text("Amount holding")
                        .font(Font.myFont.poppins15)
                        .foregroundColor(Color.theme.accent.opacity(0.7))
                        .padding(.horizontal, 4)
                    TextField("21.0", text: $quantity)
                        .padding(.horizontal, 12)
                        .foregroundColor(Color.theme.tintColor)
                        .keyboardType(.webSearch)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        .background(Color.theme.colorOverBackground)
                        .cornerRadius(10)
                }
                
                if isCoinContainsPortfolio {
                    Divider()
                        .background(Color.theme.accent.opacity(0.1))
                        .padding(.leading, 16)
                    HStack {
                        Text("In portfolio")
                            .font(Font.myFont.poppins15)
                            .foregroundColor(Color.theme.accent.opacity(0.7))
                        Spacer()
                        Text(portfolioCoin?.currentHoldingsValue.asCurrecyWith2Decimal() ?? "")
                            .font(Font.myFont.poppins15)
                            .foregroundColor(Color.theme.accent)
                    }
                }
                Divider()
                    .background(Color.theme.accent.opacity(0.1))
                    .padding(.leading, 16)
                HStack {
                    Text("Current price")
                        .font(Font.myFont.poppins15)
                        .foregroundColor(Color.theme.accent.opacity(0.7))
                    Spacer()
                    Text(selectedCoin?.currentPrice.asCurrecyWith2Decimal() ?? "")
                        .font(Font.myFont.poppins15)
                        .foregroundColor(Color.theme.accent)
                }
                Divider()
                    .background(Color.theme.accent.opacity(0.1))
                    .padding(.leading, 16)
                HStack {
                    Text("Current value")
                        .font(Font.myFont.poppins15)
                        .foregroundColor(Color.theme.accent.opacity(0.7))
                    Spacer()
                    Text(getCurrentValues().asCurrecyWith2Decimal())
                        .font(Font.myFont.poppins15)
                        .foregroundColor(Color.theme.accent)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 16)
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text(isCoinContainsPortfolio ? "Save" : "Add")
                    .foregroundColor(Color.theme.backgroundAuth)
                    .font(Font.myFont.poppins18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 56)
                            .foregroundColor(Color.theme.accent.opacity(0.1))
                    )
                    .frame(width: UIScreen.main.bounds.width - 32, height: 56)
            })
            .padding(.bottom, 32)
        }
        .cornerRadius(radius: 32, corners: [.topLeft, .topRight])
    }
    
    private func updatePortfolioValue(coin: CoinModel) {
        selectedCoin = coin
        
        if vm.cryptoCurrencyPortfolio.contains(where: { coin in
            portfolioCoin = coin
            return selectedCoin?.currentPrice == coin.currentPrice
        }) {
            isCoinContainsPortfolio = true

        } else {
            isCoinContainsPortfolio = false
        }
        
        if let portfolio = vm.cryptoCurrencyPortfolio.first(where: {$0.id == coin.id}),
           let amount = portfolio.currentHoldings
        {
            quantity = "\(amount)"
        } else {
            quantity = ""
        }
    }
    
    private func getCurrentValues() -> Double {
        if let quantity = Double(quantity) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantity)
        else { return }
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation {
            removeSelectedCoin()
        }
        UIApplication.shared.endEditing()
    }
    //MARK: - Нужно реализовать логику удаления портфолио при авторизации нового пользователя
//    private func removeAllCoin() {
//
//    }
    
    private func cellCoin() {
        guard let coin = selectedCoin else { return }
        
        vm.updatePortfolio(coin: coin, amount: 0)
        
        withAnimation {
            removeSelectedCoin()
        }
        UIApplication.shared.endEditing()
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
