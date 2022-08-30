//
//  MarketDataService.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 19.07.2022.
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketModel: MarketDataModel? = nil
    var marketDataSubsription: AnyCancellable?
    
    init() {
        getData()
    }
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubsription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] coinModel in
                self?.marketModel = coinModel.data
                self?.marketDataSubsription?.cancel()
            })
    }
}
