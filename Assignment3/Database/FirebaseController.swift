//
//  FirebaseController .swift
//
//  Created by Mashaal Ahmed & Laveeshka Mahadea on 1/11/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

//This is Mashaal's Git!


class FirebaseController: NSObject, DatabaseProtocol {
    
    //let DEFAULT_FAVOURITE_NAME = "Default Favorite"
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var humidTempSonarRef: CollectionReference?
    var colourRFIDRef: CollectionReference?
    //var favouritesRef: CollectionReference?
    var humidTempSonarDataList: [HumidTempSonarData]
    var colourRfidList: [ColourRfidData]
    //var defaultFavourite: Favourite
    
    
    
    
    
    override init() {
        // To use Firebase in our application we first must run the FirebaseApp configure method
        FirebaseApp.configure()
        // We call auth and firestore to get access to these frameworks
        authController = Auth.auth()
        database = Firestore.firestore()
        humidTempSonarDataList = [HumidTempSonarData]()
        colourRfidList = [ColourRfidData]()
        
        //defaultFavourite = Favourite()
        
        super.init()
        
        // This will START THE PROCESS of signing in with an anonymous account
        // The closure will not execute until its recieved a message back which can be any time later
        
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            
            // Once we have authenticated we can attach our listeners to the firebase firestore
            self.setUpListeners()
        }
    }
    
    func setUpListeners() {
        // Setting up listeners for the HumidTempSonar sensors
        humidTempSonarRef = database.collection("RaspberryPi").document("b8:27:eb:76:69:ef").collection("HumidTempSonar")
        humidTempSonarRef?.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            print("something")
            self.parseRecordsSnapshot(snapshot: querySnapshot!)
        }
        
        // Setting up listeners for the ColourTempRFID Sensors
        colourRFIDRef = database.collection("RaspberryPi").document("b8:27:eb:76:69:ef").collection("ColourRFID")
        colourRFIDRef?.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseColourRfid(snapshot: querySnapshot!)
            
        }
        
    }
    
    
    func deleteHumidTempSonarData(htsRecord: HumidTempSonarData) {
        humidTempSonarRef?.document(htsRecord.id).delete()
    }
    
    func deleteColourRFID(rfidColourRecord: ColourRfidData) {
        colourRFIDRef?.document(rfidColourRecord.id).delete()
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.htsRecords {
            listener.onHumidTempSonarDataChange(change: .update, htsRecords: humidTempSonarDataList)
        }
        
        if listener.listenerType == ListenerType.rfidColourRecords {
            listener.onColourRFIDChange(change: .update, rfidColourRecords: colourRfidList)
        }
        
    }
    
    
    func parseRecordsSnapshot(snapshot: QuerySnapshot!) { snapshot.documentChanges.forEach { change in
        
        let documentRef = change.document.documentID
        
        print("documentRef \(documentRef)")
        
        if change.document.data()["Humidity"] as? Double == nil
        {
            return
        }
        
        let humidity = change.document.data()["Humidity"] as! Double
        let indoorTemperature = change.document.data()["IndoorTemperature"] as! Double
        let sonarDistance = change.document.data()["SonarDistance"] as! Double
        let timestamp = change.document.data()["Timestamper"] as! Timestamp
        let timestamper = timestamp.dateValue()
        
        
        
        print("New Record: \(change.document.data())")
        let newRecord = HumidTempSonarData()
        newRecord.humidity = humidity
        newRecord.indoorTemperature = indoorTemperature
        newRecord.sonarDistance = sonarDistance
        newRecord.timeStamp = timestamper
        newRecord.id = documentRef
        humidTempSonarDataList.append(newRecord)
        LatestReadings.allHumidTempReadings.append(newRecord)
        //PerpetualReadings.allReadings.append(newRecord)
        
        
        //Taking the latest readings for the humidity and temperature, also for the level of clothes in the basket
        if LatestReadings.allHumidTempReadings.count > 0 {
            LatestReadings.latestHumidTempReadings = LatestReadings.allHumidTempReadings.last!
        }
        
        
        }
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.htsRecords{
                listener.onHumidTempSonarDataChange(change: .update, htsRecords: humidTempSonarDataList) }
        }
        
    }
    

    
    func parseColourRfid(snapshot: QuerySnapshot!) { snapshot.documentChanges.forEach { change in
        
        let docRef = change.document.documentID
        print("docRef \(docRef)")
        
        if change.document.data()["Blue"] as? Int == nil
        {
            return
        }
        
        if change.document.data()["RFIDInfo"] as? String == nil
        {
            return
        }
        
        
        
        let blue = change.document.data()["Blue"] as! Int
        let green = change.document.data()["Green"] as! Int
        let rfidInfo = change.document.data()["RFIDInfo"] as! String
        let red = change.document.data()["Red"] as! Int
        let timeStamp = change.document.data()["TimeStamp"] as! Timestamp
        let timestamper = timeStamp.dateValue()
        
        print("New Record: \(change.document.data())")
        let newRecord = ColourRfidData()
        newRecord.blue = blue
        newRecord.green = green
        newRecord.rfidInfo = rfidInfo
        newRecord.red = red
        newRecord.timeStamp = timestamper
        
        newRecord.id = docRef
        colourRfidList.append(newRecord)
        LatestReadings.allColourRfidReadings.append(newRecord)
        //        PerpetualReadings.allReadings.append(newRecord)
        
        
        //Taking the latest readings for the humidity and temperature, also for the level of clothes in the basket
        if LatestReadings.allColourRfidReadings.count > 0 {
            LatestReadings.latestColourRfidReadings = LatestReadings.allColourRfidReadings.last!
        }
        
        }
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.rfidColourRecords{
                listener.onColourRFIDChange(change: .update, rfidColourRecords: colourRfidList) }
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    func getRecordIndexByID(reference: String) -> Int? {
        for humidRecord in humidTempSonarDataList {
            if(humidRecord.id == reference) {
                return humidTempSonarDataList.firstIndex(of: humidRecord)
            }
        }
        
        
        return nil
    }
    
    
    func getRecordIndexByIDColour(reference: String) -> Int? {
        for colourRecord in colourRfidList{
            if(colourRecord.id == reference)
            {
                return colourRfidList.firstIndex(of: colourRecord)
            }
        }
        return nil
    }
    
    func getRecordByIDColour(reference: String) -> ColourRfidData?{
        for colourRecord in colourRfidList {
                  if(colourRecord.id == reference) { return colourRecord
                  }
                  
              }
              
              return nil
    }
         
    
    
    func getRecordByID(reference: String) -> HumidTempSonarData? {
        for humidRecord in humidTempSonarDataList {
            if(humidRecord.id == reference) { return humidRecord
            }
            
        }
        
        return nil
    }
    
    
    
}
