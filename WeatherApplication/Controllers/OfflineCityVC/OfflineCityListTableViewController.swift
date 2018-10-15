//
//  CityTableViewController.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 09.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class OfflineCityListTableViewController: UIViewController {
    
    @IBOutlet weak var offlineTableView: UITableView!
    
    var cellId = "cityId"
    
    var fetchedResultController  = CoreDataManager.instance.fetchedResultController(entityName: "Forecast", keyForSort: "city")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        offlineTableView.register(CityTableViewCell.self, forCellReuseIdentifier: cellId)
        offlineTableView.delegate = self
        offlineTableView.dataSource = self
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
    private func showForecast(city : String){
        weak var offlineDetailVC = (VCBuilder.createOfflineDetailVC() as! OfflineDetailForecastViewController)
        navigationController?.pushViewController(offlineDetailVC!, animated: true)
        offlineDetailVC?.city = city
        
    }
}

extension OfflineCityListTableViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK:- tableView methods
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  forecast = fetchedResultController.object(at: indexPath) as! Forecast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CityTableViewCell
        cell.cityLabel.text = forecast.city
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let forecast = fetchedResultController.object(at: indexPath) as? Forecast {
            showForecast(city : forecast.city!)
        }
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultController.object(at: indexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }
}

extension OfflineCityListTableViewController: NSFetchedResultsControllerDelegate {
    //MARK: - CoreData methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        offlineTableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                offlineTableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let city = fetchedResultController.object(at: indexPath) as! Forecast
                let cell = offlineTableView.cellForRow(at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                offlineTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                offlineTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                offlineTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        offlineTableView.endUpdates()
    }
}
