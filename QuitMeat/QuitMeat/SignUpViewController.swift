//
//  SignInViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 09/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var RepeatPasswordTextField: UITextField!
    
    @IBAction func SignUpButtonTapped(_ sender: UIButton) {
        handleSignUp()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func handleSignUp() {
        guard let name = NameTextField.text?.capitalized else { return }
        let nameAsLower = name.lowercased()
        guard let email = EmailTextField.text else { return }
        guard let password = PasswordTextField.text else { return }
        guard let repeatedPassword = RepeatPasswordTextField.text else { return }
        guard password == repeatedPassword else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print(Auth.auth().currentUser?.uid)
                if let userID = Auth.auth().currentUser?.uid {
                    self.ref.child("users/\(userID)/name").setValue(name)
                    self.ref.child("users/\(userID)/nameAsLower").setValue(nameAsLower)
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges { error in
                        if error == nil {
                            SessionController.shared.name = name.capitalized
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
//                    self.dismiss(animated: false, completion: nil)
                }
            } else {
                print("Error creating user: \(error!.localizedDescription)")
            }
        }
    }
}
