//
//  Weather.swift
//  Assignment3
//
//  Created by Laveeshka on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import Foundation

//Weather struct of type Codable with a currently property
//Currently is a property of type CurrentWeather
struct Weather: Codable {
    let currently: CurrentWeather
}
