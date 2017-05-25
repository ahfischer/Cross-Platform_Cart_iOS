//
//  FormViewController.swift
//  A_Fischer_iOS_UsersAndData
//
//  Created by Anthony Fischer on 12/3/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import UIKit
import Firebase

class FormViewController: UIViewController {

    @IBOutlet weak var textFieldItemName: UITextField!
    
    @IBOutlet weak var textFieldItemType: UITextField!
    
    @IBOutlet weak var textFieldItemQuantity: UITextField!
    
    var selectedItem: Item!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // If selectedItem data has been passed
        if (selectedItem != nil) {
            
            // Fill in values from selected item to be updated
            textFieldItemName.text = selectedItem.mName;
            textFieldItemName.isUserInteractionEnabled = false;
            textFieldItemName.alpha = 0.3;
            
            textFieldItemType.text = selectedItem.mType;
            textFieldItemQuantity.text = selectedItem.mQuantity?.description;
        }
        
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
        // Ensure all fields are filled out
        if (textFieldItemName.text != "" && textFieldItemType.text != ""
            && textFieldItemQuantity.text != "") {
            
            let ref: FIRDatabaseReference = FIRDatabase.database().reference();
        
            let userID = FIRAuth.auth()?.currentUser?.uid;
            
            // Set new values from textfields
            ref.child("users").child(userID!).child("Cart").child(textFieldItemName.text!).setValue(["Category": textFieldItemType.text!, "Quantity": Int(textFieldItemQuantity.text!) ?? 1]);
            
            // If no internet connection available
            if (NetworkUtil().hasInternet() == false) {
                
                // Inform user they need internet to sign in
                let alert = UIAlertController(title: self.title, message: "Once internet connection is restored, data will be synced with database.", preferredStyle: UIAlertControllerStyle.alert);
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                    // Remove from the stack
                    _ = self.navigationController?.popViewController(animated: true);
                }
                alert.addAction(okAction);
                self.present(alert, animated: true, completion: nil);
            }
        } else {
            
            // Inform user they need to fill out all fields
            let alert = UIAlertController(title: title, message: "Please fill out all fields", preferredStyle: UIAlertControllerStyle.alert);
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
            alert.addAction(action);
            self.present(alert, animated: true, completion: nil);
        }
        
    }
}
