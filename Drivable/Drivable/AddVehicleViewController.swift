//
//  AddVehicleViewController.swift
//  Drivable
//
//  Created by Brandyn Roatch on 7/22/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AddVehicleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Variables
    var pickerList = ["Dodge", "Ford", "Mercedes", "Nissan"]
    
    //Views
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var elementsView: UIView!
    @IBOutlet weak var inputTextView: UIView!
    
    //Labels
    @IBOutlet weak var nameLabel: UILabel!
    
    //Text Fields
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var modelTF: UITextField!
    @IBOutlet weak var drivetrainTF: UITextField!
    @IBOutlet weak var vinNumTF: UITextField!
    @IBOutlet weak var odometerTF: UITextField!
    
    //Buttons
    @IBOutlet weak var addBtn: UIButton!
    
    //Switch
    @IBOutlet weak var statusSwitch: UISwitch!
    
    //Picker
    @IBOutlet weak var makePicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add to FLeet"
        
        setCorners()
        
        makePicker.delegate = self
        makePicker.dataSource = self
        
        makePicker.reloadAllComponents()
        
    }
    
    //MARK: Methods for Layouts
    func setCorners(){
        
        for view in [elementsView, inputTextView, scrollView]{
            
            view?.layer.cornerRadius = 20
            
        }
        
        addBtn.layer.cornerRadius = 10
    }
    
    //MARK: Methods for Picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
    
    
}
