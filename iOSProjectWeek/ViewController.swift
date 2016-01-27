//
//  ViewController.swift
//  iOSProjectWeek
//
//  Created by Sarah Sherman on 1/25/16.
//  Copyright © 2016 Sarah Sherman. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    let locationManager = CLLocationManager()
    
    var originalTopMargin: CGFloat!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalTopMargin = topMarginConstraint.constant
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        
    }

}