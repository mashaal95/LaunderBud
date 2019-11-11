//
//  DatabaseProtocol.swift
//
//  Created by Michael Wybrow on 22/3/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.

import Foundation

//this enum lists the possible types of change occurring to the database
//it includes add, remove and update
enum DatabaseChange {
    case add
    case remove
    case update
}


//this enum allows the listener to determine which changes to receive updates about,
//be it for htsRecords or rfidColourRecords or both
enum ListenerType {
    case rfidColourRecords
    case htsRecords
    case all
}

//The DatabaseListener protocol defines a delegate that will be used for receiving updates
//from the database. Any class which communicates with the database will implement the
//onHumidTempSonarDataChange method, onColourRFIDChange method and the type of listener
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onHumidTempSonarDataChange(change: DatabaseChange, htsRecords: [HumidTempSonarData])
    func onColourRFIDChange(change: DatabaseChange, rfidColourRecords: [ColourRfidData])
}

//The DatabaseProtocol outlines all the core functionalities that the Firestore cloud database must implement for LaunderBuddy.
protocol DatabaseProtocol: AnyObject {
    
    func deleteHumidTempSonarData(htsRecord: HumidTempSonarData)
    func deleteColourRFID(rfidColourRecord: ColourRfidData)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
}
