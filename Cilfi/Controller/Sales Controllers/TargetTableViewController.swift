//
//  TargetTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 26/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DatePickerDialog
import DropDown
import Alamofire
import SVProgressHUD


class TargetCell : UITableViewCell{
    
    @IBOutlet weak var pItemGroupLbl: UILabel!
    @IBOutlet weak var pTSLbl: UILabel!
    @IBOutlet weak var pTALbl: UILabel!
    @IBOutlet weak var sItemGroupLbl: UILabel!
    @IBOutlet weak var sTSLbl: UILabel!
    @IBOutlet weak var sTALbl: UILabel!
    
    @IBOutlet weak var totalTSLbl: UILabel!
    @IBOutlet weak var totalTALbl: UILabel!
    
}

class TargetTableViewController: UITableViewController {
    
    var toMMyyyy = ""
    var fromMMyyyy = ""
    var toDateFlag = false
    
    var totalAssigned = 0.0
    var totalAchieved = 0.0
    
    var group = [String]()
    var pTAssign = [String]()
    var sTAssign = [String]()
    var pTAchieve = [String]()
    var sTAchieve = [String]()
    
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var empCodeLbl: UILabel!
    @IBOutlet weak var empNameLbl: UILabel!
    
    @IBAction func toDateBtn(_ sender: UIButton) {
        
        if toDateFlag{
            DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM yyyy"
                    self.toDateLbl.text = formatter.string(from: dt)
                    formatter.dateFormat = "MMyyyy"
                    self.toMMyyyy = formatter.string(from: dt)
                    self.getCustomerOutstandingData()
                }
            }
        }else{
            SVProgressHUD.showError(withStatus: "Please select From Date First")
        }
        
    }
    
    @IBAction func fromDateBtn(_ sender: UIButton) {
        
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM yyyy"
                self.fromDateLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "MMyyyy"
                self.fromMMyyyy = formatter.string(from: dt)
                self.toDateFlag = true
                self.getCustomerOutstandingData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let today = DateFormatter()
        today.dateFormat = "MMMM yyyy"
        fromDateLbl.text = today.string(from: date)
        toDateLbl.text = today.string(from: date)
        today.dateFormat = "MMyyyy"
        toMMyyyy = today.string(from: date)
        fromMMyyyy = today.string(from: date)
        empNameLbl.text = defaults.string(forKey: "name")!
        empCodeLbl.text = defaults.string(forKey: "employeeCode")!
        
        getCustomerOutstandingData()
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "targetCell", for: indexPath) as! TargetCell
        
        guard let pTS =  Double(pTAssign[indexPath.row]) else {fatalError()}
        guard let sTS = Double(sTAssign[indexPath.row]) else {fatalError()}
        guard let pTA = Double(pTAchieve[indexPath.row]) else {fatalError()}
        guard let sTA = Double(sTAchieve[indexPath.row]) else {fatalError()}
        
        
        cell.pItemGroupLbl.text = group[indexPath.row]
        cell.sItemGroupLbl.text = group[indexPath.row]
        cell.pTALbl.text = pTAchieve[indexPath.row]
        cell.pTSLbl.text = pTAssign[indexPath.row]
        cell.sTALbl.text = sTAchieve[indexPath.row]
        cell.sTSLbl.text = sTAssign[indexPath.row]
        
        
        
        cell.totalTALbl.text = String(pTA+sTA)
        
        cell.totalTSLbl.text = String(pTS+sTS)
        cell.totalTSLbl.textColor = UIColor.flatOrangeDark
        cell.totalTALbl.textColor = UIColor.flatOrangeDark
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return group.count ?? 1
    }
    
    
    func getCustomerOutstandingData(){
        
        group = [String]()
        pTAssign = [String]()
        sTAssign = [String]()
        pTAchieve = [String]()
        sTAchieve = [String]()
        
        totalAssigned = 0.0
        totalAchieved = 0.0
        
        var header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "fromyymm" : fromMMyyyy, "toyymm" : toMMyyyy]
        
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/Target", method: .get, headers : header).responseJSON{
            response in
            
            //            print(header)
            
            let targetData = response.data!
            let targetJSON = response.result.value
            
            if response.result.isSuccess{
                //                print("UserJSON: \(custJSON)")
                do{
                    let target = try JSONDecoder().decode(TargetRoot.self, from: targetData)
                    
                    
                    for x in target.tData{
                        
                        if let grp = x.groupName{
                            self.group.append(grp)
                        }
                        if let value = x.achivedPrimary{
                            self.pTAchieve.append(value)
                            
                        }
                        if let value = x.achievedSecondary{
                            self.sTAchieve.append(value)
                        }
                        if let value = x.primarySale{
                            self.pTAssign.append(value)
                        }
                        if let value = x.secondarySale{
                            self.sTAssign.append(value)
                        }
                    }
                    
//                    self.calculateTotal()
                    
                    
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
    
}
