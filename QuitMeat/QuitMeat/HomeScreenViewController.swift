//
//  HomeScreenViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 09/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == savingInfoTableView {
            return SessionController.shared.screenHeight / 20
        }
        return SessionController.shared.screenHeight / 13
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case stoppingInfoTableView:
            if SessionController.shared.stoppedItemsUser.count == 0 {
                return 1
            }
            return SessionController.shared.stoppedItemsUser.count
        case savingInfoTableView:
            return 3
        case socialInfoTableView:
            if SessionController.shared.events.count == 0 {
                return 1
            }
            return SessionController.shared.events.count
        case challengeInfoTableView:
            if SessionController.shared.currentChallengesIDsUser.count == 0 {
                print("EROOR")
                return 1
            }
            print("NOICE")
            return SessionController.shared.currentChallengesIDsUser.count
        default:
            return 0
        }
    }

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch tableView {
        case stoppingInfoTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "StoppingInfoCell", for: indexPath)
            guard SessionController.shared.stoppedItemsUser.count != 0 else {
                cell.textLabel?.text = "Press here to tart consuming less meat!"
                return cell
            }
            let keys = Array(SessionController.shared.stoppedItemsUser.keys)
            let values = Array(SessionController.shared.stoppedItemsUser.values)
            let i = indexPath.row
            if i < keys.count {
                cell.textLabel?.text = "\(keys[i].capitalized) for \(values[i].days) day(s) a week since \(values[i].stopDate)!"
            }
        case savingInfoTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SavingInfoCell", for: indexPath)
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Animals"
                cell.detailTextLabel?.text = String(SessionController.shared.animalsSavedUser)
            case 1:
                cell.textLabel?.text = "Water"
                cell.detailTextLabel?.text = String(SessionController.shared.waterSavedUser)
            case 2:
                cell.textLabel?.text = "CO2"
                cell.detailTextLabel?.text = String(SessionController.shared.co2savedUser)
            default:
                return cell
            }
        case socialInfoTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SocialInfoCell", for: indexPath)
            guard SessionController.shared.events.count != 0 else {
                cell.textLabel?.text = "Press here to find friends!"
                return cell
            }
            let currentUserName = SessionController.shared.name!
            let event = SessionController.shared.events[indexPath.row]
            var description = event.description
            if description.components(separatedBy: " ").first == currentUserName {
                description = description.replacingOccurrences(of: currentUserName, with: "You")
            }
            cell.textLabel?.text = description
            
        case challengeInfoTableView:
            print(SessionController.shared.currentChallengesIDsUser.count)
            cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeInfoCell", for: indexPath)
            guard SessionController.shared.currentChallengesIDsUser.count != 0 else {
                cell.textLabel?.text = "Press here to find challenges!"
                return cell
            }
            print("CHAL")

            let orderdChallenges = SessionController.shared.currentChallengesIDsUser.sorted(by: { $0.value.goalDate > $1.value.goalDate })
            print(orderdChallenges)
            print(indexPath.row)
            let challengeID = orderdChallenges[indexPath.row].key
            print(challengeID)
            guard let challenge = SessionController.shared.currentChallengesObjectsUser.first(where: { $0.ID == challengeID }) else { return cell }
            cell.textLabel?.text = challenge.name
            cell.detailTextLabel?.text = challenge.descirption
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        
    }
    
    var ref: DatabaseReference!
    
    var co2Saved = 0
    var animalsSaved = 0
    var waterSaved = 0
    
    @IBOutlet weak var logInButton: UIButton!

    
    @IBOutlet weak var stoppingInfoView: UIView!
    @IBOutlet weak var savingInfoView: UIView!
    @IBOutlet weak var socialInfoView: UIView!
    @IBOutlet weak var challengeInfoView: UIView!
    
    @IBOutlet weak var stoppingInfoTableView: UITableView!
    @IBOutlet weak var savingInfoTableView: UITableView!
    @IBOutlet weak var socialInfoTableView: UITableView!
    @IBOutlet weak var challengeInfoTableView: UITableView!
    
    
    @IBAction func LogOutButtonTapped(_ sender: UIButton) {
        try! Auth.auth().signOut()
        SessionController.shared.clearSessionData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapStoppingInfo = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        let tapSavingInfo = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        let tapSocialInfo = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        let tapChallengeInfo = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        stoppingInfoTableView.addGestureRecognizer(tapStoppingInfo)
        savingInfoTableView.addGestureRecognizer(tapSavingInfo)
        socialInfoTableView.addGestureRecognizer(tapSocialInfo)
        challengeInfoTableView.addGestureRecognizer(tapChallengeInfo)
    }
    
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if stoppingInfoTableView.gestureRecognizers!.contains(sender) || savingInfoTableView.gestureRecognizers!.contains(sender) {
            performSegue(withIdentifier: "ToDetailSegue", sender: nil)
        }
        else if socialInfoTableView.gestureRecognizers!.contains(sender) {
            performSegue(withIdentifier: "ToMainSocialSegue", sender: nil)
        }
        else if challengeInfoTableView.gestureRecognizers!.contains(sender) {
            performSegue(withIdentifier: "ToMainChallengeSegue", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        updateUI(for: "")
        fetchStopsUser()
        fetchFriendsAndEvents()
        fetchCurrentChallengesIDsUser()
    }
    
    func updateUI(for data: String) {

        logInButton.layer.cornerRadius = 15.0
        stoppingInfoView.layer.cornerRadius = 30.0
        savingInfoView.layer.cornerRadius = 30.0
        socialInfoView.layer.cornerRadius = 30.0
        challengeInfoView.layer.cornerRadius = 30.0
        
        switch data {
        case "userStoppingInfo":
            stoppingInfoTableView.reloadData()
        case "userSavedInfo":
            savingInfoTableView.reloadData()

        case "socialInfo":
            socialInfoTableView.reloadData()
        case "challengesInfo":
            challengeInfoTableView.reloadData()
        default:
            return
        }
    }

    func fetchStopsUser() {
        let userID = SessionController.shared.userID!
        let childPath = "users/\(userID)/stopped"
        ref.child(childPath).observeSingleEvent(of: .value) {
            (snapshot) in
            guard let data = snapshot.value as? [String:Any] else { return }
            for (key, value) in (data) {
                let stoppingData = value as! Dictionary<String, Any>
                let stoppedItem = StoppedItem(days: stoppingData["days"] as! Int, stopDate: stoppingData["date"] as! String)
                SessionController.shared.stoppedItemsUser[key] = stoppedItem
                self.updateUI(for: "userStoppingInfo")
                self.fetchProductTypes()
            }
        }
    }
    
    func fetchProductTypes() {
        ref.child("productTypes").observeSingleEvent(of: .value) {
            (snapshot) in
            guard let data = snapshot.value as? [String:Any] else { return }
            for (key, value) in (data) {
                let productTypeData = value as! Dictionary<String, Any>
                let productType = ProductType(co2: productTypeData["co2"] as! Int, water: productTypeData["water"] as! Int, animals: productTypeData["animals"] as! Int)
                SessionController.shared.productTypes[key] = productType
            }
            self.updateUI(for: "userSavedInfo")
        }
    }
    
    
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

            self.updateUI(for: "socialInfo")
        })
    }
    
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
    
    func fetchCurrentChallengesIDsUser() {
        guard let userID = SessionController.shared.userID else { return }
        ref.child("users/\(userID)/currentChallenges").observeSingleEvent(of: .value, with: { snapshot  in
            var currentChallenges = [String:AcceptedChallenge]()
            guard let data = snapshot.value as? [String:Any] else { SessionController.shared.currentChallengesIDsUser = currentChallenges; self.fetchCompletedChallengesIDsUser(); return }
            for (key, value) in data {
                guard let dateData = value as? [String] else { return }
                let challengeID = key
                let startDateAsString = dateData[0]
                let goalDateAsString = dateData[1]
                let currentChallenge = AcceptedChallenge(challengeID: challengeID, startDate: startDateAsString, goalDate: goalDateAsString)
                    currentChallenges[challengeID] = currentChallenge
                }
            SessionController.shared.currentChallengesIDsUser = currentChallenges
            self.fetchCompletedChallengesIDsUser()
        })
    }
    
    func fetchCompletedChallengesIDsUser() {
        guard let userID = SessionController.shared.userID else { return }
        ref.child("users/\(userID)/completedChallenges").observeSingleEvent(of: .value, with: { snapshot  in
            var completedChallenges = [String:AcceptedChallenge]()
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
            print(SessionController.shared.currentChallengesObjectsUser)
            print(SessionController.shared.completedChallengesObjectsUser)
            self.updateUI(for: "challengesInfo")
        })
    }

    
    
}
