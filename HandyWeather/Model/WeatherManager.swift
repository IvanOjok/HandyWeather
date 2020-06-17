//
//  WeatherManager.swift
//  HandyWeather
//
//  Created by Tayari Africa on 6/17/20.
//  Copyright © 2020 Tayari Africa. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func  didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=36e510de03335a96b000004a05eceba2&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func  fetchWeatherByName(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
 
    
    func  fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString:String) {
        //1. Create a URL
        
        ///the if is cause this URL string is an optional
        if let url = URL(string: urlString) {
            //2. Create a URL Session
            
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            ///using a closure here instead of the handle function defined below
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safedata = data {
                    //the self keyword is because the function is called in a closure and hence must be notified
                    if let weather = self.parseJSON(weatherData: safedata){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
        
    }
    
   // func handle(data:Data?, urlResponse:URLResponse?, error:Error?) {
   //
   //
   // }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decodable = JSONDecoder()
        //this takes two parameters: type and data. Type is decoder and so we call the structure created of Decoder protocol
        do{
            let results = try decodable.decode(WeatherData.self, from: weatherData)
            //print(resullts.weather[0].description)
            let id = results.weather[0].id
            let city = results.name
            let temperature = results.main.temp
            let pressure = results.main.pressure
            let humidity = results.main.humidity
            let speed = results.wind.speed
            
            let weather = WeatherModel(name: city, temperature: temperature, conditionId: id, pressure: pressure, humidity: humidity, speed: speed)
            //(name: city, temperature: temperature, conditionId: id, pressure: pressure, humidity: humidity)
            return weather
            //print(getConditionName(weatherId: id))
        }
        catch
        {
           delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    /*func  getConditionName(weatherId: Int) -> String {
        switch weatherId {
        case 200 ... 232:
            return "cloud.bolt"
        case 300 ... 321:
            return "cloud.drizzle"
        case 500 ... 531:
            return "cloud.rain"
        case 600 ... 622:
            return "snow"
        case 701 ... 781:
            return "cloud.sun"
        case 800:
            return "sun.min"
        case 801 ... 804:
            return "cloud"
        default:
            return "clouds"
        }
    }
 */
}
