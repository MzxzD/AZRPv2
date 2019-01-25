//
//  LocationViewModel.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 18/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import MapKit

class LocationViewModel: LocationViewModelProtocol {
    var location : CLLocationCoordinate2D
    var annotation = MKPointAnnotation()
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    var region : MKCoordinateRegion

    
    init(longitude: Double, latitude: Double, userName: String) {
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.annotation.coordinate = self.location
        self.annotation.title = userName
        self.region = MKCoordinateRegion(center: self.location, span: span)
    }
    
    
}

protocol LocationViewModelProtocol {
    var annotation : MKPointAnnotation {get}
    var location : CLLocationCoordinate2D {get}
    var region : MKCoordinateRegion {get}
}
