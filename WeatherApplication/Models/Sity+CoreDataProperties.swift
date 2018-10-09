//
//  Sity+CoreDataProperties.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 09.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//
//

import Foundation
import CoreData


extension Sity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sity> {
        return NSFetchRequest<Sity>(entityName: "Sity")
    }

    @NSManaged public var city: String?
    @NSManaged public var forecast: NSSet?

}

// MARK: Generated accessors for forecast
extension Sity {

    @objc(addForecastObject:)
    @NSManaged public func addToForecast(_ value: Forecast)

    @objc(removeForecastObject:)
    @NSManaged public func removeFromForecast(_ value: Forecast)

    @objc(addForecast:)
    @NSManaged public func addToForecast(_ values: NSSet)

    @objc(removeForecast:)
    @NSManaged public func removeFromForecast(_ values: NSSet)

}
