//
//  detailTableViewController.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 09.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//
import UIKit
import CoreData

class OfflineDetailForecastViewController: UIViewController {
    @IBOutlet weak var DetailLabel: UILabel!
    
    let network: NetworkManager = NetworkManager.sharedInstance
    var forecast : Forecast?
//    var weather : [Weather] = []
    var city = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupNavBar()
        printForecast()
    }
    //MARK:- private methods
    private func setupNavBar(){
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 227, g: 243, b: 90)
        navigationItem.title = city
    }
    private func printForecast(){
        NetworkManager.isReachable { (_) in
            self.printForecastWhenOnline()
        }
        NetworkManager.isUnreachable { (_) in
            self.printForecastWhenOffline()
        }
    }
    private func printForecastWhenOffline(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        request.predicate = NSPredicate(format: "city = %@", city)
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try CoreDataManager.instance.managedObjectContext.fetch(request)
            for data in result as! [NSManagedObject] {
                self.DetailLabel.text = " \(String(describing: data.value(forKey: "descript") as! String))" + "\n Tmin: \(String(describing: data.value(forKey: "min") as! String))"  + " \n Tmax: \(String(describing: data.value(forKey: "max") as! String))" + "\n Tavg: \(String(describing: data.value(forKey: "avg") as! String))"
            }
        } catch {
            print("Failed")
        }
    }
    
    private func printForecastWhenOnline(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        request.predicate = NSPredicate(format: "city = %@", self.city)
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        if let result =  try? CoreDataManager.instance.managedObjectContext.fetch(request) {
            for object in result {
                CoreDataManager.instance.managedObjectContext.delete(object as! NSManagedObject)
                CoreDataManager.instance.saveContext()
            }
        }

        OpenWeatherMapAPI.requestTodaysWeather(city: (self.city)) { (weather) in
            if weather != nil {
           
                if self.forecast == nil {
                    self.forecast = Forecast()
                }
                if let forecast = self.forecast {
                    forecast.date = String(describing: weather?.date)
                    forecast.descript =  String(describing: weather!.description)
                    forecast.min =   String(describing: weather!.minTemperature)
                    forecast.max =  String(describing: weather!.maxTemperature)
                    forecast.avg =  String(describing: weather!.avgTemperature)
                    forecast.city = String(self.city)
                    CoreDataManager.instance.saveContext()
                }

                DispatchQueue.main.async {
                    self.navigationItem.title = self.city
                    self.DetailLabel.text = "\n  \(weather!.description)" +  "\n Tmin: \(String(describing: weather!.minTemperature))"   + "\n Tmax: \(String(describing: weather!.maxTemperature))" + "\n Tavg: \(String(describing: weather!.avgTemperature))"
                }
            }
        }
    }
}
