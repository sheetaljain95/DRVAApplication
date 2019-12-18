//
//  Model.swift
//  ContactListProject
//
//  Created by Sheetal Jain on 02/10/19.
//  Copyright © 2019 Sheetal Jain. All rights reserved.
//

import UIKit
import SQLite


class Model: UIViewController {
    
    var json = [
        ["field-name":"name", "type":"text", "required":true,"unique_id":1],
        ["field-name":"gender", "type":"dropdown", "options":["Male", "Female","Other"],"unique_id":4],
        ["field-name":"age", "type":"number", "unique_id":2],
    ]

    override func viewDidLoad() {
                super.viewDidLoad()
    }

}

