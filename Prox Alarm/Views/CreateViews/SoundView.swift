//
//  SoundView.swift
//  Prox Alarm
//
//  Created by Robert Soto on 10/1/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit

class SoundView: UIView {

    let tableView = UITableView()
    
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
        
        tableView.backgroundColor = .black
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
    }
}
