//
//  WeatherAPIs.swift
//  WeatherAlerts
//
//  Created by FloreaIulian on 10/4/23.
//

import Foundation
import Alamofire

enum WeatherAPIs: URLRequestBuilder {
    case getWeatherData
    
    var path: String {
        "alerts/active"
    }
    
    var parameters: Parameters? {
        ["status": "actual", "message_type": "alert"]
    }
    
    var method: HTTPMethod {
        .get
    }
}
