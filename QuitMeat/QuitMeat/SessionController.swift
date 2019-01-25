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
    var currentChallengesIDsUser = [String:AcceptedChallenge]()
    var currentChallengesObjectsUser = [Challenge]()
    var completedChallengesIDsUser = [String:AcceptedChallenge]()
    var completedChallengesObjectsUser = [Challenge]()
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
            co2Saved += Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.co2)!))
        }
        for currentChallengeObject in currentChallengesObjectsUser {
            let currentDate = Date()
            let startDateAsString = currentChallengesIDsUser[currentChallengeObject.ID]?.startDate
            dateFormatter.timeStyle = .medium
            let startDate = dateFormatter.date(from: startDateAsString!)
            let components = calender.dateComponents([.day], from: startDate!, to: currentDate)
            let dayDifference = components.day!
            let totalDaysChallenge = 7 * currentChallengeObject.weeks
            let challengeProgress = dayDifference / totalDaysChallenge
            co2Saved += Int(challengeProgress) * currentChallengeObject.co2Savings
        }
        for completedChallengeObject in completedChallengesObjectsUser {
            co2Saved += completedChallengeObject.co2Savings
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
            waterSaved += Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.water)!))
        }
        for currentChallengeObject in currentChallengesObjectsUser {
            let currentDate = Date()
            let startDateAsString = currentChallengesIDsUser[currentChallengeObject.ID]?.startDate
            dateFormatter.timeStyle = .medium
            let startDate = dateFormatter.date(from: startDateAsString!)
            let components = calender.dateComponents([.day], from: startDate!, to: currentDate)
            let dayDifference = components.day!
            let totalDaysChallenge = 7 * currentChallengeObject.weeks
            let challengeProgress = dayDifference / totalDaysChallenge
            waterSaved += Int(challengeProgress) * currentChallengeObject.waterSavings
        }
        for completedChallengeObject in completedChallengesObjectsUser {
            waterSaved += completedChallengeObject.waterSavings
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
            animalsSaved += Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.animals)!))
        }
        for currentChallengeObject in currentChallengesObjectsUser {
            let currentDate = Date()
            let startDateAsString = currentChallengesIDsUser[currentChallengeObject.ID]?.startDate
            dateFormatter.timeStyle = .medium
            let startDate = dateFormatter.date(from: startDateAsString!)
            let components = calender.dateComponents([.day], from: startDate!, to: currentDate)
            let dayDifference = components.day!
            let totalDaysChallenge = 7 * currentChallengeObject.weeks
            let challengeProgress = dayDifference / totalDaysChallenge
            animalsSaved += Int(challengeProgress) * currentChallengeObject.animalSavings
        }
        for completedChallengeObject in completedChallengesObjectsUser {
            animalsSaved += completedChallengeObject.animalSavings
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
        challenges = [Challenge]()
        currentChallengesIDsUser = [String:AcceptedChallenge]()
        currentChallengesObjectsUser = [Challenge]()
        completedChallengesIDsUser = [String:AcceptedChallenge]()
        completedChallengesObjectsUser = [Challenge]()
    }
}
