//
//  RegularizeAttendanceTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 19/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SwiftyJSON
import MGSwipeTableCell
import SVProgressHUD

class RegularizeCustomCell : MGSwipeTableCell {
    
    @IBOutlet weak var atndDateLbl: UILabel!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var regluType: UILabel!
    @IBOutlet weak var inOutTime: UILabel!
}

class RegularizeAttendanceTableViewController: UITableViewController {
    let formatter = DateFormatter()
    var atndDate = [String]()
    var empName = [String]()
    var regularizeType = [String]()
    var inOutTime = [String]()
    var status = [String]()
    var rowSequence = [String]()
    var inOrOut = [String]()
    var flag = 0
    let regularizeApproveURL = "\(LoginDetails.hostedIP)/sales/RegularizeApprove"
    
    var yearMonth = ""
    
    let dropDown = DropDown()
    
    @IBOutlet weak var approveStatusTypeBtn: UIButton!
    @IBAction func approveStatusTypeBtn(_ sender: UIButton) {
        
        dropDown.dataSource = ["Pending", "Approved", "Rejected"]
        dropDown.anchorView = approveStatusTypeBtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.approveStatusTypeBtn.setTitle(item, for: .normal)
            action = item
            
            self.updateTable(url: self.regularizeApproveURL, header: ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : self.yearMonth, "employeecode" : defaults.string(forKey: "employeeCode")!])
            self.flag = 1
            
        }
    }
    
    
    @IBOutlet weak var yearMonthBtn: UIButton!
    @IBAction func yearMonthBtn(_ sender: UIButton) {
        
        let yyyyMM = getYearMonth()
        
        let dropDown = DropDown()
        
        dropDown.dataSource = [getMMMMYYYY(yearMonth: yyyyMM[0]), getMMMMYYYY(yearMonth: yyyyMM[1]), getMMMMYYYY(yearMonth: yyyyMM[2])]
        dropDown.anchorView = yearMonthBtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.yearMonthBtn.setTitle(item, for: .normal)
            self.yearMonth = yyyyMM[index]
            
            self.updateTable(url: self.regularizeApproveURL, header: ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : self.yearMonth, "employeecode" : defaults.string(forKey: "employeeCode")!])
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        
        yearMonth = formatter.string(from: Date())
        
       
        
        action = "Pending"
        updateTable(url: self.regularizeApproveURL, header: ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : yearMonth, "employeecode" : defaults.string(forKey: "employeeCode")!])
        
        print(yearMonth)
        approveStatusTypeBtn.setTitle(action, for: .normal)
        
        formatter.dateFormat = "MMMM yyyy"
         yearMonthBtn.setTitle(formatter.string(from: Date()), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if flag == 1{
        tableView.reloadData()
        }
    }
    
    
    
   
    
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return atndDate.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return empName.count ?? 1

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReg", for: indexPath) as! RegularizeCustomCell

        
        let approve = MGSwipeButton(title: "",icon: UIImage(named: "table-success"), backgroundColor: UIColor.flatGreen) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            self.updateRegularizeStatus(inOut: self.inOrOut[indexPath.row], rowSeq: self.rowSequence[indexPath.row], status: "A")
            
            tableView.reloadData()
            
            return true
            
        }
        
        let reject = MGSwipeButton(title: "",icon: UIImage(named:"table-error"), backgroundColor: UIColor.flatRed) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            self.updateRegularizeStatus(inOut: self.inOrOut[indexPath.row], rowSeq: self.rowSequence[indexPath.row], status: "R")
           
            tableView.reloadData()
            
            return true
            
        }
        
//        formatter.dateFormat = "MM/dd/yyyy"
//
//        if let date = formatter.date(from: atndDate[indexPath.row]){
        cell.atndDateLbl.text = atndDate[indexPath.row]
        cell.empNameLbl.text = empName[indexPath.row]
        cell.inOutTime.text = inOutTime[indexPath.row]
        cell.regluType.text = regularizeType[indexPath.row]
       
        
        
            if action == "Pending"{
                cell.rightButtons = [ reject, approve]
                cell.rightSwipeSettings.transition = .drag
                
            }else if action == "Approved"{
                cell.rightButtons = [reject]
        } else if action == "Rejected" {
            cell.rightButtons = [approve]
            
            
        }
        
        
        
        return cell
}
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func updateTable(url : String, header : [String:String]){
        
        
        atndDate = [String]()
        empName = [String]()
        regularizeType = [String]()
        inOutTime = [String]()
        rowSequence = [String]()
        inOrOut = [String]()
        
        Alamofire.request(url, method: .get, headers : header).responseJSON{
            response in
            
            let attnData = response.data!
            let attnJSON = response.result.value
            
            if response.result.isSuccess{
//                print(attnJSON)
                do{
                    let attndSummary = try JSONDecoder().decode(RegularizeAttendanceRoot.self, from: attnData)
                    
                    
                    
                    for x in attndSummary.regularizeStatus{
                        
                            if x.statusIn == action{
                            if let value = x.atnDate{
                                self.atndDate.append(value)
                            }
                            
                            if let value = x.empName{
                                self.empName.append(value)
                            }
                            
                            if let value = x.rowSeq{
                                self.rowSequence.append(value)
                            }
                            
                        
                                if let value = x.regularizeTypeIn{
                                    self.regularizeType.append(value)
                                }
                                
                                if let value = x.inTime{
                                    self.inOutTime.append(value)
                                }
                                
                                self.inOrOut.append("IN")
                                
                            }else if x.statusOut == action{
                                if let value = x.atnDate{
                                    self.atndDate.append(value)
                                }
                                
                                if let value = x.empName{
                                    self.empName.append(value)
                                }
                                
                                if let value = x.rowSeq{
                                    self.rowSequence.append(value)
                                }
                                
                                
                                if let value = x.regularizeTypeOut{
                                    self.regularizeType.append(value)
                                }
                                
                                if let value = x.outTime{
                                    self.inOutTime.append(value)
                                }
                                
                                self.inOrOut.append("OUT")
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
    
    
    func updateRegularizeStatus(inOut : String, rowSeq : String, status : String ){
//        {"regularizeApprove":[{"InOrOut":"OUT","RowSeq":"253991","Status":"A"}
        
        let parameters : [String:[Any]] = [ "regularizeApprove" :[ ["InOrOut" : inOut, "RowSeq": rowSeq ,"Status":status ]]]
        
        Alamofire.request(regularizeApproveURL , method : .post,  parameters : parameters, encoding: JSONEncoding.default , headers: headers).responseJSON{
            response in
            
//            print(parameters)
            
            
            //
            let loginJSON : JSON = JSON(response.result.value)
            
            if response.result.isSuccess{
                print(loginJSON)
                if loginJSON["returnType"].string == "Regularize Rejected Successfully" || loginJSON["returnType"].string == "Regularize Approved Successfully"{
                    SVProgressHUD.showSuccess(withStatus: loginJSON["returnType"].string)
                    self.updateTable(url: self.regularizeApproveURL, header: headers)
                    
                }else{
                    SVProgressHUD.showError(withStatus: loginJSON["returnType"].string)
                }
                
            }
                
            else{
                //print("Error: \(response.result.error!)")
                print(loginJSON)
            }
            //
        }
    }
    
    
    func getYearMonth()->[String]{
        let yearMonth = defaults.string(forKey: "yearMonth")!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        
        let date = [Calendar.current.date(byAdding: .month, value: -2, to: Date()),Calendar.current.date(byAdding: .month, value: -1, to: Date())]
        
        
        formatter.dateFormat = "yyyyMM"
        
        return [formatter.string(from: date[0]!), formatter.string(from: date[1]!), formatter.string(from: Date())]
        
        
    }
    
    func getMMMMYYYY(yearMonth : String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        let monthYear = formatter.date(from: yearMonth)
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: monthYear!)
    }
}

