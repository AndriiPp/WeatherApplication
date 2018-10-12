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
    static func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let date: Date? = dateFormatterGet.date(from: "2018-02-01T19:10:04+00:00")
        return dateFormatterPrint.string(from: date!);
    }
}
