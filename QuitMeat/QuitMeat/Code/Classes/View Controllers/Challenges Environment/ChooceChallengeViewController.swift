//
//  ChooceChallengeViewController.swift
//  QuitMeat
//
//  Controller of the Choose Challenge View.
//
//  Created by Melle Meewis on 23/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class ChooceChallengeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // declare variables
    var ref: DatabaseReference!
    
    // outlets
    @IBOutlet weak var tableView: UITableView!

    /// retun number of row in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SessionController.shared.challenges.count == 0 {
            return 1
        }
        return SessionController.shared.challenges.count * 2 - 1
    }
    
    /// retun cell in row in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseChallengeCell", for: indexPath) as! ChooseChallengeTableViewCell
            configure(cell, forItemAt: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpacingCell", for: indexPath)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    /// retun height of cell in table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 130
        }
        return 10
    }
    
    /// handle selection row in table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToSingleChallenge", sender: nil)
    }
    
    /// configure cell that represents a challenge in table view
    func configure(_ cell: ChooseChallengeTableViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 20
        
        // check if any challenges are available
        guard SessionController.shared.challenges.count != 0 else  {
            cell.challengeDescriptionLabel.text = "You and your friends have not created any challenges yet."
            cell.pressToCreateLabel.text = "Press the plus button to create one!"
            cell.challengeNameLabel.text = ""
            cell.createdByLabel.text = ""
            cell.creationDateLabel.text = ""
            cell.weeksLabel.text = ""
            cell.challengeProgressBar.setProgress(0, animated: false)
            return
        }
        
        let challenge = SessionController.shared.challenges[indexPath.row / 2]
        cell.challengeDescriptionLabel.text = challenge.descirption
        cell.challengeNameLabel.text = challenge.name
        if challenge.createdBy == SessionController.shared.name {
            cell.createdByLabel.text = "Created By: You"
        } else {
            cell.createdByLabel.text = "Created By: \(challenge.createdBy)"
        }
        cell.creationDateLabel.text = challenge.creationDate
        cell.weeksLabel.text = "Weeks: \(challenge.weeks)"
        cell.pressToCreateLabel.text = ""
        
        // check if user is curretnly participating in this challenge and calculate progress
        if  SessionController.shared.currentChallengesIDsUser.keys.contains(challenge.ID) {
            let startDateAsString = SessionController.shared.currentChallengesIDsUser[challenge.ID]?.startDate.components(separatedBy: ",").first
            let currentDate = Date()
            let dateFormatter = DateFormatter()
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
        // check if user has already completed this challenge
        else if SessionController.shared.completedChallengesIDsUser.keys.contains(challenge.ID) {
            cell.challengeProgressBar.setProgress(1, animated: true)
        }
        else {
            cell.challengeProgressBar.setProgress(0, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // additional set up
        ref = Database.database().reference()
        fetchCurrentChallengesUser()
        fetchCompletedChallengesUser()
        fetchFriendsAndChallenges()
    }
    
    /// Fetch the IDs of the challenges the user is currently participating in
    func fetchCurrentChallengesUser() {
        guard let userID = SessionController.shared.userID else { return }
        ref.child("users/\(userID)/currentChallenges").observeSingleEvent(of: .value, with: { snapshot  in
            var currentChallenges = [String:AcceptedChallenge]()
            guard let data = snapshot.value as? [String:Any] else { SessionController.shared.currentChallengesIDsUser = currentChallenges; return }
            for (key, value) in data {
                guard let dateData = value as? [String] else { return }
                let challengeID = key
                let startDate = dateData[0]
                let goalDate = dateData[1]
                let currentChallenge = AcceptedChallenge(challengeID: challengeID, startDate: startDate, goalDate: goalDate)
                currentChallenges[challengeID] = currentChallenge
            }
            SessionController.shared.currentChallengesIDsUser = currentChallenges
        })
    }
    
    /// Fetch the IDs of the challenges the user has completed
    func fetchCompletedChallengesUser() {
        guard let userID = SessionController.shared.userID else { return }
        ref.child("users/\(userID)/completedChallenges").observeSingleEvent(of: .value, with: { snapshot  in
            var completedChallenges = [String:AcceptedChallenge]()
            guard let data = snapshot.value as? [String:Any] else { SessionController.shared.completedChallengesIDsUser = completedChallenges; return }
            for (key, value) in data {
                guard let dateData = value as? [String] else { return }
                let challengeID = key
                let startDate = dateData[0]
                let goalDate = dateData[1]
                let completedChallenge = AcceptedChallenge(challengeID: challengeID, startDate: startDate, goalDate: goalDate)
                completedChallenges[challengeID] = completedChallenge
            }
            SessionController.shared.completedChallengesIDsUser = completedChallenges
        })
    }
    
    // fetch the friendIDs of user
    func fetchFriendsAndChallenges() {
        guard let userID = SessionController.shared.userID else { return }
        ref.child("users/\(userID)/friends").observeSingleEvent(of: .value, with: { snapshot  in
            guard let data = snapshot.value as? [String:Any] else { self.fetchChallenges(); return }
            var friends = [String]()
            for (key, _) in data {
                friends.append(key)
            }
            SessionController.shared.friendIDs = friends
            self.fetchChallenges()
        })
    }
    
    // fetch challenge objects
    func fetchChallenges() {
        ref.child("challenges").observeSingleEvent(of: .value, with: { snapshot in
            let userID = SessionController.shared.userID!
            print(userID)
            guard let data = snapshot.value as? [String:Any] else { return }
            var challenges = [Challenge]()
            for (key, value) in data {
                if SessionController.shared.friendIDs.contains(key) || key == userID {
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
                        challenges.append(newChallenge)
                    }
                }
            }
            SessionController.shared.challenges = challenges.sorted(by: { $0.creationDate > $1.creationDate })
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // additional setup in destination view controller
        if segue.identifier == "ToSingleChallenge" {
            let singleChallengeViewController = segue.destination as! SingleChallengeViewController
            let index = tableView.indexPathForSelectedRow!.row / 2
            singleChallengeViewController.challenge = SessionController.shared.challenges[index]
        }
    }
}
