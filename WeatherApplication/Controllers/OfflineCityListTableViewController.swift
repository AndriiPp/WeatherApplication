//
//  CityTableViewController.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 09.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit
import CoreData

class OfflineCityListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var cellId = "cityId"
    
    var fetchedResultController  = CoreDataManager.instance.fetchedResultController(entityName: "Forecast", keyForSort: "city")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchedResultController.delegate = self
        do{
            try fetchedResultController.performFetch()
        } catch {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "CourierNewPS-BoldItalicMT", size: 24)!]
    }
    //MARK: - CoreData methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let city = fetchedResultController.object(at: indexPath) as! Forecast
                let cell = tableView.cellForRow(at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    //MARK:- tableView methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  forecast = fetchedResultController.object(at: indexPath) as! Forecast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CityTableViewCell
        cell.cityLabel.text = forecast.city
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let forecast = fetchedResultController.object(at: indexPath) as? Forecast {
            showForecast(city : forecast.city!)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultController.object(at: indexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }
    private func showForecast(city : String){
        let offlineDetailForecastViewController = OfflineDetailForecastViewController()
        navigationController?.pushViewController(offlineDetailForecastViewController, animated: true)
        offlineDetailForecastViewController.cityLabel.text = city
        
    }
}
