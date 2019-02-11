//
//  StationeryIssueTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੨੪/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Alamofire
import SwiftyJSON
import SVProgressHUD
import DropDown

class StationeryIssueCell : MGSwipeTableCell{
    
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
}

class StationeryIssueTableViewController: UITableViewController {

    let assets = AssetsApprovalModel()
    
    var empName = [String]()
    var asset = [String]()
    var quantity = [String]()
    var date = [String]()
    var assetCode = [String]()
    var rowSeq = [String]()
    
    var row = ""
    
    var empCode = [String]()
    
    var action = "Pending"
    
    var header =  ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "assetsType" : "T"]
    
    @IBOutlet weak var typeBtn: UIButton!
    @IBAction func typeBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = ["Pending", "Approved", "Rejected"]
        dropDown.anchorView = typeBtn
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.typeBtn.setTitle(item, for: .normal)
            self.action = item
            self.getAssetsApprovalData()
            SVProgressHUD.show()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.show()
    }

   
    override func viewDidAppear(_ animated: Bool) {
        typeBtn.setTitle(action, for: .normal)
        getAssetsApprovalData()
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return empName.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sicell", for: indexPath) as! StationeryIssueCell
        
        let more = MGSwipeButton(title: " Info",icon: UIImage(named: "table-info"), backgroundColor: UIColor.flatGray) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.row = self.rowSeq[indexPath.row]
            self.performSegue(withIdentifier: "goToDetails", sender: self)
            return true
        }
        
        let approve = MGSwipeButton(title: "",icon: UIImage(named: "table-success"), backgroundColor: UIColor.flatGreen) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.assets.setIssueData(assetType: "T", params: [self.getParams(index : indexPath.row, status : "A")], completion: { (returnType) in
                if returnType.string == "Issued successfully"{
                    SVProgressHUD.showSuccess(withStatus: returnType.string)
                    self.getAssetsApprovalData()
                }else{
                    SVProgressHUD.showError(withStatus: returnType.string)
                }
            })
            return true
        }
        let reject = MGSwipeButton(title: "",icon: UIImage(named:"table-error"), backgroundColor: UIColor.flatRed) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.assets.setIssueData(assetType: "T", params: [self.getParams(index : indexPath.row, status : "R")], completion: { (returnType) in
                if returnType.string == "Rejected successfully"{
                    SVProgressHUD.showSuccess(withStatus: returnType.string)
                    self.getAssetsApprovalData()
                }else{
                    SVProgressHUD.showError(withStatus: returnType.string)
                }
            })
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
        
        
        cell.empNameLbl.text = empName[indexPath.row]
        cell.itemLbl.text = "\(asset[indexPath.row]) (\(assetCode[indexPath.row]))"
        cell.quantityLbl.text = quantity[indexPath.row]
        cell.dateLbl.text = date[indexPath.row]
        
        return cell
    }
    
    
    func getAssetsApprovalData(){
        
        empName = [String]()
        asset = [String]()
        quantity = [String]()
        date = [String]()
        assetCode = [String]()
        rowSeq = [String]()
        
        empCode = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/Assetsissue", headers: header).responseJSON{
            response in
            
            //            print(headers)
            let aData = response.data!
            let aJSON = response.result.value
            
            if response.result.isSuccess{
                //                                print(aJSON)
                do{
                    let aStatus = try JSONDecoder().decode(AssetsApprovalRoot.self, from: aData)
                    
                    for x in aStatus.asset{
                        if self.action == x.paidStatus{
                            if let value = x.empName{
                                self.empName.append(value)
                            }
                            if let value = x.productName{
                                self.asset.append(value)
                            }
                            if let value = x.applyProduct{
                                self.assetCode.append(String(value))
                            }
                            
                            if let value = x.applyTransactionDate{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                if let date = formatter.date(from: value){
                                    formatter.dateFormat = "dd MMMM yyyy"
                                    self.date.append(formatter.string(from: date))
                                }
                                
                            }
                            if let value = x.quantity{
                                self.quantity.append(String(value))
                            }
                            if let value = x.rowSeq{
                                self.rowSeq.append(String(value))
                            }
                            
                            if let value = x.empCode{
                                self.empCode.append(String(value))
                            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails"{
            let vc = segue.destination as! AssetsIssueDetailsViewController
            vc.rowseq = row
            vc.atype = "T"
        }
    }
    
    
    
    func getParams(index : Int, status : String) -> Any{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        return ["EmployeeCode":empCode[index] ,"Quantity": quantity[index],"Product": assetCode[index],"ProductName": asset[index],"ApplyDate": formatter.string(from: Date()),"PaidStatus": status,"PaidRemark": "","RowSeq": rowSeq[index]]
        
    }
    

}
