//
//  Forecast+CoreDataProperties.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 09.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var city: String?
    @NSManaged public var min: Float
    @NSManaged public var max: Float
    @NSManaged public var avg: Float
    @NSManaged public var date: NSDate?
    @NSManaged public var sity: Sity?

}
