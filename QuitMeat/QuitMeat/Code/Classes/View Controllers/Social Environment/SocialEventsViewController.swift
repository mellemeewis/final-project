//
//  SocialEventsViewController.swift
//  QuitMeat
//
//  Controller of Social Events View.
//
//  Created by Melle Meewis on 15/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class SocialEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Declare variables
    var ref: DatabaseReference!
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Return number of row in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SessionController.shared.events.count * 2 - 1
    }
    
    // Return cell in row in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
            configure(cell, forItemAt: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpacingCell", for: indexPath)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    // Return height of cell in table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 110
        }
        return 10
    }
    
    // Configure event cell
    func configure(_ cell: EventTableViewCell, forItemAt indexPath: IndexPath) {
        let currentUserName = SessionController.shared.name!
        let event = SessionController.shared.events[indexPath.row / 2]
        cell.dateLabel.text = event.date
        var description = event.description
        if description.components(separatedBy: " ").first == currentUserName {
            description = description.replacingOccurrences(of: currentUserName, with: "You")
        }
        cell.eventLabel.text = description
        cell.nameLabel.text = event.name
        cell.layer.cornerRadius = 20
        cell.selectionStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // additional setup
        ref = Database.database().reference()
        fetchFriendsAndEvents()
    }
    
    /// Fetch friendIDs user
    func fetchFriendsAndEvents() {
        guard let userID = SessionController.shared.userID else { return }
        ref.child("users/\(userID)/friends").observeSingleEvent(of: .value, with: { snapshot
            in
            guard let data = snapshot.value as? [String:Any] else { self.fetchEvents(); return }
            var friends = [String]()
            for (key, _) in data {
                friends.append(key)
            }
            SessionController.shared.friendIDs = friends
            self.fetchEvents()
        })
    }
    
    /// Fetch events occured in social environment user
    func fetchEvents() {
        ref.child("events").observeSingleEvent(of: .value, with: {snapshot in
            let userID = SessionController.shared.userID!
            guard let data = snapshot.value as? [String:Any] else { return }
            var events = [Event]()
            for (key, value) in data {
                if SessionController.shared.friendIDs.contains(key) || key == userID {
                    guard let eventData = value as? [String:Any] else { return }
                    for (key, value) in eventData {
                        let date = key
                        let description = value as! String
                        let newEvent = Event(date: date, description: description)
                        events.append(newEvent)
                    }
                }
            }
            SessionController.shared.events = events.sorted(by: { $0.date > $1.date })
            self.tableView.reloadData()
        })
    }
}
