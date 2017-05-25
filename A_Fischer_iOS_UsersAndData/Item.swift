//
//  Items.swift
//  A_Fischer_iOS_UsersAndData
//
//  Created by Anthony Fischer on 12/3/16.
//  Copyright © 2016 Anthony Fischer. All rights reserved.
//

import Foundation

class Item {
    
    var mName: String?
    var mType: String?
    var mQuantity: Int?
    
    init(name: String, type: String, quantity: Int) {
        self.mName = name;
        self.mType = type;
        self.mQuantity = quantity;
    }
    
}
