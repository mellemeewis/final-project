//
//  HomeScreenViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 09/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController {

    @IBAction func LogOutButtonTapped(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
