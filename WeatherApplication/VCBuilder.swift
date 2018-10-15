//
//  VCBuilder.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 15.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit

class VCBuilder {
    
    class func createMainVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "MainVCStory", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVCStoryIdent")
        return controller
    }
    
    class func createDetailForecastVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "DetailForecastStory", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailForecastIdent")
        return controller
    }
    
    class func createOfflineVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "OfflineCityListVCStory", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "OfflineCityListIdent")
        return controller
    }
}
