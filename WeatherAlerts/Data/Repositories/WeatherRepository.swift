//
//  WeatherRepository.swift
//  WeatherAlerts
//
//  Created by FloreaIulian on 10/4/23.
//

import Foundation
import Combine

protocol WeatherRepositoryProtocol {
    func getWeatherData(_ completion: @escaping (Result<WeatherDOM, Error>) -> Void)
}

class WeatherRepository: WeatherRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol = NetworkService.default) {
        self.networkService = networkService
    }
    
    func getWeatherData(_ completion: @escaping (Result<WeatherDOM, Error>) -> Void) {
        networkService
            .execute(WeatherAPIs.getWeatherData, model: WeatherDOM.self) { result in
                switch result {
                case .success(let response):
                    completion(.success(response))
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }.store(in: &subscriptions)
    }
}
