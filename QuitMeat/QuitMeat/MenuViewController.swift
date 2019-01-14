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
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
    }
    
    static let shared = MenuViewController()
    
    var ref: DatabaseReference!
    
    func updateSessionControllerValues() {
        print("valuesUpdated")
        SessionController.shared.name = Auth.auth().currentUser?.displayName
        print(SessionController.shared.name)
        SessionController.shared.userID = Auth.auth().currentUser?.uid
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            updateSessionControllerValues()
            fetchProductTypes()
            self.performSegue(withIdentifier: "GoToHomeScreen", sender: self)
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
                print(SessionController.shared.productTypes)
            }
        }
    }

}
