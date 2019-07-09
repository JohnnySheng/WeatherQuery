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
    static func cityTempString(fromQuery query:WeatherQuery) -> String {
        let tempString = self.tempString(weather: query)
        return "\(query.cityName), \(tempString)"
    }
   
    //MARK: - Generate a string like "25°C" for temperature
    static func tempString(weather : WeatherQuery) -> String {
        let rightValue = rightValueByUnit(grad: weather.temp)
        let tempValueString = String(format: "%.f", rightValue)
        
        return "\(tempValueString)\(currentUnit())"
    }
    
    //MARK: - Generate a string like "25°" for temperature
    static func tempStringWithoutLetter(weather : WeatherQuery) -> String {
        let rightValue = rightValueByUnit(grad: weather.temp)
        let tempValueString = String(format: "%.f", rightValue)
        
        return "\(tempValueString)°"
    }
    
    //MARK: - Right value according to current unit, default is Celsius.
    static func rightValueByUnit(grad: Double) -> Double{
        var tempMsm = Measurement(value: grad, unit: UnitTemperature.celsius)
        //According to the switch status
        if UserDefaultManager.switchStatus() {
            tempMsm  = tempMsm.converted(to: UnitTemperature.fahrenheit)
        }
        return tempMsm.value
    }
    
    //MARK: - Get the current unit according to the switch status
    static func currentUnit() -> String{
        if UserDefaultManager.switchStatus() {
            return "°F"
        }else{
            return "°C"
        }
    }
    
}
