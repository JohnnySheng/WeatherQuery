//
//  WeatherChartViewController,,,,,,.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/30.
//  Copyright © 2019 Johnny. All rights reserved.
//

import UIKit
import Charts

class WeatherChartViewController: UIViewController{
    @IBOutlet weak var candleStickChart: CandleStickChartView!
    
    var selectedWeathQuery:WeatherQuery!
    var database: Database!
    
    func candleStickChartUpdate () {
        let queries = database.allWeatherItemsForCity(city: selectedWeathQuery.cityName)

        let dataEntries = (0..<queries.count).map { (i) -> CandleChartDataEntry in
            let high = queries[i].tempMax
            let low = queries[i].tempMin
            let open = queries[i].tempMin
            let close = queries[i].tempMax
            return CandleChartDataEntry(x: Double(i),
                                        shadowH: high,
                                        shadowL: low,
                                        open: open,
                                        close: close)
        }
        let chartDataSet = CandleChartDataSet(entries: dataEntries, label: "Weather Data")

        chartDataSet.increasingFilled = true
        chartDataSet.setColor(.orange)
        let chartData = CandleChartData(dataSets: [chartDataSet])
        candleStickChart.data = chartData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        candleStickChart.maxVisibleCount = 40
        candleStickChartUpdate()
    }
}
