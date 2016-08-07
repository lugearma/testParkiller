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
    
    var userLatitude: CLLocationDegrees?
    var userLongitude: CLLocationDegrees?
    
    var markerPoint: CLLocationCoordinate2D?
    
    var informationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.mapView = GMSMapView(frame: self.view.bounds)
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        
        self.userLatitude = self.locationManager?.location?.coordinate.latitude
        self.userLongitude = self.locationManager?.location?.coordinate.longitude
//        self.view.addSubview(mapView)
//        self.createView()
    }
    
    func createInformationView() {
        
        let viewFrame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 100.0)
        self.informationView = UIView(frame: viewFrame)
        self.informationView.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(informationView)
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
    
    func showActionSheet(title: String, message: String, textButton: String,action: (UIAlertAction) -> Void) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        let confirmButton = UIAlertAction(title: textButton, style: .Default, handler: action)
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
            
            self.userLatitude = self.locationManager?.location?.coordinate.latitude
            self.userLongitude = self.locationManager?.location?.coordinate.longitude
            
            self.camera = GMSCameraPosition.cameraWithLatitude(userLatitude!, longitude: userLongitude!, zoom: self.zoom)
            
            self.mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: self.camera!)
            
            self.mapView.delegate = self
            self.mapView.myLocationEnabled = true
            
            self.view = mapView
            
            self.locationManager?.startUpdatingLocation()
        } else {
//            self.showAlert("Error", message: "An error has occurred")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.userLatitude = locations.first?.coordinate.latitude
        self.userLongitude = locations.first?.coordinate.longitude
        print("Location: \(self.userLatitude!), \(self.userLongitude!)")
        
        // is marker in map?
        if self.markerState {
            let userPoint = CLLocationCoordinate2D(latitude: self.userLatitude!, longitude: self.userLongitude!)
            
            let distance = GMSGeometryDistance(userPoint, self.markerPoint!)
            
            print("Disance: \(distance) m")
        }
        
        self.camera = GMSCameraPosition.cameraWithLatitude(self.userLatitude!, longitude: self.userLongitude!, zoom: self.zoom)
    }
}

//MARK: Google Maps Delegate Methods

extension ViewController: GMSMapViewDelegate {
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        // Create marker
        if !self.markerState {
            self.showActionSheet("Confirm",message: "Do you want to put a marker here?", textButton: "Confirm",action: {
                action in
                self.createMarker(self.mapView, latitude: coordinate.latitude, longitude: coordinate.longitude)
                self.markerPoint = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                self.markerState = true
                
                self.createInformationView()
            })
        }
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        
        // Delete marker
        self.showActionSheet("Delete", message: "Do you want to delete the selected marker?", textButton: "Delete", action: {
            action in
            mapView.clear()
            self.markerState = false
            
            self.informationView.removeFromSuperview()
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







