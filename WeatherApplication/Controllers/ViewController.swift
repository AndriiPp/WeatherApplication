//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 08.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let network: NetworkManager = NetworkManager.sharedInstance
    var city = ""
    var forecast : Forecast?
    var weather : [Weather] = []
    var detailTableController = detailTableViewController()
    var cityTableViewController = CityTableViewController()
    
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
    let goButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(outputCity), for: .touchUpInside)
        return button
    }()
    let addButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add city", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(addCity), for: .touchUpInside)
        return button
    }()
    let detailButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Detail forecast", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(detailForecast), for: .touchUpInside)
        return button
    }()
    let viewButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Offline", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(offlineWeather), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OpenWeatherMapAPI.setAPIKey(key: "b5689ff6944f5c600737608a0be51f05")
        setupNavBar()
      
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [Forecast]{
                print("city - \(result.min!)")
                print("city - \(result.max!)")
                print("city - \(result.avg!)")
                print("city - \(result.descript!)")
                print("city - \(result.city!)")
            }
        } catch {
            print(error)
        }
    }

   private func setupNavBar(){
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 227, g: 243, b: 90)
        navigationItem.title = "Weather"
    }
    @objc func offlineWeather(){
        self.navigationController?.pushViewController(cityTableViewController, animated: true)
    }

    @objc func detailForecast(){
        NetworkManager.isUnreachable { (_) in
            self.invalidInternetController()
        }
        NetworkManager.isReachable { (_) in
            self.navigationController?.pushViewController(self.detailTableController, animated: true)
            self.detailTableController.city = self.city
            self.detailTableController.num = Int(self.numberDayText.text!)!
        }
    }
   
    @objc func outputCity(){
         NetworkManager.isUnreachable { (_) in
            if self.nameCityText.text!.isEmpty {
                self.alertCityController()
            }
           self.invalidInternetController()
       }
        NetworkManager.isReachable { (_) in
            self.city = self.nameCityText.text ?? ""
            OpenWeatherMapAPI.requestTodaysWeather(city: (self.city)) { (weather) in
                if let weather = weather {
                    print("Complete")
                    
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Weather: " + self.city
                        self.descriptionLabel.text = "Description: " + weather.description
                        self.minTemeratureLabel.text = "min temperature: " + String(weather.minTemperature)
                        self.maxTemeratureLabel.text = "max temperature: " + String(weather.maxTemperature)
                    }
                    print("Set label")
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Invalid City", message: "The city you typed in does not exist.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func invalidInternetController(){
        let alert = UIAlertController(title: "Invalid Internet", message: "no internet access exist.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func addCity(){
        NetworkManager.isUnreachable { (_) in
            self.invalidInternetController()
        }
        NetworkManager.isReachable { (_) in
            if self.saveForecast() {
                self.navigationController?.pushViewController(self.cityTableViewController, animated: true)
            }
        }
    }
    func alertCityController(){
        let alert = UIAlertController(title: "Validation error", message: "input the City", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func saveForecast() -> Bool {
        if nameCityText.text!.isEmpty {
           alertCityController()
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
   
    
    func setupSubviews(){
        view.addSubview(nameCityText)
        nameCityText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        nameCityText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        nameCityText.topAnchor.constraint(equalTo: view.topAnchor, constant: 66).isActive = true
        nameCityText.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        view.addSubview(citySeparator)
        citySeparator.leftAnchor.constraint(equalTo: nameCityText.leftAnchor).isActive = true
        citySeparator.rightAnchor.constraint(equalTo: nameCityText.rightAnchor).isActive = true
        citySeparator.topAnchor.constraint(equalTo: nameCityText.bottomAnchor).isActive = true
        citySeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(goButton)
        goButton.topAnchor.constraint(equalTo: citySeparator.bottomAnchor, constant: 12).isActive = true
        goButton.centerXAnchor.constraint(equalTo: nameCityText.centerXAnchor).isActive = true
        goButton.widthAnchor.constraint(equalTo: nameCityText.widthAnchor, multiplier: 2/3).isActive = true
        goButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(inputsContainer)
        inputsContainer.topAnchor.constraint(equalTo: goButton.bottomAnchor, constant: 24).isActive = true
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
        
        view.addSubview(detailButton)
        detailButton.topAnchor.constraint(equalTo: numberSeparator.bottomAnchor, constant: 12).isActive = true
        detailButton.centerXAnchor.constraint(equalTo: numberDayText.centerXAnchor).isActive = true
        detailButton.widthAnchor.constraint(equalTo: numberDayText.widthAnchor, multiplier: 2/3).isActive = true
        detailButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: detailButton.bottomAnchor, constant: 24).isActive = true
        addButton.centerXAnchor.constraint(equalTo: detailButton.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalTo: detailButton.widthAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(viewButton)
        viewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        viewButton.centerXAnchor.constraint(equalTo: detailButton.centerXAnchor).isActive = true
        viewButton.widthAnchor.constraint(equalTo: detailButton.widthAnchor).isActive = true
        viewButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
