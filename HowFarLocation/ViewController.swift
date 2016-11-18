//
//  ViewController.swift
//  HowFarLocation
//
//  Created by Petr Reshetin on 17/11/2016.
//  Copyright © 2016 Petr Reshetin. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {

    var radius = 1
    var userLocation: CLLocation? = nil
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLabel: UILabel!

    @IBAction func radiusChanged(_ sender: UISlider) {
        
        let intValue = Int(sender.value)
        radiusLabel.text = "\(intValue) km"
        radius = intValue
        radiusSlider.value = Float(intValue)
        
        guard let loc = userLocation else {
            print("userLocation not set.")
            return
        }
        
        if circleNeedsSetting {
            mapView.clear()
            let circ = GMSCircle(position: loc.coordinate, radius: Double(Double(radius) * 1000))
            circ.map = mapView
        }
    }
    
    
    let locationManager = CLLocationManager()
    var initialRegionNeedsSetting = true
    var circleNeedsSetting = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if initialRegionNeedsSetting {
                initialRegionNeedsSetting = false
                let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 11)
                mapView.camera = camera
            }
            userLocation = location
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

