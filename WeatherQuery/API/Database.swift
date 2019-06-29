//
//  Database.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/29.
//  Copyright © 2019 Johnny. All rights reserved.
//

import Foundation
import SQLite

struct Database {
    
    var db: Connection!
    
    init() {
        connectDatabase()
    }
    
    //connectDatabase
    mutating func connectDatabase(filePath: String = "/Documents") -> Void {
        //let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        let db = try? Connection("\(path)/db.sqlite3")
        let sqlFilePath = NSHomeDirectory() + filePath + "/db.sqlite3"
        
        do { // 与数据库建立连接
            db = try Connection(sqlFilePath)
            print("与数据库建立连接 成功")
        } catch {
            print("与数据库建立连接 失败：\(error)")
        }
        
    }
    
    // ===================================== Weather =====================================
    let tableWeather = Table("table_Weather")
    let table_weatherID = Expression<Int64>("weather_id")
    let table_cityName = Expression<String>("city_name")
    let table_tempMin = Expression<Double>("temp_min")
    let table_temp = Expression<Double>("temp")
    let table_tempMax = Expression<Double>("temp_max")
    let table_queryDate = Expression<Date>("query_date")
    
    // Create table
    func tableWeatherCreate() -> Void {
        do { // create table_Weather
            try db.run(tableWeather.create(ifNotExists: true) { table in
                table.column(table_weatherID, primaryKey: .autoincrement) // 主键自加且不为空
                table.column(table_cityName)
                table.column(table_tempMin)
                table.column(table_temp)
                table.column(table_tempMax)
                table.column(table_queryDate)
            })
            print("create table weather successfully")
        } catch {
            print("create table weather：\(error)")
        }
    }
    
    //Insertiong
    func insertWeatherQuery(_ weather : WeatherQuery) {
        tableWeatherInsertItem(city: weather.cityName, tempMin: weather.tempMin, temp:weather.temp, tempMax: weather.tempMax, queryDate: weather.queryDate)
    }
    
    func tableWeatherInsertItem(city: String, tempMin: Double, temp: Double, tempMax: Double, queryDate: Date){
        let insert = tableWeather.insert(table_cityName <- city, table_tempMin <- tempMin, table_temp <- temp, table_tempMax <- tempMax, table_queryDate <- queryDate)
        do {
            let rowid = try db.run(insert)
            print("Insertion successfully  id: \(rowid)")
        } catch {
            print("Insertion failed: \(error)")
        }
    }
    
    // Traversing
    func queryTableLamp() -> Void {
        for item in (try! db.prepare(tableWeather)) {
            print("The entire table id: \(item[table_weatherID]), city: \(item[table_cityName]), min temp: \(item[table_tempMin]), temp: \(item[table_temp]), max temp: \(item[table_tempMax]), date: \(item[table_queryDate])")
        }
    }
    
    //get all of the cities
    func allCityNames() -> Array<String> {
        var cityNames : Set = Set<String>()
        do {
            for item in try db.prepare(tableWeather.select(table_cityName)) {
                print("allCityNames:\(item)")
                cityNames.insert(item[table_cityName])
            }
        } catch let error {
            print(error)
        }
        return Array(cityNames)
    }
    
    //get all weather query items
    func allWeatherItemsForCity(city:String ) -> Array<WeatherQuery> {
        
        var weatherQueries = Array<WeatherQuery>()
        do {
            for item in try db.prepare(tableWeather.filter(table_cityName.lowercaseString==city).order(table_queryDate)) {
                print("allWeatherItemsForCity:\(item)")
                let weatherQuery = WeatherQuery(queryDate: item[table_queryDate], cityName: item[table_cityName], tempMin: item[table_tempMin], temp: item[table_temp], tempMax: item[table_tempMax])
                weatherQueries.append(weatherQuery)
            }
        } catch let error {
            print(error)
        }
        return weatherQueries
    }

    
}
