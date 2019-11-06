//
//  WeatherViewController.swift
//  Assignment3
//
//  Created by MAC on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, DatabaseListener {
    
    
    @IBOutlet weak var indoorPressureLabel: UILabel!
    @IBOutlet weak var indoorHumidityLabel: UILabel!
    @IBOutlet weak var indoorTemperatureLabel: UILabel!
    @IBOutlet weak var outdoorWeatherIcon: UIImageView!
    @IBOutlet weak var dryingConclusionLabel: UILabel!

    @IBOutlet weak var refreshOutdoorWeather: UIButton!
    @IBOutlet weak var outdoorTemperatureLabel: UILabel!

    @IBOutlet weak var outdoorLocationName: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var outdoorHumidityLabel: UILabel!
   
    @IBOutlet weak var outdoorPressureLabel: UILabel!
    @IBOutlet weak var outdoorPrecipProbabilityLabel: UILabel!
    @IBOutlet weak var outdoorWeatherSummary: UILabel!
    
    let client = DarkSkyApiClient()
   
    var locManager = CLLocationManager()
    var lat: Double = -37.8770
    var long: Double = 145.0449
    
    var listenerType = ListenerType.htsRecords
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        //Core Location Manager asking for GPS location
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locManager.startUpdatingLocation()
        }

        //obtaining current date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let currentDate = formatter.string(from: date)
        dateLabel.text = currentDate
        
        refreshCurrentWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    func onHumidTempSonarDataChange(change: DatabaseChange, htsRecords: [HumidTempSonarData]) {
        //populate indoor labels with latest data from firebase
        var latestData = LatestReadings.latestHumidTempReadings
        
        if latestData != nil {
            self.indoorHumidityLabel.text = "\(latestData.humidity) %"
            self.indoorTemperatureLabel.text = "\(latestData.indoorTemperature) ºC"
        }
    }
    
    func onColourRFIDChange(change: DatabaseChange, rfidColourRecords: [ColourRfidData]) {
        //nothing to change
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        lat = userLocation.coordinate.latitude
        long = userLocation.coordinate.longitude
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
                self.outdoorLocationName.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func displayWeather(using viewModel: CurrentWeatherViewModel){

        outdoorTemperatureLabel.text = viewModel.temperature
        outdoorWeatherIcon.image = viewModel.icon
        outdoorHumidityLabel.text = viewModel.humidity
        outdoorPrecipProbabilityLabel.text = viewModel.precipitationProbability
        outdoorWeatherSummary.text = viewModel.summary
        outdoorPressureLabel.text = viewModel.pressure
        
    }
    
    @IBAction func refreshCurrentWeather() {
        
        
                client.getCurrentWeather(at: Coordinate(latitude: lat, longitude: long)) { [unowned self] currentWeather, error in
        
                    if let currentWeather = currentWeather {
                        print(currentWeather)
                        let viewModel = CurrentWeatherViewModel(model: currentWeather)
                        self.displayWeather(using: viewModel)
                    }
                }
        
    }
    
    
    


}
