//
//  FirstPageTestViewController.swift
//  Assignment3
//
//  Created by Mashaal on 2/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import UIKit

class FirstPageTestViewController: UIViewController, DatabaseListener {
    
    var listenerType =  ListenerType.htsRecords
    weak var databaseController: DatabaseProtocol?
    
    
    @IBOutlet weak var humidLabel: UILabel!
    
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var sonarLabel: UILabel!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
                databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    func onHumidTempSonarDataChange(change: DatabaseChange, htsRecords: [HumidTempSonarData]) {
        humidLabel.text = String(LatestReadings.latestHumidTempReadings.humidity)
        tempLabel.text = String(LatestReadings.latestHumidTempReadings.indoorTemperature)
        sonarLabel.text = String(LatestReadings.latestHumidTempReadings.sonarDistance)
        
    }
    
    func onColourRFIDChange(change: DatabaseChange, rfidColourRecords: [ColourRfidData]) {
        
    }
}
