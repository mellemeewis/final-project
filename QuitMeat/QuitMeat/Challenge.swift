//
//  Challenge.swift
//  QuitMeat
//
//  Created by Melle Meewis on 23/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import Foundation

struct Challenge {
    var ID: String
    var creationDate: String
    var name: String
    var createdBy: String
    var descirption: String
    var daysAWeek: Int
    var productType: String
    var weeks: Int
    var goalDate: Date {
        let daysToAdd = self.weeks * 7
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = daysToAdd
        let goalDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        return goalDate!
    }
    
    var co2Savings: Int {
        let currentDate = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.day], from: currentDate, to: self.goalDate)
        let dayDifference = components.day!
        let daysNotEating = Float(Float(dayDifference) / 7.00 * Float(self.daysAWeek))
        let co2Savings = Int(daysNotEating * Float((SessionController.shared.productTypes[self.productType]?.co2)!))
        return co2Savings
        }
    
    var waterSavings: Int {
        let currentDate = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.day], from: currentDate, to: self.goalDate)
        let dayDifference = components.day!
        let daysNotEating = Float(Float(dayDifference) / 7.00 * Float(self.daysAWeek))
        let co2Savings = Int(daysNotEating * Float((SessionController.shared.productTypes[self.productType]?.water)!))
        return co2Savings
    }
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

