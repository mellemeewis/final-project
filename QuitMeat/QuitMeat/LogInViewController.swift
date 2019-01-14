//
//  LogInViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 09/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func LogInButtonTapped(_ sender: UIButton) {
        handleLogIn()
    }
    

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func handleLogIn() {
        guard let email = EmailTextField.text else { return }
        guard let password = PasswordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                SessionController.shared.name = Auth.auth().currentUser?.displayName
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
            }
        }
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
