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



class FirebaseController: NSObject, DatabaseProtocol {
    
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var humidTempSonarRef: CollectionReference?
    var colourRFIDRef: CollectionReference?
    var humidTempSonarDataList: [HumidTempSonarData]
    var colourRfidList: [ColourRfidData]
    
    
    override init() {
        // To use Firebase in our application we first must run the FirebaseApp configure method
        FirebaseApp.configure()
        
        // We call auth and firestore to get access to these frameworks
        authController = Auth.auth()
        database = Firestore.firestore()
        
        //Create an array variable of type HumidTempSonarData
        humidTempSonarDataList = [HumidTempSonarData]()
        
        //Create an array variable of type ColourRfidData
        colourRfidList = [ColourRfidData]()
        
        
        
        super.init()
        
        // This will START THE PROCESS of signing in with an anonymous account
        // The closure will not execute until its received a message back which can be any time later
        
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            
            // Once we have authenticated we can attach our listeners to the firebase firestore
            self.setUpListeners()
        }
    }
    
    func setUpListeners() {
        // Setting up a listener for the HumidTempSonar collection
        humidTempSonarRef = database.collection("RaspberryPi").document("b8:27:eb:76:69:ef").collection("HumidTempSonar")
        humidTempSonarRef?.addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.parseRecordsSnapshot(snapshot: querySnapshot!)
        }
        
        // Setting up a listener for the ColourRFID collection
        colourRFIDRef = database.collection("RaspberryPi").document("b8:27:eb:76:69:ef").collection("ColourRFID")
        colourRFIDRef?.addSnapshotListener(includeMetadataChanges: false) { querySnapshot, error in
            guard querySnapshot != nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseColourRfid(snapshot: querySnapshot!)
            
        }
        
        
    }
    
    
    //This method deletes a given HumidTempSonarData record from firebase
    func deleteHumidTempSonarData(htsRecord: HumidTempSonarData) {
        humidTempSonarRef?.document(htsRecord.id).delete()
    }
    
    //This method deletes a given ColourRfidData record from firebase
    func deleteColourRFID(rfidColourRecord: ColourRfidData) {
        colourRFIDRef?.document(rfidColourRecord.id).delete()
    }
    
    //Add the given listener to the list of listeners.
    //Depending on the listener type we fetch and notify the listener with a change
    //notification with an array of either all ColourRfidData or all HumidTempSonarData.
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.htsRecords {
            listener.onHumidTempSonarDataChange(change: .update, htsRecords: humidTempSonarDataList)
        }
        
        if listener.listenerType == ListenerType.rfidColourRecords {
            listener.onColourRFIDChange(change: .update, rfidColourRecords: colourRfidList)
        }
        
        if listener.listenerType == ListenerType.all
        {
            listener.onColourRFIDChange(change: .update, rfidColourRecords: colourRfidList)
            listener.onHumidTempSonarDataChange(change: .update, htsRecords: humidTempSonarDataList)
        }
        
    }
    
    
    //running a loop and fetching each document from the HumidTempSonar collection
    //that has had a change. For each document, the the data is stored as a Dictionary
    //of Any with Strings as the keys. A new HumidTempSonarData record is created and
    //appended to HumidTempSonarData list for an add
    func parseRecordsSnapshot(snapshot: QuerySnapshot!) { snapshot.documentChanges.forEach { change in
        
        let documentRef = change.document.documentID
        
        if change.document.data()["Humidity"] as? Double == nil
        {
            return
        }
        
        if change.document.data()["Pressure"] as? Double == nil
        {
            return
        }
        
        if change.document.data()["SonarDistance"] as? Double == nil
        {
            return
        }
        
        let humidity = change.document.data()["Humidity"] as! Double
        let indoorTemperature = change.document.data()["IndoorTemperature"] as! Double
        let sonarDistance = change.document.data()["SonarDistance"] as! Double
        let timestamp = change.document.data()["Timestamper"] as! Timestamp
        let timestamper = timestamp.dateValue()
        let pressure = change.document.data()["Pressure"] as! Double
        
        let newRecord = HumidTempSonarData()
        newRecord.humidity = humidity
        newRecord.indoorTemperature = indoorTemperature
        newRecord.sonarDistance = sonarDistance
        newRecord.timeStamp = timestamper
        newRecord.pressure = pressure
        newRecord.id = documentRef
        
        humidTempSonarDataList.append(newRecord)
        LatestReadings.allHumidTempReadings.append(newRecord)
        
        
        
        //Taking the latest readings for the humidity and temperature, also for the level of clothes in the basket
        if LatestReadings.allHumidTempReadings.count > 0 {
            LatestReadings.latestHumidTempReadings = LatestReadings.allHumidTempReadings.last!
        }
        
        
        }
        //Calling database listeners and providing them with the most up to date humidTempSonarData list.
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.htsRecords || listener.listenerType == ListenerType.all {
                listener.onHumidTempSonarDataChange(change: .update, htsRecords: humidTempSonarDataList) }
        }
        
    }
    
    
    //running a loop and fetching each document from the ColourRFID collection
    //that has had a change. For each document, the the data is stored as a Dictionary
    //of Any with Strings as the keys. A new ColourRfidData record is created and
    //appended to colourRfidList list for an add
    //For an update, we get the index of the ColourRfidData matching
    //that document’s ID and update that element of our ColourRfidList array.
    //For a remove, we find the ColourRfidData in the array by ID then remove it.
    func parseColourRfid(snapshot: QuerySnapshot!) { snapshot.documentChanges.forEach { change in
        
        let docRef = change.document.documentID
        if change.document.data()["Blue"] as? Int == nil
        {
            return
        }
        
        if change.document.data()["RFIDInfo"] as? String == nil
        {
            return
        }
        
        
        if change.document.data()["TimeStamp"] as? Timestamp == nil
        {
            return
        }
        
        let blue = change.document.data()["Blue"] as! Int
        let green = change.document.data()["Green"] as! Int
        let rfidInfo = change.document.data()["RFIDInfo"] as! String
        let red = change.document.data()["Red"] as! Int
        let timeStamp = change.document.data()["TimeStamp"] as! Timestamp
        let timestamper = timeStamp.dateValue()
        
        if change.type == .added {
            
            let newRecord = ColourRfidData()
            newRecord.blue = blue
            newRecord.green = green
            newRecord.rfidInfo = rfidInfo
            newRecord.red = red
            newRecord.timeStamp = timestamper
            
            
            newRecord.id = docRef
            colourRfidList.append(newRecord)
            LatestReadings.allColourRfidReadings.append(newRecord)
            
        }
        
        if change.type == .modified {
            
            print("Updated ColourRFID: \(change.document.data())")
            
            if change.document.data()["Blue"] as? Int == nil
            {
                return
            }
            
            let index = getRecordIndexByIDColour(reference: docRef)!
            colourRfidList[index].blue = blue
            LatestReadings.allColourRfidReadings[index].blue = blue
            
            colourRfidList[index].green = green
            LatestReadings.allColourRfidReadings[index].green = green
            
            colourRfidList[index].red = red
            LatestReadings.allColourRfidReadings[index].red = red
            
            colourRfidList[index].rfidInfo = rfidInfo
            LatestReadings.allColourRfidReadings[index].rfidInfo = rfidInfo
            
            colourRfidList[index].timeStamp = timeStamp.dateValue()
            LatestReadings.allColourRfidReadings[index].timeStamp = timeStamp.dateValue()
            
            colourRfidList[index].id = docRef
            LatestReadings.allColourRfidReadings[index].id = docRef
        }
        
        if change.type == .removed {
            
            print("Removed colourRFID record: \(change.document.data())")
            if let index = getRecordIndexByIDColour(reference: docRef){
                colourRfidList.remove(at: index)
                LatestReadings.allColourRfidReadings.remove(at: index)
            }
        }
        
        //Taking the latest readings for the humidity and temperature, also for the level of clothes in the basket
        if LatestReadings.allColourRfidReadings.count > 0 {
            LatestReadings.latestColourRfidReadings = LatestReadings.allColourRfidReadings.last!
        }
        
        }
        //Calling database listeners and providing them with the most up to date ColourRfidData list.
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.rfidColourRecords || listener.listenerType == ListenerType.all {
                listener.onColourRFIDChange(change: .update, rfidColourRecords: colourRfidList) }
        }
    }
    
    //Remove the given listener from the list of listeners
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    //The getRecordIndexByID method takes in an ID and returns the index of the HumidTempSonarData in
    //the array. If it’s not present in the array, the method returns nil instead
    func getRecordIndexByID(reference: String) -> Int? {
        for humidRecord in humidTempSonarDataList {
            if(humidRecord.id == reference) {
                return humidTempSonarDataList.firstIndex(of: humidRecord)
            }
        }
        
        
        return nil
    }
    
    //The getRecordIndexByIDColour method takes in an ID and returns the index of the ColourRfidData in
    //the array. If it’s not present in the array, the method returns nil instead
    func getRecordIndexByIDColour(reference: String) -> Int? {
        for colourRecord in colourRfidList{
            if(colourRecord.id == reference)
            {
                return colourRfidList.firstIndex(of: colourRecord)
            }
        }
        return nil
    }
    
    //The getRecordByIDColour method takes an ID and returns the actual ColourRfidData object itself (if it exists)
    func getRecordByIDColour(reference: String) -> ColourRfidData?{
        for colourRecord in colourRfidList {
            if(colourRecord.id == reference) { return colourRecord
            }
            
        }
        
        return nil
    }
    
    
    //The getRecordByID method takes an ID and returns the actual HumidTempSonarData object itself (if it exists).
    func getRecordByID(reference: String) -> HumidTempSonarData? {
        for humidRecord in humidTempSonarDataList {
            if(humidRecord.id == reference) { return humidRecord
            }
            
        }
        
        return nil
    }
    
    
    
}

