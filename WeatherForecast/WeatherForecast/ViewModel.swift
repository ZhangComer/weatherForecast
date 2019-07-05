//
//  ViewModel.swift
//  WeatherForecast
//
//  Created by zhongkang zhang on 6/7/19.
//  Copyright © 2019 weather. All rights reserved.
//

import Foundation

class ViewModel {
    
    var weatherList : [WeatherModel] = []
    var weatherNow : WeatherModel?
    var highLowTemps : [String : (Double,Double)] = [:]
    
    init( list : [ThreeHourInfo]) {
        
        list.forEach({
            self.weatherList.append(WeatherModel(info: $0))
        })
        
        weatherNow = self.weatherList.first(where: { (model) -> Bool in
            return model.isNow
        })
        
        
        // calculate the max and min temperature for each  5 days
        weatherList.forEach { (model) in
            
            if let day_txt = model.day_txt, let tempHigh = model.tempHigh , let tempLow = model.tempLow {
                
                if highLowTemps.keys.contains(day_txt){
                    
                    if let max = highLowTemps[day_txt]?.0 , tempHigh > max {
                        highLowTemps[day_txt]!.0 = tempHigh
                    }
                    
                    if let min = highLowTemps[day_txt]?.1 , tempLow < min {
                        highLowTemps[day_txt]!.1 = tempLow
                    }
                    
                }else {
                    highLowTemps[day_txt] = (tempHigh,tempLow)
                }
            }
        }
        
        
    }
}


class WeatherModel {
    
    var weather, icon, main : String?
    var temperature, wind : String?
    var time_txt : String?
    var day_txt : String?
    var tempHigh, tempLow : Double?
    var isNow : Bool = false
    
    
    init(info : ThreeHourInfo) {
        
        weather = info.weather.first?.description
        main = info.weather.first?.main
        icon = info.weather.first?.icon
        
        if let temp = info.main?.temp {
            let tempInt  = Int((temp - 273.15).rounded())
            temperature = String(format: "%d°C", tempInt)
        }
        
        tempHigh = info.main?.temp_max
        tempLow = info.main?.temp_min
        
        if let windy = info.wind?.speed {
            wind = String(format: "%.2f m/s", windy)
        }
        
        if let txt = info.dt_txt {
            
            isNow = checkIsNow(txt)
            (time_txt,day_txt) = newDateFormat(txt)
        }
        
    }
    // spit dt_txt into date_txt and time_txt
    func newDateFormat(_ dt_txt :String) -> (String?,String?) {
        
        var timeTxt : String? = nil
        var dayTxt : String? = nil
        
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dt_txt){
            
            if calender.isDateInToday(date) {
                dayTxt = "Today"
            }else if calender.isDateInTomorrow(date){
                dayTxt = "Tomorrow"
            }else {
                dateFormatter.dateFormat = "E, d MMM"
                dayTxt = dateFormatter.string(from: date)
            }
            
            dateFormatter.dateFormat = "h:mm a"
            timeTxt = dateFormatter.string(from: date)
        }
        return (timeTxt, dayTxt)
    }
    
    // to check dt_txt is within 3 hours
    func checkIsNow(_ dt_txt :String) -> Bool{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dt_txt){
            let interval = date.timeIntervalSinceNow
            if interval < 0 && interval > -10800 {
                return true
            }
        }
        return false
    }
}
