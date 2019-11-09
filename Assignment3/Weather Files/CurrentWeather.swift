//
//  CurrentWeather.swift
//  Assignment3
//
//  Created by MAC on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather: Codable {
    let temperature: Double
    let humidity: Double
    let precipProbability: Double
    let summary: String
    let icon: String
    let pressure: Double
}

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
