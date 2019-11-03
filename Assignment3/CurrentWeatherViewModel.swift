//
//  CurrentWeatherViewModel.swift
//  Assignment3
//
//  Created by MAC on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//
import Foundation
import UIKit

struct CurrentWeatherViewModel {
    let temperature: String
    let humidity: String
    let precipitationProbability: String
    let summary: String
    let icon: UIImage
    
    init (model: CurrentWeather){
        let roundedTemperature = Int((model.temperature - 32)/1.8)
        self.temperature = "\(roundedTemperature)º"
        
        let humidityPercentValue = Int(model.humidity * 100)
        self.humidity = "\(humidityPercentValue)%"
        
        let precipPercentValue = Int(model.precipProbability * 100)
        self.precipitationProbability = "\(precipPercentValue)%"
        
        self.summary = model.summary
        
        self.icon = model.iconImage
    }
}
