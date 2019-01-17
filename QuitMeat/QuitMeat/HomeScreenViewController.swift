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

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == savingInfoTableView {
            print("HI")
            return SessionController.shared.screenHeight / 25
        }
        return SessionController.shared.screenHeight / 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case stoppingInfoTableView:
            return SessionController.shared.stoppedItemsUser.count
        case savingInfoTableView:
            return 3
        case socialInfoTableView:
            return 0
        case challengeInfoTableView:
            return 0
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch tableView {
        case stoppingInfoTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "StoppingInfoCell", for: indexPath)
            let keys = Array(SessionController.shared.stoppedItemsUser.keys)
            let values = Array(SessionController.shared.stoppedItemsUser.values)
            print(keys)
            print(values)
            let i = indexPath.row
            if i < keys.count {
                
                cell.textLabel?.text = "\(keys[i].capitalized) for \(values[i].days) day(s) a week since \(values[i].stopDate)!"
//                cell.detailTextLabel?.text = values[i].stopDate
            }
        case savingInfoTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SavingInfoCell", for: indexPath)
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Animals"
                cell.detailTextLabel?.text = String(animalsSaved)
            case 1:
                cell.textLabel?.text = "Water"
                cell.detailTextLabel?.text = String(waterSaved)
            case 2:
                cell.textLabel?.text = "CO2"
                cell.detailTextLabel?.text = String(co2Saved)
            default:
                return cell
            }
        case socialInfoTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SocialInfoCell", for: indexPath)
        case challengeInfoTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeInfoCell", for: indexPath)
        default:
            return cell
        }
        return cell
    }
    
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        
    }
    
    var ref: DatabaseReference!
    
    var co2Saved = 0
    var animalsSaved = 0
    var waterSaved = 0
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var stoppingInfoButton: UIButton!
    @IBOutlet weak var SavingInfoButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    @IBOutlet weak var challengesButton: UIButton!
    
    @IBOutlet weak var stoppingInfoView: UIView!
    @IBOutlet weak var savingInfoView: UIView!
    @IBOutlet weak var socialInfoView: UIView!
    @IBOutlet weak var challengeInfoView: UIView!
    
    @IBOutlet weak var stoppingInfoTableView: UITableView!
    @IBOutlet weak var savingInfoTableView: UITableView!
    @IBOutlet weak var socialInfoTableView: UITableView!
    @IBOutlet weak var challengeInfoTableView: UITableView!
    
    
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
//        let height = SessionController.shared.screenHiehgt / 5

        logInButton.layer.cornerRadius = 15.0
        stoppingInfoView.layer.cornerRadius = 30.0
        savingInfoView.layer.cornerRadius = 30.0
        socialInfoView.layer.cornerRadius = 30.0
        challengeInfoView.layer.cornerRadius = 30.0
        
        switch data {
        case "userStoppingInfo":
            stoppingInfoTableView.reloadData()
        case "userSavedInfo":
            savingInfoTableView.reloadData()
            
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
