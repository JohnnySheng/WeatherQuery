//
//  DateToolsTests.swift
//  WeatherQueryTests
//
//  Created by Yuangang Sheng on 2019/7/10.
//  Copyright © 2019 Johnny. All rights reserved.
//

import XCTest

@testable import WeatherQuery

class DateToolsTests: XCTestCase {

    
    var dateTools: DateTools!

    override func setUp() {
        super.setUp()
        dateTools = DateTools()
    }

    override func tearDown() {
        dateTools = nil
        super.tearDown()
    }

    func testDateString() {
        let currentDate = Date()
        let dateString = dateTools.dateString(fromDate: currentDate)
        
        XCTAssertEqual(dateString.count, 19, "date string is wrong")
    }

    func testChartDateString() {
        let currentDate = Date()
        let dateString = dateTools.chartDateString(fromDate: currentDate)
        
        XCTAssertEqual(dateString.count, 5, "date string for chart is wrong")
    }

}
