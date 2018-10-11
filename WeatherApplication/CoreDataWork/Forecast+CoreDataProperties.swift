//
//  Forecast+CoreDataProperties.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 10.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var avg: String?
    @NSManaged public var date: String?
    @NSManaged public var descript: String?
    @NSManaged public var max: String?
    @NSManaged public var min: String?
    @NSManaged public var city: String?

}
