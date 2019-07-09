//
//  WeatherChartViewController.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/30.
//  Copyright © 2019 Johnny. All rights reserved.
//

import UIKit
import Charts

class WeatherChartViewController: UIViewController{
    var dateTools = DateTools()
    var tempTools = TempTools()
    var defaultsManager = UserDefaultsManager()
    @IBOutlet weak var candleStickChart: CandleStickChartView!
    
    fileprivate let MAX_AMOUNT = 20
    
    var selectedWeathQuery:WeatherQuery!
    var database: Database!
    
    func candleStickChartUpdate () {
        var queries = database.allWeatherItemsForCity(city: selectedWeathQuery.cityName)
        if queries.count > MAX_AMOUNT{
            queries.removeSubrange(MAX_AMOUNT..<queries.count)
        }
        
        let dataEntries = (0..<queries.count).map { (i) -> CandleChartDataEntry in
            let high = queries[i].tempMax
            let low = queries[i].tempMin
            let open = queries[i].tempMin
            let close = queries[i].tempMax
            return CandleChartDataEntry(x: Double(i),
                                        shadowH: tempTools.rightValueByUnit(grad: high, defaultsManager: defaultsManager),
                                        shadowL: tempTools.rightValueByUnit(grad: low, defaultsManager: defaultsManager),
                                        open: tempTools.rightValueByUnit(grad: open, defaultsManager:  defaultsManager),
                                        close: tempTools.rightValueByUnit(grad: close, defaultsManager: defaultsManager))
        }
        let chartDataSet = CandleChartDataSet(entries: dataEntries, label: "Weather Data with Unit: \(tempTools.currentUnit(defaultsManager: defaultsManager))")

        let dateEntries = (0..<queries.count).map { (i) -> String in
            let date = queries[i].queryDate
            return dateTools.chartDateString(fromDate: date)
        }
        candleStickChart.xAxis.valueFormatter = IndexAxisValueFormatter.init(values: dateEntries)
        chartDataSet.increasingFilled = true
        chartDataSet.setColor(.orange)
        let chartData = CandleChartData(dataSets: [chartDataSet])
        candleStickChart.data = chartData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        candleStickChartUpdate()
    }
}
