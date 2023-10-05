//
//  AlertsUseCase.swift
//  WeatherAlerts
//
//  Created by FloreaIulian on 10/4/23.
//

import Foundation

protocol AlertsUseCaseProtocol {
    func getAlerts(_ completion: @escaping (Result<[Alert], Error>) -> Void)
}

class AlertsUseCase: AlertsUseCaseProtocol {
    private let weatherRepository: WeatherRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }
    
    func getAlerts(_ completion: @escaping (Result<[Alert], Error>) -> Void) {
        weatherRepository.getWeatherData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let weather):
                completion(.success(self.mapAlerts(from: weather)))
            }
        }
    }
    
    private func mapAlerts(from weather: WeatherDOM) -> [Alert] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let stringFormatter = DateFormatter()
        stringFormatter.dateFormat = "d MMM YYYY, HH:mm:ss"
        
        return weather.features.map { feature in
            let startDate = dateFormatter.date(from: feature.properties.effective) ?? Date()
            var endString = "No end date"
            var duration = "Permanent"
            if let date = feature.properties.ends, let endDate = dateFormatter.date(from: date) {
                endString = stringFormatter.string(from: endDate)
                let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
                duration = "\(numberOfDays.day ?? 0) days"
            }
            
            return Alert(id: feature.properties.id,
                         eventName: feature.properties.event,
                         source: feature.properties.senderName,
                         startDate: stringFormatter.string(from: startDate),
                         endDate: endString,
                         duration: duration)
        }
    }
}
