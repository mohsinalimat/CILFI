//
//  ReimbursementStatusTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 26/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ReimbursementStatusCell : UITableViewCell{
    
    @IBOutlet weak var rTypeLbl: UILabel!
    @IBOutlet weak var expDateLbl: UILabel!
    @IBOutlet weak var remarkLbl: UILabel!
    @IBOutlet weak var amntLbl: UILabel!
    @IBOutlet weak var mgrRemarksLbl: UILabel!
    @IBOutlet weak var mgrStatusLbl: UILabel!
    @IBOutlet weak var hrRemarks: UILabel!
    @IBOutlet weak var hrStatusLbl: UILabel!
    
}

class ReimbursementStatusTableViewController: UITableViewController {
    
    var reimburseType = [String]()
    var expenseDate = [String]()
    var remarks = [String]()
    var amnt = [String]()
    var managerRemmarks = [String]()
    var managerStatus = [String]()
    var hrRemarks = [String]()
    var hrStatus = [String]()
    
    let reimbursementStatusURL = "\(LoginDetails.hostedIP)/sales/reimbursementstatus"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        getRStatusData()
        
    }
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reimburseType.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reimbursementStatusCell", for: indexPath) as! ReimbursementStatusCell
        cell.rTypeLbl.text = reimburseType[indexPath.row]
        cell.expDateLbl.text = expenseDate[indexPath.row]
        cell.remarkLbl.text = remarks[indexPath.row]
        cell.amntLbl.text = amnt[indexPath.row]
        cell.mgrStatusLbl.text = managerStatus[indexPath.row]
        cell.mgrRemarksLbl.text = managerRemmarks[indexPath.row]
        cell.hrRemarks.text = hrRemarks[indexPath.row]
        cell.hrStatusLbl.text = hrStatus[indexPath.row]
        
        if hrStatus[indexPath.row] == "Pending"{
            cell.hrStatusLbl.textColor = UIColor.flatOrange
        }else if hrStatus[indexPath.row] == "Rejected"{
            cell.hrStatusLbl.textColor = UIColor.flatRed
        }else if hrStatus[indexPath.row] == "Approved"{
            cell.hrStatusLbl.textColor = UIColor.flatGreen
        }
        
        if managerStatus[indexPath.row] == "Pending"{
            cell.mgrStatusLbl.textColor = UIColor.flatOrange
        }else if managerStatus[indexPath.row] == "Rejected"{
            cell.mgrStatusLbl.textColor = UIColor.flatRed
        }else if managerStatus[indexPath.row] == "Approved"{
            cell.mgrStatusLbl.textColor = UIColor.flatGreen
        }
        
        return cell
    }
    //
    
    
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func getRStatusData(){
        
        reimburseType = [String]()
        expenseDate = [String]()
        remarks = [String]()
        amnt = [String]()
        managerRemmarks = [String]()
        managerStatus = [String]()
        hrRemarks = [String]()
        hrStatus = [String]()
        
        Alamofire.request(reimbursementStatusURL, headers: headers).responseJSON{
            response in
            
            print(headers)
            let rStatusData = response.data!
            let rStatusJSON = response.result.value
            
            if response.result.isSuccess{
                print(rStatusJSON)
                do{
                    let rStatus = try JSONDecoder().decode(ReimbursementStatusRoot.self, from: rStatusData)
                    
                    for x in rStatus.statInfo{
                        
                        if let rtype = x.rType{
                            self.reimburseType.append(rtype)
                        }
                        if let expdate = x.expenseDate{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
                            if let date = formatter.date(from: expdate){
                                formatter.dateFormat = "dd MMMM yyyy"
                                self.expenseDate.append(formatter.string(from: date))
                                
                            }
                        }
                        
                        if let amnt = x.amount{
                                self.amnt.append(amnt)
                            }
                        
                        if let remarks = x.remark{
                            self.remarks.append(remarks)
                        }
                       
                        if let mgrremarks = x.mgrRemarks{
                            self.managerRemmarks.append(mgrremarks)
                        }
                        if let mgrstatus = x.mgrStatus{
                            self.managerStatus.append(mgrstatus)
                        }
                        if let hrmgrremarks = x.hrMgrRemark{
                            self.hrRemarks.append(hrmgrremarks)
                        }
                        if let hrmgrstatus = x.hrMgrStatus{
                            self.hrStatus.append(hrmgrstatus)
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
                print("Something Went wrong")
            }
        }
        
    }
    
    
}
