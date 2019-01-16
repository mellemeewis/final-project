//
//  NewStopViewController.swift
//  QuitMeat
//
//  Created by Melle Meewis on 10/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class NewStopViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var ref: DatabaseReference!
    var selectedProductType: String!
    var daysAWeek: Int!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var productTypePickerWheel: UIPickerView!
    
    var productTypeNames = [String]()
    var daysInWeek = ["1", "2", "3", "4", "5", "6", "7"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return productTypeNames.count
        }
        else {
            return daysInWeek.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return productTypeNames[row]
        }
        else {
            return daysInWeek[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateUI()
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        guard let userID = SessionController.shared.userID else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let date = Date()
        let dateAsString = dateFormatter.string(from: date)
        dateFormatter.timeStyle = .medium
        let eventDate = dateFormatter.string(from: date).replacingOccurrences(of: "/", with: "-")
        guard let name = SessionController.shared.name else { return }
        guard let selectedProductType = self.selectedProductType else { return }
        let eventDescription = "\(name) stopped eating \(selectedProductType) on \(dateAsString) for \(daysAWeek!) days a week!"
        let childupdates = ["/users/\(userID)/stopped/\(selectedProductType)": ["days": daysAWeek, "date": dateAsString], "/events/\(eventDate)/\(userID)": eventDescription] as [String : Any]
        ref.updateChildValues(childupdates) { (error: Error?, ref: DatabaseReference) in
            if error == nil {
                self.dismiss(animated: false)
            }
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        productTypePickerWheel.dataSource = self
        productTypePickerWheel.delegate = self
        
        for key in SessionController.shared.productTypes.keys {
            productTypeNames.append(key)
        }
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        selectedProductType = productTypeNames[productTypePickerWheel.selectedRow(inComponent: 0)]
        daysAWeek = Int(daysInWeek[productTypePickerWheel.selectedRow(inComponent: 1)])
        
        createButton.setTitle("Stop eating \(selectedProductType!) for \(daysAWeek!) day(s) a week!", for: .normal)
    }
}
