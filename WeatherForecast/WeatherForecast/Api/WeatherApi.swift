//
//  WeatherApi.swift
//  WeatherForecast
//
//  Created by zhongkang zhang on 6/7/19.
//  Copyright © 2019 weather. All rights reserved.
//

import Foundation

class WeatherApi {
    
    static let shared = WeatherApi()
    
    init() {}
    
    private let urlSession = URLSession.shared
    
    private let appId = "3c906ef4a342b497365c68b877a0b29d"
    
    private let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?id=1880252&APPID=3c906ef4a342b497365c68b877a0b29d")!
    
    func retriveData(completion: @escaping (Forecast?) -> Void){
        
        urlSession.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                do {
                    let model = try JSONDecoder().decode(Forecast.self, from: data)
                    completion(model)
                    return
                } catch let parsingError{
                    print("Error", parsingError)
                }
            }
            completion(nil)
            
            }.resume()
        
    }
    
    
}
