//
//  FleetListViewController.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/20/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FleetListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Views
    @IBOutlet weak var tableView: UITableView!
    
    //Buttons
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    
    //Variables
    var vehicles = [Vehicle]()
    var cAcronym: String!
    
    //Variables for Firestore Collection Accounts
    let firebase_collection_accounts = "accounts"
    let firebase_accounts_fields_userid = "user_id"
    let firebase_accounts_fields_company_acronym = "company_acronym"
    
    //Variables for Firebase Collection Vehicles
    let firebase_collection_vehicles = "vehicles"
    let firebase_vehicles_fields_name = "name"
    let firebase_vehicles_fields_vin_num = "vin_num"
    let firebase_vehicles_fields_odometer = "odometer"
    let firebase_vehicles_fields_is_active = "isActive"
    let firebase_vehicles_fields_year = "year"
    let firebase_vehicles_fields_make = "make"
    let firebase_vehicles_fields_model = "model"
    let firebase_vehicles_fields_drive_train = "drive_train"
    let firebase_vehicles_fields_is_at_lot = "is_at_lot"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Fleet"
        
        setTableView()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ReadAccountDoc()
        
        
    }
    
    //MARK: Methods for Layout
    func setTableView(){
        
        tableView.layer.cornerRadius = 5
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    //MARK: Methods for Firebase
    
    func ReadAccountDoc(){
        
        let db = Firestore.firestore()
        vehicles.removeAll()
        
        
        db.collection(firebase_collection_accounts).getDocuments { (snapshot, error) in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    
                    snapshot?.documents.forEach({ (doc) in
                        
                        guard let uID = doc[self.firebase_accounts_fields_userid] as? String,
                              let userID = Auth.auth().currentUser?.uid
                        else{return}
                        
                        if uID == userID{
                            print("Dashboard - Found User Details")
                            
                            guard
                                  let companyAcronym = doc[self.firebase_accounts_fields_company_acronym] as? String
                            else {return}
                            
                            self.cAcronym = companyAcronym
                            
                            self.ReadVehicleDoc(accountID: doc.documentID)
                            
                        }
                        
                    })
                    
                    
                }
                
                
            }
            else {
                print("Error occred loading firebase - Accounts")
            }
            
        }
        
    }
    
    func ReadVehicleDoc(accountID: String){
        
        
        let db = Firestore.firestore()
        
        db.collection(firebase_collection_accounts).document(accountID).collection(firebase_collection_vehicles).getDocuments { (snapshot, error) in
            
            if error == nil {
                
                snapshot?.documents.forEach({ (doc) in
                    
                    guard let name = doc[self.firebase_vehicles_fields_name] as? String,
                          let vinNum = doc[self.firebase_vehicles_fields_vin_num] as? String,
                          let odometer = doc[self.firebase_vehicles_fields_odometer] as? String,
                          let isActive = doc[self.firebase_vehicles_fields_is_active] as? Bool,
                          let year = doc[self.firebase_vehicles_fields_year] as? String,
                          let make = doc[self.firebase_vehicles_fields_make] as? String,
                          let model = doc[self.firebase_vehicles_fields_model] as? String,
                          let driveTrain = doc[self.firebase_vehicles_fields_drive_train] as? String,
                          let isAtLot = doc[self.firebase_vehicles_fields_is_at_lot] as? Bool
                    else {return}
                  
                    let newVehicle = Vehicle(docID: doc.documentID, name: name, vinNum: vinNum, odometer: odometer, isActive: isActive, year: year, make: make, model: model, driveTrain: driveTrain, isAtLot: isAtLot)
                    
                    self.vehicles.append(newVehicle)
                    
                })
                
                //self.setVehicleTotals()
                
            }
            else{
                print("Error occred loading firebase - Vehicles")
                
            }
            
            self.vehicles.sort { (v1, v2) -> Bool in
                return v1.name < v2.name
            
            }
            self.tableView.reloadData()
            
        }
        
    }
    
    //MARK: TableView Callbacks
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set the reuse cell
        //This will be where the custom would go during beta
        let cell = tableView.dequeueReusableCell(withIdentifier: "vehicle_cell_01", for: indexPath)
        
        //confirgure cell
        let vehicle = vehicles[indexPath.row]
        
        cell.textLabel?.text = "\(cAcronym!) - \(vehicle.name)"
        cell.detailTextLabel?.text = vehicle.vinNum
        cell.imageView?.image = UIImage.init(named: vehicle.make.lowercased())
        cell.imageView?.layoutMargins = UIEdgeInsets.init(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Fleet: \(vehicles.count) Vehicles"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vehicleToSend = vehicles[indexPath.row]
        
        print("Vehicle: \(vehicleToSend.name)")
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.init(named: "blue_200")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: Methods for Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            let vehicleToSend = vehicles[indexPath.row]
            
            if let destination = segue.destination as? VehicleDetailsViewController {
                
                destination.selectedVehicle = vehicleToSend
                
                
                
                
                destination.acronym = cAcronym
                
            }
            
        }
        
        if let s = sender as? UIBarButtonItem {
            
            if s.title == "Add Vehicle"{
                
                let destination = segue.destination as? AddVehicleViewController
                
                
                
            }
            
        }
        
        
        
    }
    
    
    
}
