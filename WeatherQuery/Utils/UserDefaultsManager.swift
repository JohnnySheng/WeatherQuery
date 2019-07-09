//
//  UserDefaultManager.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/29.
//  Copyright © 2019 Johnny. All rights reserved.
//

import Foundation


class UserDefaultsManager {
    
    //On:true->Fahrenheit
    var userDefaultSwitch = "UserDefaultSwitch"
    //On:true-> Location is querying
    var userDefaultLocationQuery = "UserDefaultLocationQuerying"
    
    var defaults:UserDefaults!
    
    init() {
        defaults = UserDefaults.standard
    }
    
    init(fromDefaults defaults:UserDefaults) {
        self.defaults = defaults
    }

    //MARK: - For Switch
    func switchStatus() -> Bool {
        let currentStatus = defaults.bool(forKey: self.userDefaultSwitch)
        return currentStatus
    }
    
    func saveSwitchStatus(_ status : Bool) {
        defaults.set(status, forKey: self.userDefaultSwitch)
    }
  
    //MARK: - For Location Querying Delegate
    func locationQueryStatus() -> Bool {
        let currentStatus = defaults.bool(forKey: self.userDefaultLocationQuery)
        return currentStatus
    }
    
    func saveLocationQueryStatus(_ status : Bool) {
        defaults.set(status, forKey: self.userDefaultLocationQuery)
    }
    
}
