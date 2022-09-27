//
//  CryptoCoreViewModel.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 13.07.2022.
//

import Foundation
import Combine

class CryptoCoreViewModel: ObservableObject {
    @Published var statisticModel: [StatisticModel] = []
    
    @Published var allCryptoCoins: [CoinModel] = []
    @Published var cryptoCurrencyPortfolio: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .priceReversed
    
    private var cancellable = Set<AnyCancellable>()
    private let coinDataService = CryptoDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addData()
    }
    
    private func addData() {
        //update allCoin with searchBar
        $searchText
            .combineLatest(coinDataService.$cryptoCoinModel, $sortOption)
            .map(filterAndSortCoinModel)
            .sink { [weak self] returnCoinModel in
                self?.allCryptoCoins = returnCoinModel
            }
            .store(in: &cancellable)
        //Update portfolio
        $allCryptoCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnCoinModel in
                guard let self = self else { return }
                self.cryptoCurrencyPortfolio = self.getSortedPortfolioCoins(coins: returnCoinModel)
            }
            .store(in: &cancellable)
        //Update market data
        marketDataService.$marketModel
            .combineLatest($cryptoCurrencyPortfolio)
            .map(getMarketDataModel)
            .sink { [weak self] returnMarketData in
                self?.statisticModel = returnMarketData
                self?.isLoading = false
            }
            .store(in: &cancellable)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func deletePortfolio() {
        portfolioDataService.removeAll()
    }
    
    private func mapAllCoinsToPortfolioCoins(coinModels: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        coinModels.compactMap { (coin) -> CoinModel? in
            guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else { return nil }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func filterAndSortCoinModel(text: String, startCoins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var filterCoins = filterCoinModel(text: text, startCoins: startCoins)
        sortCoins(sort: sort, coins: &filterCoins)
        return filterCoins
    }
    
    private func filterCoinModel(text: String, startCoins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return startCoins
        }
        let lowercased = text.lowercased()
        return startCoins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercased) ||
            coin.id.lowercased().contains(lowercased) ||
            coin.symbol.lowercased().contains(lowercased)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
            coins.sort(by: {$0.rank > $1.rank})
        case .price:
            coins.sort(by: {$0.currentPrice < $1.currentPrice})
        case .priceReversed:
            coins.sort(by: {$0.currentPrice > $1.currentPrice})
        }
    }

    private func getSortedPortfolioCoins(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    private func getMarketDataModel(data: MarketDataModel?, portfolioCoin: [CoinModel]) -> [StatisticModel] {
        var stat: [StatisticModel] = []
        
        guard let statisticData = data else {
            return stat
        }
        
        let marketCap = StatisticModel(title: "Market Cap",
                                       value: statisticData.marketCap,
                                       percentageChange: statisticData.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume",
                                    value: statisticData.volume)
        let btcDominants = StatisticModel(title: "BTC Dominance",
                                          value: statisticData.btcDominance)
        
        let portfolioValue =
        portfolioCoin
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        let previewsValue =
        portfolioCoin
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0.0) / 100
                let previewsValue = currentValue / (1 + percentChange)
                return previewsValue
            }
            .reduce(0, +)
        let percentageChange = ((portfolioValue - previewsValue) / previewsValue) * 100
        
        let portfolio = StatisticModel(title: "Porfolio value",
                                       value: portfolioValue.asCurrecyWith2Decimal(),
                                       percentageChange: percentageChange)
        
        stat.append(contentsOf: [
            marketCap,
            volume,
            btcDominants,
            portfolio
        ])
        return stat
    }
}
