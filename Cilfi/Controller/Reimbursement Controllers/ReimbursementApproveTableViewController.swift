//
//  ReimbursementApproveTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 26/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import MGSwipeTableCell
import SwiftyJSON
import SVProgressHUD

class ReimbursementApproveCell : MGSwipeTableCell{
    
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var rTypeLbl: UILabel!
    @IBOutlet weak var tAmntLbl: UILabel!
    @IBOutlet weak var expDateLbl: UILabel!
    @IBOutlet weak var empCodeLbl: UILabel!
    @IBOutlet weak var actualKmsLbl: UILabel!
    @IBOutlet weak var kmsLbl: UILabel!
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
}


class ReimbursementApproveTableViewController: UITableViewController {
    let reimbursementApprove = ReimbursementApprovalModel()
    let reimbursementDetailURL = "\(LoginDetails.hostedIP)/sales/ReimbursementDetail"
    
    let reim = ReimbursementModel()
    
    var reimType = "Pending"
    var rowSequence = ""
    var location = "All Locations"
    
    var backButton = UIBarButtonItem()
    
    var locations = [String]()
    
    var empName = [String]()
    var empCode = [String]()
    var dType = [String]()
    var lType = [String]()
    var expenseDate = [String]()
    
    var _expDate = [String]()
    var mgrRemarks = [String]()
    var mgrStatus = [String]()
    var rowSeq = [String]()
    var reimburseName = [String]()
    var reimburseType = [String]()
    var totalKms = [String]()
    var trackedKms = [String]()
    var totalAmmnt = [String]()
    var remarks = [String]()
    var trackingKms = [Int]()
    
    //    var empName = [String]()
    //    var reimburseType = [String]()
    //    var totalAmmnt = [String]()
    //    var expenseDate = [String]()
    //    var empCode = [String]()
    //    var totalKms = [String]()
    
    var date = [Date]()
    let dropDown = DropDown()
    
    
    
    @IBOutlet weak var typeBtn: UIButton!
    
    @IBAction func typeBtn(_ sender: UIButton) {
        
        dropDown.dataSource = ["Pending", "Approved", "Rejected", "Paid"]
        dropDown.anchorView = typeBtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.typeBtn.setTitle(item, for: .normal)
            self.reimType = item
            
            self.getRDetailsData()
            
        }
        
    }
    
    @IBOutlet weak var locationBtn: UIButton!
    @IBAction func locationBtn(_ sender: UIButton) {
        
        dropDown.dataSource = locations
        dropDown.anchorView = locationBtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.locationBtn.setTitle(item, for: .normal)
            self.location = item
            
            self.getRDetailsData()
            //            SVProgressHUD.show()
        }
        
    }
    
    
    @IBAction func unwindToReimbursementApprovalTable(segue:UIStoryboardSegue) {
        if let tbText = typeBtn.titleLabel?.text{
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocationData { (loc) in
            self.locations = loc
        }
        
        locationBtn.setTitle(location, for: .normal)
        typeBtn.setTitle(reimType, for: .normal)
        
        getRDetailsData()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButton))
        
        self.tableView.allowsSelection = false
        self.tableView.allowsMultipleSelection = false
        
        //        backButton = navigationItem.leftBarButtonItem!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if reimType == "Pending" || reimType == "Approved" || reimType == "Rejected"{
            getRDetailsData()
        }
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return empName.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reimbursementApproveCell", for: indexPath) as! ReimbursementApproveCell
        
        let more = MGSwipeButton(title: " Info",icon: UIImage(named: "table-info"), backgroundColor: UIColor.flatGray) {
            (sender: MGSwipeTableCell!) -> Bool in
            rowseq = self.rowSeq[indexPath.row]
            
            self.performSegue(withIdentifier: "reimbursementApproveInfos", sender: self)
            return true
            
        }
        
        let approve = MGSwipeButton(title: "",icon: UIImage(named: "table-success"), backgroundColor: UIColor.flatGreen) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            
            self.reimbursementApprove.status(dType: self.dType[indexPath.row], empCode: self.empCode[indexPath.row], expensedate: self.expenseDate[indexPath.row], ltype: self.lType[indexPath.row], mgrremarks: "", mgrStatus: "Y", rowseq: self.rowSeq[indexPath.row], approvedAmmount: self.totalAmmnt[indexPath.row], approvedKms: self.totalKms[indexPath.row], completion: {(returnType) in
                
                if returnType == "Reimbursement rejected successfully" || returnType == "Reimbursement approved successfully"{
                    SVProgressHUD.showSuccess(withStatus: returnType)
                    self.getRDetailsData()
                }else{
                    SVProgressHUD.showError(withStatus: returnType)
                }
                
                
            })
            
            return true
            
        }
        
        let reject = MGSwipeButton(title: "",icon: UIImage(named:"table-error"), backgroundColor: UIColor.flatRed) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            self.reimbursementApprove.status(dType: self.dType[indexPath.row], empCode: self.empCode[indexPath.row], expensedate: self.expenseDate[indexPath.row], ltype: self.lType[indexPath.row], mgrremarks: "", mgrStatus: "N", rowseq: self.rowSeq[indexPath.row], approvedAmmount: self.totalAmmnt[indexPath.row], approvedKms: self.totalKms[indexPath.row], completion:{(returnType) in
                
                
                if returnType == "Reimbursement rejected successfully" || returnType == "Reimbursement approved successfully"{
                    SVProgressHUD.showSuccess(withStatus: returnType)
                    self.getRDetailsData()
                }else{
                    SVProgressHUD.showError(withStatus: returnType)
                }
                
                
            })
            return true
            
        }
        
        
        
        cell.empNameLbl.text = empName[indexPath.row]
        
        cell.rTypeLbl.text = reimburseType[indexPath.row]
        cell.tAmntLbl.text = totalAmmnt[indexPath.row]
        cell.expDateLbl.text = expenseDate[indexPath.row]
        cell.empCodeLbl.text = empCode[indexPath.row]
        
        if reimburseName[indexPath.row].contains("Other"){
            cell.kmsLbl.isHidden = true
            cell.actualKmsLbl.text = reimburseName[indexPath.row]
        }else{
            cell.kmsLbl.isHidden = false
            cell.actualKmsLbl.text = reimburseName[indexPath.row]
            cell.kmsLbl.text = totalKms[indexPath.row]
        }
        
        cell.leftButtons = [more]
        
        cell.leftSwipeSettings.transition = .drag
        
        if reimType == "Pending"{
            cell.rightButtons = [ reject, approve]
            cell.rightSwipeSettings.transition = .drag
            
        }
        else if reimType == "Approved"{
            cell.rightButtons = [reject]
            cell.rightSwipeSettings.transition = .drag
        }
            
        else if reimType == "Rejected"{
            cell.rightButtons = [approve]
            cell.rightSwipeSettings.transition = .drag
        }
        cell.rightSwipeSettings.transition = .rotate3D
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reimbursementApproveInfos"{
            // get a reference to the second view controller
            let vc = segue.destination as! ReimbursementDetailsViewController
            
            // set a variable in the second view controller with the String to pass
            vc.rowSeq = rowseq
            
        }
    }
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    
    
    func getRDetailsData(){
        
        empName = [String]()
        reimburseType = [String]()
        totalAmmnt = [String]()
        expenseDate = [String]()
        empCode = [String]()
        totalKms = [String]()
        date = [Date]()
        //_expDate = [String]() // used for fetching date for accept/reject all btns
        rowSeq = [String]()
        lType = [String]()
        dType = [String]()
        Alamofire.request(reimbursementDetailURL, headers: headers).responseJSON{
            response in
            
            
            let rStatusData = response.data!
            let rStatusJSON = response.result.value
            
            if response.result.isSuccess{
                SVProgressHUD.show()
                //                                print(rStatusJSON)
                do{
                    let rDetail = try JSONDecoder().decode(ReimbursementDetailRoot.self, from: rStatusData)
                    
                    print(self.reimType)
                    for x in rDetail.rInfo{
                        
                        
                        
                        if self.location == "All Locations"{
                            
                            if self.reimType == x.mgrstatus{
                                
                                if x.mgrstatus == "Approved"{
                                    if let value = x.approvedAmmount{
                                        self.totalAmmnt.append(String(value))
                                    }
                                }else{
                                    if let value = x.amnt{
                                        self.totalAmmnt.append(value)
                                    }
                                }
                                
                                if let value = x.empname{
                                    self.empName.append(value)
                                }
                                if let value = x.empcode{
                                    self.empCode.append(value)
                                }
                                if let value = x.reimbursetype{
                                    self.reimburseType.append(value)
                                }
                                
                                if let value = x._expenseDate{
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                    if let date = formatter.date(from: value){
                                        self.date.append(date)
                                        formatter.dateFormat = "dd MMMM yyyy"
                                        self.expenseDate.append(formatter.string(from: date))
                                    }
                                }
                                if let value = x.kms{
                                    self.totalKms.append(String(value))
                                }
                                if let value = x.fullName{
                                    self.reimburseName.append(value)
                                }
                                
                                if let value = x.ltype{
                                    self.lType.append(value)
                                }
                                if let value = x.dtype{
                                    self.dType.append(value)
                                }
                                if let value = x.rowSeq{
                                    self.rowSeq.append(value)
                                }
                                
                            }
                            
                        }else{
                            if self.reimType == x.mgrstatus && self.location == x.locationName {
                                if let value = x.empname{
                                    self.empName.append(value)
                                    
                                }
                                if let value = x.empcode{
                                    self.empCode.append(value)
                                }
                                if let value = x.reimbursetype{
                                    self.reimburseType.append(value)
                                }
                                if let value = x.amnt{
                                    self.totalAmmnt.append(value)
                                }
                                if let value = x._expenseDate{
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                    let date = formatter.date(from: value)!
                                    self.date.append(date)
                                    formatter.dateFormat = "dd-MM-yyyy"
                                    self.expenseDate.append(value)
                                    
                                }
                                if let value = x.kms{
                                    self.totalKms.append(String(value))
                                }
                                if let value = x.fullName{
                                    self.reimburseName.append(value)
                                }
                                if let value = x.ltype{
                                    self.lType.append(value)
                                }
                                if let value = x.dtype{
                                    self.dType.append(value)
                                }
                                if let value = x.rowSeq{
                                    self.rowSeq.append(value)
                                }
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                    //                    print(self.empCode)
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
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func getLocationData(completion : @escaping ([String])-> Void){
        
        var loc = ["All Locations"]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/PayLocationList", headers: headers).responseJSON{
            response in
            
            
            let payData = response.data!
            let payJSON = response.result.value
            
            if response.result.isSuccess{
                //                print(rStatusJSON)
                do{
                    let pay = try JSONDecoder().decode(PayLocationListRoot.self, from: payData)
                    
                    for x in pay.payList{
                        
                        if let value = x.name{
                            loc.append(value)
                        }
                        
                        
                    }
                    
                    completion(loc)
                }catch{
                    
                }
            }
            else{
                print("Something Went wrong")
            }
            
        }
        
    }
    
    @objc func selectButton(){
        if reimType == "Pending"{
            SVProgressHUD.showInfo(withStatus: "You can now select data.")
            SVProgressHUD.dismiss(withDelay: 3)
            self.tableView.allowsMultipleSelection = true
            
            self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton)), UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(selectAllButton))]
            self.navigationItem.title = ""
            self.navigationItem.hidesBackButton = true
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Reject", style: .plain, target: self, action: #selector(navRejectBtn)), UIBarButtonItem(title: "Accept", style: .plain, target: self, action: #selector(navAcceptBtn))]
        }
    }
    
    @objc func selectAllButton(){
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton)),UIBarButtonItem(title: "Deselect All", style: .plain, target: self, action: #selector(deselectAllButton))]
        
        let totalRows = tableView.numberOfRows(inSection: 0)
        for row in 0..<totalRows {
            tableView.selectRow(at: NSIndexPath(row: row, section: 0) as IndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        }
        
    }
    
    @objc func deselectAllButton(){
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton)),UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(selectAllButton))]
        
        let totalRows = tableView.numberOfRows(inSection: 0)
        for row in 0..<totalRows {
            tableView.deselectRow(at: NSIndexPath(row: row, section: 0) as IndexPath, animated: true)
        }
        
    }
    
    @objc func doneButton(){
        
        
        let totalRows = tableView.numberOfRows(inSection: 0)
        for row in 0..<totalRows {
            tableView.deselectRow(at: NSIndexPath(row: row, section: 0) as IndexPath, animated: true)
        }
        
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButton))]
        
        self.navigationItem.title = "Reimbusement Approve"
        self.navigationItem.leftBarButtonItems = []
        self.tableView.allowsMultipleSelection = false
        self.navigationItem.hidesBackButton = false
    }
    
    //    func moveToTop(){
    //        let indexPath = IndexPath(row: 0, section: 0)
    //        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    //    }
    
    
    
    
    
    
    @objc func navAcceptBtn(){
        
        setAcceptRejectData(mgrStatus: "Y")
    }
    
    @objc func navRejectBtn(){
        setAcceptRejectData(mgrStatus: "N")
    }
    
    
    func setAcceptRejectData(mgrStatus : String){
        
        
        var param = [Any]()
        let totalRows = self.tableView.indexPathsForSelectedRows
        if totalRows != nil{
            for x in totalRows!{
                let index = x[1]
                
                
                param.append(["Dtyp" : dType[index], "EmpCode": empCode[index],"ExpenseDate":expenseDate[index], "Ltyp":lType[index], "MgrRemark":"", "MgrStatus":mgrStatus, "RowSeq": rowSeq[index], "ApprovedAmount":totalAmmnt[index],"ApprovedKms":totalKms[index]])
                
            }
            
            reimbursementApprove.statusforAcceptRejectBtn(params: param) { (returnType) in
                if returnType == "Reimbursement rejected successfully" || returnType == "Reimbursement approved successfully"{
                    SVProgressHUD.showSuccess(withStatus: returnType)
                    self.getRDetailsData()
                }else{
                    SVProgressHUD.showError(withStatus: returnType)
                }
            }
            
        }
    }
    
}
