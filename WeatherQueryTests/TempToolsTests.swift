//
//  TempToolsTests.swift
//  WeatherQueryTests
//
//  Created by Yuangang Sheng on 2019/7/9.
//  Copyright © 2019 Johnny. All rights reserved.
//

import XCTest
@testable import WeatherQuery

class MockUserDefaults: UserDefaults {
    var switchStatus = 0
    override func set(_ value: Int, forKey defaultName: String) {
        if defaultName == "UserDefaultSwitch" {
            switchStatus += 1
        }
    }
}
class TempToolsTests: XCTestCase {
    var view :WeatherMainView!
    var userDefaults :MockUserDefaults!
    var defaultsManager: UserDefaultsManager!
    var tempTools : TempTools!
    
    override func setUp() {
        super.setUp()
        userDefaults = MockUserDefaults(suiteName: "testing")
        defaultsManager = UserDefaultsManager(fromDefaults: userDefaults)
        tempTools = TempTools()
    }

    override func tearDown() {
        view = nil
        userDefaults = nil
        defaultsManager = nil
        tempTools = nil
        super.tearDown()
    }
    
    func testCurrentUnit() {
        //For Celsius
        // given
        defaultsManager.saveSwitchStatus(false)
        // when
        let currentUnit = tempTools.currentUnit(defaultsManager: defaultsManager)
        // then
         XCTAssertEqual(currentUnit,  "°C", "Temperatur unit is not celsius when switch is off")
        
        //For Fahrenheit
        // given
        defaultsManager.saveSwitchStatus(true)
        // when
        let unitAfterChange = tempTools.currentUnit(defaultsManager: defaultsManager)
        // then
        XCTAssertEqual(unitAfterChange, "°F", "Temperatur unit is not fahrenheit when switch is on")
    }
    
    func testRightValueByUnit() {
         let berlinWQ = WeatherQuery(queryDate: Date(), cityName: "Berlin", tempMin: -6.3, temp: -3.4, tempMax: 2.5)
        //For Celsius
        // given
        defaultsManager.saveSwitchStatus(false)
        // when
        let rightValueBerlin = tempTools.rightValueByUnit(grad: berlinWQ.temp, defaultsManager: defaultsManager)
        // then
        XCTAssertEqual(rightValueBerlin,  -3.4, "the value for celsuis is not right")
        
        //For Fahrenheit
        // given
        defaultsManager.saveSwitchStatus(true)
        // when
        let rightValueAfterChange = tempTools.rightValueByUnit(grad: berlinWQ.temp, defaultsManager: defaultsManager)
        // then
        XCTAssertEqual(rightValueAfterChange, 25, accuracy: 1, "the value for fahrenheit is not right")
    }
    
    
    func testCityTempString() {
        let berlinWQ = WeatherQuery(queryDate: Date(), cityName: "Berlin", tempMin: -6.3, temp: 13.4, tempMax: 22.5)
        //For Celsius
        // given
        defaultsManager.saveSwitchStatus(false)
        // when
        let rightValueBerlin = tempTools.cityTempString(fromQuery: berlinWQ, defaultsManager: defaultsManager)
        // then
        XCTAssertEqual(rightValueBerlin,  "Berlin, 13°C", "the city temp for celsuis is not right")
        
        //For Fahrenheit
        // given
        defaultsManager.saveSwitchStatus(true)
        // when
        let rightValueAfterChange = tempTools.cityTempString(fromQuery: berlinWQ, defaultsManager: defaultsManager)
        // then
        XCTAssertEqual(rightValueAfterChange, "Berlin, 56°F", "the city temp for fahrenheit is not right")
    }

    
    func testTempStringWithoutLetter() {
        let berlinWQ = WeatherQuery(queryDate: Date(), cityName: "Berlin", tempMin: -6.3, temp: 13.4, tempMax: 22.5)
        //For Celsius
        // given
        defaultsManager.saveSwitchStatus(false)
        // when
        let rightValueBerlin = tempTools.tempStringWithoutLetter(weather: berlinWQ, defaultsManager: defaultsManager)
        // then
        XCTAssertEqual(rightValueBerlin,  "13°", "the city temp for celsuis is not right")
        
        //For Fahrenheit
        // given
        defaultsManager.saveSwitchStatus(true)
        // when
        let rightValueAfterChange = tempTools.tempStringWithoutLetter(weather: berlinWQ, defaultsManager: defaultsManager)
        // then
        XCTAssertEqual(rightValueAfterChange, "56°", "the city temp for fahrenheit is not right")
    }
}
