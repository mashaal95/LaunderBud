//
//  GooglePlace.swift
//  Assignment3
//
//  Created by Laveeshka on 4/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//
// this is a model class for coin laundry results returned from Google
// code referenced from https://www.raywenderlich.com/197-google-maps-ios-sdk-tutorial-getting-started

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

class GooglePlace {
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let placeType: String
    var photoReference: String?
    var photo: UIImage?
    
    init(dictionary: [String: Any], acceptedTypes: [String])
    {
        let json = JSON(dictionary)
        name = json["name"].stringValue
        address = json["vicinity"].stringValue
        
        let lat = json["geometry"]["location"]["lat"].doubleValue as CLLocationDegrees
        let lng = json["geometry"]["location"]["lng"].doubleValue as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        photoReference = json["photos"][0]["photo_reference"].string
        
        var foundType = "coin_laundry"
        let possibleTypes = acceptedTypes.count > 0 ? acceptedTypes : ["laundry", "coinlaundry"]
        
        if let types = json["types"].arrayObject as? [String] {
            for type in types {
                if possibleTypes.contains(type) {
                    foundType = type
                    break
                }
            }
        }
        placeType = foundType
    }
}

