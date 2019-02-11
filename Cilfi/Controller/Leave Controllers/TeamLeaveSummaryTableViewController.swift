//
//  TeamLeaveSummaryTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 16/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import DatePickerDialog
import SVProgressHUD
import DropDown


class TeamLeaveSummaryCell : UITableViewCell{
    
    @IBOutlet weak var leaveType: UILabel!
    @IBOutlet weak var openingLbl: UILabel!
    @IBOutlet weak var creditedLbl: UILabel!
    @IBOutlet weak var consumedLbl: UILabel!
    @IBOutlet weak var closingLbl: UILabel!
    
}


class TeamLeaveSummaryTableViewController: UITableViewController {

    let team = TeamDetailModel()
    
    var date = ""
    var user = ""
    
    var leaveType = [String]()
    var opening = [String]()
    var credited = [String]()
    var consumed = [String]()
    var closing = [String]()
    
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var selectUserBtn: UIButton!
    
    @IBAction func selectUserBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = team.employeeName
        dropDown.anchorView = selectUserBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.selectUserBtn.setTitle(item, for: .normal)
            self.user = self.team.employeeCode[index]
            self.getSummary(dt: self.date, usr: self.user)
        }
    }
    @IBAction func dateBtn(_ sender: UIButton) {
    
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMM"
                self.date = formatter.string(from: dt)
                formatter.dateFormat = "dd-MM-yyyy"
                self.dateLbl.text = formatter.string(from: dt)
                self.getSummary(dt: self.date, usr: self.user)
                
            }
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        team.getTeamData()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        date = formatter.string(from: Date())
        formatter.dateFormat = "dd-MM-yyyy"
        self.dateLbl.text = formatter.string(from: Date())
       
    }

    
    func getSummary(dt : String, usr : String){
        SVProgressHUD.show()
        
        leaveType = [String]()
        opening = [String]()
        credited = [String]()
        consumed = [String]()
        closing = [String]()
        
        let header : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : dt, "employeecode" : usr]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/leavesummary", method: .get, headers : header).responseJSON{
            response in
            
            let leaveStatusData = response.data!
            let leaveStatusJSON = response.result.value
            
            if response.result.isSuccess{
                                print("LeaveStatusJSON: \(leaveStatusJSON)")
                //                print(response)
                
                do{
                    let summary = try JSONDecoder().decode(LeaveSummaryRoot.self, from: leaveStatusData)
                    //                    print(leaveStatusData)
                    for x in summary.leaveSummary{
                        
                        if let value = x.leaveType{
                            self.leaveType.append(value)
                        }
                        
                        if let value = x.credited{
                            self.credited.append(value)
                        }
                        
                        if let value = x.consumed{
                            self.consumed.append(value)
                        }
                        
                        if let value = x.opening{
                            self.opening.append(value)
                        }
                        
                        if let value = x.closing{
                            self.closing.append(value)
                        }
                        
                        
                    }
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
                catch{
                    print (error)
                }
                
            }
            else{
                print("Something Went wrong \(LoginDetails.hostedIP)/sales/leavesummary")
            }
            
        }
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return leaveType.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tlsCell", for: indexPath) as! TeamLeaveSummaryCell
        cell.closingLbl.text = closing[indexPath.row]
        cell.consumedLbl.text = consumed[indexPath.row]
        cell.creditedLbl.text = credited[indexPath.row]
        cell.leaveType.text = leaveType[indexPath.row]
        cell.openingLbl.text = opening[indexPath.row]
        return cell
    }


}
