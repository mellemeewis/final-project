//
//  SingleFriendViewController.swift
//  QuitMeat
//
//  Controller of the Single Friend View.
//
//  Created by Melle Meewis on 28/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import Firebase
import UIKit


class SingleFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // declare variables
    var ref: DatabaseReference!
    var friend: User!
    var friends = [User]()
    var stopDetails = [StopDetail]()
    
    // outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var animalLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var stoppedTableView: UITableView!
    
    @IBOutlet weak var friendButton: UIButton!
    
    // actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func friendButtonTapped(_ sender: UIButton) {
        let userID = SessionController.shared.userID!
        ref.child("/users/\(userID)/friends/\(friend.ID)").removeValue()
        self.dismiss(animated: false, completion: nil)
    }
    
    // return number of row in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == stoppedTableView {
            guard stopDetails.count != 0 else { return 3 }
            return ((stopDetails.count + 1) * 2 - 1)
        } else {
            return self.friends.count + 1
        }
    }
    
    // return cell in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // check if table view is stopped table view or friendstableview
        if tableView == stoppedTableView {
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
                    cell.descriptionLabel.text = "\(friend.name) is currently not participating in any challenges."
                }
                cell.animalLabel.text = ""
                cell.co2Label.text = ""
                cell.waterLabel.text = ""
                cell.selectionStyle = .default
            }
            // set rest of cells table view
            else {
                if stopDetails.count == 0 {
                    cell.descriptionLabel.text = "\(friend.name) did not start consuming less meet yet!"
                    cell.co2Label.text = ""
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
                }
            }
            cell.selectionStyle = .none
            cell.layer.cornerRadius = 20
            return cell
        } else  { // friends table view
            // check if user has any friends
            guard friends.count != 0 else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FriendInfoCell", for: indexPath) as! FriendInfoTableViewCell
                cell.textLabel?.text = "\(friend.name) doesn't have any friends yet!"
                cell.textLabel?.font = UIFont(name: "Marker Felt", size: 17)
                cell.nameLabel.text = ""
                cell.animalLabel.text = ""
                cell.co2Label.text = ""
                cell.waterLabel.text = ""
                cell.selectionStyle = .none
                return cell
            }
            // set up header cell
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")!
                cell.selectionStyle = .none
                cell.textLabel?.text = ""
                return cell
            }
            // set up rest of cells
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FriendInfoCell", for: indexPath) as! FriendInfoTableViewCell
                let friend = friends[indexPath.row - 1]
                cell.textLabel?.text = ""
                cell.nameLabel.text = friend.name
                
                var animalsSavedString = ""
                var co2SavedString = ""
                var waterSavedString = ""
                
                // check if values in grams and liters are more than 1000 and transoform to KG or M3 if true
                if friend.animalsSaved > 1000 {
                    let animalsSaved = Float(friend.animalsSaved) / 1000
                    animalsSavedString = "\(String(format: "%.1f", animalsSaved))kg"
                } else {
                    animalsSavedString = "\(friend.animalsSaved)g"
                }
                if friend.co2Saved > 1000 {
                    let co2Saved = Float(friend.co2Saved) / 1000
                    co2SavedString = "\(String(format: "%.1f", co2Saved))kg"
                } else {
                    co2SavedString = "\(friend.co2Saved)g"
                }
                if friend.waterSaved > 1000 {
                    let waterSaved = Float(friend.waterSaved) / 1000
                    waterSavedString = "\(String(format: "%.1f", waterSaved))m3"
                } else {
                    waterSavedString = "\(friend.waterSaved)l"
                }
                cell.animalLabel.text = animalsSavedString
                cell.co2Label.text = co2SavedString
                cell.waterLabel.text = waterSavedString
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    /// return height of cell in tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == stoppedTableView {
            if indexPath.row % 2 == 0 {
                return 80
            }
            return 10
        } else {
            return 40
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // additional setup
        ref = Database.database().reference()
        createStopDetails()
        fetchFriends()
        updateUI()
        friendButton.layer.cornerRadius = 20
        friendButton.backgroundColor = UIColor.init(displayP3Red: 0.6, green: 0, blue: 0, alpha: 1)
    }
    
    /// update user interface
    func updateUI() {
        nameLabel.text = friend.name
        
        
        var animalsSavedString = ""
        var co2SavedString = ""
        var waterSavedString = ""
        
        // check if values in grams and liters are more than 1000 and transoform to KG or M3 if true
        if friend.animalsSaved > 1000 {
            let animalsSaved = Float(friend.animalsSaved) / 1000
            animalsSavedString = "\(String(format: "%.1f", animalsSaved))kg Animals"
        } else {
            animalsSavedString = "\(friend.animalsSaved)g Animals"
        }
        if friend.co2Saved > 1000 {
            let co2Saved = Float(friend.co2Saved) / 1000
            co2SavedString = "\(String(format: "%.1f", co2Saved))kg CO2"
        } else {
            co2SavedString = "\(friend.co2Saved)g CO2"
        }
        if friend.waterSaved > 1000 {
            let waterSaved = Float(friend.waterSaved) / 1000
            waterSavedString = "\(String(format: "%.1f", waterSaved))m3 Water"
        } else {
            waterSavedString = "\(friend.waterSaved)l Water"
        }
        
        animalLabel.text = animalsSavedString
        co2Label.text = co2SavedString
        waterLabel.text = waterSavedString
    }

    
    /// create detailed inforbation about stopped product types users
    func createStopDetails() {
        // check if user has any stopped items
        guard friend.stoppedItems.count != 0 else {
            self.stoppedTableView.reloadData()
            return
        }
        var stopDetails = [StopDetail]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let keys = Array(friend.stoppedItems.keys)
        let values = Array(friend.stoppedItems.values)
        for i in 0...keys.count - 1 {
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
        self.stoppedTableView.reloadData()
    }
    
    /// fetch friend IDs user
    func fetchFriends() {
        var friends = [User]()
        for friendID in friend.friends {
            self.ref.child("users/\(friendID)").observeSingleEvent(of: .value, with: { snapshot
                in
                // check if user has any friens
                guard let friendData = snapshot.value as? [String:Any] else { self.friendsTableView.reloadData(); return }
                let friendName = friendData["name"] as! String
                var stopsFriend = [String:StoppedItem]()
                if let stoppedData = friendData["stopped"] as? [String:Any] {
                    for (key, value) in stoppedData {
                        if let stoppedItemData = value as? [String:Any] {
                            let days = stoppedItemData["days"] as! Int
                            let stopDate = stoppedItemData["date"] as! String
                            let stoppedItemFriend = StoppedItem(days: days, stopDate: stopDate)
                            stopsFriend[key] = stoppedItemFriend
                        }
                    }
                }
                var friendsFriend = [String]()
                if let friendsData = friendData["friends"] as? [String:Any] {
                    for (key, _) in friendsData {
                        friendsFriend.append(key)
                    }
                }
                let newFriend = User(name: friendName, ID: friendID, stoppedItems: stopsFriend, friends: friendsFriend)
                friends.append(newFriend)
                self.friends = friends
                self.friendsTableView.reloadData()
            })
        }
    }
}
