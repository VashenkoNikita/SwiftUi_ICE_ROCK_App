//
//  NetworkManager.swift
//  IceRockSwiftUIProject
//
//  Created by NikitaV on 13.07.2022.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkError: LocalizedError {
        case badURLRespoce(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
                
            case .badURLRespoce(url: let url):
                return "[🔥] Bad responce from URL: \(url)"
            case .unknown:
                return "[⚠️] Unknown error occurver"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error>{
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try urlResponce(output: $0, url: url)})
            .eraseToAnyPublisher()
    }
    static func urlResponce(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.badURLRespoce(url: url) }
        return output.data
        
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
