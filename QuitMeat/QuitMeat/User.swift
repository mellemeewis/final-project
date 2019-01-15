//
//  User.swift
//  QuitMeat
//
//  Created by Melle Meewis on 15/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var ID: String
    var stoppedItems: [String]
    var friends: [String]
}

struct SearchUser {
    var name: String
    var ID: String
}
