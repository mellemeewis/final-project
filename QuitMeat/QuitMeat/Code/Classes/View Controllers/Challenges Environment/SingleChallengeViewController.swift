//
//  SingleChallengeViewController.swift
//  QuitMeat
//
//  Controller of the Single Challenge View.
//
//  Created by Melle Meewis on 23/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class SingleChallengeViewController: UIViewController {

    // declare variables
    var ref: DatabaseReference!
    var challenge: Challenge!
    let dateFormatter = DateFormatter()
    
    // outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var savingsLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var savingsHeaderLabel: UILabel!
    @IBOutlet weak var startDateHeaderLabel: UILabel!
    @IBOutlet weak var stopDateLabel: UILabel!
    
    @IBOutlet weak var stopDateHeaderLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var acceptChallengeButton: UIButton!
    
    // actions
    @IBAction func acceptChallengeButtonTapped(_ sender: UIButton) {
        switch acceptChallengeButton.titleLabel?.text {
        case "Accept Challenge!":
            acceptChallenge()
        case "Quit Challenge":
            quitChallenge(with: "quit")
        case "Forget Challenge":
            quitChallenge(with: "forget")
        default:
            return
        }
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // additional setup
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // check if challenges is new, current, or completed for user
        if SessionController.shared.completedChallengesIDsUser.keys.contains(challenge.ID) {
            updateUI(with: "completedChallenge")
        } else if SessionController.shared.currentChallengesIDsUser.keys.contains(challenge.ID) {
            updateUI(with: "currentChallenge")
        } else {
            updateUI(with: "newChallenge")
        }
    }
    
    /// Update user interface
    func updateUI(with challengeType: String) {
        acceptChallengeButton.layer.cornerRadius = 30
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        titleLabel.text = challenge.name
        descriptionLabel.text = challenge.descirption
        createdLabel.text = "Created By \(challenge.createdBy) on \(challenge.creationDate)"
        savingsLabel.text = "\(challenge.animalSavings) \(challenge.productType.capitalized)s\n\(challenge.waterSavings) liters of water\n\(challenge.co2Savings) KG of CO2"
        
        // check if challenges is new, current, or completed for user
        if challengeType == "newChallenge" {
            let date = Date()
            let dateAsString = dateFormatter.string(from: date)
            let goalDateAsString = dateFormatter.string(from: challenge.goalDate)
            startDateLabel.text = dateAsString
            stopDateLabel.text = goalDateAsString
            savingsHeaderLabel.text = "This Will Save:"
            stopDateHeaderLabel.text = "Goal Date:"
            startDateHeaderLabel.text = "Start Date:"
            acceptChallengeButton.setTitle("Accept Challenge!", for: .normal)
            
        } else if challengeType == "currentChallenge" {
            acceptChallengeButton.setTitle("Quit Challenge", for: .normal)
            acceptChallengeButton.backgroundColor = UIColor.init(displayP3Red: 0.6, green: 0, blue: 0, alpha: 1)
            let startDate = SessionController.shared.currentChallengesIDsUser[challenge.ID]?.startDate
            let goalDate = SessionController.shared.currentChallengesIDsUser[challenge.ID]?.goalDate
            startDateHeaderLabel.text = "Started on:"
            startDateLabel.text = startDate
            stopDateLabel.text = goalDate
            savingsHeaderLabel.text = "This Saves:"
            stopDateHeaderLabel.text = "Goal Date:"

        } else if challengeType == "completedChallenge" {
            acceptChallengeButton.setTitle("Forget Challenge", for: .normal)
            let startDate = SessionController.shared.completedChallengesIDsUser[challenge.ID]?.startDate.components(separatedBy: ",").first
            let completionDate = SessionController.shared.completedChallengesIDsUser[challenge.ID]?.goalDate.components(separatedBy: ",").first
            startDateHeaderLabel.text = "Started on:"
            startDateLabel.text = startDate
            stopDateLabel.text = completionDate
            savingsHeaderLabel.text = "This Saved:"
            stopDateHeaderLabel.text = "Completed on:"
        }
    }
    
    /// Add challenge to database as accepted challenge user
    func acceptChallenge() {
        guard let userID = SessionController.shared.userID else { return }
        guard let name = SessionController.shared.name else { return }
        let challengeName = challenge.name
        let date = Date()
        var dateComponent = DateComponents()
        dateComponent.day = challenge.weeks * 7
        let goalDate = Calendar.current.date(byAdding: dateComponent, to: date)
        dateFormatter.timeStyle = .medium
        let dateAndTimeAsString = dateFormatter.string(from: date).replacingOccurrences(of: "/", with: "-")
        let goalDateAsString = dateFormatter.string(from: goalDate!).replacingOccurrences(of: "/", with: "-")
        dateFormatter.timeStyle = .none
        let challengeID = challenge.ID
        let eventDescription = "\(name) accepted the challenge '\(challengeName)!'"
        let childupdates = ["/users/\(userID)/currentChallenges/\(challengeID)":  [dateAndTimeAsString, goalDateAsString], "/events/\(userID)/\(dateAndTimeAsString)": eventDescription] as [String : Any]
        print(childupdates)
        ref.updateChildValues(childupdates) { (error: Error?, ref: DatabaseReference) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    /// Remove challenge as current or completed challenge user in database
    func quitChallenge(with quitType: String) {
        guard let userID = SessionController.shared.userID else { return }
        guard let name = SessionController.shared.name else { return }
        let challengeName = challenge.name
        let date = Date()
        dateFormatter.timeStyle = .medium
        let dateAndTimeAsString = dateFormatter.string(from: date).replacingOccurrences(of: "/", with: "-")
        dateFormatter.timeStyle = .none
        let challengeID = challenge.ID
        
        // check if challenges should be forgotten or quit
        if quitType == "quit" {
            let eventDescription = "\(name) quitted the challenge '\(challengeName)!'"
            let childupdates = ["/users/\(userID)/currentChallenges/\(challengeID)":  nil, "/events/\(userID)/\(dateAndTimeAsString)": eventDescription] as [String : Any]
            ref.updateChildValues(childupdates) { (error: Error?, ref: DatabaseReference) in
                self.dismiss(animated: false, completion: nil)
            }
        } else if quitType == "forget" {
            ref.child("/users/\(userID)/completedChallenges/\(challengeID)").removeValue() { (error: Error?, ref: DatabaseReference) in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
