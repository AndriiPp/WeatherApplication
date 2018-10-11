//
//  detailTableViewController.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 09.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit
import CoreData

class OfflineDetailViewController: UIViewController {
    let network: NetworkManager = NetworkManager.sharedInstance
    var forecast : Forecast?
    var weather : [Weather] = []
    var city = ""
    lazy var inputsContainer : UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        cv.layer.cornerRadius = 10
        cv.layer.masksToBounds = true
        return cv
    }()
    lazy var cityLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    lazy var maxTemeratureLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        label.text = "max"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    lazy var minTemeratureLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        label.text = "min"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        label.text = "descript"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    lazy var avgLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        label.text = "avg"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    let citySeparator : UIView = {
        let  cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.black
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupNavBar()
        printForecast()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSubviews()
    }
    private func setupNavBar(){
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 227, g: 243, b: 90)
        navigationItem.title = cityLabel.text!
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
        request.predicate = NSPredicate(format: "city = %@", cityLabel.text!)
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try CoreDataManager.instance.managedObjectContext.fetch(request)
            for data in result as! [NSManagedObject] {
                descriptionLabel.text = data.value(forKey: "descript") as? String
                minTemeratureLabel.text =  data.value(forKey: "min") as? String
                maxTemeratureLabel.text = data.value(forKey: "max") as? String
                avgLabel.text = data.value(forKey: "avg") as? String
            }
        } catch {
            print("Failed")
        }
    }
    
    private func printForecastWhenOnline(){
        self.city = cityLabel.text!
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        request.predicate = NSPredicate(format: "city = %@", self.cityLabel.text!)
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        if let result =  try? CoreDataManager.instance.managedObjectContext.fetch(request) {
            for object in result {
                CoreDataManager.instance.managedObjectContext.delete(object as! NSManagedObject)
            }
        }
        OpenWeatherMapAPI.requestTodaysWeather(city: self.city) { (weather) in
            if let weather = weather {
                if self.forecast == nil {
                    self.forecast = Forecast()
                }
                if let forecast = self.forecast {
                    forecast.date = String(describing: weather.date)
                    forecast.descript =  String(weather.description)
                    forecast.min =  "Tmin: " + String(weather.minTemperature)
                    forecast.max =  "Tmax: " + String(weather.maxTemperature)
                    forecast.avg =  "Tavg: " + String(weather.avgTemperature)
                    forecast.city = String(self.city)
                    CoreDataManager.instance.saveContext()
                }
                DispatchQueue.main.async {
                    self.descriptionLabel.text =  weather.description
                    self.minTemeratureLabel.text = "Tmin: " + String(weather.minTemperature)
                    self.maxTemeratureLabel.text = "Tmax: " + String(weather.maxTemperature)
                    self.avgLabel.text = "avg temperature: " + String(weather.maxTemperature)
                }
            }
        }
    }
        
    
    func setupSubviews(){
        view.addSubview(inputsContainer)
        inputsContainer.addSubview(cityLabel)
        inputsContainer.addSubview(citySeparator)
        inputsContainer.addSubview(descriptionLabel)
        inputsContainer.addSubview(minTemeratureLabel)
        inputsContainer.addSubview(maxTemeratureLabel)
        inputsContainer.addSubview(avgLabel)
        
        inputsContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        inputsContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        inputsContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainer.heightAnchor.constraint(equalToConstant: 380).isActive = true
        
        cityLabel.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        cityLabel.topAnchor.constraint(equalTo: inputsContainer.topAnchor).isActive = true
        cityLabel.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        cityLabel.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/5).isActive = true
        
        citySeparator.topAnchor.constraint(equalTo: cityLabel.bottomAnchor).isActive = true
        citySeparator.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor).isActive = true
        citySeparator.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        citySeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        descriptionLabel.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: citySeparator.bottomAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/5).isActive = true
        minTemeratureLabel.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        minTemeratureLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        minTemeratureLabel.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        minTemeratureLabel.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/5).isActive = true
        maxTemeratureLabel.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        maxTemeratureLabel.topAnchor.constraint(equalTo: minTemeratureLabel.bottomAnchor).isActive = true
        maxTemeratureLabel.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        maxTemeratureLabel.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/5).isActive = true
        avgLabel.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        avgLabel.topAnchor.constraint(equalTo: maxTemeratureLabel.bottomAnchor).isActive = true
        avgLabel.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        avgLabel.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/5).isActive = true
    }
}
