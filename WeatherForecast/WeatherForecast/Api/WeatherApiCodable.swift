//
//  WeatherApiCodable.swift
//  WeatherForecast
//
//  Created by zhongkang zhang on 6/7/19.
//  Copyright © 2019 weather. All rights reserved.
//

import Foundation

struct Forecast : Codable {
    let list : [ThreeHourInfo]
}

struct ThreeHourInfo: Codable {
    let dt : Int?
    let main : Main?
    let weather : [Weather]
    let clouds : Clouds?
    let wind : Wind?
    let rain : Rain?
    let dt_txt : String?
}

struct Main : Codable {
    let temp, temp_min, temp_max, pressure : Double?
}

struct Weather : Codable {
    let id : Int?
    let main, description, icon : String?
}

struct Clouds : Codable {
    let all : Int?
}

struct Wind : Codable {
    let speed, deg : Double?
}

struct Rain : Codable {
    let threeHour : Double?
    
    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
}
