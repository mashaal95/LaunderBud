//
//  MapViewController.swift
//  Assignment3
//
//  Created by Laveeshka on 4/11/19.
//  Copyright © 2019 Monash. All rights reserved.
//  The Map Screen shows all the nearby coin laundries within a 5km radius relative to the user current location
//code referenced from https://www.raywenderlich.com/197-google-maps-ios-sdk-tutorial-getting-started

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapCenterPinImage: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var currentAddressLabel: UILabel!
    
    
    private let locationManager = CLLocationManager()
    
    // GoogleDataProvider() object to make calls to the Google Places Web API
    private let dataProvider = GoogleDataProvider()
    // setting a search radius of 5km from the user's current location to locate coin laundries
    private let searchRadius: Double = 5000
    var searchedTypes = ["laundry", "coinlaundry"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //request access to the user's location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        
        
    }
    
    // this method implements reverse geocoding of the user's current location and any location on the map that the user taps on
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        // GMSGeocoder object to turn coordinates into a street address
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.currentAddressLabel.unlock()
            
            self.currentAddressLabel.text = lines.joined(separator: "\n")
            
            let labelHeight = self.currentAddressLabel.intrinsicContentSize.height
            self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                                bottom: labelHeight, right: 0)
            
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // this method first clears the map of all markers, then queries Google for nearby coin laundries within 5km from the user's location, filtered to the user's selected types
    // for each result, a PlaceMarker is created and added to the map
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        
        mapView.clear()
        
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
            places.forEach {
                
                let marker = PlaceMarker(place: $0)
                
                marker.map = self.mapView
            }
        }
    }
    
    
    
}






//MapViewController extension conforming to CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    // this method is called when the user allows or denies location permission
    // if permission is granted, the location manager is requested to update the user's location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        //this draws a blue dot over the user's current location
        mapView.isMyLocationEnabled = true
        //this adds a button that when pressed, centers the maps on the user's current location
        mapView.settings.myLocationButton = true
        
        

    }
    
    
    
    // this method is called the location manager recognises a location change
    // the map centers on the new location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        
        
        fetchNearbyPlaces(coordinate: location.coordinate)
        
        //this draws a blue dot over the user's current location
        mapView.isMyLocationEnabled = true
        //this adds a button that when pressed, centers the maps on the user's current location
        mapView.settings.myLocationButton = true
        
        
    }
    
}

// MapViewController conforms to the GMSMapViewDelegate protocol
extension MapViewController: GMSMapViewDelegate {
    
    //the currentAddressLabel is given a loading animation whenever the map is moving
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        currentAddressLabel.lock()
    }
    
    //whenever the maps stops moving, the reverseGeocodeCoordinate method is called to reverse geocode the new position
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
        
    }
    
    // this method is called each time that the user taps on a coin laundry marker on the map
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        
        // the tapped laundry marker is cast to a PlaceMarker
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }
        
        // a MarkerInfoView is created from the nib file
        // the MarkerInfoView class is a UIView subclass found under Map Files
        guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
            return nil
        }
        
        // the name of that place marker is assigned to the nameLabel of the MarkerInfoView
        infoView.nameLabel.text = placeMarker.place.name
        
        // if a photo exists for the place, add the photo to the MarkerInfoView
        // otherwise, add a default coin laundry icon as the generic photo
        if let photo = placeMarker.place.photo {
            infoView.placePhoto.image = photo
        } else {
            infoView.placePhoto.image = UIImage(named: "Coin Laundry Icon")
        }
        
        return infoView
    }
    
    // this makes sure that the location marker does not cover the location callout
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapCenterPinImage.fadeOut(0.25)
        return false
    }
    
    // the map centers on the user's location when the user taps on the Locate button
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
    
}

