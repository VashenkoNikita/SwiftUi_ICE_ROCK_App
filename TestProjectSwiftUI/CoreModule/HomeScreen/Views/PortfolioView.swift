//
//  PortfolioView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 26.07.2022.
//

import SwiftUI

struct PortfolioView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var vm: CryptoCoreViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantity: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                allCryptoViewList
                myCryptoViewList
                
                if selectedCoin != nil {
                    portfolioInputView
                }
            }
            .navigationTitle("Edit portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBar
                }
            }
            .onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.cryptoViewModel)
            .preferredColorScheme(.dark)
    }
}

extension PortfolioView {
    private var allCryptoViewList: some View {
        VStack(alignment: .leading, spacing: 20) {
            SearchBarView(searchText: $vm.searchText)
            Text("All crypto currency")
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            Divider()
                .background(Color.theme.accent)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(vm.allCryptoCoins) {coin in
                        CoinLogoView(coin: coin)
                            .frame(width: 75, height: 120)
                            .padding(4)
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    updatePortfolioValue(coin: coin)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedCoin?.id == coin.id ? Color.theme.red : Color.clear, lineWidth: 2)
                            )
                    }
                }
            }
            .padding(4)
            .padding(.leading)
        }
    }
    private var myCryptoViewList: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("My crypto currency")
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            Divider()
                .background(Color.theme.accent)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(vm.cryptoCurrencyPortfolio) {coin in
                        CoinLogoView(coin: coin)
                            .frame(width: 75, height: 120)
                            .padding(4)
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    updatePortfolioValue(coin: coin)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedCoin?.id == coin.id ? Color.theme.red : Color.clear, lineWidth: 2)
                            )
                    }
                }
            }
            .padding(4)
            .padding(.leading)
        }
    }
    
    private var portfolioInputView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrecyWith2Decimal() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Enter quantity", text: $quantity)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValues().asCurrecyWith2Decimal())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
        .foregroundColor(Color.theme.accent)
    }
    
    private var trailingNavBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantity)) ? 1.0 : 0.0)
        }
        .font(.headline)
    }
    
    private func updatePortfolioValue(coin: CoinModel) {
        selectedCoin = coin
        
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
            showCheckMark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
    
    
}
