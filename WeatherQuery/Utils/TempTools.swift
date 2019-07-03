//
//  TempTools.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/30.
//  Copyright © 2019 Johnny. All rights reserved.
//

import Foundation

class TempTools {
    static func cityTempString(fromQuery query:WeatherQuery) -> String {
        let tempString = self.tempString(weather: query)
        return "\(query.cityName), \(tempString)"
    }
   
    static func tempString(weather : WeatherQuery) -> String {
        let rightValue = rightValueByUnit(grad: weather.temp)
        let tempValueString = String(format: "%.f", rightValue)
        
        return "\(tempValueString)\(currentUnit())"
    }
    
    static func tempStringWithoutLetter(weather : WeatherQuery) -> String {
        let rightValue = rightValueByUnit(grad: weather.temp)
        let tempValueString = String(format: "%.f", rightValue)
        
        return "\(tempValueString)°"
    }
    
    
    
    //right value according to unit,default is Celsius
    static func rightValueByUnit(grad: Double) -> Double{
        var tempMsm = Measurement(value: grad, unit: UnitTemperature.celsius)
        //Fahrenheit
        if UserDefaultManager.switchStatus() {
            tempMsm  = tempMsm.converted(to: UnitTemperature.fahrenheit)
        }
        return tempMsm.value
    }
    
    static func currentUnit() -> String{
        if UserDefaultManager.switchStatus() {
            return "°F"
        }else{
            return "°C"
        }
    }
    
}
