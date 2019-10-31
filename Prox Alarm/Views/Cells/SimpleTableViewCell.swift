//
//  SimpleTableViewCell.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/30/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {

    let leftLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.accessoryType = selected ? .checkmark : .none
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(leftLabel)
        // set up view
        setUpView()
        let cellColor = UIColor(hue: 0.3972, saturation: 0, brightness: 1, alpha: 0.08)
        backgroundColor = cellColor
        self.selectionStyle = .none
    }
    
    func setUpView() {
        // City Name Label
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Left label
            leftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            leftLabel.heightAnchor.constraint(equalToConstant: 22),
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
