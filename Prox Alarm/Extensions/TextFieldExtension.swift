//
//  TextFieldExtension.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/24/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit

extension UITextField {

    func modifyClearButtonWithImage(image : UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 20, y: 0, width: 14, height: 14)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:) ), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }

    @objc func clear(sender : AnyObject) {
        self.text = ""
    }
}
