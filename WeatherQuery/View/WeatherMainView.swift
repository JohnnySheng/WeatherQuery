//
//  WeatherMainView.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/7/3.
//  Copyright © 2019 Johnny. All rights reserved.
//

import UIKit

class WeatherMainView: UIView {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempSwitch: UISwitch!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var switchStackView: UIStackView!
    
    var tempLableOriginalRect: CGRect!
    var tempLabelDestinationRect: CGRect!
}
