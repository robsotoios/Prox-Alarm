//
//  AppDelegate.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/6/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications
import MobileCoreServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    var playAlarm = false
    var currentAlarm : NSManagedObject?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        
        nav.navigationBar.barTintColor = .black
        nav.navigationBar.tintColor = .orange
        nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        startLocationManager()
        
        playAlarm = false
        
        setUpActiveAlarms()
        
        return true
    }
    
    func startLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Location manager delegate methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            setUpActiveAlarms()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        userReachedDestination(region: region)
    }
    
    // MARK: - Location functions
    var activeAlarms = [NSManagedObject]()
    
    func setUpActiveAlarms() {
        
        print("set up active alarms called")
        
        activeAlarms.removeAll(keepingCapacity: false)
        
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Alarm")
        do {
            let alarms = try managedContext.fetch(fetchRequest)
            for alarm in alarms {
                if let active = alarm.value(forKey: "active") as? Bool {
                    if active {
                        if let repeatArray = alarm.value(forKey: "repeatArray") as? [String] {
                            let date = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEEE"
                            let currentDateString: String = dateFormatter.string(from: date)
                            if repeatArray.contains("Once") || repeatArray.contains("Always") || repeatArray.contains(currentDateString) {
                                // Add the alarm to look for
                                activeAlarms.append(alarm)
                                passDistanceLatAndLong(alarm: alarm)
                            }
                        }
                    }
                }
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func passDistanceLatAndLong(alarm: NSManagedObject) {
        if let distance = alarm.value(forKey: "distance") as? Double {
            if let lat = alarm.value(forKey: "latitude") as? Double {
                if let long = alarm.value(forKey: "longitude") as? Double {
                    if let alarmName = alarm.value(forKey: "alarmName") as? String {
                        let meters = convertFeetToMeters(feet: distance)
                        setUpGeofenceForDestination(lat: lat, long: long, distance: meters, identifier: alarmName)
                    }
                }
            }
        }
    }
    
    func setUpGeofenceForDestination(lat: Double, long: Double, distance: Double, identifier: String) {
        print("set up geofence called")
        let geofenceRegionCenter = CLLocationCoordinate2DMake(lat, long)
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 100.0, identifier: identifier)
       // geofenceRegion.notifyOnExit = true
        geofenceRegion.notifyOnEntry = true
        self.locationManager.startMonitoring(for: geofenceRegion)
    }
    
    func convertFeetToMeters(feet: Double) -> Double {
        let distanceFeet = Measurement(value: feet, unit: UnitLength.feet)
        let distanceMeters = distanceFeet.converted(to: UnitLength.meters)
        print("Ft: \(distanceFeet.value) - Mt: \(distanceMeters.value)")
        return distanceMeters.value
    }

    let workspace = LSApplicationWorkspace()
    
    func userReachedDestination(region: CLRegion) {
        let identifier = region.identifier
        for alarm in activeAlarms {
            
            if let alarmName = alarm.value(forKey: "alarmName") as? String {
                if alarmName == identifier {
                    
                    playAlarm = true
                    currentAlarm = alarm
                    // Reactivate the app
                    openApp(withBundleIdentifier: "adapptt.Prox-Alarm")
                    
                }
            }
        }
    }
    
    func openApp(withBundleIdentifier bundleIdentifier: String) {
        // Call the Private API LSApplicationWorkspace method
        workspace.openApplication(withBundleID: bundleIdentifier)
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

