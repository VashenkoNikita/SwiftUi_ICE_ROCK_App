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
            Spacer()
            if showHoldingColomn {
                centerSideOfTheCell
            }
            rightSideOfTheCell
        }
        .font(.subheadline)
        .background(Color.theme.background.opacity(0.001))
    }
}

struct CryptoRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CryptoRowView(coin: dev.coin, showHoldingColomn: true)
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
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryTint)
                .frame(minWidth: 10)
            CryptoImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .padding(.leading, 4)
                .foregroundColor(.theme.accent)
        }
        
    }
    private var centerSideOfTheCell: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrecyWith2Decimal())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    private var rightSideOfTheCell: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrecyWith2Decimal())
                .bold()
                .foregroundColor(.theme.accent)
            Text(coin.marketCapChangePercentage24H?.asPercentString() ?? "0.0%")
                .foregroundColor(
                    (coin.marketCapChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red
            )
        }.frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
