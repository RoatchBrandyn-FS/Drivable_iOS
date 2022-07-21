//
//  UserAccount.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/20/22.
//

import Foundation

class UserAccount {
    
    //Stored Properties
    var docID: String
    var accountImageRef: String
    var company: String
    var companyAcronym: String
    var firstName: String
    var lastName: String
    
    //Computed Properties
    
    //inits
    init(docID: String, accountImageRef: String, company: String, companyAcronym: String, firstName: String, lastName: String) {
        
        self.docID = docID
        self.accountImageRef = accountImageRef
        self.company = company
        self.companyAcronym = companyAcronym
        self.firstName = firstName
        self.lastName = lastName
        
        
    }
    
}
