//
//  AddSensorDataDelegate.swift
//  Assignment3
//
//  Created by Mashaal on 2/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import Foundation

protocol  AddSensorDataDelegate: AnyObject {
    func addHumidSensorData(newRecord: HumidTempSonarData) -> Bool
    func addColourSensorData(newRecord: ColourRfidData) -> Bool
}
