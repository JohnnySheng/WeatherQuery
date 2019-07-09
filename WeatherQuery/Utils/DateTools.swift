//
//  DateTools.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/30.
//  Copyright © 2019 Johnny. All rights reserved.
//

import Foundation
class DateTools {
    //MARK: - Generate date string in format "dd.MM.yyyy HH:mm:ss"
    static func dateString(fromDate date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    //MARK: - Generate date string in format "dd.MM"
    static func chartDateString(fromDate date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter.string(from: date)
    }
}
