//
//  Event.swift
//  QuitMeat
//
//  Created by Melle Meewis on 16/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import Foundation

struct Event {
    var date: String
    var description: String
    var name: String {
        return self.description.components(separatedBy: " ").first!
    }
}
