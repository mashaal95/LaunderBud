//
//  SecondPageTestViewController.swift
//  Assignment3
//
//  Created by Mashaal on 2/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import UIKit

class SecondPageTestViewController: UIViewController, DatabaseListener {
    var listenerType =  ListenerType.rfidColourRecords
    weak var databaseController: DatabaseProtocol?
    
  
    @IBOutlet weak var redLabel: UILabel!
    

    @IBOutlet weak var greenLabel: UILabel!
    
    
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var rfidLabel: UILabel!
    func onHumidTempSonarDataChange(change: DatabaseChange, htsRecords: [HumidTempSonarData]) {
        
    }
    
    func onColourRFIDChange(change: DatabaseChange, rfidColourRecords: [ColourRfidData]) {
        
        redLabel.text = String(LatestReadings.latestColourRfidReadings.red)
        blueLabel.text = String(LatestReadings.latestColourRfidReadings.blue)
        greenLabel.text = String(LatestReadings.latestColourRfidReadings.green)
        rfidLabel.text = String(LatestReadings.latestColourRfidReadings.rfidInfo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
