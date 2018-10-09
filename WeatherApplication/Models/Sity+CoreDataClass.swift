//
//  Sity+CoreDataClass.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 09.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Sity)
public class Sity: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Sity"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
