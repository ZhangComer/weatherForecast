//
//  ViewController.swift
//  WeatherForecast
//
//  Created by zhongkang zhang on 6/7/19.
//  Copyright © 2019 weather. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var ivWeather: UIImageView!
    @IBOutlet weak var lTemp: UILabel!
    @IBOutlet weak var lWeather: UILabel!
    @IBOutlet weak var lWind: UILabel!
    
    @IBOutlet weak var lDate: UILabel!
    @IBOutlet weak var lMaxTemp: UILabel!
    @IBOutlet weak var lMinTemp: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel : ViewModel?
    
    @IBAction func refresh(_ sender: Any) {
        fetchWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "hourlyCollectionViewCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                flowLayout.itemSize = CGSize(width: 100, height: view.frame.height / 2 - 60)
            }else {
                flowLayout.itemSize = CGSize(width: 100, height: collectionView.frame.height)
            }
            
        }
        
        fetchWeather()
        
    }
    
    // retrive weather forecast data
    func fetchWeather(){

        spinner.startAnimating()
        WeatherApi.shared.retriveData { (forecast) in
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                if let hoursWeathers = forecast?.list{
                    self.viewModel = ViewModel(list: hoursWeathers)
                    self.displayViews()
                }
            }
        }
    }
    
    
    
    func displayViews(){
        
        if let weather = self.viewModel?.weatherNow {
            self.displayCurrentWeather(weather)
        }
        self.collectionView.reloadData()
        if let today = self.viewModel?.weatherList.first {
            self.displayDaySummaryView(dateTxt: today.day_txt)
        }
        
    }
    
    // display current weather info
    func displayCurrentWeather(_ data : WeatherModel){
        
        if let icon = data.icon{
            ivWeather.loadWeatherIcon(icon)
        }
        lWeather.text = data.weather
        lTemp.text = data.temperature
        lWind.text = String(format: "Wind : %@", data.wind ?? "0.00 m/s")
        
    }
    
    // display max and min temperature of day
    func displayDaySummaryView(dateTxt : String?){
        
        guard let dateTxt = dateTxt else {
            return
        }
        lDate.text = dateTxt
        if let max = self.viewModel?.highLowTemps[dateTxt]?.0 {
            let tempInt = Int((max - 273.15).rounded())
            lMaxTemp.text = String(format: "%d°C", tempInt)
        }
        if let min = self.viewModel?.highLowTemps[dateTxt]?.1{
            let tempInt = Int((min - 273.15).rounded())
            lMinTemp.text = String(format: "%d°C", tempInt)
        }
    }


}

