//
//  BasketViewController.swift
//  Assignment3
//
//  Created by Mashaal on 4/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class BasketViewController: UIViewController, DatabaseListener {
   
    var listenerType = ListenerType.all
    weak var databaseController: DatabaseProtocol?
    @IBOutlet weak var circularProgressBar: MBCircularProgressBarView!
    
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var darkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        redLabel.text = String(LatestReadings.latestColourRfidReadings.red)
//        blueLabel.text = String(LatestReadings.latestColourRfidReadings.blue)
//        greenLabel.text = String(LatestReadings.latestColourRfidReadings.green)
//        rfidLabel.text = String(LatestReadings.latestColourRfidReadings.rfidInfo)
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        databaseController?.addListener(listener: self)
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    func onHumidTempSonarDataChange(change: DatabaseChange, htsRecords: [HumidTempSonarData]) {
       
        var basketLevel = LatestReadings.latestHumidTempReadings.sonarDistance
        
        
        switch basketLevel {
        case _ where basketLevel >= 6.07:
            self.circularProgressBar.value = 0
        case _ where basketLevel <= 6.06:
            var percent = (basketLevel*100)/6.07
            UIView.animate(withDuration: 1,animations: {self.circularProgressBar.value = CGFloat(Int(percent))})
        default:
            self.circularProgressBar.value = 0
        }
    }
    
    func onColourRFIDChange(change: DatabaseChange, rfidColourRecords: [ColourRfidData]) {
        
        var allColourReadings = LatestReadings.allColourRfidReadings
        var lightClothes = 0
        var darkClothes = 0
        for readings in allColourReadings
        {
            if(UIColor(red: CGFloat(readings.red), green: CGFloat(readings.green), blue:CGFloat (readings.blue), alpha: 1.0)).isLight
            {
                darkClothes += 1
            }
            else
            {
                lightClothes += 1
            }
        }
        
        lightLabel.text = String(lightClothes)
        darkLabel.text = String(darkClothes)
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

extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}
