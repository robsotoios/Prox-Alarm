//
//  MainView.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/9/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit

class MainView: UIView {

    let tableView = UITableView()
    
    let locAlertView : UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        return v
    }()
    
    let locImage : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "location.png")
        return img
    }()
    
    let locExplainLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16.0)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.text = "Enable location services so that we can let you know when you get to your destination"
        return lbl
    }()
    
    let locApproveButton : UIButton = {
        let but = UIButton()
        but.backgroundColor = .white
        but.setTitleColor(.black, for: .normal)
        but.setTitle("Enable", for: .normal)
        return but
    }()
    
    let locCancelButton : UIButton = {
        let but = UIButton()
        but.backgroundColor = .clear
        but.setTitleColor(.white, for: .normal)
        but.setTitle("Cancel", for: .normal)
        return but
    }()
    
    // Alarm Alert View
    let alarmAlertView : UIView = {
        let v = UIView()
        v.backgroundColor = .gray
        return v
    }()
    
    let alarmImage : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "alarm.png")
        return img
    }()
    
    let alarmNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18.0)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.text = "Alarm"
        return lbl
    }()
    
    let alarmCityLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16.0)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.text = "City"
        return lbl
    }()
    
    let alarmDoneButton : UIButton = {
        let but = UIButton()
        but.backgroundColor = .white
        but.setTitleColor(.black, for: .normal)
        but.setTitle("Done", for: .normal)
        return but
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
        setupTableView()
        setUpLocationAlert()
        setUpAlarmView()
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
       // tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        //tableView.heightAnchor.constraint(equalToConstant: 300.0).isActive = true
        //tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.backgroundColor = .black
    }
    
    func setUpAlarmView() {
        addSubview(alarmAlertView)
        alarmAlertView.addSubview(alarmImage)
        alarmAlertView.addSubview(alarmNameLabel)
        alarmAlertView.addSubview(alarmCityLabel)
        alarmAlertView.addSubview(alarmDoneButton)
        
        alarmAlertView.translatesAutoresizingMaskIntoConstraints = false
        alarmImage.translatesAutoresizingMaskIntoConstraints = false
        alarmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        alarmCityLabel.translatesAutoresizingMaskIntoConstraints = false
        alarmDoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Alert view
            alarmAlertView.heightAnchor.constraint(equalToConstant: 300),
            alarmAlertView.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: 20),
            alarmAlertView.rightAnchor.constraint(equalTo: tableView.rightAnchor, constant: -20),
            alarmAlertView.centerYAnchor.constraint(equalTo: centerYAnchor),
            // Imageview
            alarmImage.topAnchor.constraint(equalTo: alarmAlertView.topAnchor, constant: 26),
            alarmImage.heightAnchor.constraint(equalToConstant: 60),
            alarmImage.widthAnchor.constraint(equalToConstant: 60),
            alarmImage.centerXAnchor.constraint(equalTo: alarmAlertView.centerXAnchor),
            // Name Label
            alarmNameLabel.topAnchor.constraint(equalTo: alarmImage.bottomAnchor, constant: 20),
            alarmNameLabel.leftAnchor.constraint(equalTo: alarmAlertView.leftAnchor, constant: 20),
            alarmNameLabel.rightAnchor.constraint(equalTo: alarmAlertView.rightAnchor, constant: -20),
            // City label
            alarmCityLabel.topAnchor.constraint(equalTo: alarmNameLabel.bottomAnchor, constant: 20),
            alarmCityLabel.leftAnchor.constraint(equalTo: alarmAlertView.leftAnchor, constant: 20),
            alarmCityLabel.rightAnchor.constraint(equalTo: alarmAlertView.rightAnchor, constant: -20),
            // Done button
            alarmDoneButton.topAnchor.constraint(equalTo: locApproveButton.bottomAnchor, constant: 20),
            alarmDoneButton.heightAnchor.constraint(equalToConstant: 24),
            alarmDoneButton.widthAnchor.constraint(equalToConstant: 64),
            alarmDoneButton.centerXAnchor.constraint(equalTo: alarmAlertView.centerXAnchor),
        ])
    }
    
    func setUpLocationAlert() {
        
       // bringSubviewToFront(locAlertView)
        
        addSubview(locAlertView)
        locAlertView.addSubview(locImage)
        locAlertView.addSubview(locExplainLabel)
        locAlertView.addSubview(locApproveButton)
        locAlertView.addSubview(locCancelButton)
        
        locAlertView.translatesAutoresizingMaskIntoConstraints = false
        locImage.translatesAutoresizingMaskIntoConstraints = false
        locExplainLabel.translatesAutoresizingMaskIntoConstraints = false
        locApproveButton.translatesAutoresizingMaskIntoConstraints = false
        locCancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Alert view
            locAlertView.heightAnchor.constraint(equalToConstant: 300),
            locAlertView.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: 20),
            locAlertView.rightAnchor.constraint(equalTo: tableView.rightAnchor, constant: -20),
            locAlertView.centerYAnchor.constraint(equalTo: centerYAnchor),
            // Imageview
            locImage.topAnchor.constraint(equalTo: locAlertView.topAnchor, constant: 26),
            locImage.heightAnchor.constraint(equalToConstant: 60),
            locImage.widthAnchor.constraint(equalToConstant: 60),
            locImage.centerXAnchor.constraint(equalTo: locAlertView.centerXAnchor),
            // Label
            locExplainLabel.topAnchor.constraint(equalTo: locImage.bottomAnchor, constant: 20),
            locExplainLabel.leftAnchor.constraint(equalTo: locAlertView.leftAnchor, constant: 20),
            locExplainLabel.rightAnchor.constraint(equalTo: locAlertView.rightAnchor, constant: -20),
            // Aprrove button
            locApproveButton.topAnchor.constraint(equalTo: locExplainLabel.bottomAnchor, constant: 30),
            locApproveButton.heightAnchor.constraint(equalToConstant: 36),
            locApproveButton.widthAnchor.constraint(equalToConstant: 200),
            locApproveButton.centerXAnchor.constraint(equalTo: locAlertView.centerXAnchor),
            // Cancel button
            locCancelButton.topAnchor.constraint(equalTo: locApproveButton.bottomAnchor, constant: 20),
            locCancelButton.heightAnchor.constraint(equalToConstant: 24),
            locCancelButton.widthAnchor.constraint(equalToConstant: 64),
            locCancelButton.centerXAnchor.constraint(equalTo: locAlertView.centerXAnchor),
        ])
    }
}
