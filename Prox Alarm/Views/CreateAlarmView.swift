//
//  CreateAlarmView.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/9/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit
import MapKit

class CreateAlarmView: UIView {

    let tableView = UITableView()
    let mapView = MKMapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    
    func createSubviews() {
        // all the layout code from above
        //backgroundColor = .white
        setUpMapView()
        setupTableView()
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        //tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        //tableView.heightAnchor.constraint(equalToConstant: 300.0).isActive = true
        //tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.backgroundColor = .black
       // tableView.allowsSelection = true
    }
    
    func setUpMapView() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.rightAnchor.constraint(equalTo: rightAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
}
