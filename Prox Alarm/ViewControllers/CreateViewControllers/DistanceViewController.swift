//
//  DistanceViewController.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/24/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit

protocol UpdateDistanceDelegate {
    func didUpdateDistance(controller: DistanceViewController)
}

class DistanceViewController: UIViewController {
    
    // MARK:- UI Components
    var distanceView = DistanceView()
    var picker = UIPickerView()
    
    // MARK: - Variables
    var alarmDistance: Double = 100.0
    var pickerData = [20, 50, 100, 200, 500, 1000, 2000]
    var delegate: UpdateDistanceDelegate! = nil
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpPicker()
        setNavigationBar()
        
    }
    
    override func loadView() {
        view = distanceView
        picker = distanceView.picker
    }
    
    // MARK: - Set up functions
    func setUpPicker() {
        picker.delegate = self
        picker.dataSource = self
        
        let distance = Int(alarmDistance)
        if let row = pickerData.firstIndex(of: distance) {
            picker.selectRow(row, inComponent: 0, animated: true)
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "Distance"
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(done))
        doneItem.tintColor = .orange
        navigationItem.rightBarButtonItem = doneItem
    }
    
    // MARK: - Functions
    @objc func done() {
        self.alarmDistance = Double(pickerData[picker.selectedRow(inComponent: 0)])
        delegate.didUpdateDistance(controller: self)
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - Picker delegate methods
extension DistanceViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = "\(pickerData[row]) ft"
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return myTitle
    }
}
