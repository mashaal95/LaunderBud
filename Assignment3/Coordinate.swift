//
//  Coordinate.swift
//  Assignment3
//
//  Created by MAC on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//
import Foundation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}


extension Coordinate: CustomStringConvertible {
    
    var description: String {
        return "\(latitude),\(longitude)"
    }
    
    static var monashCaulfield: Coordinate{
        return Coordinate(latitude: -37.8770, longitude: 145.0449)
    }
}
