//
//  PlaceMarker.swift
//  Assignment3
//
//  Created by Laveeshka on 4/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//


import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    
    //adding a property of type GooglePlace
    let place: GooglePlace
    
    //Initialise a place marker with a position, icon image, appearance animation and an anchor for the position for the marker
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        icon = UIImage(imageLiteralResourceName: "laundrymarker40")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}
