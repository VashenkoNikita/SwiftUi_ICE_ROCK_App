//
//  CryptoImageView.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 13.07.2022.
//

import SwiftUI

struct CryptoImageView: View {
    
    @StateObject var vm: CryptoImageViewModel
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CryptoImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.theme.secondaryTint)
            }
        }
    }
}

struct CryptoImageView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoImageView(coin: dev.coin)
            .previewLayout(.sizeThatFits)
    }
}
