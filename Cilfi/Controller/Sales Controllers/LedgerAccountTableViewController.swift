//
//  LedgerAccountTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 16/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
import DatePickerDialog
import Alamofire

class LedgerAccountCell : UITableViewCell{
    
    
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bookLbl: UILabel!
    @IBOutlet weak var ammountLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var narrationLbl: UITextView!
}



class LedgerAccountTableViewController: UITableViewController {
    
    var date = [String]()
    var book = [String]()
    var desc = [String]()
    var ammnt = [String]()
    var bal = [String]()
    
   
    
    let ledger = LedgerAccountModel()
    var companyCode = ""
    var toDate = ""
    var fromDate = ""
    
    
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var companyBtn: UIButton!
    
    @IBAction func toDateBtn(_ sender: UIButton) {
    
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                self.toDate = formatter.string(from: dt)
                self.toDateLbl.text = formatter.string(from: dt)
                self.getLedgerDetail()
            }
        }
        
    }
    
    @IBAction func fromDateBtn(_ sender: UIButton) {
   
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                self.fromDate = formatter.string(from: dt)
                self.fromDateLbl.text = formatter.string(from: dt)
                self.getLedgerDetail()
            }
        }
    
    }
   
    @IBAction func companyBtn(_ sender: UIButton) {
        
        let dropDown = DropDown()
        
        dropDown.dataSource = custName
        dropDown.anchorView = companyBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
           
            self.companyBtn.titleLabel?.text = item
            self.companyCode = self.ledger.custCode[index]
            self.getLedgerDetail()
            
        }
        
       
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       ledger.getCustomerData()
        
       
        
    }

   
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return date.count ?? 1
        
       
    }

    
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ledgerCell", for: indexPath) as! LedgerAccountCell
    
    cell.dateLbl.text = date[indexPath.row]
    cell.ammountLbl.text = ammnt[indexPath.row]
    cell.bookLbl.text = book[indexPath.row]
    cell.balanceLbl.text = bal[indexPath.row]
    cell.narrationLbl.text = desc[indexPath.row]
    
    
    

    if Int(bal[indexPath.row])! < 0{
        cell.balanceLbl.textColor = UIColor.flatRed
        cell.ammountLbl.textColor = UIColor.flatRed
    }else  if Int(bal[indexPath.row])! > 0{
        cell.balanceLbl.textColor = UIColor.flatGreen
        cell.ammountLbl.textColor = UIColor.flatGreen
    }else{
        cell.balanceLbl.textColor = UIColor.flatOrange
        cell.ammountLbl.textColor = UIColor.flatOrange
    }
    
    
        return cell
 }
    
    
    
    
    func getLedgerDetail(){
        
         date = [String]()
         book = [String]()
         desc = [String]()
         ammnt = [String]()
         bal = [String]()
       
        
        if companyCode != "" && fromDate != "" && toDate != ""{
        
        var header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : companyCode, "fromdate" : fromDate, "todate" : toDate]
        
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/CustomerLedger", method: .get, headers : header).responseJSON{
            response in
            
            let ledgerData = response.data!
            let JSON = response.result.value
            if response.result.isSuccess{
                
                //               print("UserTrackJSON: \(userTrackDetailJSON)")
                do{
                    let ledger = try JSONDecoder().decode(LedgerDataRoot.self, from: ledgerData)
                    
                    for x in ledger.ledgerData{
                       for y in x.ledgerDetail{
                        
                        var book = String()
                        var desc = String()
                        var amnt = String()
                        var bal = String()
                        var date = String()
                        
                        if y.title == "date"{
                            if let value = y.value{
                                self.date.append(value)
                                date = value
                            }
                            
                        }
                        
                            if y.title == "Book"{
                                if let value = y.value{
                                    self.book.append(value)
                                    book = value
                                }
                                
                            }
                            
                            if y.title == "Description"{
                                if let value = y.value{
                                    self.desc.append(value)
                                    desc = value
                                }
                                
                            }
                            
                            if y.title == "Amount"{
                                if let value = y.value{
                                    self.ammnt.append(value)
                                    amnt = value
                                }
                                
                            }
                            
                            if y.title == "Balance"{
                                if let value = y.value{
                                    self.bal.append(value)
                                    bal = value
                                }
                                
                            }
                        
                       
                        
                        }
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
    
    
    
}
