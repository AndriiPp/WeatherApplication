//
//  Forecast+CoreDataClass.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 10.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Forecast)
public class Forecast: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Forecast"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
