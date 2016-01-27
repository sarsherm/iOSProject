//
//  Pin.swift
//  projectUI
//
//  Created by Sarah Sherman on 1/26/16.
//  Copyright © 2016 Sarah Sherman. All rights reserved.
//

import MapKit

class Pin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    let coordinate: CLLocationCoordinate2D
    var type: String
    
    init(coordinate: CLLocationCoordinate2D) {
        self.title = String()
        self.subtitle = String()
        self.coordinate = coordinate
        self.type = String()
        super.init()
    }
    
    func pinColor() -> UIColor  {
        switch type {
        case "User":
            return UIColor.blueColor()
        default:
            return UIColor.redColor()
        }
    }

}