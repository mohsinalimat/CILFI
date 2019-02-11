//
//  LoanApprovalTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੧੭/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Alamofire
import SVProgressHUD
import SwiftyJSON
import DropDown

class LoanApprovalCell : MGSwipeTableCell{
    
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var loanTypeLbl: UILabel!
    @IBOutlet weak var amntLbl: UILabel!
    
    
}

class LoanApprovalTableViewController: UITableViewController {
    
    var action = "Pending" 
    var row = ""
    var empName = [String]()
    var loanType = [String]()
    var amnt = [String]()
    var date = [String]()
    
    var empCode = [String]()
    var installmentAmnt = [String]()
    var noOfInstallments = [String]()
    var rowSeq = [String]()
    
    let loan = LoanApprovalModel()
    
    @IBOutlet weak var loanTypeBtn: UIButton!
    @IBAction func loanTypeBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = ["Pending", "Approved", "Rejected"]
        dropDown.anchorView = loanTypeBtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.loanTypeBtn.setTitle(item, for: .normal)
            self.action = item
            
            self.getLoanApplyData()
            SVProgressHUD.show()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        getLoanApplyData()
        loanTypeBtn.setTitle(action, for: .normal)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return empName.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lacell", for: indexPath) as! LoanApprovalCell
        
        let more = MGSwipeButton(title: " Info",icon: UIImage(named: "table-info"), backgroundColor: UIColor.flatGray) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.row = self.rowSeq[indexPath.row]
            self.performSegue(withIdentifier: "goToLoanApplyDetail", sender: self)
            return true
        }
        
        let approve = MGSwipeButton(title: "",icon: UIImage(named: "table-success"), backgroundColor: UIColor.flatGreen) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.setData(index: indexPath.row, status: "A")
            return true
        }
        let reject = MGSwipeButton(title: "",icon: UIImage(named:"table-error"), backgroundColor: UIColor.flatRed) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.setData(index: indexPath.row, status: "R")
            return true
        }
        
        more.centerIconOverText()
        approve.centerIconOverText()
        reject.centerIconOverText()
        
        if action == "Pending"{
            cell.rightButtons = [reject,approve]
            cell.leftButtons = [more]
        }else if action == "Approved"{
            cell.rightButtons = [reject]
            cell.leftButtons = [more]
        }else if action == "Rejected"{
            cell.rightButtons = [approve]
            cell.leftButtons = [more]
        }
       
        
        
        cell.amntLbl.text = amnt[indexPath.row]
        cell.dateLbl.text = date[indexPath.row]
        
        cell.loanTypeLbl.text = loanType[indexPath.row]
        cell.empNameLbl.text = empName[indexPath.row]
        return cell
    }
    
    func getLoanApplyData(){
        
        empName = [String]()
        loanType = [String]()
        amnt = [String]()
        date = [String]()
        
        empCode = [String]()
        installmentAmnt = [String]()
        noOfInstallments = [String]()
        rowSeq = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/loanapply", headers: headers).responseJSON{
            response in
            
            //            print(headers)
            let lApplyData = response.data!
            let lApplyJSON = response.result.value
            
            if response.result.isSuccess{
                //                print(lStatusJSON)
                do{
                    let lApply = try JSONDecoder().decode(LoanApplyRoot.self, from: lApplyData)
//                    print(lApplyJSON)
                    for x in lApply.loanApply{
                        if self.action == x.mgrStatus{
                            if let value = x.empName{
                                self.empName.append(value)
                            }
                            if let value = x.loanType{
                                self.loanType.append(value)
                            }
                            if x.mgrStatus == "Pending"{
                                if let value = x.applyAmnt{
                                    self.amnt.append(String(value))
                                }
                            }else{
                                if let value = x.mgrAmnt{
                                    self.amnt.append(String(value))
                                }
                            }
                            
                            if let value = x.startDeduction{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "MMyyyy"
                                if let date = formatter.date(from: value){
                                    formatter.dateFormat = "MMM yyyy"
                                    self.date.append(formatter.string(from: date))
                                }
                                
                            }
                            
                            
                            if let value = x.empCode{
                                self.empCode.append(value)
                            }
                            if let value = x.applyInstallmentAmount{
                                self.installmentAmnt.append(String(value))
                            }
                            if let value = x.applyNoOfInstallment{
                                self.noOfInstallments.append(String(value))
                            }
                            if let value = x.rowSeq{
                                self.rowSeq.append(value)
                            }
                            
                        }
                    }
                    SVProgressHUD.dismiss()
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
    
    
    func setData(index : Int, status: String){
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        loan.setLoanApprovalModal(params: ["loanData":[["EmployeeCode":self.empCode[index],"MgrAmount":Double(self.amnt[index])!,"MgrInstallmentAmount":Double(self.installmentAmnt[index])!,"MgrNoOfInstallment":Double(self.noOfInstallments[index])!,"MgrRemark":"","MgrStatus":status,"MgrTransactionDate":formatter.string(from: Date()),"RowSeq":self.rowSeq[index]]]], completion: { (returnType) in
           
            print(returnType.string)
            if returnType.string == "Loan approved successfully" || returnType.string == "Loan rejected successfully"{
                SVProgressHUD.showSuccess(withStatus: returnType.string)
                self.getLoanApplyData()
                
            }else{
                
                SVProgressHUD.showError(withStatus: returnType.string)
            }
            
            
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! LoanApproveDetailViewController
        vc.rowSeq = row
        
    }
    
}


