//
//  NameView.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/24/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit

class NameView: UIView {
    
    //let cellCe = UIColor(hue: 0.3972, saturation: 0, brightness: 1, alpha: 0.08)
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        //tf.backgroundColor = UIColor(hue: 0.3972, saturation: 0, brightness: 1, alpha: 0.08)
        tf.borderStyle = .none
        tf.clearButtonMode = .whileEditing
        tf.textColor = .white
        tf.leftViewMode = .always
        tf.leftView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        tf.returnKeyType = .done
        return tf
    }()
    
    let backView : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hue: 0.3972, saturation: 0, brightness: 1, alpha: 0.08)
        return v
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
        addSubview(backView)
        backView.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        backView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backView.heightAnchor.constraint(equalToConstant: 44),
            backView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            backView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            backView.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameTextField.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 0),
            nameTextField.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -16),
            nameTextField.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
            nameTextField.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0)
        ])
        
        nameTextField.modifyClearButtonWithImage(image: UIImage(named: "clear-button.png")!)
        
    }
}
