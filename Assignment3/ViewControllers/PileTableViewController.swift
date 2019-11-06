//
//  PileTableViewController.swift
//  Assignment3
//
//  Created by Mashaal on 5/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import UIKit

class PileTableViewController: UITableViewController, DatabaseListener {
    
    var index: Int!
    let SECTION_RECORDS = 0;
    let SECTION_COUNT = 1;
    let CELL_RECORD = "colourCell"
    var all: [ColourRfidData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        
    }
    
    
    weak var databaseController: DatabaseProtocol?
    var listenerType =  ListenerType.rfidColourRecords
    
    func onHumidTempSonarDataChange(change: DatabaseChange, htsRecords: [HumidTempSonarData]) {
        
    }
    
    func onColourRFIDChange(change: DatabaseChange, rfidColourRecords: [ColourRfidData]) {
        
        all = rfidColourRecords
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_RECORDS {
            
            return all.count
        } else {
            return 1
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let colourRfidCell = tableView.dequeueReusableCell(withIdentifier: CELL_RECORD, for: indexPath) as! PileTableViewCell
        let colourRecord = all[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "hh:mm a"
        let timer = dateFormatter.string(from: colourRecord.timeStamp)
        
        var RFID = String(colourRecord.rfidInfo)
        let time = (timer)
        
        colourRfidCell.rfidLabel.text = String(RFID)
        colourRfidCell.timeLabel.text = String(time)
        
        
        
        return colourRfidCell
    }
    
    
    
}
