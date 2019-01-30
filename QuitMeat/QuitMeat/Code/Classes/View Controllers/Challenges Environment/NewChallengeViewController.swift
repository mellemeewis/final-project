//
//  NewChallengeViewController.swift
//  QuitMeat
//
//  Controller of the Create new challenge View.
//
//  Created by Melle Meewis on 22/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class NewChallengeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // declare variables
    var ref: DatabaseReference!
    
    var selectedProductType: String!
    var selectedDaysAWeek: Int!
    var selectedWeeks: Int!
    var productTypeNames = [String]()
    
    let daysInWeek = ["1", "2", "3", "4", "5", "6", "7"]
    let weeks = ["1", "2", "3", "4", "5", "6", "7", "8"]

    // outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pickerWheel: UIPickerView!
    @IBOutlet weak var createChallengeButton: UIButton!
    
    // actions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func createButtonTapped(_ sender: UIButton) {
        addChallengeToDataBase()
    }
    
    /// retun number of components in pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    /// return number of row in component in pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return productTypeNames.count
        }
        else if component == 1 {
            return daysInWeek.count
        }
        else {
            return weeks.count
        }
    }
    
    /// retun view in row in pickerview
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel?
        if view == nil {
            pickerLabel = UILabel()
        }
        var titleData: String!
        if component == 0 {
            titleData = productTypeNames[row].capitalized
        } else if component == 1 {
            if row == 0 {
                titleData = "\(daysInWeek[row]) day"
            } else {
                titleData = "\(daysInWeek[row]) days"
            }
        } else {
            if row == 0 {
                titleData = "\(weeks[row]) week"
            } else {
                titleData = "\(weeks[row]) weeks"
            }
            
        }
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Marker Felt", size: 19)!])
        pickerLabel?.attributedText = myTitle
        pickerLabel?.textAlignment = .center
        return pickerLabel!
    }
    
    /// Handle selection row in pickerview
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setVariables()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // additional setup
        ref = Database.database().reference()
        pickerWheel.dataSource = self
        pickerWheel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // additional setup
        createChallengeButton.layer.cornerRadius = 20
        for key in SessionController.shared.productTypes.keys {
            productTypeNames.append(key)
        }
        setVariables()
    }
    
    /// set variables to current selection picerwheel components
    func setVariables() {
        selectedProductType = productTypeNames[pickerWheel.selectedRow(inComponent: 0)]
        selectedDaysAWeek = Int(daysInWeek[pickerWheel.selectedRow(inComponent: 1)])
        selectedWeeks = Int(weeks[pickerWheel.selectedRow(inComponent: 2)])
    }
    
    /// add new created challenge to the database
    func addChallengeToDataBase() {
        // check if input is valid
        guard let userID = SessionController.shared.userID else { return }
        guard let challengeName = nameTextField.text else { return }
        guard challengeName != "" else { sendAlert(); return }
        guard let name = SessionController.shared.name else { return }
        guard let selectedProductType = self.selectedProductType else { return }

        let description = "Try to stop eating \(selectedProductType) for \(selectedDaysAWeek!) day(s) a week!"
        
        // calculate date information
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let date = Date()
        let dateAsString = dateFormatter.string(from: date)
        dateFormatter.timeStyle = .medium
        let eventDate = dateFormatter.string(from: date).replacingOccurrences(of: "/", with: "-")
        
        let eventDescription = "\(name) created a new challenge to stop eating \(selectedProductType) on \(dateAsString)!"
        let challengeKey = ref.childByAutoId().key
        let childupdates = ["/challenges/\(userID)/\(challengeKey!)": ["days": selectedDaysAWeek, "description": description, "weeks": selectedWeeks, "name": challengeName, "productType": selectedProductType, "createdBy": name, "creationDate": dateAsString], "/events/\(userID)/\(eventDate)": eventDescription] as [String : Any]
        ref.updateChildValues(childupdates) { (error: Error?, ref: DatabaseReference) in
            if error == nil {
                self.dismiss(animated: false)
            }
        }
    }
    
    /// Send alert to user
    func sendAlert() {
        let erroralert = UIAlertController(title: "Creation Failed", message: "Challenge should have a name." , preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        erroralert.addAction(okButton)
        self.present(erroralert, animated: true, completion: nil)
    }

    
}
