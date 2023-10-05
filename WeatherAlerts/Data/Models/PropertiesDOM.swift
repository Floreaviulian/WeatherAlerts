//
//  AlertDOM.swift
//  WeatherAlerts
//
//  Created by FloreaIulian on 10/4/23.
//

import Foundation

struct PropertiesDOM: Decodable {
    let id: String
    let event: String
    let effective: String
    let ends: String?
    let senderName: String
}
