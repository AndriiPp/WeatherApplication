//
//  detailTableViewController.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 08.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit
import CoreData

class detailTableViewController: UITableViewController {
    var cellId = "cellid"
    var city = ""
    var num = 0
    
 
    var forecast: [Weather] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: cellId)
        OpenWeatherMapAPI.requestWeatherForecast(city: self.city, days: self.num) { (forecast) in
            self.forecast = forecast
            
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! WeatherTableViewCell
        cell.timeLabel.text = forecast[indexPath.row].date?.description
        cell.descriptionLabel.text = "Description: " + forecast[indexPath.row].description
        cell.minLabel.text = "Min: " + String(forecast[indexPath.row].minTemperature)
        cell.maxLabel.text = "Max: " + String(forecast[indexPath.row].maxTemperature)
        cell.avgLabel.text = "Avg: " + String(forecast[indexPath.row].avgTemperature)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
        
    }
}
