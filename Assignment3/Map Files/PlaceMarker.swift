//
//  PlaceMarker.swift
//  Assignment3
//
//  Created by MAC on 4/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//


import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    // 1
    let place: GooglePlace
    
    // 2
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        icon = UIImage(imageLiteralResourceName: "laundrymarker40")
        //icon = UIImage(named: place.placeType+"_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}
