//
//  StationeryStatusTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੨੪/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


class StationeryStatusCell : UITableViewCell{

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var quantLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var approvedQuantLbl: UILabel!
    @IBOutlet weak var approvedDateLbl: UILabel!
    @IBOutlet weak var remarkLbl: UILabel!
    


}

class StationeryStatusTableViewController: UITableViewController {

    var name = [String]()
    var code = [String]()
    var quant = [String]()
    var date = [String]()
    var status = [String]()
    var approvedQuant = [String]()
    var approvedDate = [String]()
    var remarks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        getAssetsData()
        
    }
   

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return code.count ?? 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sscell", for: indexPath) as! StationeryStatusCell
        
        cell.nameLbl.text = name[indexPath.row]
        cell.codeLbl.text = code[indexPath.row]
        cell.quantLbl.text = quant[indexPath.row]
        cell.dateLbl.text = date[indexPath.row]
        cell.statusLbl.text = status[indexPath.row]
        cell.approvedQuantLbl.text = approvedQuant[indexPath.row]
        cell.approvedDateLbl.text = approvedDate[indexPath.row]
        cell.remarkLbl.text = remarks[indexPath.row]
        
        if status[indexPath.row] == "Pending"{
            cell.statusLbl.textColor = UIColor.flatOrange
        }else if status[indexPath.row] == "Rejected"{
            cell.statusLbl.textColor = UIColor.flatRed
        }else if status[indexPath.row] == "Approved"{
            cell.statusLbl.textColor = UIColor.flatGreen
        }
        
        return cell
    }
    
    func getAssetsData(){
        
        name = [String]()
        code = [String]()
        quant = [String]()
        date = [String]()
        status = [String]()
        approvedQuant = [String]()
        approvedDate = [String]()
        remarks = [String]()
        
        var header =  [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "assetsType" : "T"]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/AssetsData", headers: header).responseJSON{
            response in
            
            //            print(headers)
            let aData = response.data!
            let aJSON = response.result.value
            
            if response.result.isSuccess{
                print(aJSON)
                do{
                    let aStatus = try JSONDecoder().decode(AssetsDataRoot.self, from: aData)
                    
                    for x in aStatus.asset{
                        if let value = x.productName{
                            self.name.append(value)
                        }
                        if let value = x.product{
                            self.code.append(value)
                        }
                        if let value = x.applyQuantity{
                            self.quant.append(String(value))
                        }
                        if let value = x.applyTransactionDate{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                            if let date = formatter.date(from: value){
                                formatter.dateFormat = "dd MMMM yyyy"
                                self.date.append(formatter.string(from: date))
                            }
                            
                        }
                        if let value = x.paidStatus{
                            self.status.append(value)
                        }
                        if let value = x.quantity{
                            self.approvedQuant.append(String(value))
                        }
                        if x.mgrStatus == "Approved" || x.mgrStatus == "Rejected"{
                            if let value = x.transactionDate{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                if let date = formatter.date(from: value){
                                    formatter.dateFormat = "dd MMMM yyyy"
                                    self.approvedDate.append(formatter.string(from: date))
                                }
                            }
                        }else{
                            
                            self.approvedDate.append("")
                        }
                        
                        if let value = x.remark{
                            self.remarks.append(value)
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
    
}
