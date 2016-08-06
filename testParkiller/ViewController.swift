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
    
    override func loadView() {
        let camera = GMSCameraPosition.cameraWithLatitude(-33.9, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        
        mapView.myLocationEnabled = true
        self.view = mapView
        
        createMarker(mapView)
    }
    
    func createMarker(map: GMSMapView) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sidney"
        marker.snippet = "Australia"
        marker.map = map
    }


}

