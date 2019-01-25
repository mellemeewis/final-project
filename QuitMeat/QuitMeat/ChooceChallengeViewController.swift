//
//  ChooceChallengeViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 23/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class ChooceChallengeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SessionController.shared.challenges.count * 2 - 1
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 130
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToSingleChallenge", sender: nil)
    }
    
    func configure(_ cell: ChooseChallengeTableViewCell, forItemAt indexPath: IndexPath) {
        let challenge = SessionController.shared.challenges[indexPath.row / 2]
        cell.challengeDescriptionLabel.text = challenge.descirption
        cell.challengeNameLabel.text = challenge.name
        cell.createdByLabel.text = "Created By: \(challenge.createdBy)"
        cell.creationDateLabel.text = challenge.creationDate
        cell.weeksLabel.text = "Weeks: \(challenge.weeks)"
        cell.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        fetchCurrentChallengesUser()
        fetchCompletedChallengesUser()
        fetchFriendsAndChallenges()
    }
    
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
            self.updateUI()
        })
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSingleChallenge" {
            let singleChallengeViewController = segue.destination as! SingleChallengeViewController
            let index = tableView.indexPathForSelectedRow!.row / 2
            singleChallengeViewController.challenge = SessionController.shared.challenges[index]
        }
    }
}
