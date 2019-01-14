//
//  DetailStoppingInformationViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 10/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class DetailStoppingInformationViewController: UIViewController {
    
    static var shared = DetailStoppingInformationViewController()
    var ref: DatabaseReference!
    @IBOutlet weak var stoppingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    func updateData() {
            ref = Database.database().reference()
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
            self.updateUI()
            }
        }
    
    func updateUI() {
        var string = "You stopped eating: \n"
        for (key, value) in SessionController.shared.stoppedItemsUser {
            string = string + key + " since " + value.stopDate + " for " + String(value.days) + " a week.\n"
            print(key)
            print(value)
        }
        print(string)
        self.stoppingLabel.text = string
    }



}
