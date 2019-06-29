//
//  ViewController.swift
//  WeatherQuery
//
//  Created by Yuangang Sheng on 2019/6/29.
//  Copyright © 2019 Johnny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tampLaben: UILabel!
    
    
    @IBAction func switchPressed(_ sender: Any) {
    }
    
    
    @IBAction func goButtonPressed(_ sender: Any) {
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
    }
    
    
    private let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getWeather()
        getWeatherForCity()
    }


}

extension ViewController {
    
    private func getWeather() {
        let coord = Coord(lon: 9.18, lat: 48.77)
        apiManager.getWeather(coordinate:coord) { (weather, error) in
            if let error = error {
                print("Get weather error: \(error.localizedDescription)")
                return
            }
            guard let weather = weather  else { return }
            print("Current Weather Object:")
//            print(weather.name)
            print(weather)
        }
    }
    
    private func getWeatherForCity() {
        apiManager.getWeather(cityName:"Stuttgart") { (weather, error) in
            if let error = error {
                print("Get weather error: \(error.localizedDescription)")
                return
            }
            guard let weather = weather  else { return }
            print("Current Weather Object:")
//            print(weather.name)
            print(weather)
        }
    }
}

