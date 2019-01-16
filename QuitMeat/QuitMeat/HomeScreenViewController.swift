//
//  HomeScreenViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 09/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeScreenViewController: UIViewController {
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        
    }
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var stoppingInfoButton: UIButton!
    @IBOutlet weak var SavingInfoButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    @IBOutlet weak var challengesButton: UIButton!
    

    @IBAction func LogOutButtonTapped(_ sender: UIButton) {
        try! Auth.auth().signOut()
        SessionController.shared.clearSessionData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        updateUI(for: "")

        fetchStopsUser()
    }
    
    func updateUI(for data: String) {
        let height = SessionController.shared.screenHiehgt / 5

        logInButton.layer.cornerRadius = 15.0
        stoppingInfoButton.layer.cornerRadius = 30.0
        SavingInfoButton.layer.cornerRadius = 30.0
        socialButton.layer.cornerRadius = 30.0
        challengesButton.layer.cornerRadius = 30.0
        let heightConstraint = NSLayoutConstraint(item: stoppingInfoButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        let heightConstraint1 = NSLayoutConstraint(item: SavingInfoButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        let heightConstraint2 = NSLayoutConstraint(item: socialButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        let heightConstraint3 = NSLayoutConstraint(item: challengesButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        NSLayoutConstraint.activate([heightConstraint, heightConstraint1, heightConstraint2, heightConstraint3])
        
        switch data {
        case "userStoppingInfo":
            var stoppedString = "You stopped eating: \n"
            for (key, value) in SessionController.shared.stoppedItemsUser {
                stoppedString = stoppedString + key + " since " + value.stopDate + " for " + String(value.days) + " days a week.\n"
            }
            self.stoppingInfoButton.setTitle(stoppedString, for: .normal)
        case "userSavedInfo":
            var co2Saved = 0
            var waterSaved = 0
            var animalsSaved = 0
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            let calender = Calendar.current
            
            
            for (key, value) in SessionController.shared.stoppedItemsUser {
                let dateAsString = value.stopDate
                let stopDate = dateFormatter.date(from: dateAsString)!
                let currentDate = Date()
                let components = calender.dateComponents([.day], from: stopDate, to: currentDate)
                let dayDifference = components.day!
                let daysNotEaten = Float(Float(dayDifference) / 7.00 * Float(value.days))
                co2Saved = co2Saved + Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.co2)!))
                waterSaved = waterSaved + Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.water)!))
                animalsSaved = animalsSaved + Int(daysNotEaten * Float((SessionController.shared.productTypes[key]?.animals)!))
            }
            let savedString = "By doing this you saved:\n\(co2Saved) gram CO2\n\(waterSaved) liters of water\n\(animalsSaved) animals!"
            self.SavingInfoButton.setTitle(savedString, for: .normal)

        default:
            return
        }
    }

    func fetchStopsUser() {
        let userID = SessionController.shared.userID!
        let childPath = "users/\(userID)/stopped"
        ref.child(childPath).observeSingleEvent(of: .value) {
            (snapshot) in
            guard let data = snapshot.value as? [String:Any] else { return }
            for (key, value) in (data) {
                let stoppingData = value as! Dictionary<String, Any>
                let stoppedItem = StoppedItem(days: stoppingData["days"] as! Int, stopDate: stoppingData["date"] as! String)
                SessionController.shared.stoppedItemsUser[key] = stoppedItem
                self.updateUI(for: "userStoppingInfo")
                self.fetchProductTypes()
            }
        }
    }
    
    func fetchProductTypes() {
        ref.child("productTypes").observeSingleEvent(of: .value) {
            (snapshot) in
            guard let data = snapshot.value as? [String:Any] else { return }
            for (key, value) in (data) {
                let productTypeData = value as! Dictionary<String, Any>
                let productType = ProductType(co2: productTypeData["co2"] as! Int, water: productTypeData["water"] as! Int, animals: productTypeData["animals"] as! Int)
                SessionController.shared.productTypes[key] = productType
            }
            self.updateUI(for: "userSavedInfo")
        }
    }
    
    func fetchEvents() {
        ref.child("productTypes").observeSingleEvent(of: .value) {
            (snapshot) in
            guard let data = snapshot.value as? [String:Any] else { return }
            for (key, value) in (data) {
                let productTypeData = value as! Dictionary<String, Any>
                let productType = ProductType(co2: productTypeData["co2"] as! Int, water: productTypeData["water"] as! Int, animals: productTypeData["animals"] as! Int)
                SessionController.shared.productTypes[key] = productType
            }
            self.updateUI(for: "userSavedInfo")
        }
    }
}
