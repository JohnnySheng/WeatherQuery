//
//  ViewController.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/29.
//  Copyright © 2019 Johnny. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate,LocationServiceDelegate {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var tempSwitch: UISwitch!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var currentWeather:WeatherQuery?

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    
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
    
    
    private let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateSwitch();
        
        LocationService.sharedInstance.delegate = self
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
        var tempMsm = Measurement(value: (weather.tempMin + weather.tempMax)/2.0, unit: UnitTemperature.celsius)
        
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
            DispatchQueue.main.async{
                self.updateMainViewWith(weather: weather)
            }
            
        }
    }
}

