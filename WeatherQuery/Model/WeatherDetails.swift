//
//  WeatherDetails.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/29.
//  Copyright © 2019 Johnny. All rights reserved.
//

struct WeatherDetails: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
