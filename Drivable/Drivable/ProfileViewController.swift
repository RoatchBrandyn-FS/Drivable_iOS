//
//  ProfileViewController.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/21/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    //Labels
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var acronymLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //Views
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    
    //Buttons
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var passwordBtn: UIButton!
    
    //Variables
    var account: UserAccount!
    
    //Variables for Firestore Collection Accounts
    let firebase_collection_accounts = "accounts"
    let firebase_accounts_fields_userid = "user_id"
    let firebase_accounts_fields_account_image_ref = "account_image_ref"
    let firebase_accounts_fields_company = "company"
    let firebase_accounts_fields_company_acronym = "company_acronym"
    let firebase_accounts_fields_firstname = "first_name"
    let firebase_accounts_fields_lastname = "last_name"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        
        setCorners()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ReadAccountDoc()
        
    }
    
    //MARK: Methods for Layouts
    func setCorners(){
        
        for view in [detailsView]{
         
            view?.layer.cornerRadius = 5
            
        }
        
        for btn in [emailBtn, passwordBtn]{
            
            btn?.layer.cornerRadius = 10
            
        }
        
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
                            print("Profile- Found User Details")
                            
                            
                            guard let accountRefImage = doc[self.firebase_accounts_fields_account_image_ref] as? String,
                                  let company = doc[self.firebase_accounts_fields_company] as? String,
                                  let companyAcronym = doc[self.firebase_accounts_fields_company_acronym] as? String,
                                  let firstName = doc[self.firebase_accounts_fields_firstname] as? String,
                                  let lastName = doc[self.firebase_accounts_fields_lastname] as? String
                            else {return}
                            
                            self.account = UserAccount(docID: doc.documentID, accountImageRef: accountRefImage, company: company, companyAcronym: companyAcronym, firstName: firstName, lastName: lastName)
                            
                            print("Profile: Account Loaded - " + self.account.company)
                            
                            self.setDetailsView()
                            
                        }
                        
                    })
                    
                    
                }
                
                
            }
            else {
                print("Error occred loading firebase - Accounts")
            }
            
        }
        
    }
    
    func setDetailsView(){
        
        companyLabel.text = account.company
        acronymLabel.text = account.companyAcronym
        ownerLabel.text = "\(account.firstName) \(account.lastName)"
        emailLabel.text = Auth.auth().currentUser?.email
        
    }
    
}
