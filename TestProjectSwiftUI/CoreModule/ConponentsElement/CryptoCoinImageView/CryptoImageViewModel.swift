//
//  CryptoImageViewModel.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 13.07.2022.
//

import SwiftUI
import Combine

class CryptoImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let dataService: CryptoImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CryptoImageService(coin: coin)
        addSubsribers()
        isLoading = true
    }
    
    private func addSubsribers() {
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] coinImage in
                self?.image = coinImage
            }
            .store(in: &cancellables)
    }
}
