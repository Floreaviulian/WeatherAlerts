//
//  Alert.swift
//  WeatherAlerts
//
//  Created by FloreaIulian on 10/4/23.
//

import Foundation
import UIKit

enum AlertImage {
    case url(URL)
    case image(UIImage)
}

struct Alert {
    let id: String
    let eventName: String
    let source: String
    let startDate: String
    let endDate: String
    let duration: String
}
