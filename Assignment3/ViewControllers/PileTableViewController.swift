//
//  PileTableViewController.swift
//  Assignment3
//
//  Created by Mashaal & Laveeshka on 5/11/19.
//  Copyright © 2019 Monash. All rights reserved.
// This UIViewController class is responsible for managing the table view cells for the 'Pile' screen

import UIKit

class PileTableViewController: UITableViewController, DatabaseListener {
    
    var index: Int!
    let SECTION_RECORDS = 0;
    let SECTION_PARTY = 0;
    let SECTION_COUNT = 1;
    let CELL_RECORD = "colourCell"
    var all: [ColourRfidData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        self.tableView.rowHeight = 150
    }
    
    
    weak var databaseController: DatabaseProtocol?
    var listenerType =  ListenerType.rfidColourRecords
    
    func onHumidTempSonarDataChange(change: DatabaseChange, htsRecords: [HumidTempSonarData]) {
        // Won't be called since this sensor data has no use in this screen
    }
    
    // This function is responsible for loading the data from the Firebase database when it comes to the Colour & RFID values
    func onColourRFIDChange(change: DatabaseChange, rfidColourRecords: [ColourRfidData]) {
        
        all = rfidColourRecords
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
        // Adding a listener
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
        // Removing a listener
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        // This function returns 1 to only show 1 table view
    }
    
    // This function returns the count of all the records in the Colour RFID sensors
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_RECORDS {
            
            return all.count
        } else {
            return 1
        }
        
    }
    
    
    // This function is responsible for displaying the appropriate data in its labels
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let colourRfidCell = tableView.dequeueReusableCell(withIdentifier: CELL_RECORD, for: indexPath) as! PileTableViewCell
        let colourRecord = all[indexPath.row]
        
        // Date needed additional formatting as it was stored as a time stamp value in the firebase database
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "hh:mm a"
        let timer = dateFormatter.string(from: colourRecord.timeStamp)
        
        var RFID = String(colourRecord.rfidInfo)
        let time = (timer)
        
        colourRfidCell.rfidLabel.text = String(RFID)
        colourRfidCell.timeLabel.text = String(time)
        
        
        let redFloat: Float = Float(colourRecord.red)/255.0
        let blueFloat: Float = Float(colourRecord.blue)/255.0
        let greenFloat: Float = Float(colourRecord.green)/255.0
        
        
        // This displays the colour of the clothing item
        colourRfidCell.colourImageView.image = colourRfidCell.colourImageView.image?.withRenderingMode(.alwaysTemplate)
        colourRfidCell.colourImageView.tintColor = UIColor(red: CGFloat(redFloat), green: CGFloat(greenFloat), blue: CGFloat (blueFloat), alpha: 1.0)
        
        return colourRfidCell
    }
    
    // This function is responsible for deleting a particular item in the table view cell, should the user choose to delete it
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_PARTY {
            databaseController?.deleteColourRFID(rfidColourRecord: all[indexPath.row]) }
        
    }
    
    
    
}
