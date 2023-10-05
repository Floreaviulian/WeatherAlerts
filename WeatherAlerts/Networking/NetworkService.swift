//
//  NetworkService.swift
//  WeatherAlerts
//
//  Created by FloreaIulian on 10/4/23.
//

import Foundation
import Alamofire
import Combine

protocol NetworkServiceProtocol: AnyObject {
    func execute<T: Decodable>(_ urlRequest: URLRequestBuilder, model: T.Type, completion: @escaping (Result<T, AFError>) -> Void) -> AnyCancellable
}

extension NetworkServiceProtocol {
    func execute<T: Decodable>(_ urlRequest: URLRequestBuilder, model: T.Type, completion: @escaping (Result<T, AFError>) -> Void) -> AnyCancellable {
        
        let requestPublisher = AF.request(urlRequest).publishDecodable(type: T.self)
        
        let cancellable = requestPublisher
            .subscribe(on: DispatchQueue(label: "Background Queue", qos: .background))
            .receive(on: RunLoop.main)
            .sink { result in
                if let value = result.value {
                    completion(Result.success(value))
                } else if let error = result.error {
                    completion(Result.failure(error))
                }
            }
        return cancellable
    }
}

class NetworkService: NetworkServiceProtocol {
    public static let `default`: NetworkServiceProtocol = {
        var service = NetworkService()
        return service
    }()
}
