//
//  AddFriendViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 15/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class AddFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchUserTableViewCellDelegate {
    
    var ref: DatabaseReference!
    var searchUsers = [SearchUser]()

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newFriendTextField: UITextField!
    
    
    
    @IBAction func NewFriendTextFieldEdited(_ sender: UITextField) {
        guard let searchText = newFriendTextField.text?.lowercased() else { return }
        findUsers(searchText: searchText)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NUmbersoverows")
        return searchUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserCell", for: indexPath) as! SearchUserTableViewCell
        
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func configure(_ cell: SearchUserTableViewCell, forItemAt indexPath: IndexPath) {
        let searchUser = searchUsers[indexPath.row]
        cell.delegate = self
        cell.nameLabel.text = searchUser.name
        cell.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }
    
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
            print(searchUsers)
            self.updateUI(with: searchUsers)
        })
    }
    
    func updateUI(with users: [SearchUser]) {
        self.searchUsers = users
        print("HI")
        print(self.searchUsers)
        tableView.reloadData()
        
    }
    
    func addFriendTapped(sender: SearchUserTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            let newFriend = searchUsers[indexPath.row]
            let newFriendId = newFriend.ID
            addFriend(with: newFriendId)
        }
    }
    
    func addFriend(with friendID: String) {
        guard let userID = SessionController.shared.userID else { return }
        guard userID != friendID else { return }
        ref.child("users/\(userID)/friends/").updateChildValues([friendID:"true"])
        self.dismiss(animated: false, completion: nil)
    }
}
