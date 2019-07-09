//
//  TempTools.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/30.
//  Copyright © 2019 Johnny. All rights reserved.
//

import Foundation

class TempTools {
    //MARK: - Generate a city with temperature "Stuttgart, 25°C"
    func cityTempString(fromQuery query:WeatherQuery, defaultsManager:UserDefaultsManager) -> String {
        let tempString = self.tempString(weather: query, defaultsManager: defaultsManager)
        return "\(query.cityName), \(tempString)"
    }
   
    //MARK: - Generate a string like "25°C" for temperature
    func tempString(weather : WeatherQuery, defaultsManager:UserDefaultsManager) -> String {
        let rightValue = rightValueByUnit(grad: weather.temp, defaultsManager: defaultsManager)
        let tempValueString = String(format: "%.f", rightValue)
        
        return "\(tempValueString)\(currentUnit(defaultsManager: defaultsManager))"
    }
    
    //MARK: - Generate a string like "25°" for temperature
    func tempStringWithoutLetter(weather : WeatherQuery, defaultsManager:UserDefaultsManager) -> String {
        let rightValue = rightValueByUnit(grad: weather.temp, defaultsManager: defaultsManager)
        let tempValueString = String(format: "%.f", rightValue)
        
        return "\(tempValueString)°"
    }
    
    //MARK: - Right value according to current unit, default is Celsius.
    func rightValueByUnit(grad: Double, defaultsManager:UserDefaultsManager) -> Double{
        var tempMsm = Measurement(value: grad, unit: UnitTemperature.celsius)
        //According to the switch status
        if defaultsManager.switchStatus() {
            tempMsm  = tempMsm.converted(to: UnitTemperature.fahrenheit)
        }
        return tempMsm.value
    }
    
    //MARK: - Get the current unit according to the switch status
    func currentUnit(defaultsManager:UserDefaultsManager) -> String{
        if defaultsManager.switchStatus() {
            return "°F"
        }else{
            return "°C"
        }
    }
    
}
