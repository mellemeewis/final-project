//
//  SessionController.swift
//  QuitMeat
//
//  Class that controls the session of the user currently signed in.
//
//  Created by Melle Meewis on 10/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import Foundation
import Firebase

class SessionController {
    
    // Declare variables
    var screenHeight = UIScreen.main.bounds.height
    let dateFormatter = DateFormatter()
    let calender = Calendar.current
    static let shared = SessionController()
    
    var productTypes = [String:ProductType]()
    var challenges = [Challenge]()
    var events = [Event]()

    var userID: String!
    var name: String!
    var stoppedItemsUser = [String:StoppedItem]()
    var friendIDs = [String]()
    var currentChallengesIDsUser = [String:AcceptedChallenge]()
    var currentChallengesObjectsUser = [Challenge]()
    var completedChallengesIDsUser = [String:AcceptedChallenge]()
    var completedChallengesObjectsUser = [Challenge]()
    
    // Set self constructing variables
    var co2savedUser: Int {
        var co2Saved = 0
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        // Find amount of co2 saved from producttypes user stopped eating
        for (key, value) in self.stoppedItemsUser {
            let dateAsString = value.stopDate
            guard let stopDate = dateFormatter.date(from: dateAsString) else { return co2Saved }
            let currentDate = Date()
            let components = calender.dateComponents([.day], from: stopDate, to: currentDate)
            guard let dayDifference = components.day else { return co2Saved }
            let daysNotEaten = Float(Float(dayDifference) / 7.00 * Float(value.days))
            co2Saved += Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.co2)!))
        }
        // Find amount of co2 saved from challenges user participated in
        for currentChallengeObject in currentChallengesObjectsUser {
            let currentDate = Date()
            guard let startDateAsString = currentChallengesIDsUser[currentChallengeObject.ID]?.startDate else { return co2Saved }
            dateFormatter.timeStyle = .medium
            guard let startDate = dateFormatter.date(from: startDateAsString) else { return co2Saved }
            let components = calender.dateComponents([.day], from: startDate, to: currentDate)
            guard let dayDifference = components.day else { return co2Saved}
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
        // Find amount of water saved from producttypes user stopped eating
        var waterSaved = 0
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        for (key, value) in self.stoppedItemsUser {
            let dateAsString = value.stopDate
            guard let stopDate = dateFormatter.date(from: dateAsString) else { return waterSaved }
            let currentDate = Date()
            let components = calender.dateComponents([.day], from: stopDate, to: currentDate)
            guard let dayDifference = components.day else { return waterSaved }
            let daysNotEaten = Float(Float(dayDifference) / 7.00 * Float(value.days))
            waterSaved += Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.water)!))
        }
        // Find amount of water saved from challenges user participated in
        for currentChallengeObject in currentChallengesObjectsUser {
            let currentDate = Date()
            guard let startDateAsString = currentChallengesIDsUser[currentChallengeObject.ID]?.startDate else { return waterSaved }
            dateFormatter.timeStyle = .medium
            guard let startDate = dateFormatter.date(from: startDateAsString) else { return waterSaved }
            let components = calender.dateComponents([.day], from: startDate, to: currentDate)
            guard let dayDifference = components.day else { return waterSaved }
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
        // Find amount of animals saved from producttypes user stopped eating
        var animalsSaved = 0
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        for (key, value) in self.stoppedItemsUser {
            let dateAsString = value.stopDate
            guard let stopDate = dateFormatter.date(from: dateAsString) else { return animalsSaved }
            let currentDate = Date()
            let components = calender.dateComponents([.day], from: stopDate, to: currentDate)
            guard let dayDifference = components.day else { return animalsSaved }
            let daysNotEaten = Float(Float(dayDifference) / 7.00 * Float(value.days))
            animalsSaved += Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.animals)!))
        }
        // Find amount of animals saved from challenges user participated in
        for currentChallengeObject in currentChallengesObjectsUser {
            let currentDate = Date()
            guard let startDateAsString = currentChallengesIDsUser[currentChallengeObject.ID]?.startDate else { return animalsSaved }
            dateFormatter.timeStyle = .medium
            guard let startDate = dateFormatter.date(from: startDateAsString) else { return animalsSaved }
            let components = calender.dateComponents([.day], from: startDate, to: currentDate)
            guard let dayDifference = components.day else { return animalsSaved }
            let totalDaysChallenge = 7 * currentChallengeObject.weeks
            let challengeProgress = dayDifference / totalDaysChallenge
            animalsSaved += Int(challengeProgress) * currentChallengeObject.animalSavings
        }
        for completedChallengeObject in completedChallengesObjectsUser {
            animalsSaved += completedChallengeObject.animalSavings
        }
        return animalsSaved
    }
    
    /// Reset data in session controller
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
