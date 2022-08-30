//
//  CoinLogoView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 26.07.2022.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: CoinModel
    var body: some View {
        VStack {
            CryptoImageView(coin: coin)
                .frame(width: 40, height: 40)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryTint)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinLogoView(coin: dev.coin)
                .previewLayout(.sizeThatFits)
            CoinLogoView(coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
