//
//  ViewController.swift
//  ContactListProject
//
//  Created by Sheetal Jain on 02/10/19.
//  Copyright © 2019 Sheetal Jain. All rights reserved.
//

import UIKit
import SQLite
var database: Connection!
let usersTable = Table("users")

var type: [String] = []
var unique_id: [Int] = []
var a = Int()


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var employeeDetailsTable: UITableView!
    var field_name: [String] = []
    var nameArray = [String]()
    var ageArray = [String]()
    var genderArray = [String]()
    var useridArray = [Int]()
    let name = Expression<String?>("name")
    let age = Expression<String>("age")
    let gender = Expression<String>("gender")
    let userid = Expression<Int?>("userid")

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do{
            let stmt =  try database.prepare("SELECT count(*) FROM users")
            for row in stmt {
                _ = row[0]! as! Int64
        }
            return nameArray.count
        }
        catch {
            print(error)
            return 0        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeDetailCell", for: indexPath) as! EmployeeDetailCell
        cell.name.text = self.nameArray[indexPath.row]
        cell.age.text = self.ageArray[indexPath.row]
        cell.gender.text = self.genderArray[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination  = storyboard.instantiateViewController(withIdentifier: "EmployeeDetailsVC") as! EmployeeDetailsVC
        navigationController?.pushViewController(destination, animated: true)
        destination.UserId = self.useridArray[indexPath.row]
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func registerTableViewCells() {
        let cellRegistered = UINib(nibName: "EmployeeDetailCell", bundle: nil)
        self.employeeDetailsTable.register(cellRegistered.self, forCellReuseIdentifier:"EmployeeDetailCell")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            database = try Connection("\(path)/users.sqlite3")
        }
        catch {
            database = nil
            print("unable to connect")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
         for user in try database.prepare(usersTable) {
             nameArray.append(user[name] ?? "")
             ageArray.append(user[age] )
             genderArray.append(user[gender] )
             useridArray.append(user[userid] ?? 0)
             }
        }
         catch {
             print(error)
         }
         registerTableViewCells()
    }
}
    
