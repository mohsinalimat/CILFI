//
//  AbsentTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 13/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DatePickerDialog
import Alamofire
import SVProgressHUD

class AbsentCell : UITableViewCell{
    
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var absentLbl: UILabel!
    
}


class AbsentTableViewController: UITableViewController {

    var code = [String]()
    var name = [String]()
    var absent = [String]()
   
    @IBOutlet weak var yearMonth : UILabel!
    @IBAction func monthYearBtn(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                self.yearMonth.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyyMM"
                self.getAbsentData(ym: formatter.string(from: dt))
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        self.yearMonth.text = formatter.string(from: Date())
        formatter.dateFormat = "yyyyMM"
        self.getAbsentData(ym: formatter.string(from: Date()))
    }

    func getAbsentData(ym : String){
        SVProgressHUD.show()
       
        code = [String]()
        name = [String]()
        absent = [String]()
        
        
        var header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : ym, "employeecode" : defaults.string(forKey: "employeeCode")!]
        
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/Absent", method: .get, headers : header).responseJSON{
            response in
            
            let absentData = response.data!
            let absentJSON = response.result.value
            
            if response.result.isSuccess{
                
                do{
                    let absent = try JSONDecoder().decode(AbsentRoot.self, from: absentData)
                    
                        for x in absent.absentEmployee{
                            if let code = x.code{
                                self.code.append(code)
                            }
                            if let name = x.name{
                                self.name.append(name)
                            }
                            if let absent = x.absent{
                                self.absent.append(absent)
                            }
                        }
                        SVProgressHUD.dismiss()
                        self.tableView.reloadData()
                    }
                
                catch{
                    print (error)
                }
            }
            else{
                print("Something Went wrong")
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return code.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath) as! AbsentCell
        
       
        cell.codeLbl.text = code[indexPath.row]
        cell.nameLbl.text = name[indexPath.row]
        cell.absentLbl.text = absent[indexPath.row]
        
        
        
        return cell
    }
   
}
