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
    let pressure: String
    
    init (model: CurrentWeather){
        let convertedTemperature = (model.temperature - 32)/1.8
        let convertedTemperatureString = String(format: "%.1f", convertedTemperature)
        self.temperature = "\(convertedTemperatureString) ºC"
        
        let humidityPercentValue = Int(model.humidity * 100)
        self.humidity = "\(humidityPercentValue) %"
        
        let precipPercentValue = Int(model.precipProbability * 100)
        self.precipitationProbability = "\(precipPercentValue) %"
        
        self.summary = model.summary
        
        self.icon = model.iconImage
        
        let convertedPressure = model.pressure/10
        let convertedPressureString = String(format: "%.1f", convertedPressure)
        self.pressure = "\(convertedPressureString) kPa"
    }
}
