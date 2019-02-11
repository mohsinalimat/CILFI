//
//  LoanStatusTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੬/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LoanStatusCell : UITableViewCell{
    
    @IBOutlet weak var seqNo: UILabel!
    @IBOutlet weak var loanType: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var noOfInstallments: UILabel!
    @IBOutlet weak var installment: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var deductionStart: UILabel!
    
    
}


class LoanStatusTableViewController: UITableViewController {

    var seqNo = [String]()
    var loanType = [String]()
    var tDate = [String]()
    var amnt = [String]()
    var noOfInstallments = [String]()
    var installmentAmnt = [String]()
    var remark = [String]()
    var status = [String]()
    var deductionStart = [Date]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       getData()
    }

   
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return seqNo.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lscell", for: indexPath) as! LoanStatusCell
        
        cell.seqNo.text = seqNo[indexPath.row]
        cell.loanType.text = loanType[indexPath.row]
        cell.transactionDate.text = tDate[indexPath.row]
        
        cell.amount.text = amnt[indexPath.row]
        cell.noOfInstallments.text = noOfInstallments[indexPath.row]
        cell.installment.text = installmentAmnt[indexPath.row]
        
        cell.remark.text = remark[indexPath.row]
        if status[indexPath.row] == "Pending"{
            cell.status.textColor = UIColor.flatOrange
        }else if status[indexPath.row] == "Rejected"{
            cell.status.textColor = UIColor.flatRed
        }else if status[indexPath.row] == "Approved"{
            cell.status.textColor = UIColor.flatGreen
        }
        cell.status.text = status[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        
        cell.deductionStart.text = formatter.string(from: deductionStart[indexPath.row])
        
        
        return cell
    }
   
    func getData(){
        
         seqNo = [String]()
         loanType = [String]()
         tDate = [String]()
         amnt = [String]()
         noOfInstallments = [String]()
         installmentAmnt = [String]()
         remark = [String]()
         status = [String]()
         deductionStart = [Date]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/LoanStatus", headers: headers).responseJSON{
            response in
            
            //            print(headers)
            let lStatusData = response.data!
            let lStatusJSON = response.result.value
            
            if response.result.isSuccess{
                //                print(lStatusJSON)
                do{
                    let lStatus = try JSONDecoder().decode(LoanStatusRoot.self, from: lStatusData)
                    
                    for x in lStatus.loanStat{
                       
                            if let value = x.seqNo{
                                self.seqNo.append(value)
                            }
                            if let value = x.loanType{
                                self.loanType.append(value)
                            }
                            if let value = x.applyTransactionDate{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                
                                if let date = formatter.date(from: value){
                                    formatter.dateFormat = "dd MMMM yyyy"
                                    self.tDate.append(formatter.string(from: date))
                                    
                                }
                            }
                        
                            if let value = x.remark{
                                self.remark.append(value)
                            }
                            if let value = x.mgrStatus{
                                if value == "Approved"{
                                    if let value = x.mgrAmnt{
                                        self.amnt.append(String(value))
                                    }
                                    if let value = x.mgrNoOfInstallment{
                                        self.noOfInstallments.append(String(value))
                                    }
                                    if let value = x.mgrInstallmentAmount{
                                        self.installmentAmnt.append(String(value))
                                    }
                                }else{
                                    if let value = x.applyAmnt{
                                        self.amnt.append(String(value))
                                    }
                                    if let value = x.applyNoOfInstallment{
                                        self.noOfInstallments.append(String(value))
                                    }
                                    if let value = x.applyInstallmentAmount{
                                        self.installmentAmnt.append(String(value))
                                    }
                                }
                                self.status.append(value)
                            }
                            if let value = x.startDeduction{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "MMyyyy"
                                self.deductionStart.append(formatter.date(from: value)!)
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
