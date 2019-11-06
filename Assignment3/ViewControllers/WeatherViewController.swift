//
//  WeatherViewController.swift
//  Assignment3
//
//  Created by MAC on 3/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var outdoorLocationName: UILabel!
    @IBOutlet weak var refreshOutdoorWeather: UIButton!
    @IBOutlet weak var outdoorTemperatureLabel: UILabel!
    @IBOutlet weak var outdoorWeatherIcon: UIImageView!
    @IBOutlet weak var outdoorHumidityLabel: UILabel!
    @IBOutlet weak var outdoorPrecipProbabilityLabel: UILabel!
    @IBOutlet weak var outdoorWeatherSummary: UILabel!
    
    let client = DarkSkyApiClient()
   
    var locManager = CLLocationManager()
    var lat: Double = -37.8770
    var long: Double = 145.0449
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Core Location Manager asking for GPS location
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locManager.startUpdatingLocation()
        }

        
        refreshCurrentWeather()
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
