//
//  NewStopViewController.swift
//  QuitMeat
//
//  Controller of the New Stop View.
//
//  Created by Melle Meewis on 10/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit
import Firebase

class NewStopViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // declare variables
    var ref: DatabaseReference!
    var selectedProductType: String!
    var daysAWeek: Int!
    var productTypeNames = [String]()
    var daysInWeek = ["1", "2", "3", "4", "5", "6", "7"]
    
    // outlets
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var productTypePickerWheel: UIPickerView!

    
    // actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
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
        let eventDescription = "\(name) stopped eating \(selectedProductType) on \(dateAsString) for \(daysAWeek!) day(s) a week!"
        let childupdates = ["/users/\(userID)/stopped/\(selectedProductType)": ["days": daysAWeek, "date": dateAsString], "/events/\(userID)/\(eventDate)": eventDescription] as [String : Any]
        ref.updateChildValues(childupdates) { (error: Error?, ref: DatabaseReference) in
            if error == nil {
                self.dismiss(animated: false)
            }
        }
    }
    
    /// return number of components in pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    /// return number of rows in component in pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return productTypeNames.count
        }
        else {
            return daysInWeek.count
        }
    }
    
    
    /// return view in fow in pickerview
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel?
        if view == nil {
            pickerLabel = UILabel()
        }
        var titleData: String!
        if component == 0 {
            titleData = productTypeNames[row].capitalized
        } else {
            titleData = daysInWeek[row].capitalized
        }
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Marker Felt", size: 21)!])
        pickerLabel?.attributedText = myTitle
        pickerLabel?.textAlignment = .center
        return pickerLabel!
    }
    
    /// handle selection row in pickerview
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // additional setup
        ref = Database.database().reference()
        productTypePickerWheel.dataSource = self
        productTypePickerWheel.delegate = self
        for key in SessionController.shared.productTypes.keys {
            productTypeNames.append(key)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // additional setup
        updateUI()
    }
    
    /// update user interface
    func updateUI() {
        createButton.layer.cornerRadius = 20
        selectedProductType = productTypeNames[productTypePickerWheel.selectedRow(inComponent: 0)]
        daysAWeek = Int(daysInWeek[productTypePickerWheel.selectedRow(inComponent: 1)])
        createButton.setTitle("Stop eating \(selectedProductType!) for \(daysAWeek!) day(s) a week!", for: .normal)
    }
    
}
