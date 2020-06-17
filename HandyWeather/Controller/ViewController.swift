//
//  ViewController.swift
//  HandyWeather
//
//  Created by Tayari Africa on 6/17/20.
//  Copyright © 2020 Tayari Africa. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

  @IBOutlet weak var conditionImageView: UIImageView!
        @IBOutlet weak var temperatureLabel: UILabel!
        @IBOutlet weak var cityLabel: UILabel!
        @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
        var weatherManager = WeatherManager()
        var locationManager = CLLocationManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            locationManager.delegate = self
            //sends a pop up message to user to access His current location. In the info.plist file, we display a message we want to show the user while accessing their location
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            //used in getting real time updates for the users location
            //locationManager.startUpdatingLocation()
         
            //make the weathermanagerdelegate protocol reort to the controller
            weatherManager.delegate = self
            //the delegate property is to the self (weatherview controller) which makes the textfield report back to the textfield
            searchTextField.delegate = self
        }
        
        @IBAction func getCurrentLocationWeather(_ sender: UIButton) {
            locationManager.requestLocation()
        }
        
        
    }

    //MARK: - CLLocationManagerDelegate
    extension ViewController: CLLocationManagerDelegate {
        
       
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                locationManager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let long = location.coordinate.longitude
                
                weatherManager.fetchWeather(latitude: lat, longitude: long)
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }

    }

    //MARK: - UITextFieldDelegate
    //extensions enable us to make code simpler and readable.
    extension ViewController: UITextFieldDelegate {
        
        @IBAction func searchPressed(_ sender: UIButton) {
               //this line dismisses the keyboard
               searchTextField.endEditing(true)
            if let city = searchTextField.text {
                weatherManager.fetchWeatherByName(cityName: city)
            }
            searchTextField.text = ""
           }
           
           //this is when the return key on the keyboard is pressed
           func textFieldShouldReturn(_ textField: UITextField) -> Bool {
               return true
           }
           
           //this lets the view controller know what to do when the user is done editing or moves away from the textfield
           func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
               if textField.text != "" {
               return true
               }
               else {
                   textField.placeholder = "Type Something"
                   return false
               }
           }
           
           //this enables the view contoller know that the user is done editing
           func textFieldDidEndEditing(_ textField: UITextField) {
               //enables remove the text when user is done editing
               if let city = searchTextField.text {
                   weatherManager.fetchWeatherByName(cityName: city)
               }
               searchTextField.text = ""
           }
    }

    //MARK: - WeatherManagerDelegate
    extension ViewController: WeatherManagerDelegate {
        
        func  didUpdateWeather(weather: WeatherModel)  {
            ///this piece of code won't be executedcause the competion handler continues running and only when its processes stop that  it can output information. And so we use the DispatchQueue method and this needs the self initializer
            //temperatureLabel.text = weather.temperatureString
            
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage.init(systemName: weather.conditionName)
                self.cityLabel.text = weather.name
                self.humidityLabel.text = String(weather.humidity)
                self.pressureLabel.text = String(weather.pressure)
                self.windLabel.text = weather.speedString
                
            }
            print(weather.temperatureString)
        }
        
        func didFailWithError(error: Error) {
            print(error)
        }
        


}

