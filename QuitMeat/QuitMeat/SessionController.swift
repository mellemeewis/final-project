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
    
    var productTypes = [String:ProductType]()
    
    let userID = Auth.auth().currentUser?.uid
    static let shared = SessionController()
}
