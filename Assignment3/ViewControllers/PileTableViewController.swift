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
        all = LatestReadings.allColourRfidReadings
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

    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//        // This function returns 1 to only show 1 table view
//    }
    
//     This function returns the count of all the records in the Colour RFID sensors and if there are none, the function displays a friendly message
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if all.count == 0 {
            self.tableView.setEmptyMessage("No clothes have been added yet, use the sensors to add clothes :)")
        }
        else {
            self.tableView.restore()
        }
        
        return all.count
    }
    
    
    
    
    // This function is responsible for displaying the appropriate data in its labels
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let colourRfidCell = tableView.dequeueReusableCell(withIdentifier: CELL_RECORD, for: indexPath) as! PileTableViewCell
        let colourRecord = all[indexPath.row]
        print (colourRecord)
        
        // Date needed additional formatting as it was stored as a time stamp value in the firebase database
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm a"
        let timer = dateFormatter.string(from: colourRecord.timeStamp)
        
        let RFID = String(colourRecord.rfidInfo)
        let time = (timer)
        
        colourRfidCell.rfidLabel.text = String(RFID)
        colourRfidCell.timeLabel.text = String(time)
        
        
        let redFloat: Float = Float(colourRecord.red)/255.0
        let blueFloat: Float = Float(colourRecord.blue)/255.0
        let greenFloat: Float = Float(colourRecord.green)/255.0
        
        
        // This displays the colour of the clothing item
        // the tint colour of the icon image was changed according to RGB values
        //code referenced from https://stackoverflow.com/questions/19274789/how-can-i-change-image-tintcolor-in-ios-and-watchkit
        
        colourRfidCell.colourImageView.image = colourRfidCell.colourImageView.image?.withRenderingMode(.alwaysTemplate)
        colourRfidCell.colourImageView.tintColor = UIColor(red: CGFloat(redFloat), green: CGFloat(greenFloat), blue: CGFloat (blueFloat), alpha: 1.0)
        
        return colourRfidCell
    }
    
    // This function is responsible for deleting a particular item in the table view cell, should the user choose to delete it
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        
        if editingStyle == .delete {
            databaseController?.deleteColourRFID(rfidColourRecord: all.remove(at: indexPath.row))
            LatestReadings.allColourRfidReadings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        
    }
    
    
    
}

// code referenced from https://stackoverflow.com/questions/15746745/handling-an-empty-uitableview-print-a-friendly-message
// This extension sets a message for when the Pile is empty
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.textColor = UIColor(red: CGFloat(224), green: CGFloat(247), blue: CGFloat(250), alpha: 1.0)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
