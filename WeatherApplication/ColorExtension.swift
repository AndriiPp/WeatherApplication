//
//  ColorExtension.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 11.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


