//
//  ViewController.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/15/22.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    
    //Views
    @IBOutlet weak var inputTextView: UIView!
    @IBOutlet weak var subContainerView: UIView!
    
    //Buttons
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    //TextFields
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setCorners()
        
        emailTF.delegate = self
        passwordTF.delegate = self
    }

    //MARK: Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setCorners(){
        
        for view in [inputTextView, subContainerView]{
         
            view?.layer.cornerRadius = 20
            
        }
        
        signInBtn.layer.cornerRadius = 10
        
    }

}

