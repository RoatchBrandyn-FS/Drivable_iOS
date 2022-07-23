//
//  VehicleDetailsViewController.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/22/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class VehicleDetailsViewController: UIViewController {
    
    //Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vinNumLabel: UILabel!
    @IBOutlet weak var odometerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var driveTrainLabel: UILabel!
    
    
    //Views
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var specsView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    //Variables
    var selectedVehicle: Vehicle!
    var acronym: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Vehicle Details"
        print("Vehicle Name: \(selectedVehicle.name)")
        
        setCorners()
        setDetails()
        
    }
    
    //MARK: Methods for Layouts
    func setCorners(){
        
        
        for view in [specsView, statusView]{
         
            view?.layer.cornerRadius = 5
            
        }
        
    }
    
    func setDetails(){
        
        //title details
        nameLabel.text = "\(acronym!)-\(selectedVehicle.name)"
        vinNumLabel.text = "Vin: \(selectedVehicle.vinNum)"
        odometerLabel.text = "Odometer: \(selectedVehicle.odometer)"
        
        if selectedVehicle.make != "NOT ASSIGNED" {
            
            imageView.image = UIImage.init(named: selectedVehicle.make.lowercased())
            
        }
        
        
        //status details
        if selectedVehicle.isActive == true {
            statusLabel.text = "Active"
            statusLabel.textColor = UIColor.init(named: "Green")
        }
        else {
            statusLabel.text = "Inactive"
            statusLabel.textColor = UIColor.init(named: "Red")
        }
        
        //specs details
        yearLabel.text = selectedVehicle.year
        makeLabel.text = selectedVehicle.make
        modelLabel.text = selectedVehicle.model
        driveTrainLabel.text = selectedVehicle.driveTrain
        
    }
    
    
}
