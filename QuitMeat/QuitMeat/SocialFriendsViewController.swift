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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        cell.textLabel?.text = friend.name
        cell.backgroundColor = .clear
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print("viewloaded")
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
                    var stopsFriend = [String]()
                    if let stoppedData = friendData["stopped"] as? [String:Any] {
                        for (key, _) in stoppedData {
                            stopsFriend.append(key)
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
                    //  self.updateUI(with: friends)
                })
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
