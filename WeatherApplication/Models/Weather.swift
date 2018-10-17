//
//  Weather.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 08.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import Foundation

enum TemperatureUnit: String {
    case kelvin// = "kelvin"
    case imperial// = "imperial"
    case metric// = "metric"
}

struct Weather {
    let date: NSDate?
    let description: String
    let minTemperature: Double
    let maxTemperature: Double
    let avgTemperature: Double
    let temperatureUnit: TemperatureUnit
}
