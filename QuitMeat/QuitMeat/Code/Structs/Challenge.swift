//
//  Challenge.swift
//  QuitMeat
//
//  Struct that represents a challenge.
//
//  Created by Melle Meewis on 23/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import Foundation

// Struct that represents a challenge.
struct Challenge {
    var ID: String
    var creationDate: String
    var name: String
    var createdBy: String
    var descirption: String
    var daysAWeek: Int
    var productType: String
    var weeks: Int
    
    // Calcualte goal date
    var goalDate: Date {
        let daysToAdd = self.weeks * 7
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = daysToAdd
        let goalDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        return goalDate!
    }
    // Calcualte co2 savings
    var co2Savings: Int {
        let currentDate = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.day], from: currentDate, to: self.goalDate)
        let dayDifference = components.day!
        let daysNotEating = Float(Float(dayDifference) / 7.00 * Float(self.daysAWeek))
        let co2Savings = Int(daysNotEating * Float((SessionController.shared.productTypes[self.productType]?.co2)!))
        return co2Savings
        }
    
    // Calculate water savings
    var waterSavings: Int {
        let currentDate = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.day], from: currentDate, to: self.goalDate)
        let dayDifference = components.day!
        let daysNotEating = Float(Float(dayDifference) / 7.00 * Float(self.daysAWeek))
        let co2Savings = Int(daysNotEating * Float((SessionController.shared.productTypes[self.productType]?.water)!))
        return co2Savings
    }
    
    // Calculate animal savings
    var animalSavings: Int {
        let currentDate = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.day], from: currentDate, to: self.goalDate)
        let dayDifference = components.day!
        let daysNotEating = Float(Float(dayDifference) / 7.00 * Float(self.daysAWeek))
        let co2Savings = Int(daysNotEating * Float((SessionController.shared.productTypes[self.productType]?.animals)!))
        return co2Savings
    }
    
}

// Struct that represetns an accepted challenge
struct AcceptedChallenge {
    var challengeID: String
    var startDate: String
    var goalDate: String
}

