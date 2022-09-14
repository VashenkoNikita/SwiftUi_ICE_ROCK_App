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
            Text(coin.name)
                .font(Font.myFont.poppins16)
                .foregroundColor(Color.theme.accent)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .padding(.all, 1)
                .lineLimit(2)
            Text(coin.currentPrice.asCurrecyWith2Decimal())
                .font(Font.myFont.poppins12)
                .foregroundColor(Color.theme.secondaryTint)
        }
        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 6)
        .background(Color.theme.backgroundElements)
        .cornerRadius(16)
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinLogoView(coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
