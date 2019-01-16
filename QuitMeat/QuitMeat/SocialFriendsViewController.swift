//
//  SocialFriendsViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 15/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class SocialFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friends = [User]()
    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = friends[indexPath.row - 1]
        print(selectedUser.name)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count + 1
    }
    
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
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        fetchFriends()
    }
    
    func fetchFriends() {
        guard let userID = SessionController.shared.userID else { return }
        print("1")
        ref.child("users/\(userID)/friends").observeSingleEvent(of: .value, with: { snapshot
            in
            guard let data = snapshot.value as? [String:Any] else { return }
            print(data)
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
                                print(stoppedItemFriend)
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
                    print(friends)
                    self.updateUI(with: friends)
                })
            }
        })
    }
    
    func updateUI(with friends: [User]) {
        self.friends = friends
        print(self.friends)
        tableView.reloadData()
    }

}
