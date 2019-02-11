//
//  ReimbursmentLedgerTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 11/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog
import Alamofire
import SVProgressHUD

class ReimbursementLedgerCell : UITableViewCell{
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dueLbl: UILabel!
    @IBOutlet weak var paidLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    
    
}

class ReimbursmentLedgerTableViewController: UITableViewController {

    
    
    let reimburse = ReimbursementLedgerModel()
    
    var oBal = [String]()
    var paidAmmnt = [String]()
    var dueAmmnt = [String]()
    var _expDate = [Date]()
    
    var toDate = ""
    var fromDate = ""
    var gType : String?
    
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var toDateBtn: UIButton!
    
    @IBAction func typeBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        
        dropDown.dataSource = reimburse.groupType
        dropDown.anchorView = typeBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.typeBtn.setTitle(item, for: .normal)
            self.gType = item
            self.getLedgerData()
        }
    }
    @IBAction func fromDateBtn(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
               
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.fromLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy/MM/dd"
                self.fromDate = formatter.string(from: dt)
                self.toDateBtn.isEnabled = true
                self.toLbl.isEnabled = true
                self.getLedgerData()
            }
        }
    }
    @IBAction func toDateBtn(_ sender: UIButton) {
    
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.toLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyy/MM/dd"
                self.toDate = formatter.string(from: dt)
                self.typeBtn.isEnabled = true
                self.getLedgerData()
            }
        }
        
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toDateBtn.isEnabled = false
        typeBtn.isEnabled = false
        toLbl.isEnabled = false
        reimburse.getLedgerGroupTypeData(empCode: "")
    }

  
    
    func getLedgerData(){
        
        oBal = [String]()
        paidAmmnt = [String]()
        dueAmmnt = [String]()
        _expDate = [Date]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        var header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "fromdate" : toDate, "todate":fromDate]
        
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/ReimbursementLedger", method: .get, headers : header).responseJSON{
            response in
            
            let ledgerData = response.data!
            let ledgerJSON = response.result.value
            
            if response.result.isSuccess{
                
                do{
                    let ledger = try JSONDecoder().decode(ReimbursementLedgerRoot.self, from: ledgerData)
                    
//                    print(ledgerJSON)
                    if ledger.rlgList.count != 0 {
                    for x in 1...ledger.rlgList.count{
                        if let group = ledger.rlgList[x-1].groupTitle{
                            if group == self.gType{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "rlCell", for: indexPath) as! ReimbursementLedgerCell
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        
        cell.dateLbl.text = formatter.string(from: _expDate[indexPath.row])
        cell.balanceLbl.text = oBal[indexPath.row]
        cell.dueLbl.text = dueAmmnt[indexPath.row]
        cell.paidLbl.text = paidAmmnt[indexPath.row]
        
       
        
        return cell
    }
}
