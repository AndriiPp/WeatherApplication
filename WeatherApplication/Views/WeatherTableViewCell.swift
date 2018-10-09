//
//  WeatherTableViewCell.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 08.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let minLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let maxLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let avgLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(timeLabel)
        addSubview(descriptionLabel)
        addSubview(minLabel)
        addSubview(maxLabel)
        addSubview(avgLabel)
        
        timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive  = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive  = true
        descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        minLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        minLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive  = true
        minLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        minLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        maxLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        maxLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive  = true
        maxLabel.topAnchor.constraint(equalTo: minLabel.bottomAnchor).isActive = true
        maxLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
       
        avgLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        avgLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive  = true
        avgLabel.topAnchor.constraint(equalTo: maxLabel.bottomAnchor).isActive = true
        avgLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
