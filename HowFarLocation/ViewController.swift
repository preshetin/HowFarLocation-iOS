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
    
    var radius = 5
    var userLocation: CLLocation? = nil
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var radiusLabel: UILabel!
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        let intValue = Int(sender.value)
        radiusLabel.text = "\(intValue) km"
        radius = intValue
        putCircle(withRadius: radius)
    }
    
    let locationManager = CLLocationManager()
    var initialRegionNeedsSetting = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
    }
    
    private func putCircle(withRadius raduis: Int) {
        guard let loc = userLocation else {
            print("userLocation not set.")
            return
        }
        
        mapView.clear()
        let circ = GMSCircle(position: loc.coordinate, radius: Double(Double(radius) * 1000))
        circ.strokeWidth = 10
        circ.strokeColor = UIColor(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 0.3)
        // colorWithRed: green: blue: alpha:1.0
        let update = GMSCameraUpdate.fit(circ.bounds())
        mapView.animate(with: update)
        circ.map = mapView

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            if initialRegionNeedsSetting {
                initialRegionNeedsSetting = false
                putCircle(withRadius: radius)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(positive : Bool) -> CLLocationCoordinate2D {
            let sign:Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180/M_PI)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * M_PI/180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        return GMSCoordinateBounds(coordinate: locationMinMax(positive: true),
                                   coordinate: locationMinMax(positive: false))
    }
}
