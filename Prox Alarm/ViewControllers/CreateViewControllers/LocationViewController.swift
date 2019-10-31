//
//  LocationViewController.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/24/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit
import MapKit

protocol UpdateLocationDelegate {
    func didUpdateLocation(controller: LocationViewController)
}

class LocationViewController: UIViewController {

    // MARK:- UI Components
    var locationView = LocationView()
    var mapView = MKMapView()
    var cityLabel = UILabel()
    
    // MARK: - Variables
    var latitude: Double?
    var longitude: Double?
    var cityName: String?
    var delegate: UpdateLocationDelegate! = nil
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpNavigationBar()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTouched))
        mapView.addGestureRecognizer(gestureRecognizer)
        
        setUpMapKit()
    }
    
    override func loadView() {
        view = locationView
        mapView = locationView.mapView
        cityLabel = locationView.cityLabel
    }
    
    // MARK: - Set up functions
    func setUpNavigationBar() {
        navigationItem.title = "Destination"
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(done))
        doneItem.tintColor = .orange
        navigationItem.rightBarButtonItem = doneItem
    }
    
    func setUpMapKit() {
        if let lat = self.latitude {
            if let long = self.longitude {
                
                let coordinate = CLLocationCoordinate2DMake(lat, long)
                
                // Add annotation:
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                if let city = self.cityName {
                    annotation.title = city
                    cityLabel.text = city
                }
                mapView.addAnnotation(annotation)
                
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
        }
    }
    
    // MARK: - Functions
    @objc func done() {
        delegate.didUpdateLocation(controller: self)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func mapTouched(gestureRecognizer: UITapGestureRecognizer) {
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
                
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        convertPointsToAddress(lat: coordinate.latitude, long: coordinate.longitude)
    }
    
    func convertPointsToAddress(lat: Double, long: Double) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: {
                placemarks, error -> Void in

                // Place details
                guard let placeMark = placemarks?.first else { return }

                // City
                if let city = placeMark.locality {
                    self.cityLabel.text = city
                    self.cityName = city
                }
        })
    }
}
