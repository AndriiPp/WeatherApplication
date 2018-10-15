//
//  detailTableViewController.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 08.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit
import CoreData

class DetailForecastTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellId = "cellid"
    public var city = ""
    var num = 1
    
    var forecast: [Weather] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tableView.register(DetailForecastTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("sdfsdsd \(city)")
        
        OpenWeatherMapAPI.requestWeatherForecast(city: self.city, days: self.num) { (forecast) in
            self.forecast = forecast
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension DetailForecastTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! DetailForecastTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        cell.timeLabel.text = dateFormatter.string(from: forecast[indexPath.row].date! as Date)
        cell.descriptionLabel.text = "Description: " + forecast[indexPath.row].description
        cell.minLabel.text = "Min: " + String(forecast[indexPath.row].minTemperature)
        cell.maxLabel.text = "Max: " + String(forecast[indexPath.row].maxTemperature)
        cell.avgLabel.text = "Avg: " + String(forecast[indexPath.row].avgTemperature)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
