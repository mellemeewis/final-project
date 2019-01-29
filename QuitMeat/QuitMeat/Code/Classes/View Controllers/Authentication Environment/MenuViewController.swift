//
//  MenuViewController.swift
//  QuitMeat
//
//  Controller of the Menu View. This is the first view the user sees if nog logged in.
//
//  Created by Melle Meewis on 09/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    // static let shared = MenuViewController()
    var ref: DatabaseReference!
    
    // Actions
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional interface setup
        logInButton.layer.cornerRadius = 20
        signUpButton.layer.cornerRadius = 20
        ref = Database.database().reference()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check if a user is logged in and go to home screen if true.
        if Auth.auth().currentUser != nil {
            updateSessionControllerValues()
//            fetchProductTypes()
            self.performSegue(withIdentifier: "GoToHomeScreen", sender: self)
        }
    }
    
    /// Update user info
    func updateSessionControllerValues() {
        SessionController.shared.name = Auth.auth().currentUser?.displayName
        SessionController.shared.userID = Auth.auth().currentUser?.uid
    }

//    /// Fetch available product types from database
//    func fetchProductTypes() {
//        ref.child("productTypes").observeSingleEvent(of: .value) {
//            (snapshot) in
//            guard let data = snapshot.value as? [String:Any] else { return }
//            for (key, value) in (data) {
//                let productTypeData = value as! Dictionary<String, Any>
//                let productType = ProductType(co2: productTypeData["co2"] as! Int, water: productTypeData["water"] as! Int, animals: productTypeData["animals"] as! Int)
//                SessionController.shared.productTypes[key] = productType
//            }
//        }
//    }
}
