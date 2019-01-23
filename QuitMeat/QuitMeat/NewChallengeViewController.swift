//
//  NewChallengeViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 22/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class NewChallengeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: DatabaseReference!
    var selectedProductType: String!
    var selectedDaysAWeek: Int!
    var selectedWeeks: Int!
    var productTypeNames = [String]()
    let daysInWeek = ["1", "2", "3", "4", "5", "6", "7"]
    let weeks = ["1", "2", "3", "4", "5", "6", "7", "8"]

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pickerWheel: UIPickerView!
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        addChallengeToDataBase()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return productTypeNames[row]
        }
        else if component == 1 {
            return daysInWeek[row]
        }
        else {
            return weeks[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setVariables()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        pickerWheel.dataSource = self
        pickerWheel.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for key in SessionController.shared.productTypes.keys {
            productTypeNames.append(key)
        }
        setVariables()

    }
    
    func setVariables() {
        selectedProductType = productTypeNames[pickerWheel.selectedRow(inComponent: 0)]
        selectedDaysAWeek = Int(daysInWeek[pickerWheel.selectedRow(inComponent: 1)])
        selectedWeeks = Int(weeks[pickerWheel.selectedRow(inComponent: 2)])
    }
    
    func addChallengeToDataBase() {
        guard let userID = SessionController.shared.userID else { return }
        guard let challengeName = nameTextField.text else { return }
        guard challengeName != "" else { return }
        guard let name = SessionController.shared.name else { return }
        guard let selectedProductType = self.selectedProductType else { return }

        let description = "Try to stop eating \(selectedProductType) for \(selectedDaysAWeek!) day(s) a week!"
        
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
        print(childupdates)
        ref.updateChildValues(childupdates) { (error: Error?, ref: DatabaseReference) in
            if error == nil {
                self.dismiss(animated: false)
            }
        }
        

    }
    
}
