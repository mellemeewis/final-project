//
//  SingleChallengeViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 23/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class SingleChallengeViewController: UIViewController {

    var ref: DatabaseReference!
    var challenge: Challenge!
    let dateFormatter = DateFormatter()
    
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
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if SessionController.shared.completedChallengesUsers.keys.contains(challenge.ID) {
            updateUI(with: "completedChallenge")
        } else if SessionController.shared.currentChallengesUser.keys.contains(challenge.ID) {
            print("hoi")
            print(SessionController.shared.currentChallengesUser)
            print("HI")
            updateUI(with: "currentChallenge")
        } else {
            updateUI(with: "newChallenge")
        }
    }
    
    func updateUI(with challengeType: String) {
        
        acceptChallengeButton.layer.cornerRadius = 30
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        titleLabel.text = challenge.name
        descriptionLabel.text = challenge.descirption
        createdLabel.text = "Created By \(challenge.createdBy) on \(challenge.creationDate)"
        savingsLabel.text = "\(challenge.animalSavings) \(challenge.productType.capitalized)s\n\(challenge.waterSavings) liters of water\n\(challenge.co2Savings) KG of CO2"
        
        
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
            startDateHeaderLabel.text = "Started on:"
            let startDateAsString = SessionController.shared.currentChallengesUser[challenge.ID]?.replacingOccurrences(of: "-", with: "/").components(separatedBy: ",").first
            let startDate = dateFormatter.date(from: startDateAsString!)
            var dateComponent = DateComponents()
            dateComponent.day = challenge.weeks * 7
            let goalDate = Calendar.current.date(byAdding: dateComponent, to: startDate!)
            let goalDateAsString = dateFormatter.string(from: goalDate!)
            startDateLabel.text = startDateAsString
            stopDateLabel.text = goalDateAsString

        } else if challengeType == "completedChallenge" {
            acceptChallengeButton.setTitle("Forget Challenge", for: .normal)
        }
    }
    
    func acceptChallenge() {
        guard let userID = SessionController.shared.userID else { return }
        guard let name = SessionController.shared.name else { return }
        let challengeName = challenge.name
        let date = Date()
        dateFormatter.timeStyle = .medium
        let dateAndTimeAsString = dateFormatter.string(from: date).replacingOccurrences(of: "/", with: "-")
        dateFormatter.timeStyle = .none
        let challengeID = challenge.ID
        let eventDescription = "\(name) accepted the challenge '\(challengeName)!'"
        let childupdates = ["/users/\(userID)/currentChallenges/\(challengeID)":  dateAndTimeAsString, "/events/\(userID)/\(dateAndTimeAsString)": eventDescription] as [String : Any]
        ref.updateChildValues(childupdates) { (error: Error?, ref: DatabaseReference) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func quitChallenge(with quitType: String) {
        guard let userID = SessionController.shared.userID else { return }
        guard let name = SessionController.shared.name else { return }
        let challengeName = challenge.name
        let date = Date()
        dateFormatter.timeStyle = .medium
        let dateAndTimeAsString = dateFormatter.string(from: date).replacingOccurrences(of: "/", with: "-")
        dateFormatter.timeStyle = .none
        let challengeID = challenge.ID
        if quitType == "quit" {
            let eventDescription = "\(name) quitted the challenge '\(challengeName)!'"
            let childupdates = ["/users/\(userID)/currentChallenges/\(challengeID)":  nil, "/events/\(userID)/\(dateAndTimeAsString)": eventDescription] as [String : Any]
            ref.updateChildValues(childupdates) { (error: Error?, ref: DatabaseReference) in
                self.dismiss(animated: false, completion: nil)
            }
        } else if quitType == "forget" {
            ref.child("/users/\(userID)/currentChallenges/\(challengeID)").removeValue() { (error: Error?, ref: DatabaseReference) in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
