//
//  DashboardViewController.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/20/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class DashboardViewController: UIViewController{
    
    //Labels
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalVehiclesLabel: UILabel!
    @IBOutlet weak var totalActivesLabel: UILabel!
    @IBOutlet weak var totalInactivesLabel: UILabel!
    
    //Views
    @IBOutlet weak var fleetDetailsView: UIView!

    //Buttons
    @IBOutlet weak var myFleetBtn: UIButton!
    
    
    
    //Variables
    var account: UserAccount!
    var vehicles = [Vehicle]()
    
    //Variables for Firestore Collection Accounts
    let firebase_collection_accounts = "accounts"
    let firebase_accounts_fields_userid = "user_id"
    let firebase_accounts_fields_account_image_ref = "account_image_ref"
    let firebase_accounts_fields_company = "company"
    let firebase_accounts_fields_company_acronym = "company_acronym"
    let firebase_accounts_fields_firstname = "first_name"
    let firebase_accounts_fields_lastname = "last_name"
    
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
        
        navigationItem.title = "Dashboard"
        navigationItem.hidesBackButton = true
        
        setCorners()
        
        if Auth.auth().currentUser == nil{
            print("Dashboard User: No Current User")
        }
        else{
            print("Dashboard User: " + Auth.auth().currentUser!.uid)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ReadAccountDoc()
        
    }
    
    //MARK: Methods for Layouts
    
    func setTitleView(){
        
        companyLabel.text = account.company
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        dateLabel.text = dateFormatter.string(from: Date())
        
    }
    
    func setCorners(){
        
        for view in [fleetDetailsView]{
         
            view?.layer.cornerRadius = 5
            
        }
        
        for btn in [myFleetBtn]{
            
            btn?.layer.cornerRadius = 10
            
        }
        
    }
    
    func setVehicleTotals(){
        
        totalVehiclesLabel.text = "\(vehicles.count)"
        var totalActives: Int = 0
        var totalInactives: Int = 0
        
        for v in vehicles {
            
            if v.isActive {
                totalActives+=1
            }
            else{
                totalInactives+=1
            }
            
        }
        
        totalActivesLabel.text = "\(totalActives)"
        totalInactivesLabel.text = "\(totalInactives)"
        
    }
    
    //MARK: Methods for Firebase
    
    func ReadAccountDoc(){
        
        let db = Firestore.firestore()
        
        db.collection(firebase_collection_accounts).getDocuments { (snapshot, error) in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    
                    snapshot?.documents.forEach({ (doc) in
                        
                        guard let uID = doc[self.firebase_accounts_fields_userid] as? String,
                              let userID = Auth.auth().currentUser?.uid
                        else{return}
                        
                        if uID == userID{
                            print("Dashboard - Found User Details")
                            
                            
                            guard let accountRefImage = doc[self.firebase_accounts_fields_account_image_ref] as? String,
                                  let company = doc[self.firebase_accounts_fields_company] as? String,
                                  let companyAcronym = doc[self.firebase_accounts_fields_company_acronym] as? String,
                                  let firstName = doc[self.firebase_accounts_fields_firstname] as? String,
                                  let lastName = doc[self.firebase_accounts_fields_lastname] as? String
                            else {return}
                            
                            self.account = UserAccount(docID: doc.documentID, accountImageRef: accountRefImage, company: company, companyAcronym: companyAcronym, firstName: firstName, lastName: lastName)
                            
                            print("Dashboard: Account Loaded - " + self.account.company)
                            
                            self.ReadVehicleDoc(accountID: doc.documentID)
                            
                            self.setTitleView()
                            
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
                
                self.setVehicleTotals()
                
            }
            else{
                print("Error occred loading firebase - Vehicles")            }
            
        }
        
    }
    
    
    //MARK: Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "DashboardToFleet"{
            return true
        }
        
        else{
            print("Error - No Matching Segue Identifier")
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let s = sender as? UIButton {
            
            if s.currentTitle! == "My FLeet" {
                
                let destination = segue.destination as? FleetListViewController
                
            }
            
        }
        
    }
    
    
}
