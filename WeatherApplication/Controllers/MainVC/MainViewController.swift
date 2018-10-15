//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 08.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var changeDaysTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!

    var city = ""
    var forecast : Forecast?
    var weather : [Weather]? = []
    var offlineCityListTableViewController = OfflineCityListTableViewController()
    var detailForecastTableViewController = DetailForecastTableViewController()
    
    //MARK:- LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OpenWeatherMapAPI.setAPIKey(key: "b5689ff6944f5c600737608a0be51f05")
        setupNavBar()
    }
    
   private func setupNavBar(){
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 227, g: 243, b: 90)
        navigationItem.title = "Weather"
    }
    //MARK:- Buttons Actions
    
    @IBAction func doneButton(_ sender: UIButton) {
        NetworkManager.isUnreachable { (_) in
            self.invalidAllertController(title: "Invalid Internet", message: "no internet access exist.")
        }
        if self.searchCityTextField.text!.isEmpty {
            self.invalidAllertController(title: "Validation error", message: "input the City")
        } else {
            NetworkManager.isReachable { (_) in
                self.city = self.searchCityTextField.text ?? ""
                OpenWeatherMapAPI.requestTodaysWeather(city: (self.city)) { (weather) in
                    if weather != nil {
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Weather: " + self.city
                            self.tempLabel.text = "  " + weather!.description + "\n Tmin: " + String(describing: weather!.minTemperature) + "\n Tmax: " + String(describing: weather!.maxTemperature)
                        }
                    } else {
                        self.invalidAllertController(title: "Invalid City", message: "The city you typed in does not exist.")
                    }
                }
            }
        }
    }
    @IBAction func addCityButton(_ sender: UIButton) {
        
        weak var offlineCityVC = (VCBuilder.createOfflineVC() as! OfflineCityListTableViewController)
        
        NetworkManager.isUnreachable { (_) in
            self.invalidAllertController(title: "Invalid Internet", message: "no internet access exist.")
        }
        NetworkManager.isReachable { (_) in
            if self.saveForecast() {
                self.navigationController?.pushViewController(offlineCityVC!, animated: true)
            }
        }
    }
    @IBAction func changeDaysButton(_ sender: UIButton) {
        
        weak var detailsVC = (VCBuilder.createDetailForecastVC() as! DetailForecastTableViewController)
        
        NetworkManager.isUnreachable { (_) in
            self.invalidAllertController(title: "Invalid Internet", message: "no internet access exist.")
        }
        if searchCityTextField.text!.isEmpty || changeDaysTextField.text!.isEmpty || (Int(self.changeDaysTextField.text!)) == nil{
            invalidAllertController(title: "Validation error", message: "check the city and the number of days")
        } else  {
            if Int(self.changeDaysTextField.text!)!<0 || Int(self.changeDaysTextField.text!)! > 14{
                invalidAllertController(title: "Number of days", message: "the number of days must be less than 14 and over 0")
            } else {
                NetworkManager.isReachable { (_) in
                    self.navigationController?.pushViewController(detailsVC!, animated: true)
                    detailsVC?.city = self.searchCityTextField.text!
                    detailsVC?.num = Int(self.changeDaysTextField.text!)!
                }
            }
        }
    }
    @IBAction func SavedCityButton(_ sender: UIButton) {
        weak var detailsVC = (VCBuilder.createOfflineVC() as! OfflineCityListTableViewController)
        self.navigationController?.pushViewController(detailsVC!, animated: true)
    }
    
    //MARK:- private methods
    private func saveForecast() -> Bool {
        if searchCityTextField.text!.isEmpty {
            invalidAllertController(title: "Validation error", message: "input the City")
            return false
        }
        OpenWeatherMapAPI.requestTodaysWeather(city: searchCityTextField.text!) { (weather) in
            if self.forecast == nil {
                self.forecast = Forecast()
            }
            if let forecast = self.forecast {
                DispatchQueue.main.async {
                    
                    forecast.date = String(describing: weather!.date)
                    forecast.descript =  String(weather!.description)
                    forecast.min =  String(weather!.minTemperature)
                    forecast.max =  String(weather!.maxTemperature)
                    forecast.avg =  String(weather!.avgTemperature)
                    forecast.city = String(self.searchCityTextField.text!)
                    CoreDataManager.instance.saveContext()
                }
            }
        }
        return true
    }
    private func invalidAllertController(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

