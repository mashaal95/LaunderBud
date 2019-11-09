//
//  DarkSkyError.swift
//  Assignment3
//
//  Created by Laveeshka on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import Foundation

//this enum lists all the possible types of errors arising from communicating
//with the DarkSky Weather API
enum DarkSkyError: Error {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidUrl
}
