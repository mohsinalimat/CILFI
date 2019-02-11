//
//  SalaryLedgerViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 23/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import MonthYearPicker
import DatePickerDialog
class LedgerCell : UITableViewCell{
    
    @IBOutlet weak var yearMonthlbl: UILabel!
    @IBOutlet weak var paidlbl: UILabel!
    @IBOutlet weak var duelbl: UILabel!
    @IBOutlet weak var netpaylbl: UILabel!
    
}

class SalaryLedgerViewController: UITableViewController {

    let paySlipUrl = "\(LoginDetails.hostedIP)/Sales/SalaryLedger"
    
    var monthYear = [String]()
    var paid = [String]()
    var due = [String]()
    var netPay = [String]()
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBAction func dateBtn(_ sender: UIButton) {
    
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMM"
                self.getSalaryLedger(ym: formatter.string(from: dt))
                self.dateLbl.text = formatter.string(from: dt)
            }
        }
    
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let yearmonth = defaults.string(forKey: "yearMonth"){
            dateLbl.text = yearmonth
        
            getSalaryLedger(ym: yearmonth)
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthYear.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ledgerCell", for: indexPath) as! LedgerCell
        cell.yearMonthlbl.text = monthYear[indexPath.row]
        cell.netpaylbl.text = netPay[indexPath.row]
        cell.paidlbl.text = paid[indexPath.row]
        cell.duelbl.text = due[indexPath.row]
        if paid[indexPath.row] != "0.00"{
            cell.paidlbl.textColor = UIColor.flatGreen
        }else{
            cell.paidlbl.textColor = UIColor.flatRed
        }
        return cell

    }


    func getSalaryLedger(ym : String){
        
        monthYear = [String]()
        paid = [String]()
        due = [String]()
        netPay = [String]()
        
        print(ym)
        let header : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : ym, "employeecode" : defaults.string(forKey: "user")!]
        
        Alamofire.request(paySlipUrl, method: .get, headers : header).responseJSON{
            response in
            
            let slData = response.data!
            let slJSON = response.result.value
            if response.result.isSuccess{
                //                print(paySlipJSON)
                do{
                    let sl = try JSONDecoder().decode(SalaryLedgerRoot.self, from: slData)
                    
                    for x in sl.slData{
                        
                        self.monthYear.append(x.yearmonth!)
                        self.paid.append(x.paid!)
                        self.due.append(x.due!)
                        self.netPay.append(x.netPay!)
                        
                        
                    }
                   
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
