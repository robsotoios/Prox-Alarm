//
//  CreateAlarmViewController.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/9/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CreateAlarmController: UIViewController , UpdateNameDelegate, UpdateRepeatDelegate, UpdateDistanceDelegate, UpdateLocationDelegate, UpdateSoundDelegate {

    func didUpdateName(controller: NameViewController) {
        alarmName = controller.alarmName
        tableView.reloadData()
    }
    
    func didUpdateRepeat(controller: RepeatViewController) {
        repeatAlarm = controller.alarmRepeat
        tableView.reloadData()
    }
    
    func didUpdateDistance(controller: DistanceViewController) {
        distance = controller.alarmDistance
        tableView.reloadData()
    }
    
    func didUpdateSound(controller: SoundViewController) {
        sound = controller.sound
        tableView.reloadData()
    }
    
    func didUpdateLocation(controller: LocationViewController) {
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        if let lat = controller.latitude {
            self.latitude = lat
        }
        if let long = controller.longitude {
            self.longitude = long
        }
        if let cityname = controller.cityName {
            self.cityName = cityname
        }
        loadMapView()
        
    }

    // MARK:- UI Components
    var createView = CreateAlarmView()
    var tableView = UITableView()
    var mapView = MKMapView()
    
    // MARK: - Variables
    let cellId = "cellSimple"
    var alarm: NSManagedObject?
    var active = true
    var alarmName = "Alarm"
    var cityName : String?
    var distance = 100.0
    var latitude : Double?
    var longitude : Double?
    var repeatAlarm = ["Once"]
    var sound = "alarm.mp3"
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNavigationBar()
        setUpMapView()
        setUpInitialValues()
        registerTable()
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    override func loadView() {
        view = createView
        tableView = createView.tableView
        mapView = createView.mapView
    }
    
    // MARK: - Set up functions
    func registerTable() {
        tableView.register(CreateTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpMapView() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(changeLocation))
        mapView.addGestureRecognizer(gr)
    }
    
    func setNavigationBar() {
        navigationItem.title = "Create Alarm"
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(done))
        doneItem.tintColor = .orange
        navigationItem.rightBarButtonItem = doneItem
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancel))
        doneItem.tintColor = .orange
        navigationItem.leftBarButtonItem = cancelItem
    }
    
    func setUpInitialValues() {
        if let alarm = alarm {
            if let name = alarm.value(forKeyPath: "alarmName") as? String {
                self.alarmName = name
            }
            if let distance = alarm.value(forKeyPath: "distance") as? Double {
                self.distance = distance
            }
            if let alarmRepeat = alarm.value(forKeyPath: "repeatArray") as? [String] {
                self.repeatAlarm = alarmRepeat
            }
            if let sound = alarm.value(forKeyPath: "sound") as? String {
                self.sound = sound
            }
            if let active = alarm.value(forKey: "active") as? Bool {
                self.active = active
            }
            if let latitude = alarm.value(forKey: "latitude") as? Double {
                self.latitude = latitude
            }
            if let longitude = alarm.value(forKey: "longitude") as? Double {
                self.longitude = longitude
            }
            if let cityName = alarm.value(forKey: "cityName") as? String {
                self.cityName = cityName
            }
            loadMapView()
        }
    }
    
    // MARK: - Functions
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadMapView() {
        if let lat = self.latitude {
            if let long = self.longitude {
                
                let coordinate = CLLocationCoordinate2DMake(lat, long)
                
                // Add annotation:
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                if let city = self.cityName {
                    annotation.title = city
                }
                mapView.addAnnotation(annotation)
                
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                
            }
        }
    }
    
    @objc func changeLocation() {
        let vc = LocationViewController()
        vc.delegate = self
        if let lat = latitude {
            vc.latitude = lat
        }
        if let long = longitude {
            vc.longitude = long
        }
        if let cityname = cityName {
            vc.cityName = cityname
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func done() {
        var error = ""
        if cityName == nil {
            error = "Please choose location"
        }
        if latitude == nil {
            error = "Please choose location"
        }
        if longitude == nil {
            error = "Please choose location"
        }
        if error != "" {
            displayAlert(title: "Alarm Failed", message: error)
        } else {
            saveAlarm()
        }
    }
    
    func saveAlarm() {
        if let alarm = alarm {
            // Update the alarm object
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
              return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            alarm.setValue(active, forKey: "active")
            alarm.setValue(alarmName, forKey: "alarmName")
            alarm.setValue(cityName, forKey: "cityName")
            alarm.setValue(distance, forKey: "distance")
            alarm.setValue(latitude, forKey: "latitude")
            alarm.setValue(longitude, forKey: "longitude")
            alarm.setValue(repeatAlarm, forKey: "repeatArray")
            alarm.setValue(sound, forKey: "sound")
            
            do {
               try context.save()
                print("object saved success")
                self.navigationController?.popViewController(animated: true)
              } catch {
               print("Failed saving")
            }
            
        } else {
            // Create a new alarm object
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
              return
            }
            
            let context = appDelegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: "Alarm", in: context) {
                let newAlarm = NSManagedObject(entity: entity, insertInto: context)
                
                newAlarm.setValue(active, forKey: "active")
                newAlarm.setValue(alarmName, forKey: "alarmName")
                newAlarm.setValue(cityName, forKey: "cityName")
                newAlarm.setValue(distance, forKey: "distance")
                newAlarm.setValue(latitude, forKey: "latitude")
                newAlarm.setValue(longitude, forKey: "longitude")
                newAlarm.setValue(repeatAlarm, forKey: "repeatArray")
                newAlarm.setValue(sound, forKey: "sound")
                
                do {
                   try context.save()
                    print("object saved success")
                    self.navigationController?.popViewController(animated: true)
                  } catch {
                   print("Failed saving")
                }
            }
        }
    }
    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch!) {
        let nowOn = sender.isOn
        print("nowOn = \(nowOn)")
        active = nowOn
    }
}

// MARK: - Tableview delegate methods
extension CreateAlarmController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CreateTableViewCell {
            
            switch indexPath.row {
            case 0:
                cell.activeSwitch.isHidden = true
                cell.rightLabel.isHidden = false
                cell.forwardImageView.isHidden = false
                cell.leftLabel.text = "Name"
                cell.rightLabel.text = self.alarmName
                break
            case 1:
                cell.activeSwitch.isHidden = true
                cell.rightLabel.isHidden = false
                cell.forwardImageView.isHidden = false
                cell.leftLabel.text = "Distance"
                cell.rightLabel.text = "\(Int(self.distance)) ft"
                break
            case 2:
                cell.activeSwitch.isHidden = true
                cell.rightLabel.isHidden = false
                cell.forwardImageView.isHidden = false
                cell.leftLabel.text = "Repeat"
                cell.rightLabel.text = self.repeatAlarm[0]
                if repeatAlarm.contains("Always") || repeatAlarm.contains("Once") {
                    cell.rightLabel.text = repeatAlarm[0]
                } else {
                    var newArray = [String]()
                    for rep in repeatAlarm {
                        newArray.append(String(rep.prefix(2)))
                    }
                    let text = newArray.joined(separator: ", ")
                    cell.rightLabel.text = text
                }
                break
            case 3:
                cell.activeSwitch.isHidden = true
                cell.rightLabel.isHidden = false
                cell.forwardImageView.isHidden = false
                cell.leftLabel.text = "Sound"
                cell.rightLabel.text = self.sound
                break
            case 4:
                cell.activeSwitch.isHidden = false
                cell.rightLabel.isHidden = true
                cell.forwardImageView.isHidden = true
                cell.leftLabel.text = "Active"
                cell.activeSwitch.setOn(self.active, animated: false)
                cell.activeSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
                break
            default:
                break
            }
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let nameVC = NameViewController()
            nameVC.delegate = self
            nameVC.alarmName = self.alarmName
            navigationController?.pushViewController(nameVC, animated: true)
            break
        case 1:
            let distanceVC = DistanceViewController()
            distanceVC.delegate = self
            distanceVC.alarmDistance = self.distance
            navigationController?.pushViewController(distanceVC, animated: true)
            break
        case 2:
            let vc = RepeatViewController()
            vc.delegate = self
            vc.alarmRepeat = self.repeatAlarm
            navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc = SoundViewController()
            vc.delegate = self
            vc.sound = sound
            navigationController?.pushViewController(vc, animated: true)
            break
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            break
        }
    }
}
