//
//  ViewController.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/29.
//  Copyright © 2019 Johnny. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate,LocationServiceDelegate, UITableViewDelegate,UITableViewDataSource{
    // MARK: - Variables
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var tempSwitch: UISwitch!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var currentWeather:WeatherQuery?
    var database: Database!
    var cityList:Array<WeatherQuery>!
    
    fileprivate let weatherTableCellIdentifier = "weatherTableViewCell"
    fileprivate let showChartSegueIdentifier = "showChartSegue"
    
    private let apiManager = APIManager()
    
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseInit()
        updateSwitch()
        LocationService.sharedInstance.delegate = self
    }
    
    func databaseInit(){
        database = Database()
        database.tableWeatherCreate()
        cityList = database.allCityRows()
    }
    
    func updateSwitch() {
        self.tempSwitch.setOn(UserDefaultManager.switchStatus(), animated: false)
    }
    
    // MARK: - IBActions & Delagate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        UserDefaultManager.saveSwitchStatus(sender.isOn)
        updateEntireView()
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        cityTextField.resignFirstResponder()
        if let inputedText = cityTextField.text{
            getWeatherForCity(cityName: inputedText)
        }else{
            print("Please input a name of a city")
        }
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        LocationService.sharedInstance.startUpdatingLocation()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherQueryCell =
            tableView.dequeueReusableCell(withIdentifier: weatherTableCellIdentifier, for: indexPath) as! WeatherTableViewCell
        let query = cityList[indexPath.row]
        weatherQueryCell.cityLabel.text = TempTools.cityTempString(fromQuery: query)
        weatherQueryCell.dateLabel.text = DateTools.dateString(fromDate: query.queryDate)
        weatherQueryCell.chartButton.tag = indexPath.row
        return weatherQueryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showChartSegueIdentifier {
            let destination = segue.destination as? WeatherChartViewController
            let rowIndex = (sender as! UIButton).tag
            let selectedWeathQuery = self.cityList[rowIndex] as WeatherQuery
            destination!.selectedWeathQuery = selectedWeathQuery
            destination!.database = self.database
            destination!.title = selectedWeathQuery.cityName
        }
    }

    // MARK: - Update views
    func updateEntireViewWithDatabase() {
        cityList = database.allCityRows()
        updateEntireView()
    }
    
    func updateEntireView() {
        if let weather = self.currentWeather{
            self.updateMainViewWith(weather: weather)
        }
        updateTableview()
    }
    
    func updateTableview() {
        self.tableView.reloadData()
    }
    
    func updateMainViewWith(weather : WeatherQuery) {
        self.cityLabel.text = weather.cityName
        self.tempLabel.text = TempTools.tempString(weather: weather)
    }
    // MARK: - Location Service Delegate
    func tracingLocation(currentLocation: CLLocation) {
        LocationService.sharedInstance.stopUpdatingLocation()
        self.getWeatherForLocation(currentLocation)
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print(error.description)
        LocationService.sharedInstance.stopUpdatingLocation()
    }
}

extension ViewController {
    private func getWeatherForLocation(_ location:CLLocation) {
        let coord = Coord(lon: location.coordinate.longitude, lat: location.coordinate.latitude)
        apiManager.getWeather(coordinate:coord) { (weather, error) in
            if let error = error {
                print("Get weather error: \(error.localizedDescription)")
                return
            }
            guard let weather = weather  else { return }
            self.currentWeather = weather
            self.database.insertWeatherQuery(weather)
            DispatchQueue.main.async{
                self.updateEntireViewWithDatabase()
            }
        }
    }
    
    private func getWeatherForCity(cityName:String){
        apiManager.getWeather(cityName:cityName) { (weather, error) in
            if let error = error {
                print("Get weather error: \(error.localizedDescription)")
                return
            }
            
            guard let weather = weather  else { return }
            self.currentWeather = weather
            self.database.insertWeatherQuery(weather)
            DispatchQueue.main.async{
                self.updateEntireViewWithDatabase()
            }
        }
    }
}

