//
//  WeatherViewController.swift
//  Assignment3
//
//  Created by Laveeshka on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, DatabaseListener {
    
    //all the label outlets are defined here
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
    
    //creating a DarkSkyApiClient variable to call its methods
    let client = DarkSkyApiClient()
    
    var locManager = CLLocationManager()
    var lat: Double = -37.8770
    var long: Double = 145.0449
    
    var listenerType = ListenerType.htsRecords
    weak var databaseController: DatabaseProtocol?
    
    var outdoorTempComparison: Double = 25
    var outdoorHumidityComparison: Double = 48
    var latestData = HumidTempSonarData()
    
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
        // referenced from https://stackoverflow.com/questions/39513258/get-current-date-in-swift-3
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let currentDate = formatter.string(from: date)
        dateLabel.text = currentDate
        
        //this method obtains the latest outdoor weather and displays
        //the data appropriately on the screen
        refreshCurrentWeather()
        
        
    }
    
    //start listening for database changes whenever this view is about to be added to the view hierarchy
    override func viewWillAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
    }
    
    //stop listening for database changes whenever this view is about to be removed from the view hierarchy
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    //this method populates the indoor weather labels with the latest HumidTempSonarData record from Firebase
    func onHumidTempSonarDataChange(change: DatabaseChange, htsRecords: [HumidTempSonarData]) {
        //populate indoor labels with latest data from firebase
        latestData = LatestReadings.latestHumidTempReadings
        
        if latestData != nil {
            self.indoorHumidityLabel.text = "\(latestData.humidity) %"
            
            let indoorTempString = String(format: "%.1f", latestData.indoorTemperature)
            self.indoorTemperatureLabel.text = "\(indoorTempString) ºC"
            
            let indoorPressureString = String(format: "%.1f", latestData.pressure)
            self.indoorPressureLabel.text = "\(indoorPressureString) kPa"
            
            
        }
    }
    
    //this method does not perform anything as this screen does not deal with ColourRfidData records
    func onColourRFIDChange(change: DatabaseChange, rfidColourRecords: [ColourRfidData]) {
        //nothing to change
    }
    
    //Whenever the current location is updated, the new latitude and longitude are stored to the lat and long variables.
    //The current location is reverse geocoder to obtain a textual representation which is displayed on the screen
    // referenced from https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
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
    
    //if an error occurs while updating location, this method handles the error and prints it
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    //this method fills the outdoor weather labels with CurrentWeatherViewModel values
    func displayWeather(using viewModel: CurrentWeatherViewModel){
        
        outdoorTemperatureLabel.text = viewModel.temperature
        outdoorWeatherIcon.image = viewModel.icon
        outdoorHumidityLabel.text = viewModel.humidity
        outdoorPrecipProbabilityLabel.text = viewModel.precipitationProbability
        outdoorWeatherSummary.text = viewModel.summary
        outdoorPressureLabel.text = viewModel.pressure
        
        outdoorTempComparison = viewModel.doubleTemperature
        print("outdoorTempComparison \(outdoorTempComparison)")
        outdoorHumidityComparison = viewModel.doubleHumidity
        print("outdoorHumidityComparison \(outdoorHumidityComparison)")
        
    }
    
    //Whenever the user clicks on the refresh button at the top of the screen, the outdoor weather is updated.
    //A call is made to the DarkSky Weather API using the dark sky client object. This object uses the getCurrentWeather method at the current location and updates the outdoor weather labels
    //A comparison is performed to advise the user whether to dry washed clothes indoors or outdoors
    @IBAction func refreshCurrentWeather() {
        
        
        client.getCurrentWeather(at: Coordinate(latitude: lat, longitude: long)) { [unowned self] currentWeather, error in
            
            if let currentWeather = currentWeather {
                print(currentWeather)
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                self.displayWeather(using: viewModel)
                
                if LatestReadings.latestHumidTempReadings != nil {
                    
                    if self.outdoorWeatherIcon.image == #imageLiteral(resourceName: "rain") {
                        self.dryingConclusionLabel.text = "Raining outside. Dry indoors"
                    }
                    else {
                    
                    if self.outdoorTempComparison > LatestReadings.latestHumidTempReadings.indoorTemperature && self.outdoorHumidityComparison < LatestReadings.latestHumidTempReadings.humidity {
                        print("Outdoor temperature is \(self.outdoorTempComparison)")
                        print("Indoor temperature is \(LatestReadings.latestHumidTempReadings.indoorTemperature)")
                        print("Outdoor humidity is \(self.outdoorHumidityComparison)")
                        print("Indoor humidity is \(LatestReadings.latestHumidTempReadings.humidity)")
                        self.dryingConclusionLabel.text = "Outdoor drying strongly advised"
                    }
                    
                    if self.outdoorTempComparison > LatestReadings.latestHumidTempReadings.indoorTemperature && self.outdoorHumidityComparison > LatestReadings.latestHumidTempReadings.humidity {
                        print("Outdoor temperature is \(self.outdoorTempComparison)")
                        print("Indoor temperature is \(LatestReadings.latestHumidTempReadings.indoorTemperature)")
                        print("Outdoor humidity is \(self.outdoorHumidityComparison)")
                        print("Indoor humidity is \(LatestReadings.latestHumidTempReadings.humidity)")
                        self.dryingConclusionLabel.text = "Indoor drying advised"
                    }
                    
                    if self.outdoorTempComparison < LatestReadings.latestHumidTempReadings.indoorTemperature && self.outdoorHumidityComparison < LatestReadings.latestHumidTempReadings.humidity {
                        print("Outdoor temperature is \(self.outdoorTempComparison)")
                        print("Indoor temperature is \(LatestReadings.latestHumidTempReadings.indoorTemperature)")
                        print("Outdoor humidity is \(self.outdoorHumidityComparison)")
                        print("Indoor humidity is \(LatestReadings.latestHumidTempReadings.humidity)")
                        self.dryingConclusionLabel.text = "Outdoor drying advised"
                    }
                    
                    if self.outdoorTempComparison < LatestReadings.latestHumidTempReadings.indoorTemperature && self.outdoorHumidityComparison > LatestReadings.latestHumidTempReadings.humidity {
                        print("Outdoor temperature is \(self.outdoorTempComparison)")
                        print("Indoor temperature is \(LatestReadings.latestHumidTempReadings.indoorTemperature)")
                        print("Outdoor humidity is \(self.outdoorHumidityComparison)")
                        print("Indoor humidity is \(LatestReadings.latestHumidTempReadings.humidity)")
                        self.dryingConclusionLabel.text = "Indoor drying strongly advised"
                    }
                }
                }
            }
        }
        
    }
    
    
    
    
    
}
