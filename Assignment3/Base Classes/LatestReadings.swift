//
//  LatestReadings.swift
//  Assignment3
//
//  Created by Mashaal & Laveeshka on 1/11/19.
//  Copyright © 2019 Monash. All rights reserved.
// Initialising a static class to access the latest reading from the sensors and also storing them in lists

import Foundation

class LatestReadings
{
    static var allHumidTempReadings = [HumidTempSonarData]()
    static var latestHumidTempReadings = HumidTempSonarData()
    static var allColourRfidReadings = [ColourRfidData]()
    static var latestColourRfidReadings = ColourRfidData()
}
