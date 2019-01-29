//
//  SocialFriendsViewController.swift
//  QuitMeat
//
//  Controller of the Friends View.
//
//  Created by Melle Meewis on 15/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class SocialFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // declare variables
    var friends = [User]()
    var ref: DatabaseReference!
    
    // outlets
    @IBOutlet weak var tableView: UITableView!

    /// handle selection row in tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ToSingleFriendSegue", sender: nil)
    }
    
    /// return number of row in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count + 1
    }
    
    /// retun cell in row in tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendInfoCell", for: indexPath) as! FriendInfoTableViewCell
            configure(cell, forItemAt: indexPath)
            return cell
        }
    }
    
    /// configure cell in row in tableview
    func configure(_ cell: FriendInfoTableViewCell, forItemAt indexPath: IndexPath) {
        let friend = friends[indexPath.row - 1]
        cell.nameLabel.text = friend.name
        cell.animalLabel.text = String(friend.animalsSaved)
        cell.co2Label.text = String(friend.co2Saved)
        cell.waterLabel.text = String(friend.waterSaved)
        cell.backgroundColor = .clear
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // additional setup
        ref = Database.database().reference()
        fetchFriends()
    }
    
    /// fetch friends user from database
    func fetchFriends() {
        guard let userID = SessionController.shared.userID else { return }
        ref.child("users/\(userID)/friends").observeSingleEvent(of: .value, with: { snapshot
            in
            // check if user has any friends
            guard let data = snapshot.value as? [String:Any] else { return }
            var friends = [User]()
            for (key, _) in data {
                let friendID = key
                self.ref.child("users/\(friendID)").observeSingleEvent(of: .value, with: { snapshot
                    in
                    guard let friendData = snapshot.value as? [String:Any] else { return }
                    let friendName = friendData["name"] as! String
                    var stopsFriend = [String:StoppedItem]()
                    if let stoppedData = friendData["stopped"] as? [String:Any] {
                        for (key, value) in stoppedData {
                            print(value)
                            if let stoppedItemData = value as? [String:Any] {
                                print(stoppedItemData)
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
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSingleFriendSegue" {
            // additional setup in destination view controller
            let singleFriendViewController = segue.destination as! SingleFriendViewController
            let index = tableView.indexPathForSelectedRow!.row - 1
            let selectedFriend = friends[index]
            singleFriendViewController.friend = selectedFriend
        }
    }
}