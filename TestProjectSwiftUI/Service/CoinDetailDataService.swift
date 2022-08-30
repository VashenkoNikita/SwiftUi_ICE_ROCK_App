//
//  CoinDetailDataService.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 27.07.2022.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var cryptoDetailCoinModel: CoinDetailModel? = nil
    var coinDetailSubsription: AnyCancellable?
    var coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubsription = NetworkManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)

            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] coinModelDetail in
                self?.cryptoDetailCoinModel = coinModelDetail
                self?.coinDetailSubsription?.cancel()
            })
        
    }
}
