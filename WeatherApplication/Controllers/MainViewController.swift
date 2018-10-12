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
    
    
    var city = ""
    var forecast : Forecast?
    var weather : [Weather]? = []
    var offlineCityListTableViewController = OfflineCityListTableViewController()
    var detailForecastTableViewController = DetailForecastTableViewController()
    
    //MARK:- Views Create
    
    lazy var inputsContainer : UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        cv.layer.cornerRadius = 10
        cv.layer.masksToBounds = true
        return cv
    }()
    lazy var maxTemeratureLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        label.text = "max temperature"
        return label
    }()
    lazy var minTemeratureLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        label.text = "min temperature"
        return label
    }()
    lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(r: 235, g: 235, b: 235)
        label.text = "Description"
        return label
    }()
    lazy var nameCityText : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter City"
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let citySeparator : UIView = {
        let  cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(r: 119, g: 75, b: 153)
        return cv
    }()
    lazy var numberDayText : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter number of days"
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let numberSeparator : UIView = {
        let  cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(r: 119, g: 75, b: 153)
        return cv
    }()
    let serchWeatherOnTodayButton : UIButton = {
        let button = UIButton(type: .system)
        button.setupButton()
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(searchWeatherForCity), for: .touchUpInside)
        return button
    }()
    let addCityToOfflineListButton : UIButton = {
        let button = UIButton(type: .system)
        button.setupButton()
        button.setTitle("Add city", for: .normal)
        button.addTarget(self, action: #selector(addCityToOfflineList), for: .touchUpInside)
        return button
    }()
    let openDetailForecastButton : UIButton = {
        let button = UIButton(type: .system)
        button.setupButton()
        button.setTitle("Detail forecast", for: .normal)
        button.addTarget(self, action: #selector(showDetailForecastTableViewController), for: .touchUpInside)
        return button
    }()
    let openOfflineListButtonButton : UIButton = {
        let button = UIButton(type: .system)
        button.setupButton()
        button.setTitle("Offline", for: .normal)
        button.addTarget(self, action: #selector(showOfflineListOfWeather), for: .touchUpInside)
        return button
    }()

    //MARK:- Adding elements on view
    func setupSubviews(){
        view.addSubview(nameCityText)
        nameCityText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        nameCityText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        nameCityText.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        nameCityText.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        view.addSubview(citySeparator)
        citySeparator.leftAnchor.constraint(equalTo: nameCityText.leftAnchor).isActive = true
        citySeparator.rightAnchor.constraint(equalTo: nameCityText.rightAnchor).isActive = true
        citySeparator.topAnchor.constraint(equalTo: nameCityText.bottomAnchor).isActive = true
        citySeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(serchWeatherOnTodayButton)
        serchWeatherOnTodayButton.topAnchor.constraint(equalTo: citySeparator.bottomAnchor, constant: 12).isActive = true
        serchWeatherOnTodayButton.centerXAnchor.constraint(equalTo: nameCityText.centerXAnchor).isActive = true
        serchWeatherOnTodayButton.widthAnchor.constraint(equalTo: nameCityText.widthAnchor, multiplier: 2/3).isActive = true
        serchWeatherOnTodayButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(inputsContainer)
        inputsContainer.topAnchor.constraint(equalTo: serchWeatherOnTodayButton.bottomAnchor, constant: 24).isActive = true
        inputsContainer.leftAnchor.constraint(equalTo: nameCityText.leftAnchor).isActive = true
        inputsContainer.rightAnchor.constraint(equalTo: nameCityText.rightAnchor).isActive = true
        inputsContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainer.addSubview(descriptionLabel)
        inputsContainer.addSubview(minTemeratureLabel)
        inputsContainer.addSubview(maxTemeratureLabel)
        
        descriptionLabel.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: inputsContainer.topAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3).isActive = true
        minTemeratureLabel.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        minTemeratureLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        minTemeratureLabel.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        minTemeratureLabel.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3).isActive = true
        maxTemeratureLabel.leftAnchor.constraint(equalTo: inputsContainer.leftAnchor, constant: 12).isActive = true
        maxTemeratureLabel.topAnchor.constraint(equalTo: minTemeratureLabel.bottomAnchor).isActive = true
        maxTemeratureLabel.widthAnchor.constraint(equalTo: inputsContainer.widthAnchor).isActive = true
        maxTemeratureLabel.heightAnchor.constraint(equalTo: inputsContainer.heightAnchor, multiplier: 1/3).isActive = true
        view.addSubview(numberDayText)
        numberDayText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        numberDayText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        numberDayText.topAnchor.constraint(equalTo: inputsContainer.bottomAnchor, constant: 12).isActive = true
        numberDayText.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        view.addSubview(numberSeparator)
        numberSeparator.leftAnchor.constraint(equalTo: numberDayText.leftAnchor).isActive = true
        numberSeparator.rightAnchor.constraint(equalTo: numberDayText.rightAnchor).isActive = true
        numberSeparator.topAnchor.constraint(equalTo: numberDayText.bottomAnchor).isActive = true
        numberSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(openDetailForecastButton)
        openDetailForecastButton.topAnchor.constraint(equalTo: numberSeparator.bottomAnchor, constant: 12).isActive = true
        openDetailForecastButton.centerXAnchor.constraint(equalTo: numberDayText.centerXAnchor).isActive = true
        openDetailForecastButton.widthAnchor.constraint(equalTo: numberDayText.widthAnchor, multiplier: 2/3).isActive = true
        openDetailForecastButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(addCityToOfflineListButton)
        addCityToOfflineListButton.topAnchor.constraint(equalTo: openDetailForecastButton.bottomAnchor, constant: 24).isActive = true
        addCityToOfflineListButton.centerXAnchor.constraint(equalTo: openDetailForecastButton.centerXAnchor).isActive = true
        addCityToOfflineListButton.widthAnchor.constraint(equalTo: openDetailForecastButton.widthAnchor).isActive = true
        addCityToOfflineListButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(openOfflineListButtonButton)
        openOfflineListButtonButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        openOfflineListButtonButton.centerXAnchor.constraint(equalTo: openDetailForecastButton.centerXAnchor).isActive = true
        openOfflineListButtonButton.widthAnchor.constraint(equalTo: openDetailForecastButton.widthAnchor).isActive = true
        openOfflineListButtonButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSubviews()
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
    //MARK:- button methods
    @objc func searchWeatherForCity(){
        NetworkManager.isUnreachable { (_) in
            if self.nameCityText.text!.isEmpty {
                self.invalidAllertController(title: "Validation error", message: "input the City")
            }
            self.invalidAllertController(title: "Invalid Internet", message: "no internet access exist.")
        }
        NetworkManager.isReachable { (_) in
            self.city = self.nameCityText.text ?? ""
            OpenWeatherMapAPI.requestTodaysWeather(city: (self.city)) { (weather) in
                if let weather = weather {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Weather: " + self.city
                        self.descriptionLabel.text = "Description: " + weather.description
                        self.minTemeratureLabel.text = "min temperature: " + String(weather.minTemperature)
                        self.maxTemeratureLabel.text = "max temperature: " + String(weather.maxTemperature)
                    }
                } else {
                        self.invalidAllertController(title: "Invalid City", message: "The city you typed in does not exist.")
                }
            }
        }
    }
    
    @objc func showDetailForecastTableViewController(){
        NetworkManager.isUnreachable { (_) in
            self.invalidAllertController(title: "Invalid Internet", message: "no internet access exist.")
        }
        NetworkManager.isReachable { (_) in
                self.navigationController?.pushViewController(self.detailForecastTableViewController, animated: true)
                self.detailForecastTableViewController.city = self.city
                self.detailForecastTableViewController.num = Int(self.numberDayText.text!)!
            
        }
    }
    
    @objc func addCityToOfflineList(){
        NetworkManager.isUnreachable { (_) in
            self.invalidAllertController(title: "Invalid Internet", message: "no internet access exist.")
        }
        NetworkManager.isReachable { (_) in
            if self.saveForecast() {
                self.navigationController?.pushViewController(self.offlineCityListTableViewController, animated: true)
            }
        }
    }
    
    @objc func showOfflineListOfWeather(){
        self.navigationController?.pushViewController(offlineCityListTableViewController, animated: true)
    }
    //MARK:- private methods
    private func saveForecast() -> Bool {
        if nameCityText.text!.isEmpty {
            invalidAllertController(title: "Validation error", message: "input the City")
            return false
        }
        OpenWeatherMapAPI.requestTodaysWeather(city: nameCityText.text!) { (weather) in
            if self.forecast == nil {
                self.forecast = Forecast()
            }
            if let forecast = self.forecast {
                forecast.date = String(describing: weather!.date)
                forecast.descript =  String(weather!.description)
                forecast.min =  "Tmin: " + String(weather!.minTemperature)
                forecast.max =  "Tmax: " + String(weather!.maxTemperature)
                forecast.avg =  "Tavg: " + String(weather!.avgTemperature)
                forecast.city = String(self.nameCityText.text!)
                CoreDataManager.instance.saveContext()
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

