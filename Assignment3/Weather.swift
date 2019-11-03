//
//  Weather.swift
//  Assignment3
//
//  Created by MAC on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import Foundation


struct Weather {
    let currently: CurrentWeather
}

extension Weather {
    init?(json: [String: AnyObject]) {
        guard let currentWeatherJson = json["currently"] as? [String: AnyObject], let currentWeather = CurrentWeather(json: currentWeatherJson)
            else {
                return nil
        }
        self.currently = currentWeather
    }
}
