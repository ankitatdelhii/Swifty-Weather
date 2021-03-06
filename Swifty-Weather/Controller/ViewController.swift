//
//  ViewController.swift
//  Swifty-Weather
//
//  Created by Ankit Saxena on 14/02/19.
//  Copyright © 2019 Ankit Saxena. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, cityNamePr {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    let App_Id = "2de1c2aa184891025ed93b3ce52335da"
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather"
    
    let locationManager = CLLocationManager()
    let model = weatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let params : [String : String] = ["lat" : "\(lat)", "lon" : "\(lon)", "appid" : App_Id]
            getWeatherData(with: params)
        }
        else{
            cityLabel.text = "Accuracy Problem!"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did Fail With Error!")
        cityLabel.text = "Error Getting Location!"
    }
    
    
    //MARK:- Using Alamofire for Networking
    func getWeatherData(with param : [String : String]){
        Alamofire.request(weatherURL, method: .get, parameters: param).responseJSON { (response) in
            if response.result.isSuccess{
                guard let res = response.result.value else{
                    fatalError("Error Unwrapping result file!")
                }
                let json = JSON(res)
                self.parseJSON(with: json)
            }
            else{
                print("Error Fetching Data!")
                self.cityLabel.text = "Error Fetching Data!"
            }
        }
    }
    
    
    func parseJSON(with weatherJSON: JSON){
        if let city = weatherJSON["name"].string{
            model.city = city
            model.temperature = Int(weatherJSON["main"]["temp"].doubleValue - 273.5)
            model.maxTemp = Int(weatherJSON["main"]["temp_max"].doubleValue - 273.5)
            model.minTemp = Int(weatherJSON["main"]["temp_min"].doubleValue - 273.5)
            model.condition = weatherJSON["weather"][0]["id"].intValue
            model.weatherIconName = model.getWeatherIcon(condition: model.condition)
            updateUI()
        }
        else{
            cityLabel.text = "JSON Error"
        }
        
    }
    
    func updateUI(){
        cityLabel.text = model.city
        tempLabel.text = "\(model.temperature) °C"
        weatherIcon.image = UIImage(named: model.weatherIconName)
        maxTemp.text = "Max : \(model.maxTemp) °C"
        minTemp.text = "Min : \(model.minTemp) °C"
    }
    
    //MARK:- Code for changeCity
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCity"{
            let destinationVC = segue.destination as! CityViewController
            destinationVC.delegate = self
        }
    }

    func changeCityName(name: String) {
        let cityParam : [String : String] = ["q" : name, "appid" : App_Id]
        getWeatherData(with: cityParam)
    }

}

