//
//  CryptoRowView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 12.07.2022.
//

import SwiftUI

struct CryptoRowView: View {
    let coin: CoinModel
    let showHoldingColomn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftSideOfTheCell
                .frame(width: UIScreen.main.bounds.width / 2.5)
            
            Spacer()
            
            if showHoldingColomn {
                centerSideOfTheCell
            } else {
                ChartView(coin: coin, showChartDetail: false, frameChart: 60)
                    .frame(width: UIScreen.main.bounds.width / 3.5)
            }
            
            rightSideOfTheCell
        }
        .frame(height: 66)
        .background(Color.theme.colorOverBackground)
        
    }
}

struct CryptoRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CryptoRowView(coin: dev.coin, showHoldingColomn: false)
                .previewLayout(.sizeThatFits)
            CryptoRowView(coin: dev.coin, showHoldingColomn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CryptoRowView {
    private var leftSideOfTheCell: some View {
        HStack {
            CryptoImageView(coin: coin)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text("\(coin.symbol.uppercased())")
                    .font(Font.myFont.poppins15)
                    .padding(.leading, 4)
                    .padding(.bottom, 0.5)
                    .foregroundColor(.theme.accent)
                Text("\(coin.name)")
                    .font(Font.myFont.poppins13)
                    .padding(.leading, 4)
                    .foregroundColor(.theme.secondaryTint)
            }
            .frame(width: 60, alignment: .leading)
        }
        .padding(.horizontal, 16)
    }
    
    private var centerSideOfTheCell: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrecyWith2Decimal())
                .foregroundColor(Color.theme.accent)
                .font(Font.myFont.poppins15)
                .padding(.bottom, 0.5)
            Text((coin.currentHoldings ?? 0).asNumberString())
                .foregroundColor(Color.theme.secondaryTint)
                .font(Font.myFont.poppins13)
        }
    }
    
    private var rightSideOfTheCell: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrecyWith2Decimal())
                .font(Font.myFont.poppins15)
                .foregroundColor(.theme.accent)
                .padding(.bottom, 0.5)
            HStack(alignment: .bottom, spacing: 0) {
                Text(weekPriceChange() >= 0 ? "+" : "")
                    .font(Font.myFont.poppins13)
                Text(weekPriceChange().asPercentString())
                    .font(Font.myFont.poppins13)
            }
            .foregroundColor(weekPriceChange() >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        .padding(.trailing, 16)
    }
    
    private func weekPriceChange() -> Double {
        let firstPrice = coin.sparklineIn7D?.price?.first ?? 0
        let lastPrice = coin.sparklineIn7D?.price?.last ?? 0
        let currentPrice = (lastPrice + firstPrice) / 2
        
        let difference = lastPrice - firstPrice
        
        let result = (difference/currentPrice) * 100
        
        return result
    }
}
