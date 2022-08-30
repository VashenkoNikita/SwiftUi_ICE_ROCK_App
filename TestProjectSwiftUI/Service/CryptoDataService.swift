//
//  CryptoDataService.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 13.07.2022.
//

import Foundation
import Combine

class CryptoDataService {
    @Published var cryptoCoinModel: [CoinModel] = []
    var coinSubsription: AnyCancellable?
    
    init() {
        getCoin()
    }
    func getCoin() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubsription = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] coinModel in
                self?.cryptoCoinModel = coinModel
                self?.coinSubsription?.cancel()
            })
        
    }
}
