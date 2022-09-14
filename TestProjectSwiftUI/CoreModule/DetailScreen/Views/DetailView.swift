//
//  DetailView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 27.07.2022.
//

import SwiftUI

struct DetailLoadView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}
struct DetailView: View {
    @StateObject private var vm: DetailViewModel
    @State private var isReadMore: Bool = false
    
    private var colomns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        VStack {
            ScrollView {
                CustomNavBar(isPresentedEditButton: false) {
                    titleName
                }
                Spacer(minLength: 12)
                VStack {
                    infoChartView
                        .padding()
                    ChartView(coin: vm.coin, showChartDetail: true, frameChart: 100)
                        .padding(.vertical, 20)
                    VStack(spacing: 30) {
                        overviewTitle
                        overviewGrid
                        descriptionTitle
                        descriptionCoin
                        additionalTitle
                        additionalGrid
                    }
                    .padding()
                }
                .background(Color.theme.colorOverBackground)
                .cornerRadius(32)
            }
        }
        .ignoresSafeArea()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
            .preferredColorScheme(.dark)
    }
}


extension DetailView {
    private var infoChartView: some View {
        VStack {
            Text("\(Date().asShortDateString())")
                .font(Font.myFont.poppins12)
                .foregroundColor(Color.theme.secondaryTint)
            if let overViewStat = vm.overviewStat {
                Spacer()
                Text(overViewStat.first?.value ?? "")
                    .font(Font.myFont.poppins28)
                    .foregroundColor(Color.theme.accent)
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    Text(weeklyPriceDifference() >= 0 ? "+" : "")
                        .font(Font.myFont.poppins16)
                    Text(weeklyPriceDifference().asPercentString())
                        .font(Font.myFont.poppins16)
                }
                .foregroundColor(weeklyPriceDifference() >= 0 ? Color.theme.green : Color.theme.red)
            }
        }
    }
    
    private var descriptionTitle: some View {
        Group {
            if let _ = vm.coinDescription {
                Text("Description")
                    .font(Font.myFont.poppins18)
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var descriptionCoin: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .center) {
                    Text(coinDescription)
                        .lineLimit(isReadMore ? .none : 4)
                        .font(Font.myFont.poppins14)
                    Button {
                        withAnimation(.easeInOut) {
                            isReadMore.toggle()
                        }
                    } label: {
                        Text(isReadMore ? "Hide text" : "Check more")
                            .font(Font.myFont.poppins14)
                            .foregroundColor(Color.theme.backgroundAuth)
                            .padding(.vertical, 1)
                    }
                }
                .foregroundColor(Color.theme.secondaryTint)
            }
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(Font.myFont.poppins18)
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(Font.myFont.poppins18)
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var overviewGrid: some View {
        LazyVGrid(columns: colomns,
                  alignment: .center,
                  spacing: 8,
                  pinnedViews: []) {
            ForEach(vm.overviewStat) { stat in
                StatisticView(statModel: stat, widthStatView: UIScreen.main.bounds.width / 2 - 20)
            }
        }
    }
    private var additionalGrid: some View {
        LazyVGrid(columns: colomns,
                  alignment: .center,
                  spacing: 8,
                  pinnedViews: []) {
            ForEach(vm.additionalStat) { stat in
                StatisticView(statModel: stat, widthStatView: UIScreen.main.bounds.width / 2 - 20)
            }
        }
    }
    private var titleName: some View {
        HStack {
            CryptoImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
            Text(vm.coin.name)
                .font(Font.myFont.poppins20)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private func weeklyPriceDifference() -> Double {
        let firstPrice = vm.coin.sparklineIn7D?.price?.first ?? 0
        let lastPrice = vm.coin.sparklineIn7D?.price?.last ?? 0
        let currentPrice = (lastPrice + firstPrice)/2
        
        let difference = lastPrice - firstPrice
        
        let result = (difference/currentPrice) * 100
        
        return result
    }
}
