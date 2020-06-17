//
//  WeatherModel.swift
//  HandyWeather
//
//  Created by Tayari Africa on 6/17/20.
//  Copyright © 2020 Tayari Africa. All rights reserved.
//

import Foundation


struct WeatherModel {
    let name:String
    let temperature: Double
    let conditionId: Int
    let pressure: Int
    let humidity: Int
    var speed: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var speedString: String {
        return String(format: "%.1f", speed)
    }
    
    //using a computed variable...
    var conditionName: String {
        switch conditionId {
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
}
