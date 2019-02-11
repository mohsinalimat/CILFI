//
//  AssetsApprovalTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੨੨/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Alamofire
import SwiftyJSON
import SVProgressHUD
import DropDown

class AssetsApprovalCell:MGSwipeTableCell{
    
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var date: UILabel!
}

class AssetsApprovalTableViewController: UITableViewController {
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
    
    var header =  [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "assetsType" : "A"]
    
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
        
        typeBtn.setTitle(action, for: .normal)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "aacell", for: indexPath) as! AssetsApprovalCell
        
        let more = MGSwipeButton(title: " Info",icon: UIImage(named: "table-info"), backgroundColor: UIColor.flatGray) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.row = self.rowSeq[indexPath.row]
            self.performSegue(withIdentifier: "goToDetail", sender: self)
            return true
        }
        
        let approve = MGSwipeButton(title: "",icon: UIImage(named: "table-success"), backgroundColor: UIColor.flatGreen) {
            (sender: MGSwipeTableCell!) -> Bool in
            self.assets.setData(assetType: "A", params: [self.getParams(index : indexPath.row, status : "A")], completion: { (returnType) in
                if returnType.string == "Approved successfully"{
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
            self.assets.setData(assetType: "A", params: [self.getParams(index : indexPath.row, status : "R")], completion: { (returnType) in
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
            cell.rightButtons = []
            cell.leftButtons = [more]
        }else if action == "Rejected"{
            cell.rightButtons = [approve]
            cell.leftButtons = [more]
        }
        
        
        cell.empName.text = empName[indexPath.row]
        cell.product.text = "\(asset[indexPath.row]) (\(assetCode[indexPath.row]))"
        cell.quantity.text = quantity[indexPath.row]
        cell.date.text = date[indexPath.row]
        
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
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/Assetsapproval", headers: header).responseJSON{
            response in
            
            //            print(headers)
            let aData = response.data!
            let aJSON = response.result.value
            
            if response.result.isSuccess{
//                print(aJSON)
                do{
                    let aStatus = try JSONDecoder().decode(AssetsApprovalRoot.self, from: aData)
                    
                    for x in aStatus.asset{
                        if self.action == x.mgrStatus{
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
                            
                            if x.mgrStatus == "Approved"{
                                if let value = x.applyQuantity{
                                    self.quantity.append(String(value))
                                }
                            }else{
                                if let value = x.mgrQuantity{
                                    self.quantity.append(String(value))
                                }
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
                    
                    //scroll to last row
                    let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - 1
                    let indexPath = IndexPath(row: lastRow, section: 0);
//                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
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
        if segue.identifier == "goToDetail"{
            let vc = segue.destination as! AssetsApprovalDetailViewController
            vc.rowseq = row
        }
    }
    
    
    
    func getParams(index : Int, status : String) -> Any{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
       return ["EmployeeCode":empCode[index] ,"MgrQuantity": quantity[index],"MgrProduct": assetCode[index],"ProductName": asset[index],"MgrDate": formatter.string(from: Date()),"MgrStatus": status,"MgrRemark": "","RowSeq": rowSeq[index]]

    }
    
    
}


