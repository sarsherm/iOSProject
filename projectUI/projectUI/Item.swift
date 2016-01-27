//
//  Item.swift
//  projectUI
//
//  Created by Sarah Sherman on 1/26/16.
//  Copyright © 2016 Sarah Sherman. All rights reserved.
//

import Foundation

class Item {
    var name: String
    var latitude: Double
    var longitude: Double
    var distance: Int
    var zipCode: Int
    var details: String
    var dateListed: String
    var found: Int
    init(name: String, latitude: Double, longitude: Double, distance: Int, zipCode: Int, details: String, dateListed: String, found: Int) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.zipCode = zipCode
        self.details = details
        self.dateListed = dateListed
        self.found = found
    }
}