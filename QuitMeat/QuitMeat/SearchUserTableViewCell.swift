//
//  SearchUserTableViewCell.swift
//  QuitMeat
//
//  Created by Melle Meewis on 15/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit

@objc protocol SearchUserTableViewCellDelegate: class {
    func addFriendTapped(sender: SearchUserTableViewCell)
}

class SearchUserTableViewCell: UITableViewCell {
    var delegate: SearchUserTableViewCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func addFriendButtonTapped(_ sender: UIButton) {
        print("Tapped")
        delegate?.addFriendTapped(sender: self)
    }
}
