//
//  ReimbursementTeamLedgerTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 13/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog
import Alamofire
import SVProgressHUD
class ReimbursementTeamLedgerCell : UITableViewCell{
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dueLbl: UILabel!
    @IBOutlet weak var paidLbl: UILabel!
    @IBOutlet weak var balLbl: UILabel!
    
}

class ReimbursementTeamLedgerTableViewController: UITableViewController {

    var oBal = [String]()
    var paidAmmnt = [String]()
    var dueAmmnt = [String]()
    var _expDate = [Date]()
    
    var toDate = ""
    var fromDate = ""
    
    let team = TeamDetailModel()
    let reimburse = ReimbursementLedgerModel()
    var user = ""
    var reimType = ""
    
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var todateLbl: UILabel!
    @IBAction func toDateBtn(_ sender: UIButton) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                self.todateLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.toDate = formatter.string(from: dt)
                self.reimburse.getLedgerGroupTypeData(empCode: self.user)
                self.getReimburseData()
            }
        }
    }
    @IBAction func fromDateBtn(_ sender: UIButton) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                self.fromDateLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.fromDate = formatter.string(from: dt)
                self.reimburse.getLedgerGroupTypeData(empCode: self.user)
                self.getReimburseData()
            }
        }
        
    }
    @IBOutlet weak var selectUserBtn: UIButton!
    @IBOutlet weak var selectReimburseBtn: UIButton!
   
    @IBAction func selectUserBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = team.employeeName
        dropDown.anchorView = selectUserBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.selectUserBtn.setTitle(item, for: .normal)
            self.user = self.team.employeeCode[index]
            self.reimburse.getLedgerGroupTypeData(empCode: self.user)
            self.getReimburseData()
        }
            
    }
    
    @IBAction func selectReimburseBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = reimburse.groupType
        dropDown.anchorView = selectReimburseBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.selectReimburseBtn.setTitle(item, for: .normal)
            self.reimType = item
           self.getReimburseData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        team.getTeamData()
      
    }


    
    func getReimburseData(){
        SVProgressHUD.show()
        oBal = [String]()
        paidAmmnt = [String]()
        dueAmmnt = [String]()
        _expDate = [Date]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        var header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : user, "fromdate" : fromDate, "todate":toDate]
        
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/ReimbursementLedger", method: .get, headers : header).responseJSON{
            response in
            
            let ledgerData = response.data!
            let ledgerJSON = response.result.value
            
            if response.result.isSuccess{
                
                do{
                    let ledger = try JSONDecoder().decode(ReimbursementLedgerRoot.self, from: ledgerData)
                    
                    //                    print(ledgerJSON)
                    if ledger.rlgList.count != 0{
                        for x in 1...ledger.rlgList.count{
                            if let group = ledger.rlgList[x-1].groupTitle{
                                if group == self.reimType{
                                    for y in ledger.rlgList[x-1].rll{
                                        if let date = y._expDate{
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
                                            self._expDate.append(formatter.date(from:date)!)
                                        }
                                        if let due = y.dueAmmnt{
                                            self.dueAmmnt.append(due)
                                        }
                                        if let paid = y.paidAmmnt{
                                            self.paidAmmnt.append(paid)
                                        }
                                        if let bal = y.oBal{
                                            self.oBal.append(bal)
                                        }
                                    }
                                }
                            }
                        }
                        SVProgressHUD.dismiss()
                         self.tableView.reloadData()
                    }
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
        return _expDate.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rtlCell", for: indexPath) as! ReimbursementTeamLedgerCell
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        
        cell.dateLbl.text = formatter.string(from: _expDate[indexPath.row])
        cell.balLbl.text = oBal[indexPath.row]
        cell.dueLbl.text = dueAmmnt[indexPath.row]
        cell.paidLbl.text = paidAmmnt[indexPath.row]
        
        
        
        return cell
    }
  
   
}
