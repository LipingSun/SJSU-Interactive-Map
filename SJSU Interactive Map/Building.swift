//
//  Building.swift
//  SJSUMap
//
//  Created by xiaoxiao li on 11/9/15.
//  Copyright © 2015 xiaoxiao li. All rights reserved.
//

import UIKit

class Building {
    //MARK: Properties
    
    var name: String
    var address: String
    var photo: UIImage?
    var lat: Double
    var lng: Double
    var button: UIButton?
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, address: String, lat: Double, lng: Double) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.address = address
        self.lat = lat
        self.lng = lng
    }
    
}