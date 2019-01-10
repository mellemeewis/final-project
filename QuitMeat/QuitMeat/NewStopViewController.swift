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
    
    
    @IBOutlet weak var productTypePickerWheel: UIPickerView!
    
    var productTypeNames = [String]()
    var daysInWeek = ["1", "2", "3", "4", "5", "6", "7"]
    var ref: DatabaseReference!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTypePickerWheel.dataSource = self
        productTypePickerWheel.delegate = self
        
        for key in SessionController.shared.productTypes.keys {
            productTypeNames.append(key)
        }
    }
}
