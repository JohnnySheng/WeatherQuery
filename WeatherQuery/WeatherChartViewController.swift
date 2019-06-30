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

        var xValues = [String]()
        for i in 0...queries.count {
            xValues.append(NSString(format: "%d", i + 1993) as String)
        }
        
        let dataEntries = (0..<queries.count).map { (i) -> CandleChartDataEntry in
            let high = queries[i].tempMax
            let low = queries[i].tempMin
            let open = queries[i].tempMin
            let close = queries[i].tempMax
            return CandleChartDataEntry(x: Double(i),
                                        shadowH: TempTools.rightValueByUnit(grad: high),
                                        shadowL: TempTools.rightValueByUnit(grad: low),
                                        open: TempTools.rightValueByUnit(grad: open),
                                        close: TempTools.rightValueByUnit(grad: close))
        }
        let chartDataSet = CandleChartDataSet(entries: dataEntries, label: "Weather Data with Unit: \(TempTools.currentUnit())")

        let dateEntries = (0..<queries.count).map { (i) -> String in
            let date = queries[i].queryDate
            return DateTools.chartDateString(fromDate: date)
        }
        candleStickChart.xAxis.valueFormatter = IndexAxisValueFormatter.init(values: dateEntries)
        chartDataSet.increasingFilled = true
        chartDataSet.setColor(.orange)
        let chartData = CandleChartData(dataSets: [chartDataSet])
        candleStickChart.data = chartData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        candleStickChart.maxVisibleCount = 40
        candleStickChartUpdate()
        
        
        // 签协议
//        candleStickChart.delegate = self
//        candleStickChart.backgroundColor = UIColor.whiteColor()
//        // 画板颜色
////        candleStickChart.gridBackgroundColor = UIColor.clearColor()
////        //
////        candleStickChart.borderColor = UIColor.whiteColor()
////        self.view.addSubview(chartView)
//        // 横轴数据
//        var xValues = [String]()
//        for i in 0...25 {
//            xValues.append(NSString(format: "%d", i + 1993) as String)
//        }
//        // 初始化CandleChartDataEntry数组
//        var yValues = [CandleChartDataEntry]()
//        // 产生20个随机立柱数据
//        for j in 0...24 {
//            let val = (Double)(arc4random_uniform(40))
//            let high = (Double)(arc4random_uniform(9)) + 8.0
//            let low = (Double)(arc4random_uniform(9)) + 8.0
//            let open = (Double)(arc4random_uniform(6)) + 1.0
//            let close = (Double)(arc4random_uniform(6)) + 1.0
//
//            let even = j % 2 == 0
//
//            yValues.append(CandleChartDataEntry.init(xIndex: j, shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close))
//        }
//        let set1 = CandleChartDataSet.init(yVals: yValues, label: "data set")
//        // defult left
//        // set1.axisDependency
//        // data set color
//        set1.setColor(UIColor.blueColor())
//        set1.shadowColor = UIColor ( red: 0.5536, green: 0.5528, blue: 0.0016, alpha: 1.0 )
//        // 立线的宽度
//        set1.shadowWidth = 0.7
//        // close >= open
//        set1.decreasingColor = UIColor.redColor()
//        // 内部是否充满颜色
//        set1.decreasingFilled = true
//        // open > close
//        set1.increasingColor = UIColor ( red: 0.0006, green: 0.2288, blue: 0.001, alpha: 1.0 )
//        // 内部是否充满颜色
//        set1.increasingFilled = true
//        // 赋值数据
//        let data = CandleChartData(xVals: xValues, dataSet: set1)
//        chartView.data = data
    }
}
