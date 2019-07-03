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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tableHeaderView : WeatherTableHeaderView!
    
    var currentWeather:WeatherQuery?
    var database: Database!
    var cityList:Array<WeatherQuery>!
    
    fileprivate let weatherTableCellIdentifier = "weatherTableViewCell"
    fileprivate let emptyTableCellIndentifier = "emptyTableViewCell"
    fileprivate let showChartSegueIdentifier = "showChartSegue"
    
    private let apiManager = APIManager()
    
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        databaseInit()
        updateTableHeader()
        LocationService.sharedInstance.delegate = self
        UserDefaultManager.saveLocationQueryStatus(false)
        
    }
    
    func databaseInit(){
        database = Database()
        database.tableWeatherCreate()
        cityList = database.allCityRows()
    }
    
    func updateTableHeader() {
        
        //mark
        let mainView = Bundle.main.loadNibNamed("WeatherMainView", owner: nil, options: nil)![0] as! WeatherMainView
        
        
        tableHeaderView = WeatherTableHeaderView(subview: mainView, andType: 4)
        tableHeaderView.tableView = self.tableView
        tableHeaderView.maximumOffsetY = -60
        
        mainView.tempLableOriginalRect = mainView.tempLabel.frame
        let mainViewFrame = mainView.frame
        let tempLabelFrame = mainView.tempLableOriginalRect!
        
        mainView.tempLabelDestinationRect = CGRect.init(x: mainViewFrame.size.width - (tempLabelFrame.size.width + tempLabelFrame.origin.x), y: mainViewFrame.size.height - (tempLabelFrame.size.height + tempLabelFrame.origin.y), width: tempLabelFrame.size.width, height: tempLabelFrame.size.height)
        
        self.tableView.tableHeaderView = tableHeaderView
        
        tableHeaderView.mainSubview?.tempSwitch.addTarget(self, action:#selector(switchPressed(_:)), for: .touchUpInside)
    }
    
    @objc func switchPressed(_ sender: UISwitch) {
        UserDefaultManager.saveSwitchStatus(sender.isOn)
        updateEntireView()
    }
    
    // MARK: - IBActions & Delagate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let result = textField.resignFirstResponder()
        goSearchingWithText()
        return result
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        cityTextField.resignFirstResponder()
        goSearchingWithText()
    }
    
    func goSearchingWithText() {
        self.activityIndicatorStart()
        if let inputedText = cityTextField.text{
            //remove the whitespace
            let trimmedText = inputedText.trimmingCharacters(in: .whitespaces)
            getWeatherForCity(cityName: trimmedText)
        }else{
            print("Please input a name of a city")
        }
    }
    
    func activityIndicatorStart() {
        self.activityIndicator.startAnimating()
    }
    
    func activityIndicatorStop() {
        self.activityIndicator.stopAnimating()
        if UserDefaultManager.locationQueryStatus() {
            UserDefaultManager.saveLocationQueryStatus(false)
        }
        cityTextField.text = ""
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        self.activityIndicatorStart()
        LocationService.sharedInstance.startUpdatingLocation()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cityList.count > 0 {
            return cityList.count
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cityList.count == 0{
            let emptyTableViewCell =
                tableView.dequeueReusableCell(withIdentifier: emptyTableCellIndentifier, for: indexPath) as! EmptyTableViewCell
            return emptyTableViewCell
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! WeatherTableHeaderView
        headerView.layoutHeaderViewForScrollViewOffset(offset: scrollView.contentOffset)
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
        self.activityIndicatorStop()
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
        tableHeaderView.mainSubview?.cityLabel.text = weather.cityName
        tableHeaderView.mainSubview?.tempLabel.text = TempTools.tempStringWithoutLetter(weather: weather)
        if weather.temp < 10 {
            tableHeaderView.mainSubview?.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }else if weather.temp > 25{
            tableHeaderView.mainSubview?.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }else{
            tableHeaderView.mainSubview?.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
    }
    // MARK: - Location Service Delegate
    func tracingLocation(currentLocation: CLLocation) {
        LocationService.sharedInstance.stopUpdatingLocation()
        if UserDefaultManager.locationQueryStatus() {
            return;
        }
        UserDefaultManager.saveLocationQueryStatus(true)
        self.getWeatherForLocation(currentLocation)
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print(error.description)
        LocationService.sharedInstance.stopUpdatingLocation()
        self.activityIndicatorStop()
    }
}

extension ViewController {
    private func getWeatherForLocation(_ location:CLLocation) {
        self.activityIndicatorStart()
        let coord = Coord(lon: location.coordinate.longitude, lat: location.coordinate.latitude)
        apiManager.getWeather(coordinate:coord) { (weather, error) in
            if let error = error {
                print("Get weather error: \(error.localizedDescription)")
                DispatchQueue.main.async{
                    self.activityIndicatorStop()
                }
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
                DispatchQueue.main.async{
                    self.activityIndicatorStop()
                }
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

