//
//  ColourRfidData.swift
//  Assignment3
//
//  Created by Mashaal & Laveeshka on 1/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//
// Model class for initialising Colour and RFID Sensor Data

import Foundation
class ColourRfidData: Equatable {
    static func == (lhs: ColourRfidData, rhs: ColourRfidData) -> Bool {
        return true
    }
    
    
    var id: String = " "
    var blue: Int = 255
    var green: Int = 255
    var rfidInfo: String  = "C"
    var red: Int  = 255
    var timeStamp: Date = Date()
    
}
