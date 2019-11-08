//
//  HumidTempSonarData.swift
//  Assignment3
//
//  Created by Mashaal on 1/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import Foundation

class HumidTempSonarData: Equatable {
    static func == (lhs: HumidTempSonarData, rhs: HumidTempSonarData) -> Bool {
        return true
    }
    
    
    var id: String = " "
    var humidity: Double = 41.6
    var indoorTemperature: Double = 255
    var sonarDistance: Double  = 255
    var timeStamp: Date = Date()
    var pressure: Double = 101.3
}
