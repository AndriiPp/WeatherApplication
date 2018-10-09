//
//  CityTableViewCell.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 09.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    let cityLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(cityLabel)
        cityLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        cityLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive  = true
        cityLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
