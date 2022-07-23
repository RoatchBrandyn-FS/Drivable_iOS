//
//  SignupViewController.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/15/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class SignupViewController: UIViewController, UITextFieldDelegate {

    //Views
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var elementsView: UIView!
    @IBOutlet weak var inputTextView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    
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
    
    //Variables for Firebase Storage
    let firebase_storage_accounts = "accounts/"
    let firebase_storage_images = "images/"
    let firebase_storage_account_image = "account_image"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setCorners()
        
        for textView in [companyTF, acronymTF, firstNameTF, lastNameTF, emailTF, passwordTF, confirmTF]{
            
            textView?.delegate = self
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Actions
    @IBAction func pressedAddImage(_ sender: Any) {
        
        //takePicture() -> Needs a device with a camera for testing
        getImageFromPhone()
        
        
    }
    
    @IBAction func pressedSignup(_ sender: Any) {
        
        checkForRequiredData()
        
    }
    
    
    //MARK: Methods for CRUD
    func checkForRequiredData(){
        
        if imageView.tag == 0 {
            
            //Both Email and Pasword are empty
            let emptyAlert = UIAlertController(title: "Missing Image...", message: "Please make sure and add an Image for the New Account.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
            emptyPasswords()
        }
        else if companyTF.text?.isEmpty == true || acronymTF.text?.isEmpty == true || firstNameTF.text?.isEmpty == true || lastNameTF.text?.isEmpty == true || emailTF.text?.isEmpty == true || passwordTF.text?.isEmpty == true || confirmTF.text?.isEmpty == true {
            
            let emptyAlert = UIAlertController(title: "Sorry...", message: "All required fields needed to make a New Account.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
            
            emptyPasswords()
        }
        else if passwordTF.text!.count < 6 {
            
            let emptyAlert = UIAlertController(title: "Password Size", message: "Please make sure the password is at least 6 characters long.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
            
            emptyPasswords()
        }
        else if passwordTF.text != confirmTF.text {
            
            let emptyAlert = UIAlertController(title: "Password Don't Match", message: "Please make sure the password and confirm password match.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
            emptyPasswords()
        }
        else if isValidEmail(email: emailTF.text!) == false {
            
            let emptyAlert = UIAlertController(title: "Email Format Wrong", message: "Please make sure to use proper formatting for email address.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
            emptyPasswords()
        }
        else if acronymTF.text!.count > 4 {
            
            let emptyAlert = UIAlertController(title: "Company Acronym Too Large", message: "Please make sure the company acronym is not larger than 4 characters.", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
            
            emptyPasswords()
            
        }
        else{
            
            let emptyAlert = UIAlertController(title: "SHould Make Account", message: "All fields made", preferredStyle: .alert)
            
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyAlert, animated: true, completion: nil)
        }
        
        
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createUser(company: String, acronym: String ){
        
        
        
    }
    
    func saveImage(){
        
        
        
    }
    
    func saveToFirestore(){
        
    }
    
    //MARK: Methods for Layouts
    func setCorners(){
        
        for view in [elementsView, inputTextView, scrollView]{
            
            view?.layer.cornerRadius = 20
            
        }
        
        signupBtn.layer.cornerRadius = 10
    }

    func emptyPasswords(){
        
        passwordTF.text?.removeAll()
        confirmTF.text?.removeAll()
        
    }
    
    //MARK: Methods for handling Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
    
    //MARK: Methods for camera and getting images
    
    func takePicture(){
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func getImageFromPhone(){
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else{return}
        
        imageView.image = image
        imageView.tag = 1
        
    }
    
}


