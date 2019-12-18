//
//  UserDetailsVC.swift
//  ContactListProject
//
//  Created by Sheetal Jain on 03/10/19.
//  Copyright © 2019 Sheetal Jain. All rights reserved.
//

import UIKit
import SQLite
import iOSDropDown

let dataModel = Model()

class UserDetailsVC: UIViewController {

        var database: Connection!
        var json: [[String:Any]] = []
        var oldJson: [String] = []
        var field_name: [String] = []
        var options: [String] = []

        var type: [String] = []
        var type2: [Int] = []
        var a = String()
        var b = Int()
        var userid = Expression<Int>("userid")

        var unique_id: [Int] = []
        let usersTable = Table("users")
        var name: String = "name"
        var age: String = "age"
        var address: String = "address"
        var labelNameTemp : [String] = []
        var labelValueTemp : [String] = []
    
        let infoMessage = "Please Enter Employee Details"

        var enteredValues: [String] = []

        let infoLabel = UILabel()
        var i: Int = 0
        var j: Float = 10

        var fieldLabel = [UILabel]()
        var fieldLabelType = [UITextField]()
        var newTextField = [UITextField]()
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        @objc func buttonClicked() {
        do {
            try database.run(usersTable.create(ifNotExists:true) { t in
                t.column(userid, primaryKey: .autoincrement)
                for count in labelNameTemp {
                    t.column(Expression<String?>(count), unique : false)
                }
            })
            
            }
        catch{
                print(error)
            }
            do {

                let tableInfo = try database.prepare("PRAGMA table_info(users)")
                for row in tableInfo {
                    oldJson.append(row[1]! as! String)
                }

                print(tableInfo)
                print(oldJson)
            }
            catch _ { }

            let diffArray = labelNameTemp.count - oldJson.count
            if diffArray != -1 {
                print(diffArray)
                if diffArray == 0 {
                    do{
                        try database.run(usersTable.addColumn(Expression<String?>(labelNameTemp.last!)))
                    }
                    catch{
                        print(error)
                    }

                }
            }

            let isNameValid = isValidName(nameString: newTextField[0].text ?? "")
        
            if isNameValid == false {
                let alert = UIAlertController(title: "Error!", message: "Name validation has failed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)

            }
            
        labelValueTemp.removeAll()

        for count in newTextField {
            labelValueTemp.append (count.text ?? "none")
        }
        

        do {
            var count = 0
            var fieldName = Expression<String>("")
            var fieldValue = String()
            var setter = [Any]()
            while count < labelValueTemp.count {
                fieldName = Expression<String>(labelNameTemp[count])
                fieldValue = labelValueTemp[count]
                setter.append(fieldName <- fieldValue)
                count = count + 1
            }
            let insert = usersTable.insert(setter as! [Setter])
            _ = try database.run(insert)
        
            switchScreen()
    }
        catch {
            print(error)
            }
           
}
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print (dataModel.json)

        
        let _: Connection?
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            do {
                database = try Connection("\(path)/users.sqlite3")
            }
            catch {
                database = nil
                print("unable to connect")
            }
            
        var json = dataModel.json
        
       
        let displayText :UILabel = UILabel(frame: CGRect(x: 20, y: 30, width: 300, height: 20))
        displayText.font = UIFont.boldSystemFont(ofSize: 22.0)

        displayText.textAlignment = .center
        displayText.text = "Please Enter the Details here"
        self.view.addSubview(displayText)
        
        
        for count in json {
            
            if (count["type"] as! String) == "text" {
                
                j=j+100
                let newlabel :UILabel = UILabel(frame: CGRect(x: 10, y: Int(j), width: 100, height: 20))
                let TextField: UITextField = UITextField(frame: CGRect(x: 150, y: Int(j), width: 200, height: 30))
                self.view.addSubview(TextField)
                TextField.borderStyle = UITextField.BorderStyle.roundedRect

                TextField.backgroundColor = UIColor.gray
                newlabel.textAlignment = .left
                newlabel.text = (count["field-name"] as! String)
                self.view.addSubview(newlabel)
                TextField.textAlignment = .left
                TextField.placeholder = "Place holder text"
                newTextField.append(TextField)
                labelNameTemp.append(newlabel.text ?? "None")
            }
                
            
            else if (count["type"] as! String) == "number" {

                j = j + 100

                let newlabel :UILabel = UILabel(frame: CGRect(x: 10, y: Int(j), width: 100, height: 20))
                let TextField: UITextField = UITextField(frame: CGRect(x: 150, y: Int(j), width: 200, height: 30))
                TextField.backgroundColor = UIColor.gray

                newlabel.textAlignment = .left
                newlabel.text = (count["field-name"] as! String)
                self.view.addSubview(newlabel)
                TextField.borderStyle = UITextField.BorderStyle.roundedRect

                TextField.textAlignment = .left
                self.view.addSubview(TextField)
                TextField.placeholder = "Place holder text"
                labelNameTemp.append(newlabel.text ?? "None")
                newTextField.append(TextField)

            }
            else if (count["type"] as! String) == "dropdown" {
                j = j + 100
                let a: [String] = count["options"] as! [String]
                                
                let newlabel :UILabel = UILabel(frame: CGRect(x: 10, y: Int(j), width: 100, height: 20))
                newlabel.textAlignment = .left
                newlabel.text = (count["field-name"] as! String)
                self.view.addSubview(newlabel)
                let  dropDown = DropDown(frame: CGRect(x: 150, y: Int(j), width: 200, height: 30))
                dropDown.optionArray = a
                self.view.addSubview(dropDown)
                labelNameTemp.append(newlabel.text ?? "None")
                newTextField.append(dropDown)
            }
            else if (count["type"] as! String) == "multiline" {
                j = j + 100
                let newlabel :UILabel = UILabel(frame: CGRect(x: 10, y: Int(j), width: 100, height: 20))
                let TextField: UITextField = UITextField(frame: CGRect(x: 150, y: Int(j), width: 200, height: 80))
                TextField.backgroundColor = UIColor.gray
                newlabel.textAlignment = .left
                newlabel.text = (count["field-name"] as! String)
                self.view.addSubview(newlabel)
                TextField.textAlignment = .left
                TextField.borderStyle = UITextField.BorderStyle.roundedRect
                self.view.addSubview(TextField)
                
                TextField.placeholder = "Place holder text"
                labelNameTemp.append(newlabel.text ?? "None")
                newTextField.append(TextField)
            j = j + 100


            }

            }
        let button:UIButton = UIButton(frame: CGRect(x: 150, y: Int(j+100), width: 100, height: 50))
                  
button.backgroundColor = .black
                  button.setTitle("OK", for: .normal)
                  button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
                          self.view.addSubview(button)
               }
    func switchScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as? UIViewController {
            self.show(viewController, sender: nil)
        }
    }
    
    func validate() {
        //  print(labelValueTemp)
        for count in newTextField
        {
            if count.text == "" {
                
                let alert = UIAlertController(title: "Error!", message: "Field can't be left empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                print("called")

            }
            
        }

    }
    func isValidName(nameString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "^[a-zA-Z]{1,15}$"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = nameString as NSString
            let results = regex.matches(in: nameString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    
    func isValidAge(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}

