//
//  SignInViewController.swift
//  QuitMeat
//
//  Controller of the Sign Up View.
//
//  Created by Melle Meewis on 09/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // Declare variables
    var ref: DatabaseReference!
    

    // Outlets
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var RepeatPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    // Actions
    @IBAction func SignUpButtonTapped(_ sender: UIButton) {
        handleSignUp()
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup
        signUpButton.layer.cornerRadius = 20
        ref = Database.database().reference()
    }
    
    /// Sign up user
    func handleSignUp() {
        guard let name = NameTextField.text?.capitalized else { return }
        let nameAsLower = name.lowercased()
        guard let email = EmailTextField.text else { return }
        guard let password = PasswordTextField.text else { return }
        guard let repeatedPassword = RepeatPasswordTextField.text else { return }
        guard password == repeatedPassword else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                if let userID = Auth.auth().currentUser?.uid {
                    self.ref.child("users/\(userID)/name").setValue(name)
                    self.ref.child("users/\(userID)/nameAsLower").setValue(nameAsLower)
                    // Set user display name
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges { error in
                        if error == nil {
                            SessionController.shared.name = name.capitalized
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
