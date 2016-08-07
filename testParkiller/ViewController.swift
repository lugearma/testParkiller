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
    var distanceLabel: UILabel?
    var messageLabel: UILabel!
    
    let duration = 0.4
    let delay = 0.0
    let options = UIViewAnimationOptions.CurveEaseInOut
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        
        self.userLatitude = self.locationManager?.location?.coordinate.latitude
        self.userLongitude = self.locationManager?.location?.coordinate.longitude
    }
    
    func createInformationView() {
        
        let viewFrame = CGRect(x: 0.0, y: self.view.frame.height, width: self.view.frame.width, height: 100.0)
        
        self.informationView = UIView(frame: viewFrame)
        self.informationView.backgroundColor = UIColor.redColor()
        
        self.distanceLabel = UILabel(frame: CGRect(x: 0.0, y: 10.0, width: self.view.frame.width, height: 21))
        self.messageLabel = UILabel(frame: CGRect(x: 0.0, y: 40.0, width: self.view.frame.width, height: 21))
        
        if let dLabel = self.distanceLabel {
            dLabel.textAlignment = NSTextAlignment.Center
            dLabel.textColor = UIColor.whiteColor()
            dLabel.text = "Distance: "
            self.informationView.addSubview(dLabel)
        }
        
        if let msgLabel = self.messageLabel {
            msgLabel.textAlignment = .Center
            msgLabel.textColor = UIColor.whiteColor()
            self.informationView.addSubview(msgLabel)
        }

        self.view.addSubview(informationView)
        
        self.animateInformationView(self.duration, delay: self.delay, options: self.options, animations: {
            self.informationView.frame = CGRect(x: 0.0, y: self.view.frame.height - 100, width: self.view.frame.width, height: 100.0)
            }, completion: nil)
    }
    
    func animateInformationView(duration: NSTimeInterval, delay: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: completion)
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
            
            let distance = roundValue(GMSGeometryDistance(userPoint, self.markerPoint!))
            
            if let dLabel = self.distanceLabel {
                dLabel.text = "Distance: \(distance) m"
            }
            
            if let msgLabel = self.messageLabel {
                msgLabel.text = getMessage(distance)
            }
            
            print("Disance: \(distance) m")
        }
        
        self.camera = GMSCameraPosition.cameraWithLatitude(self.userLatitude!, longitude: self.userLongitude!, zoom: self.zoom)
    }
    
    func getMessage(distance: Double) -> String {
        switch distance {
            case 0.0..<10.0:
                return "Estas en el punto objetivo"
            
            case 10.0..<50.0:
                return "Estas muy proximo al punto objetivo"
            
            case 50.0..<100.0:
                return "Estas proximo al punto objetivo"
            
            case 100.0..<200.0:
                return "Estas lejos del punto objetivo"
            
            default:
                return "Estas muy lejos del punto objetivo"
        }
    }
    
    func roundValue(value: Double) -> Double {
        return Double(round(10*value)/10)
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
    
            self.removeInformationView()
        })
        return true
    }
    
    func removeInformationView() {
        
        self.animateInformationView(self.duration, delay: self.delay, options: self.options, animations: {
            self.informationView.frame = CGRect(x: 0.0, y: self.view.frame.height, width: self.view.frame.width, height: 100)
            }, completion: {
                completion in
                self.informationView.removeFromSuperview()
            })
    }
}

//MARK: Search Bar Delegate Methods

extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        print("editando texto")
        return true
    }
}







