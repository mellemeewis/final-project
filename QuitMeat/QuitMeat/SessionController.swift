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
    
    
    var screenHeight = UIScreen.main.bounds.height
        
    static let shared = SessionController()
    
    var productTypes = [String:ProductType]()
    var stoppedItemsUser = [String:StoppedItem]()
    var friendIDs = [String]()
    var events = [Event]()
    var challenges = [Challenge]()
    var currentChallengesUser = [String:String]()
    var completedChallengesUsers = [String:String]()
    let dateFormatter = DateFormatter()
    let calender = Calendar.current

    
    var co2savedUser: Int {
        var co2Saved = 0
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        for (key, value) in self.stoppedItemsUser {
            let dateAsString = value.stopDate
            let stopDate = dateFormatter.date(from: dateAsString)!
            let currentDate = Date()
            let components = calender.dateComponents([.day], from: stopDate, to: currentDate)
            let dayDifference = components.day!
            let daysNotEaten = Float(Float(dayDifference) / 7.00 * Float(value.days))
            co2Saved = co2Saved + Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.co2)!))
        }
        return co2Saved
    }
    var waterSavedUser: Int {
        var waterSaved = 0
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        for (key, value) in self.stoppedItemsUser {
            let dateAsString = value.stopDate
            let stopDate = dateFormatter.date(from: dateAsString)!
            let currentDate = Date()
            let components = calender.dateComponents([.day], from: stopDate, to: currentDate)
            let dayDifference = components.day!
            let daysNotEaten = Float(Float(dayDifference) / 7.00 * Float(value.days))
            waterSaved = waterSaved + Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.water)!))
        }
        return waterSaved
    }
    
    var animalsSavedUser: Int {
        var animalsSaved = 0
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        for (key, value) in self.stoppedItemsUser {
            let dateAsString = value.stopDate
            let stopDate = dateFormatter.date(from: dateAsString)!
            let currentDate = Date()
            let components = calender.dateComponents([.day], from: stopDate, to: currentDate)
            let dayDifference = components.day!
            let daysNotEaten = Float(Float(dayDifference) / 7.00 * Float(value.days))
            animalsSaved = animalsSaved + Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.animals)!))
        }
        return animalsSaved
    }
    
    var userID: String!
    var name: String!
    
    func clearSessionData() {
        productTypes = [String:ProductType]()
        stoppedItemsUser = [String:StoppedItem]()
        friendIDs = [String]()
        events = [Event]()
    }
}
