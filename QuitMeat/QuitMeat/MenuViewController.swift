//
//  MenuViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 09/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    
    static let shared = MenuViewController()
    
    var ref: DatabaseReference!
    
    func updateSessionControllerValues() {
        print("valuesUpdated")
        SessionController.shared.name = Auth.auth().currentUser?.displayName
        SessionController.shared.userID = Auth.auth().currentUser?.uid
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchProductTypes()
        if Auth.auth().currentUser != nil {
            updateSessionControllerValues()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = Auth.auth().currentUser {
            updateSessionControllerValues()
            fetchStopsUser()
            self.performSegue(withIdentifier: "GoToHomeScreen", sender: self)
            print("USER: \(user.uid)")
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
                print(SessionController.shared.stoppedItemsUser)
            }
        }
    }
    
    func updateSessionData() {
        ref = Database.database().reference()
        SessionController.shared.clearSessionData()
        fetchStopsUser()
        fetchProductTypes()
    }
}
