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
        // Check if all field as filled in correctly.
        guard let name = NameTextField.text?.capitalized else { sendAlert(); return }
        if name.contains(" ") {
            let erroralert = UIAlertController(title: "Sign Up Failed", message: "Name Can Not Contain Spaces" , preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            erroralert.addAction(okButton)
            self.present(erroralert, animated: true, completion: nil)
        }
        let nameAsLower = name.lowercased()
        guard let email = EmailTextField.text else { sendAlert(); return }
        if name == "" || email == "" {
            sendAlert();
            return
        }
        guard let password = PasswordTextField.text else { sendAlert(); return }
        guard let repeatedPassword = RepeatPasswordTextField.text else { sendAlert(); return }
        
        guard password == repeatedPassword else {
            let erroralert = UIAlertController(title: "Sign Up Failed", message: "Passwords do not match." , preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            erroralert.addAction(okButton)
            self.present(erroralert, animated: true, completion: nil)
            return
        }
        
        // Sign Up User
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
            } else {
                guard let myError = error?.localizedDescription else { return }
                let erroralert = UIAlertController(title: "Sign Up Failed", message: myError , preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                erroralert.addAction(okButton)
                self.present(erroralert, animated: true, completion: nil)
            }
        }
    }
    
    /// Send alert to user
    func sendAlert() {
        let erroralert = UIAlertController(title: "Sign Up Failed", message: "Not all required fields are filled in." , preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        erroralert.addAction(okButton)
        self.present(erroralert, animated: true, completion: nil)
    }
}
