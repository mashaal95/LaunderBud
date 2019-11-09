//
//  BasketViewController.swift
//  Assignment3
//
//  Created by Mashaal & Laveeshka on 4/11/19.
//  Copyright © 2019 Monash. All rights reserved.
// This View Controller class is responsible for managing the basket screen


import UIKit
import MBCircularProgressBar
import Firebase
import FirebaseFirestore
import FirebaseAuth


class BasketViewController: UIViewController, DatabaseListener {
    
    
    var listenerType = ListenerType.all
    @IBOutlet weak var circularProgressBar: MBCircularProgressBarView!
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var darkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Adding a listener
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Removing a listener
        databaseController?.removeListener(listener: self)
    }
    
    
    // On changing of the HumidTempSonar data, this method animates the level of clothes in the basket
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
    
    // This function is responsible for the 'scoreboard' like distribution of the darks and lights
    func onColourRFIDChange(change: DatabaseChange, rfidColourRecords: [ColourRfidData]) {
        var darks = 0
        var lights = 0
        
        for reading in LatestReadings.allColourRfidReadings
        {
            if(UIColor(red:CGFloat(reading.red), green:CGFloat(reading.green), blue:CGFloat(reading.blue), alpha:1.0).isLight()!)
            {
                lights += 1
            }
            else
            {
                darks += 1
            }
        }
        
        
        
        lightLabel.text = String(lights)
        darkLabel.text = String(darks)
    }
    
    
    // This function deletes all the clothes inside the basket from the app and in the firebase database
    @IBAction func clearBasket(_ sender: Any) {
        
        for reading in LatestReadings.allColourRfidReadings
        {
            databaseController?.deleteColourRFID(rfidColourRecord: reading)
        }
        
        
    }
    
    
    
    
}

// Code referenced from https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
extension UIColor {
    
    // Check if the color is light or dark, as defined by the injected lightness threshold.
    // Some people report that 0.7 is best. I suggest to find out for yourself.
    // A nil value is returned if the lightness couldn't be determined.
    func isLight(threshold: Float = 0.9) -> Bool? {
        let originalCGColor = self.cgColor
        
        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness < threshold)
    }
}
