//
//  RepeatViewController.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/24/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit

protocol UpdateRepeatDelegate {
    func didUpdateRepeat(controller: RepeatViewController)
}

class RepeatViewController: UIViewController {
    
    // MARK:- UI Components
    var repeatView = RepeatView()
    var tableView = UITableView()
    
    // MARK: - Variables
    var dataArray = ["Always", "Once", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var alarmRepeat = ["Once"]
    var delegate: UpdateRepeatDelegate! = nil
    var cellId = "SimpleCell"
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerTable()
        setUpNavBar()
    }
    
    override func loadView() {
        view = repeatView
        tableView = repeatView.tableView
    }
    
    // MARK: - Set up functions
    func registerTable() {
        tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func setUpNavBar() {
        navigationItem.title = "Repeat"
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(done))
        doneItem.tintColor = .orange
        navigationItem.rightBarButtonItem = doneItem
    }
    
    // MARK: - Functions
    @objc func done() {
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            alarmRepeat.removeAll(keepingCapacity: false)
            
            for index in selectedRows {
                alarmRepeat.append(dataArray[index.row])
            }
            
            self.navigationController?.popViewController(animated: true)
            self.delegate.didUpdateRepeat(controller: self)
        }
    }
}

// MARK: - Tableview delegate methods
extension RepeatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            cellId, for: indexPath) as? SimpleTableViewCell {
            cell.leftLabel.text = dataArray[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            let repeatalarm = dataArray[indexPath.row]
            self.alarmRepeat = [repeatalarm]
            self.delegate.didUpdateRepeat(controller: self)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width = UIScreen.main.bounds.width
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: width, height: 26)
        return view
    }
    
}
