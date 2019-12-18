//
//  EmployeeDetailsVC.swift
//  ContactListProject
//
//  Created by Sheetal Jain on 20/11/19.
//  Copyright © 2019 Sheetal Jain. All rights reserved.
//

import UIKit
import SQLite
import iOSDropDown

class EmployeeDetailsVC: UIViewController {
    @IBOutlet weak var deleteDetails: UIButton!
    var UserId = Int()
    @IBOutlet weak var editDetails: UIButton!
    let json = dataModel.json
    var j: Float = 50
    var field_name: [String] = []
    var options: [String] = []
    var newTextField = [UITextField]()
    var labelName: [String] = []
    var updatedTextFieldValues: [String] = []
    var userDetails: [String] = []
    var valuesFromDB: [String] = []
    var i: Int = 0
    var userid = Expression<Int>("userid")
    var count: Int = 0
    var count2: Int = 0
    var fieldValue = String()
    var fieldName = Expression<String>("")


        override func viewDidLoad() {
        super.viewDidLoad()
        pageHeading()
        selectFunction()
        
        
        for count in json {
        if (count["type"] as! String) == "text"   {
            displayJsonValues(count: count)
            }
        else if (count["type"] as! String) == "number"   {
            displayJsonValues(count: count)
        }
        else if (count["type"] as! String) == "dropdown" {
            displayJsonValues(count: count)
        }
        else if  (count["type"] as! String) == "multiline"   {
            displayJsonValues(count: count)
        }
        }
            print(newTextField)
            count = 0
            count2 = 0
    }
    
    func pageHeading() {
        let displayText = UILabel()
        displayText.translatesAutoresizingMaskIntoConstraints = false
        displayText.textAlignment = .center
        displayText.text = "User Details"
        self.view.addSubview(displayText)
    }
    
    func selectFunction(){
        do{
            let stmt =  try database.prepare("SELECT * FROM users where userid = \(UserId)")
            for row in stmt {
                while row.count > count+1
                {
                    count = count + 1
                    userDetails.append(row[count] as! String)
                }
                print(userDetails)
            }
            print("printing")
            print(userDetails)
        }
        catch {
            print(error)
        }
        print("value of count")
        print(count)
    }
    
    func displayJsonValues(count: [String:Any]) {
            j = j+100
            let newlabel :UILabel = UILabel(frame: CGRect(x: 20, y: Int(j), width: 100, height: 20))
            let TextField: UITextField = UITextField(frame: CGRect(x: 160, y: Int(j), width: 200, height: 30))
            newlabel.textAlignment = .left
            newlabel.text = ( count["field-name"] as! String )
            labelName.append(count["field-name"] as! String)
            self.view.addSubview(newlabel)
        _ = view.layoutMarginsGuide
            TextField.borderStyle = UITextField.BorderStyle.roundedRect

            TextField.textAlignment = .left
            self.view.addSubview(TextField)
        _ = view.layoutMarginsGuide
            
            TextField.text = ( userDetails[count2] as? String )
            count2 = count2 + 1
            TextField.isUserInteractionEnabled = false
            newTextField.append(TextField)

}
    
    func displayDropDown (count: [String:Any]) {
            j = j + 100
            let a: [String] = count["options"] as! [String]
            let newlabel :UILabel = UILabel(frame: CGRect(x: 20, y: Int(j), width: 100, height: 20))
            newlabel.translatesAutoresizingMaskIntoConstraints = false
            newlabel.textAlignment = .left
            newlabel.text = (count["field-name"] as! String)
            labelName.append(count["field-name"] as! String)
            self.view.addSubview(newlabel)
        _ = view.layoutMarginsGuide
            let  dropDown = DropDown(frame: CGRect(x: 200, y: Int(j), width: 200, height: 30))
            dropDown.optionArray = a
            self.view.addSubview(dropDown)
            count2 = count2 + 1
            
            }
    
    @IBAction func deleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Record?", message: "Are you sure you want to delete this record", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            do{
                let stmt =  try database.prepare("Delete FROM users where userid = \(self.UserId)")
                       for row in stmt {
                        while row.count > self.count+1
                           {
                            self.count = self.count + 1
                            self.userDetails.append(row[self.count] as! String)
                           }
                        print(self.userDetails)
                       }
                       print("printing")
                print(self.userDetails)
                print("Deleted")
                self.switchScreen()

                //self.dismiss(animated: true, completion: nil)
              
                   }
                   catch {
                       print(error)
                   }
        }))

    }
    @IBAction func editAction(_ sender: Any) {
        print("function edit called")
               for count in newTextField {
                   count.isUserInteractionEnabled = true
               }
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        button.frame = CGRect(x: 160, y: Int(j + 150), width: 70, height: 30)
        
        self.view.addSubview(button)

    }
    
    @objc func buttonClicked() {
        let alert = UIAlertController(title: "Edit Record", message: "Do you wish to post changes", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
        
                for count in self.newTextField
        {
            self.updatedTextFieldValues.append(count.text ?? "NA")
        }
        do {
            var setter = [Any]()
            var count = 0
            while count < self.labelName.count {
                self.fieldName = Expression<String>(self.labelName[count])
                self.fieldValue = self.updatedTextFieldValues[count]
                setter.append(self.fieldName <- self.fieldValue)
                count = count + 1
                }
            let updateid = usersTable.filter(self.userid == self.UserId)
            try database.run(updateid.update(setter as! [Setter]))
            print(rowid)
            self.dismiss(animated: true, completion: nil)
            self.editDetails.isHidden = false
            self.switchScreen()
            }
        catch {
            print("update failed: \(error)")
        }
    }))
    }
    
    func switchScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as? UIViewController {
            self.show(viewController, sender: nil)
        }
    }

}
