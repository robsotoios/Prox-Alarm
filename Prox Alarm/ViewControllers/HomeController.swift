//
//  ViewController.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/6/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import AVFoundation

class HomeController: UIViewController, CLLocationManagerDelegate, AVAudioPlayerDelegate {
    
    // MARK:- UI Components
    var mainView = MainView()
    var tableView = UITableView()
    var locAlert = UIView()
    var alarmAlert = UIView()
    var alarmNameLabel = UILabel()
    var alarmCityLabel = UILabel()
    
    // MARK: - Variables
    let locationManager = CLLocationManager()
    let cellId = "cellId"
    var player: AVAudioPlayer?
    var repeatSound = false
    
    var currentAlarm : NSManagedObject?
    
    fileprivate var dataArray = [NSManagedObject]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let dataSource = HomeDataModel()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerTable()
        setNavigationBar()
        dataSource.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        
        //tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataSource.requestData()
        //tableView.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(applicationDidBecomeActive),
        name: UIApplication.didBecomeActiveNotification,
        object: nil)
        
        print("this is called again")
        // Check for active alarms
        //checkForActiveAlarm()
        setUpActiveAlarms()
    }
    
    @objc func applicationDidBecomeActive() {
        print("did become active")
        checkForActiveAlarm()
    }
    
    func setUpActiveAlarms() {
        
        print("set up active alarms called")
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        appDelegate.activeAlarms.removeAll(keepingCapacity: false)
        
        let managedContext = appDelegate.persistentContainer.viewContext
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
                                appDelegate.activeAlarms.append(alarm)
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
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        print("set up geofence called")
        let geofenceRegionCenter = CLLocationCoordinate2DMake(lat, long)
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 100.0, identifier: identifier)
       // geofenceRegion.notifyOnExit = true
        geofenceRegion.notifyOnEntry = true
        appDelegate.locationManager.startMonitoring(for: geofenceRegion)
    }
    
    func convertFeetToMeters(feet: Double) -> Double {
        let distanceFeet = Measurement(value: feet, unit: UnitLength.feet)
        let distanceMeters = distanceFeet.converted(to: UnitLength.meters)
        print("Ft: \(distanceFeet.value) - Mt: \(distanceMeters.value)")
        return distanceMeters.value
    }
    
    func checkForActiveAlarm() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if appDelegate.playAlarm == true {
            if let alarm = appDelegate.currentAlarm {
                self.repeatSound = true
                self.currentAlarm = alarm
                
                // Bring up alarm alert confirmation
                if let alarmName = alarm.value(forKey: "alarmName") as? String {
                    alarmNameLabel.text = alarmName
                }
                if let alarmCity = alarm.value(forKey: "cityName") as? String {
                    alarmCityLabel.text = alarmCity
                }
                alarmAlert.isHidden = false
                
                // Play sound
                if let sound = alarm.value(forKey: "sound") as? String {
                    let playsound = String(sound.dropLast(4))
                    playSound(name: playsound)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //tableView.removeObserver(self, forKeyPath: "contentSize")
        
        NotificationCenter.default.removeObserver(self,
        name: UIApplication.didBecomeActiveNotification,
        object: nil)
        
    }
    
    override func loadView() {
        view = mainView
        tableView = mainView.tableView
        locAlert = mainView.locAlertView
        alarmAlert = mainView.alarmAlertView
        alarmNameLabel = mainView.alarmNameLabel
        alarmCityLabel = mainView.alarmCityLabel
        
        locAlert.isHidden = true
        alarmAlert.isHidden = true
        
        mainView.locApproveButton.addTarget(self, action: #selector(approveLocation), for: .touchUpInside)
        mainView.locCancelButton.addTarget(self, action: #selector(cancelLocation), for: .touchUpInside)
        
        mainView.alarmDoneButton.addTarget(self, action: #selector(alarmDone), for: .touchUpInside)
    }
    
    // MARK: - Set up functions
    func registerTable() {
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Table view estimated height
        // tableView.rowHeight = UITableView.automaticDimension
        // tableView.estimatedRowHeight = 90.0
    }
    
    func setNavigationBar() {
        navigationItem.title = "Alarm"
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem = addItem
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(edit))
        navigationItem.leftBarButtonItem = editButton
    }
    
    // MARK: - Functions
    func playSound(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.delegate = self
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func alarmDone() {
        // Turn the alarm inactive
        if let alarm = currentAlarm {
            if let repeatArray = alarm.value(forKey: "repeatArray") as? [String] {
                if repeatArray.contains("Once") {
                    makeAlarmActive(active: false, alarm: alarm)
                }
            }
        }
        
        // Reset the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        appDelegate.currentAlarm = nil
        appDelegate.playAlarm = false
        
        // Dismiss the alarm alert
        alarmAlert.isHidden = true
        
        // Stop audio play
        repeatSound = false
        if let player = player {
            player.stop()
        }
    }
    
    func makeAlarmActive(active: Bool, alarm: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        alarm.setValue(active, forKey: "active")
        
        do {
           try context.save()
            tableView.reloadData()
            print("object saved success active: \(active)")
          } catch {
           print("Failed saving")
        }
    }
    
    @objc func approveLocation() {
        self.askForLocationPermission()
    }
    
    @objc func cancelLocation() {
        locAlert.isHidden = true
    }
    
    @objc func add() {
        // Check locaton status
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedWhenInUse {
            // Check distance between user and source
            locationAlert(title: "When in Use", message: "You must enable location services 'always' so that you don't miss an alarm when the app is closed")
            return
        }
        
        if status == .authorizedAlways {
            // Check distance between user and source
            let createVC = CreateAlarmController()
            navigationController?.pushViewController(createVC, animated: true)
            return
        }
        
        // 2
        if status == .notDetermined {
            // Ask for permission
            locAlert.isHidden = false
            return
        }
        
        // 3
        if status == .denied || status == .restricted {
            locationAlert(title: "Location Services Denied", message: "Must enable location services in settings to create an alarm for when you reach your destination")
            return
        }
    }
    
    func locationAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { (action) in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func edit() {
        tableView.allowsMultipleSelection = true
        tableView.allowsSelection = true
        tableView.setEditing(true, animated: true)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = doneButton
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func done() {
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(edit))
        navigationItem.leftBarButtonItem = editButton
        
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = false
        tableView.setEditing(false, animated: true)
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Location Methods
    func askForLocationPermission() {
        // For use in foreground
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("we are checking out location")
        
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("First Location: LAT: \(latitude) LONG: \(longitude)")
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    // MARK: - Audio delegate methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audio finished playing play again if needed")
        if repeatSound {
            player.currentTime = 0
            player.play()
        }
    }
}

// MARK: - Data delegate
extension HomeController: HomeDataModelDelegate {
    func didFailDataUpdateWithError(error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    func didRecieveDataUpdate(data: [NSManagedObject]) {
        dataArray = data
    }
}

// MARK: - Tableview delegate methods
extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            cellId, for: indexPath) as? AlarmTableViewCell {
            cell.configureWithItem(item: dataArray[indexPath.item])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124.0
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CreateAlarmController()
        vc.alarm = dataArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
