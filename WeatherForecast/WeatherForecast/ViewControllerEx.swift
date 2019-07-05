//
//  ViewControllerEx.swift
//  WeatherForecast
//
//  Created by zhongkang zhang on 6/7/19.
//  Copyright © 2019 weather. All rights reserved.
//

import UIKit


extension ViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // for ipad rotate screen to update height of collection view cell
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let height = size.height / 2 - 60
                layout.itemSize = CGSize(width: 100, height: height)
                layout.invalidateLayout()
            }
        }
        
    }
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.weatherList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : HourlyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
        
        if let weather = self.viewModel?.weatherList[indexPath.row] {
            cell.setUpView(weather)
        }
        
        return cell
        
    }
    
    // to update max min temperature of date
    // date is determined by the first visible cell
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let sorted = self.collectionView.indexPathsForVisibleItems.sorted {
            return $0.row < $1.row
        }
        if let rowNumber = sorted.first?.row {
            
            if let currentDate = self.viewModel?.weatherList[rowNumber], let dayTxt = currentDate.day_txt, dayTxt != self.lDate.text {
                self.displayDaySummaryView(dateTxt: dayTxt)
            }
        }
        
    }
    
}

extension UIImageView {
    
    public func loadWeatherIcon(_ icon: String) {
        let urlString = String(format: "http://openweathermap.org/img/wn/%@@2x.png", icon)
        if let url = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
