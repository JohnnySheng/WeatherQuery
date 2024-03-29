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
    //MARK: - Init
    init() {
        connectDatabase()
    }
    
    //MARK: - Connect Database
    mutating func connectDatabase(filePath: String = "/Documents") -> Void {
        let sqlFilePath = NSHomeDirectory() + filePath + "/db.sqlite3"
        
        do {
            db = try Connection(sqlFilePath)
            print("Connect database successfully")
        } catch {
            print("Connect database failed：\(error)")
        }
    }
    //Define Table named "table_Weather"
    let tableWeather    = Table("table_Weather")
    let table_weatherID = Expression<Int64>("weather_id")
    let table_cityName  = Expression<String>("city_name")
    let table_tempMin   = Expression<Double>("temp_min")
    let table_temp      = Expression<Double>("temp")
    let table_tempMax   = Expression<Double>("temp_max")
    let table_queryDate = Expression<Date>("query_date")
    
    // Create table
    func tableWeatherCreate() -> Void {
        do {
            try db.run(tableWeather.create(ifNotExists: true) { table in
                table.column(table_weatherID, primaryKey: .autoincrement)
                table.column(table_cityName)
                table.column(table_tempMin)
                table.column(table_temp)
                table.column(table_tempMax)
                table.column(table_queryDate)
            })
            print("Create table weather successfully")
        } catch {
            print("Create table weather：\(error)")
        }
    }
    
    //Insert
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
    func queryTableWeather() -> Void {
        for item in (try! db.prepare(tableWeather)) {
            print("The entire table id: \(item[table_weatherID]), city: \(item[table_cityName]), min temp: \(item[table_tempMin]), temp: \(item[table_temp]), max temp: \(item[table_tempMax]), date: \(item[table_queryDate])")
        }
    }
    
    //get all of the city names
    func allCityNames() -> Array<String> {
        var cityNames : Set = Set<String>()
        do {
            for item in try db.prepare(tableWeather.select(table_cityName)) {
                cityNames.insert(item[table_cityName])
            }
        } catch let error {
            print(error)
        }
        //sort the city names
        let result = Array(cityNames).sorted {
            $0 < $1
        }
        return result
    }
    
    //get all weather query items of one city
    func allWeatherItemsForCity(city:String ) -> Array<WeatherQuery> {
        var weatherQueries:[WeatherQuery] = []
        do {
            for item in try db.prepare(tableWeather.filter(table_cityName.lowercaseString==city.lowercased()).order(table_queryDate.desc)) {
                let weatherQuery = WeatherQuery(queryDate: item[table_queryDate], cityName: item[table_cityName], tempMin: item[table_tempMin], temp: item[table_temp], tempMax: item[table_tempMax])
                weatherQueries.append(weatherQuery)
            }
        } catch let error {
            print(error)
        }
        return weatherQueries
    }
    
    //get last weather query item of one city
    func lastWeatherQueryItemForCity(city:String ) -> WeatherQuery?{
        var weatherQuery:WeatherQuery?
        do {
            for item in try db.prepare(tableWeather.filter(table_cityName.lowercaseString==city.lowercased()).order(table_queryDate.desc)) {
                weatherQuery = WeatherQuery(queryDate: item[table_queryDate], cityName: item[table_cityName], tempMin: item[table_tempMin], temp: item[table_temp], tempMax: item[table_tempMax])
                break;
            }
        } catch let error {
            print(error)
        }
        return weatherQuery
    }
    
    //get city rows for table
    func allCityRows() -> Array<WeatherQuery> {
        let cities = self.allCityNames()
        var queries: [WeatherQuery]  = []
        for cityString in cities {
            let query = self.lastWeatherQueryItemForCity(city: cityString)
            if let query = query{
                queries.append(query)
            }
        }
        return queries
    }
}
