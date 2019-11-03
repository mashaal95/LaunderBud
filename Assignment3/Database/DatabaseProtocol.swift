//
//  DatabaseProtocol.swift
//
//  Created by Michael Wybrow on 22/3/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//
// Hello Laveeshka's git!
import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case rfidColourRecords
    case htsRecords
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onHumidTempSonarDataChange(change: DatabaseChange, htsRecords: [HumidTempSonarData])
    func onColourRFIDChange(change: DatabaseChange, rfidColourRecords: [ColourRfidData])
}

protocol DatabaseProtocol: AnyObject {
    //var defaultFavourite: Favourite {get}
    //func addFavourite(favouriteName: String) -> Favourite
    //func addRecordToFavourite(record: SensorData, favourite: Favourite) -> Bool
    func deleteHumidTempSonarData(htsRecord: HumidTempSonarData)
    func deleteColourRFID(rfidColourRecord: ColourRfidData)
    //func removeRecordFromFavourite(record: SensorData, favourite: Favourite)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
