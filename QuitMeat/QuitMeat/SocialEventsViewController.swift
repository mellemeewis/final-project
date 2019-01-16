//
//  SocialEventsViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 15/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class SocialEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var events = [Event]()
    var friendIDs = [String]()
    var ref: DatabaseReference!
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count * 2 - 1
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 110
        }
        return 10
    }
    

    func configure(_ cell: EventTableViewCell, forItemAt indexPath: IndexPath) {
        let currentUserName = SessionController.shared.name!
        let event = events[indexPath.row / 2]
        cell.dateLabel.text = event.date
        var description = event.description
        if description.components(separatedBy: " ").first == currentUserName {
            description = description.replacingOccurrences(of: currentUserName, with: "You")
        }
        cell.eventLabel.text = description
        cell.nameLabel.text = event.name
        cell.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        fetchFriendsAndEvents()
    }
    
    func fetchEvents() {
        ref.child("events").observeSingleEvent(of: .value, with: {snapshot in
            let userID = SessionController.shared.userID!
            guard let data = snapshot.value as? [String:Any] else { return }
            var events = [Event]()
            for (key, value) in data {
                if self.friendIDs.contains(key) || key == userID {
                    guard let eventData = value as? [String:Any] else { return }
                    for (key, value) in eventData {
                        let date = key
                        let description = value as! String
                        let newEvent = Event(date: date, description: description)
                        events.append(newEvent)
                    }
                }
            }
            self.updateUI(with: events)
        })
    }
    
    func fetchFriendsAndEvents() {
        guard let userID = SessionController.shared.userID else { return }
        ref.child("users/\(userID)/friends").observeSingleEvent(of: .value, with: { snapshot
            in
            guard let data = snapshot.value as? [String:Any] else { return }
            var friends = [String]()
            for (key, _) in data {
                friends.append(key)
            }
            self.friendIDs = friends
            self.fetchEvents()
        })
    }
    
    func updateUI(with events: [Event]) {
        self.events = events.sorted(by: { $0.date > $1.date })
        tableView.reloadData()
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
