//
//  CurrentWeatherViewModel.swift
//  Assignment3
//
//  Created by Laveeshka on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//
import Foundation
import UIKit

//CurrentWeatherViewModel struct. It takes a CurrentWeather object in the initialiser
//this struct formats the way that the weather api data should be displayed on the screen
//it handles important conversion as well such converting the temperature from Fahrenheit to
//degrees Celsius
struct CurrentWeatherViewModel {
    let temperature: String
    let humidity: String
    let precipitationProbability: String
    let summary: String
    let icon: UIImage
    let pressure: String
    let doubleTemperature: Double
    let doubleHumidity: Double
    
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
        
        self.doubleTemperature = convertedTemperature
        
        self.doubleHumidity = model.humidity * 100
    }
}
