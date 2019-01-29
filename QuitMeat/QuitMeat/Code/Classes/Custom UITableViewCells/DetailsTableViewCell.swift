//
//  DetailsTableViewCell.swift
//  QuitMeat
//
//  Custom subclass of UITableViewCell for representing details about stopping information user.
//
//  Created by Melle Meewis on 26/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit

//  Custom subclass of UITableViewCell
class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var co2Label: UILabel!
    @IBOutlet weak var animalLabel: UILabel!
}
