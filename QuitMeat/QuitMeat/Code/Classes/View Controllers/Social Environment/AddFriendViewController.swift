//
//  AddFriendViewController.swift
//  QuitMeat
//
//  Controller of the Add Friend View.

//
//  Created by Melle Meewis on 15/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class AddFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchUserTableViewCellDelegate {
    
    // Declare Variables
    var ref: DatabaseReference!
    var searchUsers = [SearchUser]()

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newFriendTextField: UITextField!

    // Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func NewFriendTextFieldEdited(_ sender: UITextField) {
        guard let searchText = newFriendTextField.text?.lowercased() else { return }
        findUsers(searchText: searchText)
    }
    
    /// Return the height numbers of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchUsers.count
    }
    
    /// Return the cell in a row in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserCell", for: indexPath) as! SearchUserTableViewCell
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    /// Return the height of a row in table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    /// Configure cell
    func configure(_ cell: SearchUserTableViewCell, forItemAt indexPath: IndexPath) {
        let searchUser = searchUsers[indexPath.row]
        cell.delegate = self
        cell.nameLabel.text = searchUser.name
        cell.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup
        ref = Database.database().reference()
        findUsers(searchText: "")
        }
    
    /// Fetch users with conforming to search string
    func findUsers(searchText: String) {
        ref.child("users").queryOrdered(byChild: "nameAsLower").queryStarting(atValue: searchText).queryEnding(atValue: searchText+"\u{f8ff}").observe(.value, with: { snapshot in
            guard let data = snapshot.value as? [String:Any] else { return }
            var searchUsers = [SearchUser]()
            for (key, value) in data {
                let ID = key
                let userData = value as! Dictionary<String, Any>
                let searchUser = SearchUser(name: userData["name"] as! String, ID: ID)
                searchUsers.append(searchUser)
                
            }
            self.updateUI(with: searchUsers)
        })
    }
    
    /// Update user interface
    func updateUI(with users: [SearchUser]) {
        self.searchUsers = users
        tableView.reloadData()
        
    }
    
    /// Handle button in cell being tapped (delegate function)
    func addFriendTapped(sender: SearchUserTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            let newFriend = searchUsers[indexPath.row]
            let newFriendId = newFriend.ID
            let newFriendName = newFriend.name
            let returnValue = addFriend(with: newFriendId, newFriendName: newFriendName)
            if returnValue == 1 {
                self.dismiss(animated: false, completion: nil)
            }
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    /// Add friend to database
    func addFriend(with friendID: String, newFriendName: String) -> Int {
        guard let userID = SessionController.shared.userID else { return 1 }
        guard let name = SessionController.shared.name else { return 1 }
        guard userID != friendID else { return 1 }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        let date = Date()
        let eventDate = dateFormatter.string(from: date).replacingOccurrences(of: "/", with: "-")
        let eventDescription = "\(name) became friends with \(newFriendName)!"
        let childupdates = ["/users/\(userID)/friends/\(friendID)":  "true", "/events/\(userID)/\(eventDate)": eventDescription] as [String : Any]
        ref.updateChildValues(childupdates) { (error: Error?, ref: DatabaseReference) in
            self.dismiss(animated: false, completion: nil)
        }
        return 0
    }
}
