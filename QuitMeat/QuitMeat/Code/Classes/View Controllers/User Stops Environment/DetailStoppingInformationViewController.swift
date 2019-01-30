//
//  DetailStoppingInformationViewController.swift
//  QuitMeat
//
//  Controller of the User Details View.
//
//  Created by Melle Meewis on 10/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class DetailStoppingInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // declare variables
    var stopDetails = [StopDetail]()
    static var shared = DetailStoppingInformationViewController()
    var ref: DatabaseReference!

    // outlets
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var animalLabel: UILabel!
    @IBOutlet weak var detailsTableView: UITableView!
//    @IBOutlet weak var stoppingLabel: UILabel!
    
    /// return number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard stopDetails.count != 0 else { return 3 }
        return ((stopDetails.count + 1) * 2 - 1)
    }
    
    /// return cell in row in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpacingCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailsTableViewCell
        // set upper cell table view (info about challenges)
        if indexPath.row == 0 {
            let partipatingChallenges = SessionController.shared.currentChallengesObjectsUser.count + SessionController.shared.completedChallengesObjectsUser.count
            if partipatingChallenges > 0 {
                cell.descriptionLabel.text = "Participating in \(partipatingChallenges) challenge(s)!"
            } else {
                cell.descriptionLabel.text = "You are currently not participating in any challenges."
            }
            cell.animalLabel.text = ""
            cell.co2Label.text = "Press for details"
            cell.waterLabel.text = ""
            cell.selectionStyle = .default
        // set rest of cells table view
        } else {
            if stopDetails.count == 0 {
                cell.descriptionLabel.text = "You did not start consuming less meet yet!"
                cell.co2Label.text = "Press on the plus button to start"
                cell.waterLabel.text = ""
                cell.animalLabel.text = ""
            } else {
                let stopDetail = stopDetails[(indexPath.row - 2)/2]
                cell.descriptionLabel.text = stopDetail.description
                let productType = stopDetail.description.components(separatedBy: " ")[2]
                
                var animalsSavedString = ""
                var co2SavedString = ""
                var waterSavedString = ""
                
                // check if values in grams and liters are more than 1000 and transoform to KG or M3 if true
                if stopDetail.animalsSaved > 1000 {
                    let animalsSaved = Float(stopDetail.animalsSaved) / 1000
                    animalsSavedString = "\(String(format: "%.1f", animalsSaved))kg \(productType)"
                } else {
                    animalsSavedString = "\(stopDetail.animalsSaved)g \(productType)"
                }
                if stopDetail.co2saved > 1000 {
                    let co2Saved = Float(stopDetail.co2saved) / 1000
                    co2SavedString = "\(String(format: "%.1f", co2Saved))kg CO2"
                } else {
                    co2SavedString = "\(stopDetail.co2saved)g CO2"
                }
                if stopDetail.waterSaved > 1000 {
                    let waterSaved = Float(stopDetail.waterSaved) / 1000
                    waterSavedString = "\(String(format: "%.1f", waterSaved))m3 Water"
                } else {
                    waterSavedString = "\(stopDetail.waterSaved)l Water"
                }

                cell.animalLabel.text = animalsSavedString
                cell.co2Label.text = co2SavedString
                cell.waterLabel.text = waterSavedString
                
                cell.selectionStyle = .none
            }
            
        }
        cell.layer.cornerRadius = 20
        return cell
    }
    
    /// return height of cell in table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 110
        }
        return 10
    }
    
    /// handle selection row in table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "ToChallengesSegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // additional setup
        fetchStops()
    }
    
    // fetch the producttypes the user stoppped eating
    func fetchStops() {
            ref = Database.database().reference()
            let userID = SessionController.shared.userID!
            let childPath = "users/\(userID)/stopped"
            ref.child(childPath).observeSingleEvent(of: .value) {
                (snapshot) in
                var stoppedItems = [String: StoppedItem]()
                guard let data = snapshot.value as? [String:Any] else { self.updateUI(); return}
                for (key, value) in (data) {
                    let stoppingData = value as! Dictionary<String, Any>
                    let stoppedItem = StoppedItem(days: stoppingData["days"] as! Int, stopDate: stoppingData["date"] as! String)
                    stoppedItems[key] = stoppedItem
                }
            SessionController.shared.stoppedItemsUser = stoppedItems
            self.updateUI()
            }
        }
    
    // update user interface
    func updateUI() {
        createStopDetails()
        var animalsSavedString = ""
        var co2SavedString = ""
        var waterSavedString = ""

        // check if values in grams and liters are more than 1000 and transoform to KG or M3 if true
        if SessionController.shared.animalsSavedUser > 1000 {
            let animalsSaved = Float(SessionController.shared.animalsSavedUser) / 1000
            animalsSavedString = "\(String(format: "%.1f", animalsSaved))kg Animals"
        } else {
            animalsSavedString = "\(SessionController.shared.animalsSavedUser)g Animals"
        }
        if SessionController.shared.co2savedUser > 1000 {
            let co2Saved = Float(SessionController.shared.co2savedUser) / 1000
            co2SavedString = "\(String(format: "%.1f", co2Saved))kg CO2"
        } else {
            co2SavedString = "\(SessionController.shared.co2savedUser)g CO2"
        }
        if SessionController.shared.waterSavedUser > 1000 {
            let waterSaved = Float(SessionController.shared.waterSavedUser) / 1000
            waterSavedString = "\(String(format: "%.1f", waterSaved))m3 Water"
        } else {
            waterSavedString = "\(SessionController.shared.waterSavedUser)l Water"
        }
        
        animalLabel.text = animalsSavedString
        co2Label.text = co2SavedString
        waterLabel.text = waterSavedString
        detailsTableView.reloadData()
    }
    
    // create detailed information about the items the user stopped eating
    func createStopDetails() {
        // check if user has any stopped items
        guard SessionController.shared.stoppedItemsUser.count != 0 else {
            return
        }
        var stopDetails = [StopDetail]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let keys = Array(SessionController.shared.stoppedItemsUser.keys)
        let values = Array(SessionController.shared.stoppedItemsUser.values)
        for i in 0...keys.count - 1{
            let description = "Eating no \(keys[i].capitalized) for \(values[i].days) day(s) a week since \(values[i].stopDate)!"
            let dateAsString = values[i].stopDate
            let stopDate = dateFormatter.date(from: dateAsString)!
            let currentDate = Date()
            let components = Calendar.current.dateComponents([.day], from: stopDate, to: currentDate)
            let dayDifference = components.day!
            let daysNotEaten = Float(Float(dayDifference) / 7.00 * Float(values[i].days))
            let co2Saved = Int(daysNotEaten * Float((SessionController.shared.productTypes[keys[i]]?.co2)!))
            let waterSaved = Int(daysNotEaten * Float((SessionController.shared.productTypes[keys[i]]?.water)!))
            let animalsSaved = Int(daysNotEaten * Float((SessionController.shared.productTypes[keys[i]]?.animals)!))
            let stopDetail = StopDetail(description: description, co2saved: co2Saved, animalsSaved: animalsSaved, waterSaved: waterSaved)
            stopDetails.append(stopDetail)
        }
        self.stopDetails = stopDetails.sorted(by: { $0.animalsSaved > $1.animalsSaved })
        print(self.stopDetails)
    }
}
