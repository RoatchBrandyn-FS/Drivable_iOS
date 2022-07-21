//
//  Vehicle.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/20/22.
//

import Foundation


class Vehicle {
    
    //Stored Properties
    var docID: String
    var name: String
    var vinNum: String
    var odometer: String
    var isActive: Bool
    var year: String
    var make: String
    var model: String
    var driveTrain: String
    var isAtLot: Bool
    
    //Computed Properties
    
    //Inits
    init(docID: String, name: String, vinNum: String, odometer: String, isActive: Bool, year: String, make: String, model: String, driveTrain: String, isAtLot: Bool) {
        
        self.docID = docID
        self.name = name
        self.vinNum = vinNum
        self.odometer = odometer
        self.isActive = isActive
        self.year = year
        self.make = make
        self.model = model
        self.driveTrain = driveTrain
        self.isAtLot = isAtLot
        
    }
    
}
