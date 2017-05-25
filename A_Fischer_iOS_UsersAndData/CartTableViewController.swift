//
//  CartTableViewController.swift
//  A_Fischer_iOS_UsersAndData
//
//  Created by Anthony Fischer on 12/3/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import UIKit
import Firebase

class CartTableViewController: UITableViewController {

    var cartItems: [Item] = [];
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference();
        
        let userID = FIRAuth.auth()?.currentUser?.uid;
        
        // Listen for any changes to database to update UI
        ref.child("users").child(userID!).child("Cart").observe(.value, with: { (snapshot) in
            
            // Temp array to catch updated items
            var tempCartItems: [Item] = [];
            
            // Loop through all database items
            for element in snapshot.children {
                
                let item = element as! FIRDataSnapshot;
                let itemName: String = item.key;
                var itemType: String;
                var itemQuantity: Int!
                
                let tempDict = item.value as! NSDictionary;
                itemType = tempDict["Category"] as! String;
                itemQuantity = tempDict["Quantity"] as! Int;
                
                // Add item to temp cart array
                tempCartItems.append(Item(name: itemName, type: itemType, quantity: itemQuantity));
            }
            
            // Overwrite total array with new values from database
            self.cartItems = tempCartItems;
            self.tableView.reloadData();
        }) { (error) in
            print(error.localizedDescription);
        };
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...

        let cartItem = cartItems[indexPath.row];
        
        cell.textLabel?.text = cartItem.mName;
        cell.detailTextLabel?.text = cartItem.mQuantity?.description;

        return cell;
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let userID = FIRAuth.auth()?.currentUser?.uid;
            
            // Delete the row from the data source
            let cartItem = cartItems[indexPath.row];
            ref.child("users").child(userID!).child("Cart").child(cartItem.mName!).removeValue();
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Edit Item", message: "Are you sure you would like to edit this item?", preferredStyle: .alert);
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.performSegue(withIdentifier: "toForm", sender: self);
        };
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed");
            
            // Deselect row so item data does not get passed when canceling edit
            // and then adding new form
            tableView.deselectRow(at: indexPath, animated: true);
        };
        
        // Add the actions
        alertController.addAction(okAction);
        alertController.addAction(cancelAction);
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil);
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert);
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            try! FIRAuth.auth()!.signOut();
            self.dismiss(animated: true, completion: nil);
        };
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed");
        };
        
        // Add the actions
        alertController.addAction(okAction);
        alertController.addAction(cancelAction);
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toForm") {
            
            //prepare for segue to the form view controller
            if let vc = segue.destination as? FormViewController {
                
                // If a row has been selected, send item object forward to form
                if (self.tableView.indexPathForSelectedRow != nil) {
                    let indexPath = self.tableView.indexPathForSelectedRow;
                    vc.selectedItem = self.cartItems[indexPath!.row];
                }
            }
            
        }
    }
}
