//
//  ViewController.swift
//  HowFarLocation
//
//  Created by Petr Reshetin on 17/11/2016.
//  Copyright © 2016 Petr Reshetin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var circle = MKCircle()
    var initialRegionNeedsSetting = true
    var circleNeedsSetting = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        
        let coordinate1 = CLLocation(latitude: 53.874798, longitude: 27.675941)
        let coordinate2 = CLLocation(latitude:  32.089471, longitude: 34.784712)
        let distanceInMeters = coordinate1.distance(from: coordinate2) / 1000
        print("Minsk telaviv: \(distanceInMeters) km")
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if initialRegionNeedsSetting  {
            initialRegionNeedsSetting = false
            let latDetla: CLLocationDegrees = 0.1
            let lonDelta: CLLocationDegrees = 0.1
            let span = MKCoordinateSpan(latitudeDelta: latDetla, longitudeDelta: lonDelta)
            let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.lineWidth = 1
            return circle
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if circleNeedsSetting {
                circleNeedsSetting = false
                mapView.delegate = self
                circle = MKCircle(center: location.coordinate, radius: 2485685 as CLLocationDistance)
                mapView.add(circle)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

