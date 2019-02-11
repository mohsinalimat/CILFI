//
//  ReimbursementReportTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 30/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog
import Alamofire
import SVProgressHUD

class ReimbursementReportCell : UITableViewCell{
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var akmLbl: UILabel!
    @IBOutlet weak var tkmLbl: UILabel!
    @IBOutlet weak var diffkmLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
}


class ReimbursementReportTableViewController: UITableViewController {

    let team = TeamDetailModel()
    var fDate = ""
    var tDate = ""
    var emp = ""
    
    var code = [String]()
    var name = [String]()
    var claimDate = [String]()
    var actualKM = [Double]()
    var trackingKM = [Double]()
    var diffrenceKM = [Double]()
    var status = [String]()
    
    
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var employeeBtn: UIButton!
    
    @IBAction func fromDateBtn(_ sender: UIButton) {
    
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                
                self.fromDate.text = formatter.string(from: dt)
                self.fDate = formatter.string(from: dt)
                self.getReport()
            }
        }
    
    }
    
    @IBAction func toDateBtn(_ sender: UIButton) {
    
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                
                self.toDate.text = formatter.string(from: dt)
                self.tDate = formatter.string(from: dt)
                self.getReport()
            }
        }
    
    }
    
    @IBAction func employeeBtn(_ sender: UIButton) {
    
        let dropDown = DropDown()
        
        dropDown.dataSource = team.employeeName
        dropDown.anchorView = employeeBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
           
            self.employeeBtn.titleLabel?.text = item
            self.emp = self.team.employeeCode[index]
            self.getReport()
        }
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let date = Date()
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
        
        fDate = dateFormatter.string(from: date)
        tDate = dateFormatter.string(from: date)
        
        fromDate.text = dateFormatter.string(from: date)
        toDate.text = dateFormatter.string(from: date)
        
        
        team.getTeamData()
    }

    
    
    func getReport(){
    
    
        code = [String]()
        name = [String]()
        claimDate = [String]()
        actualKM = [Double]()
        trackingKM = [Double]()
        diffrenceKM = [Double]()
        status = [String]()
        
        
        var header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : emp, "fromdate" : fDate, "todate": tDate, "ipaddress" : "", "menuindex" : ""]
        
        Alamofire.request("\(LoginDetails.hostedIP)/Sales/ReimbursementReport", method: .get, headers : header).responseJSON{
            response in
            
            let reportData = response.data!
            let reportJSON = response.result.value
            
            if response.result.isSuccess{
//                                                                             print("UserJSON: \(reportJSON)")
                SVProgressHUD.show()
                do{
                    let report = try JSONDecoder().decode(ReimbursementReportRoot.self, from: reportData)
                    
                    for x in report.rReport{
                        
                        if let xCode = x.code{
                            self.code.append(xCode)
                        }
                        if let xName = x.name{
                            self.name.append(xName)
                        }
                        if let cDate = x.claimDate{
                            self.claimDate.append(cDate)
                        }
                        if let akm = x.actualKMS{
                            self.actualKM.append(akm)
                        }
                        if let tkm = x.trackingKMS{
                            self.trackingKM.append(tkm)
                        }
                        if let diffkm = x.diffrenceKMS{
                            self.diffrenceKM.append(diffkm)
                        }
                        if let status = x.status{
                            self.status.append(status)
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
    
   
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "rrCell", for: indexPath) as! ReimbursementReportCell
        
        print(claimDate)
        cell.dateLbl.text = claimDate[indexPath.row]
        cell.akmLbl.text = String(actualKM[indexPath.row])
        cell.tkmLbl.text = String(trackingKM[indexPath.row])
        cell.diffkmLbl.text = String(diffrenceKM[indexPath.row])
        cell.statusLbl.text = status[indexPath.row]
        
        
        if status[indexPath.row] == "Pending"{
            cell.statusLbl.textColor = UIColor.flatRed
        }else if status[indexPath.row] == "Approved"{
            cell.statusLbl.textColor = UIColor.flatGreen
        }
        
        if diffrenceKM[indexPath.row] != actualKM[indexPath.row]{
            cell.diffkmLbl.textColor = UIColor.flatRed
        }else{
             cell.diffkmLbl.textColor = .black
        }
        
        return cell
    }
    
    
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return code.count ?? 1
    }

   

}
