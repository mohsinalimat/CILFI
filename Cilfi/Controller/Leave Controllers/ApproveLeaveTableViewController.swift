//
//  ApproveLeaveTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 06/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import MGSwipeTableCell
import ChameleonFramework
import SVProgressHUD

var rowseq = ""
var action : String?

class LeaveDetailCell : MGSwipeTableCell{
    
    @IBOutlet weak var empNamelbl: UILabel!
    @IBOutlet weak var leaveTypelbl: UILabel!
    @IBOutlet weak var fromDatelbl: UILabel!
    @IBOutlet weak var toDatelbl: UILabel!
    
}


class ApproveLeaveTableViewController: UITableViewController {
    var empName = [String]()
    var leaveType = [String]()
    var fromDate = [String]()
    var toDate = [String]()
    var rowSeq = [String]()
    
    
    let dataURL = "\(LoginDetails.hostedIP)/sales/LeaveDetail"
    let setDataURL = "\(LoginDetails.hostedIP)/sales/LeaveApproval"
    
    let headers : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!]
    
    let dropDown = DropDown()
    
    
    let date = Date()
    let formatter = DateFormatter()
    
    
    @IBOutlet weak var leaveActionbtn: UIButton!
    @IBAction func leaveActionbtn(_ sender: UIButton) {
        dropDown.dataSource = ["Pending", "Approved", "Rejected"]
        dropDown.anchorView = leaveActionbtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.leaveActionbtn.setTitle(item, for: .normal)
            action = item
            self.getLeaveData(url: self.dataURL, header: self.headers)
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        getLeaveData(url: self.dataURL, header: self.headers)
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return empName.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeaveDetailCell
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        let more = MGSwipeButton(title: " Info",icon: UIImage(named: "table-info"), backgroundColor: UIColor.flatGray) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            
            self.performSegue(withIdentifier: "goToLeaveDetail", sender: self)
            rowseq = self.rowSeq[indexPath.row]
            
            return true
            
        }
        
        let approve = MGSwipeButton(title: "",icon: UIImage(named: "table-success"), backgroundColor: UIColor.flatGreen) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            
            
            self.status(rowSeq: self.rowSeq[indexPath.row], approvalDate: self.formatter.string(from: self.date), mgrRemarks: "Approved", mgerStatus:"Y" )
            
            tableView.reloadData()
            
            return true
            
        }
        
        let reject = MGSwipeButton(title: "",icon: UIImage(named:"table-error"), backgroundColor: UIColor.flatRed) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            
            self.status(rowSeq: self.rowSeq[indexPath.row], approvalDate: self.formatter.string(from: self.date), mgrRemarks: "Rejected", mgerStatus:"N" )
            tableView.reloadData()
            
            return true
            
        }
        
        
        cell.empNamelbl.text = empName[indexPath.row]
        cell.leaveTypelbl.text = leaveType[indexPath.row]
        cell.fromDatelbl.text = fromDate[indexPath.row]
        cell.toDatelbl.text = toDate[indexPath.row]
        
        cell.leftButtons = [more]
        
        cell.leftSwipeSettings.transition = .drag
        
        if action == "Pending"{
            cell.rightButtons = [ reject, approve]
            cell.rightSwipeSettings.transition = .drag
            
        }
        else{
            cell.rightButtons = []
        }
        
        cell.rightSwipeSettings.transition = .rotate3D
        
        return cell
    }
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func getLeaveData(url : String, header : [String:String]){
        empName = [String]()
        leaveType = [String]()
        fromDate = [String]()
        toDate = [String]()
        rowSeq = [String]()
        
        Alamofire.request(url, method: .get, headers : header).responseJSON{
            response in
            
            let leaveData = response.data!
            let leaveJSON = response.result.value
            
            if response.result.isSuccess{
                
                do{
                    let leave = try JSONDecoder().decode(LeaveDetailRoot.self, from: leaveData)
                    //line chart
                    
                    for x in leave.leaveInfo{
                        if x.mgrStatus == action{
                            self.empName.append(x.empName!)
                            self.leaveType.append(x.leaveType!)
                            self.fromDate.append(x.fromDate!)
                            self.toDate.append(x.toDate!)
                            self.rowSeq.append(x.rowSeq!)
                            self.tableView.reloadData()
                        }
                    }
                    //                    print(self.empName)
                    //                    print(self.leaveType)
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
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func status(rowSeq : String, approvalDate : String, mgrRemarks: String, mgerStatus: String){
        let parameters : [String:[Any]] = [ "mgrLeave" :[ ["RowSeq" : rowSeq, "ApprovalDate": approvalDate,"MgrRemark":mgrRemarks,"MgrStatus":mgerStatus]]]
        
        
        Alamofire.request(setDataURL , method : .post,  parameters : parameters, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
            print(parameters)
            
            
            //
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print("Success! Posting the Leave Detail data")
                if loginJSON["returnType"].string == "Leave rejected successfully" || loginJSON["returnType"].string == "Leave approved successfully" {
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    self.getLeaveData(url: self.dataURL, header: self.headers)
                }else{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                }
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(loginJSON)
            }
            
        }
    }
    
    
}

