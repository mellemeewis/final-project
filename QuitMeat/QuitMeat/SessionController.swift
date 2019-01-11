//
//  SessionController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 10/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import Foundation
import Firebase

class SessionController {
        
    static let shared = SessionController()
    
    var productTypes = [String:ProductType]()
    var stoppedItemsUser = [String:StoppedItem]()
    
    var userID: String!
    var name: String!
    
    func clearSessionData() {
        productTypes = [String:ProductType]()
        stoppedItemsUser = [String:StoppedItem]()
    }
}
