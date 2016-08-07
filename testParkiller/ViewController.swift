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
    var mapView: GMSMapView!
    let zoom: Float = 15.0
    var markerState = false
    
    var userLat: CLLocationDegrees?
    var userLon: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        
        self.userLat = self.locationManager?.location?.coordinate.latitude
        self.userLon = self.locationManager?.location?.coordinate.longitude

    }
    
    func createSearchBar() -> UIView{
        
        let frame = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 64.0)
        
        let searchBar = UISearchBar(frame: frame)
        searchBar.delegate = self
        searchBar.placeholder = "Search place"
//        searchBar.becomeFirstResponder()
        return searchBar
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(title: String, message: String, text: String,action: (UIAlertAction) -> Void) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        let confirmButton = UIAlertAction(title: text, style: .Default, handler: action)
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(confirmButton)
        actionSheet.addAction(cancelButton)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func createMarker(map: GMSMapView, latitude lat: CLLocationDegrees, longitude lon: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.map = map
    }
}

//MARK: Location Manager Delegate Methods

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            
            self.userLat = self.locationManager?.location?.coordinate.latitude
            self.userLon = self.locationManager?.location?.coordinate.longitude
            
            self.camera = GMSCameraPosition.cameraWithLatitude(userLat!, longitude: userLon!, zoom: self.zoom)
            
            self.mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: self.camera!)
            
            self.mapView.delegate = self
            self.mapView.myLocationEnabled = true
            
            self.view = mapView
            
            self.locationManager?.startUpdatingLocation()
        } else {
            self.showAlert("Error", message: "An error has occurred")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLat = locations.first?.coordinate.latitude
        self.userLon = locations.first?.coordinate.longitude
        print("Location: \(self.userLat!), \(self.userLon!)")
        self.camera = GMSCameraPosition.cameraWithLatitude(self.userLat!, longitude: self.userLon!, zoom: self.zoom)
    }
}

//MARK: Google Maps Delegate Methods

extension ViewController: GMSMapViewDelegate {
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        if !self.markerState {
            self.showActionSheet("Confirm",message: "Do you want to put a marker here?", text: "Confirm",action: {
                action in
                self.createMarker(self.mapView, latitude: coordinate.latitude, longitude: coordinate.longitude)
                self.markerState = true
            })
        } else {
            print("Esta puesto")
        }
        
        let startPoint = CLLocationCoordinate2D(latitude: self.userLat!, longitude: self.userLon!)
        
        let finalPoint = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let distance = GMSGeometryDistance(startPoint, finalPoint)
        
        print("Distance: \(distance) m")
        
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        
        self.showActionSheet("Delete", message: "Do you want delete the selected marker?", text: "Delete", action: {
            action in
            mapView.clear()
            self.markerState = false
        })
        
        return true
    }
}

//MARK: Search Bar Delegate Methods

extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        print("editando texto")
        return true
    }
}







