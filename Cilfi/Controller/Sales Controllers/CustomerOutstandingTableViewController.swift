//
//  CustomerOutstandingTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 25/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import Alamofire

class CustomerOutstandingCell : UITableViewCell{
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var accountLbl: UILabel!
    @IBOutlet weak var billNoLbl: UILabel!
    @IBOutlet weak var amntLbl: UILabel!
    
}

class CustomerOutstandingTableViewController: UITableViewController {

    let customer = CustomerModel()
    let ip = whatIsIP()
    var menuIndex = ""
    var acc = ""
    
    var account = [String]()
    var date = [String]()
    var billNo = [String]()
    var amount = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customer.getCustomerData()
        
    }
    
    
    @IBOutlet weak var customerBtn: UIButton!
    
    @IBAction func customerBtn(_ sender: UIButton) {
        
        let dropDown = DropDown()
        dropDown.dataSource = customer.custName
        dropDown.anchorView = customerBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.customerBtn.setTitle(item, for: .normal)
            self.getCustomerOutstandingData()
            self.acc = self.customer.custCode[index]
//            print(self.acc)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coCell", for: indexPath) as! CustomerOutstandingCell
        
        cell.amntLbl.text = amount[indexPath.row]
        cell.accountLbl.text = account[indexPath.row]
        cell.billNoLbl.text = billNo[indexPath.row]
        cell.dateLbl.text = date[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return account.count ?? 1
    }

    
    
    func getCustomerOutstandingData(){
        
        account = [String]()
        date = [String]()
        billNo = [String]()
        amount = [String]()
        
        for index in 1...Category.sub.count{
            if Category.sub[index-1] == menuNameForIndex{
                menuIndex = Category.subMenuID[index-1]
            }
        }
        
        var header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "ipaddress" : ip, "menuindex" : menuIndex, "account" : acc]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/CustomerOutstanding", method: .get, headers : header).responseJSON{
            response in
            
//            print(header)
            
            let custData = response.data!
            let custJSON = response.result.value
            
            if response.result.isSuccess{
//                print("UserJSON: \(custJSON)")
                do{
                    let cust = try JSONDecoder().decode(CustomerOutstandingRoot.self, from: custData)
                    let dateFormatter = DateFormatter()
                    
                    for x in cust.codata{
                        
                        if let account = x.account{
                            self.account.append(account)
                        }
                        if let amount = x.ammount{
                            self.amount.append(amount)
                        }
                        if let billno = x.billNo{
                            self.billNo.append(billno)
                        }
                        if let date = x.vDate{
                            self.date.append(date)
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
