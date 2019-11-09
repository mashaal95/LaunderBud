//
//  Coordinate.swift
//  Assignment3
//
//  Created by Laveeshka on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//
import Foundation

//Create a Coordinate struct with latitude and longitude properties
struct Coordinate {
    let latitude: Double
    let longitude: Double
}

//This allows the static usage of Monash Caulfield coordinates in the map screen
//if user does not allow permission to use current location
extension Coordinate: CustomStringConvertible {
    
    var description: String {
        return "\(latitude),\(longitude)"
    }
    
    static var monashCaulfield: Coordinate{
        return Coordinate(latitude: -37.8770, longitude: 145.0449)
    }
}
