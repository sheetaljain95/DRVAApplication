//
//  EmployeeDetailCell.swift
//  ContactListProject
//
//  Created by Sheetal Jain on 11/10/19.
//  Copyright © 2019 Sheetal Jain. All rights reserved.
//

import UIKit

class EmployeeDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var addedOn: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var name: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
