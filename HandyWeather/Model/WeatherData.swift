//
//  WeatherData.swift
//  HandyWeather
//
//  Created by Tayari Africa on 6/17/20.
//  Copyright © 2020 Tayari Africa. All rights reserved.
//

import Foundation


struct  WeatherData: Decodable {
    var name: String
    var main: Main
    var weather: [Weather]
    var wind: Wind

}

struct  Main: Decodable {
    var temp: Double
    var pressure: Int
    var humidity: Int
}

struct  Weather: Decodable {
    var id:Int
    var description: String
}

struct Wind: Decodable {
    var speed: Double
}
