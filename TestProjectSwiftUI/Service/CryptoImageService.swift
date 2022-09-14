//
//  CryptoImageService.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 13.07.2022.
//

import SwiftUI
import Combine

class CryptoImageService {
    
    @Published var image: UIImage? = nil
    var imageSubscriptional: AnyCancellable?
    var coin: CoinModel
    private let fileManager = LocalFileManager.shared
    private let folderName = "coin_folder"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getImageWithFileFolder()
    }
    
    private func getImageWithFileFolder() {
        if let savedImage = fileManager.getImage(nameImage: imageName, folderName: folderName) {
            image = savedImage
        } else {
            getDowloadImage()
        }
    }
    
    private func getDowloadImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscriptional = NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] imageCoin in
                guard let self = self, let downloadImage = imageCoin else { return }
                self.image = downloadImage
                self.imageSubscriptional?.cancel()
                self.fileManager.saveImage(image: downloadImage, nameImage: self.imageName, nameFolder: self.folderName)
            })
        
    }
}
