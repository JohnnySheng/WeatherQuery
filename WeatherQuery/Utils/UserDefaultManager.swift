//
//  UserDefaultManager.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/29.
//  Copyright © 2019 Johnny. All rights reserved.
//

import Foundation


class UserDefaultManager {
    
    //On:True:Fahrenheit
    static var userDefaultSwitch = "UserDefaultSwitch"
    static var userDefaultLocationQuery = "UserDefaultLocationQuerying"

    //MARK: - For Switch
    static func switchStatus() -> Bool {
        let currentStatus = UserDefaults.standard.bool(forKey: UserDefaultManager.userDefaultSwitch)
        return currentStatus
    }
    
    static func saveSwitchStatus(_ status : Bool) {
        UserDefaults.standard.set(status, forKey: UserDefaultManager.userDefaultSwitch)
    }
  
    //MARK: - For Location Querying
    static func locationQueryStatus() -> Bool {
        let currentStatus = UserDefaults.standard.bool(forKey: UserDefaultManager.userDefaultLocationQuery)
        return currentStatus
    }
    
    static func saveLocationQueryStatus(_ status : Bool) {
        UserDefaults.standard.set(status, forKey: UserDefaultManager.userDefaultLocationQuery)
    }
    
}
