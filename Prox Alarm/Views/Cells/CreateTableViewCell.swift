//
//  CreateTableViewCell.swift
//  Prox Alarm
//
//  Created by Robert Soto on 9/23/19.
//  Copyright © 2019 Adapptt. All rights reserved.
//

import UIKit

class CreateTableViewCell: UITableViewCell {

    let leftLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let rightLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let forwardImageView : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "right-arrow.png")
        return img
    }()
    
    var activeSwitch : UISwitch = {
        let switchControl = UISwitch()
        return switchControl
    }()

    var alarm: Alarm?
    
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
        print(nowOn)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(forwardImageView)
        addSubview(activeSwitch)
        
        activeSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        
        // set up view
        setUpView()
        
        let cellColor = UIColor(hue: 0.3972, saturation: 0, brightness: 1, alpha: 0.08)
        backgroundColor = cellColor
    }
    
    func setUpView() {
        // City Name Label
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        forwardImageView.translatesAutoresizingMaskIntoConstraints = false
        activeSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Left label
            leftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            leftLabel.heightAnchor.constraint(equalToConstant: 22),
            leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            // Right image
            forwardImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            forwardImageView.heightAnchor.constraint(equalToConstant: 10),
            forwardImageView.widthAnchor.constraint(equalToConstant: 10),
            forwardImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            // Right label
            rightLabel.rightAnchor.constraint(equalTo: forwardImageView.leftAnchor, constant: -10),
            rightLabel.heightAnchor.constraint(equalToConstant: 22),
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            // Active switch
            activeSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            activeSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
           // activeSwitch.heightAnchor.constraint(equalToConstant: 25),
           // activeSwitch.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithItem(item: Alarm) {
        // setImageWithURL(url: item.avatarImageURL)
        
    }
}
