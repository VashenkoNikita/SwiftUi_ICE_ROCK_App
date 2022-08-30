//
//  DetailViewModel.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 27.07.2022.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStat: [StatisticModel] = []
    @Published var additionalStat: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil

    @Published var coin: CoinModel
    private var coinDetailService: CoinDetailDataService
    private var cancelables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        coinDetailService = CoinDetailDataService(coin: coin)
        addSubscription()
    }
    
    private func addSubscription() {
        coinDetailService.$cryptoDetailCoinModel
            .combineLatest($coin)
            .map(mapStatData)
            .sink { [weak self] coinDetail in
                self?.overviewStat = coinDetail.overview
                self?.additionalStat = coinDetail.additional
            }
            .store(in: &cancelables)
        
        coinDetailService.$cryptoDetailCoinModel
            .sink { [weak self] coinDetailData in
                self?.coinDescription = coinDetailData?.readableDescription
                self?.websiteURL = coinDetailData?.links?.homepage?.first
            }
            .store(in: &cancelables)
    }
    
    private func mapStatData(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        return (createOverviewStat(coinModel: coinModel), createAdditionalModel(coinModel: coinModel, coinDetailModel: coinDetailModel))
    }
    
    private func createOverviewStat(coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrecyWith2Decimal()
        let priceChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current price", value: price, percentageChange: priceChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market CApitalization", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewStatArray: [StatisticModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overviewStatArray
    }
    
    private func createAdditionalModel(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> [StatisticModel] {
        let high = coinModel.high24H?.asCurrecyWith2Decimal() ?? "n/a"
        let highStat = StatisticModel(title: "24h high", value: high)
        
        let low = coinModel.low24H?.asCurrecyWith2Decimal() ?? "n/a"
        let lowStat = StatisticModel(title: "24h low", value: low)
        
        let priceChange2 = coinModel.priceChange24H?.asCurrecyWith2Decimal() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat2 = StatisticModel(title: "24h Price Change", value: priceChange2, percentageChange: pricePercentChange)
        
        let marketCapChange2 = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat2 = StatisticModel(title: "24h Market Cap Change", value: marketCapChange2, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalStatArray: [StatisticModel] = [
            highStat, lowStat, priceStat2, marketCapStat2, blockStat, hashingStat
        ]
        return additionalStatArray
    }
}
