//
//  ButtonExtension.swift
//  WeatherApplication
//
//  Created by Andrii Pyvovarov on 12.10.18.
//  Copyright © 2018 Andrii Pyvovarov. All rights reserved.
//

import UIKit

extension UIButton{
    func setupButton(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.darkGray
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
    }
}
