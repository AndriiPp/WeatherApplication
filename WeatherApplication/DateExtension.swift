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
    static func getFormattedDate(string: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz" // This formate is input formated .
        
        let formateDate = dateFormatter.date(from:"2018-02-02 06:50:16 +0000")!
        dateFormatter.dateFormat = "dd-MM-yyyy" // Output Formated
        
        print ("Print :\(dateFormatter.string(from: formateDate))")//Print :02-02-2018
        return dateFormatter.string(from: formateDate)
    }
}
