//
//  MyLeavesTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 05/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class LeaveCell : UITableViewCell{
    
    @IBOutlet weak var leaveType: UILabel!
    @IBOutlet weak var leaveFrom: UILabel!
    @IBOutlet weak var leaveUpto: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var remarks: UILabel!
    
}


class MyLeavesTableViewController: UITableViewController {
    
    var leaveType = [String]()
    var fromDate = [String]()
    var tillDate = [String]()
    var remarks = [String]()
    var status = [String]()
    var reason = [String]()
    var reqDate = [String]()
    
    let leaveStatusUrl = "\(LoginDetails.hostedIP)/sales/LeaveStatus"
//        let headers : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getLeaveStatusData(url: leaveStatusUrl, header: headers)
        
        SVProgressHUD.show()
    }
    
    
    func getLeaveStatusData(url : String, header : [String:String]){
        
        leaveType = [String]()
        fromDate = [String]()
        tillDate = [String]()
        remarks = [String]()
        status = [String]()
        reason = [String]()
        reqDate = [String]()
        
//                print(header)
        
        //      print("we are here")
        Alamofire.request(url, method: .get, headers : headers).responseJSON{
            response in
            
            let leaveStatusData = response.data!
            let leaveStatusJSON = response.result.value
            if response.result.isSuccess{
                print("LeaveStatusJSON: \(leaveStatusJSON)")
                //                print(response)
                
                do{
                    let summary = try JSONDecoder().decode(LeaveStatusRoot.self, from: leaveStatusData)
                    //                                        print(leaveStatusJSON)
                    for x in summary.leaveStatus{
                        
                        if let value = x.leaveType {
                            self.leaveType.append(value)
                        }
                        if let value = x.fromDate {
                            self.fromDate.append(value)
                        }
                        if let value = x.tillDate {
                            self.tillDate.append(value)
                        }
                        if let value = x.remarks {
                            self.remarks.append(value)
                        }
                        if let value = x.reason{
                            self.reason.append(value)
                        }
                        if let value = x.status {
                            self.status.append(value)
                        }
                        
                        if let rDate = x.reqDate {
                            self.reqDate.append(rDate)
                        }
                    }
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                    print(self.reason)
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
        return leaveType.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeaveCell
        
        cell.leaveType.text = leaveType[indexPath.row]
        cell.leaveFrom.text = fromDate[indexPath.row]
        cell.leaveUpto.text = tillDate[indexPath.row]
        cell.reason.text = reason[indexPath.row]
        if status[indexPath.row] == "Pending"{
            cell.status.text = status[indexPath.row]
            cell.status.textColor = UIColor.flatOrange
        }else if status[indexPath.row] == "Rejected"{
            cell.status.text = status[indexPath.row]
            cell.status.textColor = UIColor.flatRed
        }else if status[indexPath.row] == "Approved"{
            cell.status.text = status[indexPath.row]
            cell.status.textColor = UIColor.flatGreen
        }
        cell.remarks.text = remarks[indexPath.row]
        return cell
    }
    
}
