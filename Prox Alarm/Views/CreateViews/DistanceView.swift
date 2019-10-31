//
//  DistanceView.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/24/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit

class DistanceView: UIView {
    
    let picker : UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = UIColor(hue: 0.3972, saturation: 0, brightness: 1, alpha: 0.08)
        p.tintColor = .white
        return p
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
        setUpPicker()
    }
    
    func setUpPicker() {
        
        addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            picker.leftAnchor.constraint(equalTo: leftAnchor),
            picker.rightAnchor.constraint(equalTo: rightAnchor),
            picker.heightAnchor.constraint(equalToConstant: 120),
            picker.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
