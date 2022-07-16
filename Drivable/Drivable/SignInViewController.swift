//
//  ViewController.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/15/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

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
    
    //Firebase Variables

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setCorners()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //MARK: Actions
    @IBAction func signInPressed(_ sender: UIButton) {
        
        CheckText()
        
    }
    

    //MARK: Methods for Layout
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
    
    //MARK: Methods for Backend
    
    func CheckText() {
        
        if emailTF.text?.isEmpty == true && passwordTF.text?.isEmpty == true {
            
            //Both Email and Pasword are empty
            let emptyAlert = UIAlertController(title: "Sorry...", message: "All required fields needed to login: Email and Password show empty.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
        }
        
        else if emailTF.text?.isEmpty == false && passwordTF.text?.isEmpty == true {
            
            //emailTF is filled, but passwordTF is empty
            let emptyAlert = UIAlertController(title: "Sorry...", message: "All required fields needed to login: Password show empty.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
        }
        
        else if emailTF.text?.isEmpty == true && passwordTF.text?.isEmpty == false {
            
            //passwordTF is filled, but emailTF is empty
            // -> in this case, make sure to empty the passwordTF
            let emptyAlert = UIAlertController(title: "Sorry...", message: "All required fields needed to login: Email show empty.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
            passwordTF.text?.removeAll()
            
        }
        else {
            
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //both should be filled
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil{
                    print(error?.localizedDescription)
                }
                else{
                    print("Signed in Successful")
                }
            }
            
        }
        
    }
    
    //MARK: Methods for handling Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}

