//
//  SearchUserTableViewCell.swift
//  QuitMeat
//
//  Custom subclass of UITableViewCell for searching users.
//
//  Created by Melle Meewis on 15/01/2019.
//  Copyright © 2019 Melle Meewis. All rights reserved.
//

import UIKit

/// Declare protocol for delegate
@objc protocol SearchUserTableViewCellDelegate: class {
    func addFriendTapped(sender: SearchUserTableViewCell)
}

/// Custom subclass of UITableViewCell
class SearchUserTableViewCell: UITableViewCell {
    var delegate: SearchUserTableViewCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func addFriendButtonTapped(_ sender: UIButton) {
        delegate?.addFriendTapped(sender: self)
    }
}
