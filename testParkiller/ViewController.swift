//
//  ViewController.swift
//  testParkiller
//
//  Created by Luis Arias on 05/08/16.
//  Copyright © 2016 Luis Arias. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    var locationManager : CLLocationManager?
    var camera: GMSCameraPosition?
    let zoom: Float = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.requestAlwaysAuthorization()
    }
    
    override func loadView() {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        let userLat = self.locationManager?.location?.coordinate.latitude
        let userLon = self.locationManager?.location?.coordinate.longitude
        
        self.camera = GMSCameraPosition.cameraWithLatitude(userLat!, longitude: userLon!, zoom: self.zoom)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: self.camera!)
        
        mapView.myLocationEnabled = true
        self.view = mapView
        
        //createMarker(mapView, latitude: userLat!, longitude: userLon!)
    }
    
    func createMarker(map: GMSMapView, latitude lat: CLLocationDegrees, longitude lon: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.title = "Sidney"
        marker.snippet = "Australia"
        marker.map = map
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            self.locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations.first?.coordinate.latitude
        let lon = locations.first?.coordinate.longitude
        print("Location: \(lat), \(lon)")
        self.camera = GMSCameraPosition.cameraWithLatitude(lat!, longitude: lon!, zoom: self.zoom)
    }
}







