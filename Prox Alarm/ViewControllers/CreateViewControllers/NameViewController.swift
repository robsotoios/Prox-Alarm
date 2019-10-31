//
//  NameViewController.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/24/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit

protocol UpdateNameDelegate {
    func didUpdateName(controller: NameViewController)
}

class NameViewController: UIViewController {

    // MARK:- UI Components
    var nameView = NameView()
    var nameTextField = UITextField()
    
    // MARK: - Variables
    var delegate: UpdateNameDelegate! = nil
    var alarmName = "Alarm"
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        setInitialTextField()
        setUpNavBar()
    }
    
    override func loadView() {
        view = nameView
        nameTextField = nameView.nameTextField
    }

    // MARK: - Set up functions
    func setInitialTextField() {
        nameTextField.text = alarmName
        nameTextField.becomeFirstResponder()
        nameTextField.modifyClearButtonWithImage(image: UIImage(named: "clear-button.png")!)
    }
    
    func setUpNavBar() {
        navigationItem.title = "Name"
    }
    
}

// MARK: - Textfield delegate methods
extension NameViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            
            if textField.text == "" {
                // Display alert
                print("Name must not be empty")
            } else {
                if let text = textField.text {
                    alarmName = text
                    self.navigationController?.popViewController(animated: true)
                    self.delegate.didUpdateName(controller: self)
                }
            }
        }
        return true
    }

}
