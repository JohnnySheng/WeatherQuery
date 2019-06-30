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
    // MARK: -
    
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
    
    private let weatherTableCellIdentifier = "weatherTableViewCell"
    
    private let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        database = Database()
        database.tableWeatherCreate()
        
        cityList = database.allCityRows()
        
//            let allCity = database.allCityNames()
        
        //
//        let shanghai = database.allWeatherItemsForCity(city: )
        
        updateSwitch();
        
        LocationService.sharedInstance.delegate = self
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherQueryCell =
            tableView.dequeueReusableCell(withIdentifier: weatherTableCellIdentifier, for: indexPath) as! WeatherTableViewCell
        let query = cityList[indexPath.row]
        weatherQueryCell.cityLabel.text = self.cityTempString(fromQuery: query)
        weatherQueryCell.dateLabel.text = dateString(fromDate: query.queryDate)
        return weatherQueryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    
    func cityTempString(fromQuery query:WeatherQuery) -> String {
        let tempString = self.tempString(weather: query)
        return "\(query.cityName), \(tempString)"
    }
    
    func dateString(fromDate date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: - IBActions
    @IBAction func switchPressed(_ sender: UISwitch) {
        UserDefaultManager.saveSwitchStatus(sender.isOn)
        if let weather = self.currentWeather{
            self.updateMainViewWith(weather: weather)
        }
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
    
 
    func tracingLocation(currentLocation: CLLocation) {
        LocationService.sharedInstance.stopUpdatingLocation()
        self.getWeatherForLocation(currentLocation)
    }
    func tracingLocationDidFailWithError(error: NSError) {
        print(error.description)
        LocationService.sharedInstance.stopUpdatingLocation()
    }
    
    func updateSwitch() {
        self.tempSwitch.setOn(UserDefaultManager.switchStatus(), animated: false)
    }
        
    func updateMainViewWith(weather : WeatherQuery) {
        self.cityLabel.text = weather.cityName
        self.tempLabel.text = self.tempString(weather: weather)
    }
    
    func tempString(weather : WeatherQuery) -> String {
        var tempMsm = Measurement(value: weather.temp, unit: UnitTemperature.celsius)
        
        if UserDefaultManager.switchStatus() {
            tempMsm  = tempMsm.converted(to: UnitTemperature.fahrenheit)
        }
        let tempValueString = String(format: "%.2f", tempMsm.value)
        
        if UserDefaultManager.switchStatus() {
            return "\(tempValueString)°F"
        }else{
            return "\(tempValueString)°C"
        }
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
                self.updateMainViewWith(weather: weather)
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
                self.updateMainViewWith(weather: weather)
            }
            
        }
    }
}

