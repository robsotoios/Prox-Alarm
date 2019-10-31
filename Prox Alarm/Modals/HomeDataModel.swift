//
//  HomeDataModel.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/9/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit
import CoreData

protocol HomeDataModelDelegate: class {
    func didRecieveDataUpdate(data: [NSManagedObject])
    func didFailDataUpdateWithError(error: Error)
}

class HomeDataModel {
    
    weak var delegate: HomeDataModelDelegate?
    
    func requestData() {
        
        var alarms = [NSManagedObject]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Alarm")
        
        //3
        do {
            alarms = try managedContext.fetch(fetchRequest)
            print("alarms: \(alarms)")
            
            for alarm in alarms {
                if let active = alarm.value(forKey: "active") as? Bool {
                    if let alarmName = alarm.value(forKey: "alarmName") as? String {
                        print("'\(alarmName)' is active: \(active)")
                    }
                }
            }
            
            setDataWithResponse(response: alarms)
            /*
            for alarm in alarms {
                managedContext.delete(alarm)
            }
            do {
                print("deleted")
                try managedContext.save() // <- remember to put this :)
            } catch {
                // Do something... fatalerror
            }
            */
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func setDataWithResponse(response: [NSManagedObject]) {
        delegate?.didRecieveDataUpdate(data: response)
    }
    
}
