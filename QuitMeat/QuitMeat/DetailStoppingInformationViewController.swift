//
//  DetailStoppingInformationViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 10/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit

class DetailStoppingInformationViewController: UIViewController {
    @IBOutlet weak var stoppingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        var string = "You stopped eating: \n"
        for (key, value) in SessionController.shared.stoppedItemsUser {
            string = string + key + " since " + value.stopDate + " for " + String(value.days) + " a week.\n"
            print(key)
            print(value)
        }
        stoppingLabel.text = string
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
