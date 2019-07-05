//
//  HourlyCollectionViewCell.swift
//  WeatherForecast
//
//  Created by zhongkang zhang on 6/7/19.
//  Copyright © 2019 weather. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lTemp: UILabel!
    @IBOutlet weak var ivWeather: UIImageView!
    @IBOutlet weak var lWeather: UILabel!
    @IBOutlet weak var lTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpView(_ weather :WeatherModel){
        lTemp.text = weather.temperature
        if let icon = weather.icon{
            ivWeather.loadWeatherIcon(icon)
        }
        lWeather.text = weather.main
        lTime.text = weather.time_txt
    }

}
