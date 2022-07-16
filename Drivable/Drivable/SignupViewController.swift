//
//  SignupViewController.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/15/22.
//

import UIKit

class SignupViewController: UIViewController {

    //Views
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var elementsView: UIView!
    @IBOutlet weak var inputTextView: UIView!
    
    //Text Fields
    @IBOutlet weak var companyTF: UITextField!
    @IBOutlet weak var acronymTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmTF: UITextField!
    
    //Buttons
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var addImageBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setCorners()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Methods
    func setCorners(){
        
        for view in [elementsView, inputTextView, scrollView]{
            
            view?.layer.cornerRadius = 20
            
        }
        
        signupBtn.layer.cornerRadius = 10
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


