//
//  ViewController.swift
//  A_Fischer_iOS_UsersAndData
//
//  Created by Anthony Fischer on 12/1/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FIRDatabase.database().persistenceEnabled = true;
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                
                // User is signed in, transition to list
                self.performSegue(withIdentifier: "toList", sender: self);
            }
        }
        
    }
    
    // MARK: Actions
    @IBAction func login(_ sender: AnyObject) {
        
        // If no internet connection available
        if (NetworkUtil().hasInternet() == true) {
            
            // If login fields are filled
            if (textFieldLoginEmail.text != "" && textFieldLoginPassword.text != "") {
            
                // Sign user in
                FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                                   password: textFieldLoginPassword.text!);
            } else {
            
                // Inform user they need to fill out all fields
                let alert = UIAlertController(title: title, message: "Please fill out all fields", preferredStyle: UIAlertControllerStyle.alert);
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
                alert.addAction(action);
                self.present(alert, animated: true, completion: nil);
            }
        } else {
            
            // Inform user they need internet to sign in
            let alert = UIAlertController(title: title, message: "No internet connection. Please reconnect and try again.", preferredStyle: UIAlertControllerStyle.alert);
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
            alert.addAction(action);
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    
    
    @IBAction func signUp(_ sender: AnyObject) {
        
        // Create alert to create new account (Since there aren't fragments and a new screen is unnecessary)
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert);
        
        // Create text fields within alert to fill out details
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        };
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        };
        
        // Action for creating account
        let createAction = UIAlertAction(title: "Create", style: .default) { action in
            let emailField = alert.textFields![0];
            let passwordField = alert.textFields![1];
            
            if (emailField.text != "" && passwordField.text != "") {
                
                // If no internet connection available
                if (NetworkUtil().hasInternet() == true) {
                    
                    // Create new user
                    FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                        if (error == nil) {
                            FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!);
                        }
                    }
                } else {
                    
                    // Inform user they need internet to sign in
                    let alert = UIAlertController(title: self.title, message: "No internet connection. Please reconnect and try again.", preferredStyle: UIAlertControllerStyle.alert);
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil);
                    alert.addAction(action);
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
        
        // Add actions and present
        let cancelAction = UIAlertAction(title: "Cancel", style: .default);
        
        alert.addAction(createAction);
        alert.addAction(cancelAction);
        
        present(alert, animated: true, completion: nil);
    }
    
}
