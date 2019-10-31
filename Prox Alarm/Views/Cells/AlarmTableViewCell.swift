//
//  AlarmTableViewCell.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/9/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit
import CoreData

class AlarmTableViewCell: UITableViewCell {
    
    var leftConstraint: NSLayoutConstraint!
    
    private let cityNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.boldSystemFont(ofSize: 32)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private let distanceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    var alarmNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textAlignment = .left
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    var repeatLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textAlignment = .left
        lbl.textColor = .white
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    var activeSwitch : UISwitch = {
        let switchControl = UISwitch()
        return switchControl
    }()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch!) {
        let nowOn = sender.isOn
        print("nowOn = \(nowOn)")
        if nowOn {
            cityNameLabel.textColor = .white
            distanceLabel.textColor = .white
            alarmNameLabel.textColor = .white
        } else {
            cityNameLabel.textColor = .lightGray
            distanceLabel.textColor = .lightGray
            alarmNameLabel.textColor = .lightGray
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cityNameLabel)
        addSubview(distanceLabel)
        addSubview(alarmNameLabel)
        addSubview(activeSwitch)
        addSubview(repeatLabel)
        
        activeSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        
        // set up view
        setUpView()
        
        let cellColor = UIColor(hue: 0.3972, saturation: 0, brightness: 1, alpha: 0.08)
        backgroundColor = cellColor
        
    }
    
    func setUpView() {
        // City Name Label
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
       // cityNameLabel.bottomAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: 8).isActive = true
        cityNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        cityNameLabel.rightAnchor.constraint(equalTo: activeSwitch.leftAnchor, constant: 10).isActive = true
        cityNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Distance label
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
       // distanceLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 8).isActive = true
       // distanceLabel.bottomAnchor.constraint(equalTo: alarmNameLabel.topAnchor, constant: 8).isActive = true
        distanceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        distanceLabel.rightAnchor.constraint(equalTo: activeSwitch.leftAnchor, constant: 10).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        // Alarm Name label
        alarmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        alarmNameLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 6).isActive = true
        alarmNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        alarmNameLabel.rightAnchor.constraint(equalTo: activeSwitch.leftAnchor, constant: 10).isActive = true
        alarmNameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        repeatLabel.translatesAutoresizingMaskIntoConstraints = false
        repeatLabel.topAnchor.constraint(equalTo: alarmNameLabel.bottomAnchor, constant: 6).isActive = true
        repeatLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        repeatLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        repeatLabel.rightAnchor.constraint(equalTo: activeSwitch.leftAnchor, constant: 10).isActive = true
        repeatLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        // Active Switch
        activeSwitch.translatesAutoresizingMaskIntoConstraints = false
        activeSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        activeSwitch.heightAnchor.constraint(equalToConstant:28).isActive = true
        activeSwitch.widthAnchor.constraint(equalToConstant:28).isActive = true
        addConstraint(NSLayoutConstraint(item: activeSwitch, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation(rawValue: 0)!, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithItem(item: NSManagedObject) {
        
        if let cityname = item.value(forKeyPath: "cityName") as? String {
            cityNameLabel.text = cityname
        }
        
        if let distance = item.value(forKeyPath: "distance") as? Double {
            distanceLabel.text = "\(distance) ft"
        }
        
        if let alarmname = item.value(forKeyPath: "alarmName") as? String {
            alarmNameLabel.text = alarmname
        }
        
        if let repeatArrray = item.value(forKeyPath: "repeatArray") as? [String] {
            if repeatArrray.contains("Always") || repeatArrray.contains("Once") {
                repeatLabel.text = repeatArrray[0]
            } else {
                var newArray = [String]()
                for rep in repeatArrray {
                    newArray.append(String(rep.prefix(2)))
                }
                let text = newArray.joined(separator: ", ")
                repeatLabel.text = text
            }
        }
        
        if let active = item.value(forKeyPath: "active") as? Bool {
            activeSwitch.isOn = active
            activeSwitch.setOn(active, animated: false)
            if active {
                cityNameLabel.textColor = .white
                distanceLabel.textColor = .white
                alarmNameLabel.textColor = .white
            } else {
                cityNameLabel.textColor = .lightGray
                distanceLabel.textColor = .lightGray
                alarmNameLabel.textColor = .lightGray
            }
        }
    }
}
