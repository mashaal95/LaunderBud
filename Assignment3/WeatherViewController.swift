//
//  WeatherViewController.swift
//  Assignment3
//
//  Created by MAC on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var outdoorTemperatureLabel: UILabel!
    @IBOutlet weak var outdoorWeatherIcon: UIImageView!
    @IBOutlet weak var outdoorHumidityLabel: UILabel!
    @IBOutlet weak var outdoorPrecipProbabilityLabel: UILabel!
    @IBOutlet weak var outdoorWeatherSummary: UILabel!
    
    let client = DarkSkyApiClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.getCurrentWeather(at: Coordinate.monashCaulfield) { [unowned self] currentWeather, error in
            
            if let currentWeather = currentWeather {
                print(currentWeather)
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                self.displayWeather(using: viewModel)
            }
        }
    }
    
    func displayWeather(using viewModel: CurrentWeatherViewModel){

        outdoorTemperatureLabel.text = viewModel.temperature
        outdoorWeatherIcon.image = viewModel.icon
        outdoorHumidityLabel.text = viewModel.humidity
        outdoorPrecipProbabilityLabel.text = viewModel.precipitationProbability
        outdoorWeatherSummary.text = viewModel.summary
        
    }
}

