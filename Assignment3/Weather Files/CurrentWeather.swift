//
//  CurrentWeather.swift
//  Assignment3
//
//  Created by Laveeshka on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import Foundation
import UIKit

//CurrentWeather struct of type Codable.
//It has temperature, humidity, precipProbability, summary, icon and pressure as properties
struct CurrentWeather: Codable {
    let temperature: Double
    let humidity: Double
    let precipProbability: Double
    let summary: String
    let icon: String
    let pressure: Double
}

//defines a UIImage variable. The icon which name matches with the icon string value is returned
extension CurrentWeather{
    var iconImage: UIImage {
        switch icon {
        case "clear-day": return #imageLiteral(resourceName: "clear-day")
        case "clear-night": return #imageLiteral(resourceName: "degree")
        case "rain": return #imageLiteral(resourceName: "rain")
        case "snow": return #imageLiteral(resourceName: "snow")
        case "wind": return #imageLiteral(resourceName: "wind")
        case "fog": return #imageLiteral(resourceName: "fog")
        case "sleet": return #imageLiteral(resourceName: "sleet")
        case "cloudy": return #imageLiteral(resourceName: "cloudy")
        case "partly-cloudy-day": return #imageLiteral(resourceName: "partly-cloudy")
        case "partly-cloudy-night": return #imageLiteral(resourceName: "cloudy-night")
        default: return #imageLiteral(resourceName: "default")
        }
    }
}
