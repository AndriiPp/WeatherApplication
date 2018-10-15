//
//  File.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 12.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import Foundation
import Foundation

extension Date {
    static func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}
