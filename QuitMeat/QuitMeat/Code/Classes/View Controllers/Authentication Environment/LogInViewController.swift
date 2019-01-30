//
//  LogInViewController.swift
//  QuitMeat
//
//  Controller of the Log In View.
//
//  Created by Melle Meewis on 09/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    // Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func LogInButtonTapped(_ sender: UIButton) {
        handleLogIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    /// Log In user
    func handleLogIn() {
        guard let email = EmailTextField.text else { return }
        guard let password = PasswordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                SessionController.shared.name = Auth.auth().currentUser?.displayName
                self.dismiss(animated: false, completion: nil)
            } else {
                guard let myError = error?.localizedDescription else { return }
                let erroralert = UIAlertController(title: "LogIn Failed", message: myError , preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                erroralert.addAction(okButton)
                self.present(erroralert, animated: true, completion: nil)
            }
        }
    }
}
