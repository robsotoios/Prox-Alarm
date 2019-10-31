//
//  LocationView.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/24/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit
import MapKit

class LocationView: UIView {

    let mapView = MKMapView()
    
    let cityLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.text = "Please choose destination"
        lbl.textAlignment = .center
        return lbl
    }()
    
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
        backgroundColor = .black
        setUpView()
    }

    func setUpView() {
        addSubview(mapView)
        addSubview(cityLabel)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.rightAnchor.constraint(equalTo: rightAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 420),
            mapView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cityLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            cityLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            cityLabel.heightAnchor.constraint(equalToConstant: 60),
            cityLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20)
        ])
    }
}
