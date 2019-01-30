//
//  ChallengesUserViewController.swift
//  QuitMeat
//
//  Controller of the Challenges the user participates in View.
//
//  Created by Melle Meewis on 23/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class ChallengesUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // Declare variables
    var dateFormatter = DateFormatter()
    var challengeToPass: Challenge?
    var orderedCurrentChallengesIDs =  [(key: String, value: AcceptedChallenge)]()
    var orderdCompletedChallengesIDs = [(key: String, value: AcceptedChallenge)]()
    var ref: DatabaseReference!
    
    // Outlets
    @IBOutlet weak var currentChallengesTableView: UITableView!
    @IBOutlet weak var completedChallengesTableView: UITableView!
   
    /// Return number of row in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case currentChallengesTableView:
            guard SessionController.shared.currentChallengesIDsUser.count != 0 else { return 1}
            return SessionController.shared.currentChallengesIDsUser.count * 2 - 1
        case completedChallengesTableView:
            guard SessionController.shared.completedChallengesIDsUser.count != 0 else { return 1 }
            return SessionController.shared.completedChallengesIDsUser.count * 2 - 1
        default:
            return 0
            }
        }
    
    /// Return cell in row in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath) as! ChooseChallengeTableViewCell
            if tableView == currentChallengesTableView {
                configureCurrentChallengeCell(cell, forItemAt: indexPath)
            } else if tableView == completedChallengesTableView {
                configureCompletedChallengeCell(cell, forItemAt: indexPath)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpacingCell", for: indexPath)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    /// Return height of cell in table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 130
        }
        return 10
    }
    
    /// Handle selection row in table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == currentChallengesTableView {
            let challengeID = orderedCurrentChallengesIDs[indexPath.row / 2].key
            challengeToPass = SessionController.shared.currentChallengesObjectsUser.first(where: { $0.ID == challengeID })
        } else {
            let challengeID = orderdCompletedChallengesIDs[indexPath.row / 2].key
            challengeToPass = SessionController.shared.completedChallengesObjectsUser.first(where: { $0.ID == challengeID })
        }
        performSegue(withIdentifier: "ToSingleChallenge", sender: nil)
    }
    
    /// Configure a cell representing a challenge a user is currently participating in
    func configureCurrentChallengeCell(_ cell: ChooseChallengeTableViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 20
        
        // Check if user is currently participating in any challenges
        guard SessionController.shared.currentChallengesIDsUser.count != 0 else {
            cell.challengeDescriptionLabel.text = "You have no current challenges."
            cell.pressToCreateLabel.text = "Swipe right to choose or add a challenges!"
            cell.challengeNameLabel.text = ""
            cell.createdByLabel.text = ""
            cell.creationDateLabel.text = ""
            cell.weeksLabel.text = ""
            cell.challengeProgressBar.setProgress(0, animated: false)
            currentChallengesTableView.allowsSelection = false
            return
        }
        
        currentChallengesTableView.allowsSelection = true
        let challengeID = orderedCurrentChallengesIDs[indexPath.row / 2].key
        guard let challenge = SessionController.shared.currentChallengesObjectsUser.first(where: { $0.ID == challengeID }) else { return }
        let startDateAsString = SessionController.shared.currentChallengesIDsUser[challengeID]?.startDate.components(separatedBy: ",").first
        let goalDate = SessionController.shared.currentChallengesIDsUser[challengeID]?.goalDate.components(separatedBy: ",").first
        cell.challengeDescriptionLabel.text = challenge.descirption
        cell.challengeNameLabel.text = challenge.name
        if challenge.createdBy == SessionController.shared.name {
            cell.createdByLabel.text = "Created By: You"
        } else {
            cell.createdByLabel.text = "Created By: \(challenge.createdBy)"
        }
        cell.creationDateLabel.text = "Started on: \(startDateAsString!)"
        cell.weeksLabel.text = "Goal Date: \(goalDate!)"
        cell.pressToCreateLabel.text = ""

        // calculate progress current challenge
        let currentDate = Date()
        dateFormatter.dateStyle = .short
        let startDate = dateFormatter.date(from: startDateAsString!)
        let components = Calendar.current.dateComponents([.day], from: startDate!, to: currentDate)
        let dayDifference = components.day!
        let totalDaysChallenge = 7 * challenge.weeks
        var challengeProgress = Float(dayDifference) / Float(totalDaysChallenge)
        if challengeProgress < 0.1 {
            challengeProgress = 0.1
        }
        cell.challengeProgressBar.setProgress(challengeProgress, animated: true)
    }
    
    /// Configure a cell representing a challenge a has completed
    func configureCompletedChallengeCell(_ cell: ChooseChallengeTableViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 20
        
        // check if user has completed any challenges yet
        guard SessionController.shared.completedChallengesIDsUser.count != 0 else {
            cell.challengeDescriptionLabel.text =  "You have no completed challenges yet."
            completedChallengesTableView.allowsSelection = false
            cell.challengeNameLabel.text = ""
            cell.createdByLabel.text = ""
            cell.creationDateLabel.text = ""
            cell.weeksLabel.text = ""
            cell.challengeProgressBar.setProgress(0, animated: false)
            return
        }
        
        completedChallengesTableView.allowsSelection = true
        let challengeID = orderdCompletedChallengesIDs[indexPath.row / 2].key
        guard let challenge = SessionController.shared.completedChallengesObjectsUser.first(where: { $0.ID == challengeID }) else { return }
        let startDate = SessionController.shared.completedChallengesIDsUser[challengeID]?.startDate.components(separatedBy: ",").first
        let goalDate = SessionController.shared.completedChallengesIDsUser[challengeID]?.goalDate.components(separatedBy: ",").first
        cell.challengeDescriptionLabel.text = challenge.descirption
        cell.challengeNameLabel.text = challenge.name
        cell.createdByLabel.text = "Created By: \(challenge.createdBy)"
        cell.creationDateLabel.text = "Started on: \(startDate!)"
        cell.weeksLabel.text = "Completed on: \(goalDate!)"
        cell.challengeProgressBar.setProgress(1, animated: false)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // additional setup
        orderedCurrentChallengesIDs = SessionController.shared.currentChallengesIDsUser.sorted(by: { $0.value.goalDate > $1.value.goalDate })
        orderdCompletedChallengesIDs = SessionController.shared.completedChallengesIDsUser.sorted(by: { $0.value.goalDate > $1.value.goalDate })
        fetchCurrentChallengesIDsUser()
        }
    
    /// Fetch the IDs of the challenges the user is currently participating in
    func fetchCurrentChallengesIDsUser() {
        guard let userID = SessionController.shared.userID else { return }
        ref.child("users/\(userID)/currentChallenges").observeSingleEvent(of: .value, with: { snapshot  in
            var currentChallenges = [String:AcceptedChallenge]()
            
            // check if user is currently participating in any challenges.
            guard let data = snapshot.value as? [String:Any] else { SessionController.shared.currentChallengesIDsUser = currentChallenges; self.fetchCompletedChallengesIDsUser(); return }
            
            for (key, value) in data {
                guard let dateData = value as? [String] else { return }
                let challengeID = key
                let startDateAsString = dateData[0]
                let goalDateAsString = dateData[1]
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .medium
                dateFormatter.dateStyle = .short
                let currentDate = Date()
                let goalDate = dateFormatter.date(from: goalDateAsString)
                
                // check if current challenges is past goal date and should move to completed
                if goalDate! < currentDate {
                    let currentDateAsString = dateFormatter.string(from: currentDate).replacingOccurrences(of: "/", with: "-")
                    let userName = SessionController.shared.name!
                    let eventDescription = "\(userName) just completed a challenge!"
                    let childUpdates = ["/users/\(userID)/completedChallenges/\(challengeID)":
                                        [startDateAsString, goalDateAsString],
                                        "/users/\(userID)/currentChallenges/\(challengeID)": nil,
                                        "/events/\(userID)/\(currentDateAsString)": eventDescription] as [String : Any?]
                    self.ref.updateChildValues(childUpdates)
                }
                else {
                    let currentChallenge = AcceptedChallenge(challengeID: challengeID, startDate: startDateAsString, goalDate: goalDateAsString)
                    currentChallenges[challengeID] = currentChallenge
                }
            }
            SessionController.shared.currentChallengesIDsUser = currentChallenges
            self.fetchCompletedChallengesIDsUser()
        })
    }
    
    /// Fetch the IDs of the challenges the user has completed
    func fetchCompletedChallengesIDsUser() {
        guard let userID = SessionController.shared.userID else { return }
        ref.child("users/\(userID)/completedChallenges").observeSingleEvent(of: .value, with: { snapshot  in
            var completedChallenges = [String:AcceptedChallenge]()
            // check if user has any completed challenges
            guard let data = snapshot.value as? [String:Any] else { SessionController.shared.completedChallengesIDsUser = completedChallenges; self.fetchChallenges(); return }
            
            for (key, value) in data {
                guard let dateData = value as? [String] else { return }
                let challengeID = key
                let startDate = dateData[0]
                let goalDate = dateData[1]
                let completedChallenge = AcceptedChallenge(challengeID: challengeID, startDate: startDate, goalDate: goalDate)
                completedChallenges[challengeID] = completedChallenge
            }
            SessionController.shared.completedChallengesIDsUser = completedChallenges
            self.fetchChallenges()
        })
    }
    
    /// Fetch challenges objects
    func fetchChallenges() {
        ref.child("challenges").observeSingleEvent(of: .value, with: { snapshot in
            guard let data = snapshot.value as? [String:Any] else { return }
            var currentChallenges = [Challenge]()
            var completedChallenges = [Challenge]()
            for (_, value) in data {
                guard let challengeData = value as? [String:Any] else { return }
                for (key, value) in challengeData {
                    guard let challengeDetails = value as? [String:Any] else { return }
                    let creationDate = challengeDetails["creationDate"] as! String
                    let challengeName = challengeDetails["name"] as! String
                    let challengeDescription = challengeDetails["description"] as! String
                    let daysAWeek = challengeDetails["days"] as! Int
                    let productType = challengeDetails["productType"] as! String
                    let weeks = challengeDetails["weeks"] as! Int
                    let createdBy = challengeDetails["createdBy"] as! String
                    let challengeID = key
                    let newChallenge = Challenge(ID: challengeID, creationDate: creationDate, name: challengeName, createdBy: createdBy, descirption: challengeDescription, daysAWeek: daysAWeek, productType: productType, weeks: weeks)
                    if SessionController.shared.currentChallengesIDsUser.keys.contains(challengeID) {
                        currentChallenges.append(newChallenge)
                    } else if SessionController.shared.completedChallengesIDsUser.keys.contains(challengeID) {
                        completedChallenges.append(newChallenge)
                    }
                }
            }
            SessionController.shared.currentChallengesObjectsUser = currentChallenges
            SessionController.shared.completedChallengesObjectsUser = completedChallenges
            self.updateUI()
        })
    }
    
    /// Update user interface
    func updateUI() {
        orderedCurrentChallengesIDs = SessionController.shared.currentChallengesIDsUser.sorted(by: { $0.value.goalDate > $1.value.goalDate })
        orderdCompletedChallengesIDs = SessionController.shared.completedChallengesIDsUser.sorted(by: { $0.value.goalDate > $1.value.goalDate })
        currentChallengesTableView.reloadData()
        completedChallengesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // additional setup in destination view controller
        if segue.identifier == "ToSingleChallenge" {
            let singleChallengeViewController = segue.destination as! SingleChallengeViewController
            singleChallengeViewController.challenge = challengeToPass
        }
    }
    
}


