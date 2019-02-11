//
//  RegularizeAttendanceSummaryViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 15/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
class RegularizeCell: UITableViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var remarksLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var attendanceDate: UILabel!
    @IBOutlet weak var regularizeType: UILabel!
    @IBOutlet weak var inTime: UILabel!
    @IBOutlet weak var inRemarks: UILabel!
    @IBOutlet weak var inStatus: UILabel!
}

class RegularizeAttendanceSummaryViewController: UITableViewController {

    let regularizeURL = "\(LoginDetails.hostedIP)/sales/RegularizeStatus"
    
    var attendanceDate = [String]()
    var regularizeTypeIN = [String]()
    var regularizeTypeOut = [String]()
    var inTime = [String]()
    var inRemark = [String]()
    var inStatus = [String]()
    var outTime = [String]()
    var outRemark = [String]()
    var outStatus = [String]()
    
    
    
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
            print(yyyyMM[index])
            self.getAttendanceTrackData(url: self.regularizeURL, header: ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : yyyyMM[index], "employeecode" : defaults.string(forKey: "user")!])
        }
      
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        
        getAttendanceTrackData(url: regularizeURL, header: ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : formatter.string(from: Date()), "employeecode" : defaults.string(forKey: "user")!])
        
        formatter.dateFormat = "MMMM yyyy"

        yearMonthBtn.setTitle(formatter.string(from: Date()), for: .normal)
    }

    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func getAttendanceTrackData(url : String, header : [String:String]){
        attendanceDate = [String]()
        regularizeTypeIN = [String]()
        regularizeTypeOut = [String]()
        inTime = [String]()
        inRemark = [String]()
        inStatus = [String]()
        outTime = [String]()
        outRemark = [String]()
        outStatus = [String]()
        
        Alamofire.request(url, method: .get, headers : header).responseJSON{
            response in
            
            let attnData = response.data!
            let attnJSON = response.result.value
            
            if response.result.isSuccess{
                //                print(attnJSON)
                do{
                    let attndSummary = try JSONDecoder().decode(RegularizeAttendanceRoot.self, from: attnData)
                    //line chart
                    
                    for x in attndSummary.regularizeStatus{
                        if let atndDate = x.atnDate{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
                            if let date = formatter.date(from: atndDate){
                                formatter.dateFormat = "dd MMMM yyyy"
                                self.attendanceDate.append(formatter.string(from: date))
                            }
                            
                        }
                        if let regType = x.regularizeTypeIn{
                            self.regularizeTypeIN.append(regType)
                        }
                        if let regType = x.regularizeTypeOut{
                            self.regularizeTypeOut.append(regType)
                        }
                        if let intime = x.inTime{
                            self.inTime.append(intime)
                        }
                        if let remarkin = x.remarkIn{
                            self.inRemark.append(remarkin)
                        }
                        if let statusin = x.statusIn{
                            self.inStatus.append(statusin)
                        }
                        
                        if let outtime = x.outTime{
                            self.outTime.append(outtime)
                        }
                        if let remarkout = x.remarkOut{
                            self.outRemark.append(remarkout)
                        }
                        if let statusout = x.statusOut{
                            self.outStatus.append(statusout)
                        }
                       
                        
                    }
                    //                    print(self.empName)
                    //                    print(self.leaveType)
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
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return attendanceDate.count ?? 1
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return attendanceDate.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celll", for: indexPath) as! RegularizeCell
        
        
        
        cell.attendanceDate.text = attendanceDate[indexPath.row]
        
        if regularizeTypeIN[indexPath.row].isEmpty || regularizeTypeIN[indexPath.row] == ""{
            cell.regularizeType.text = regularizeTypeOut[indexPath.row]
        }else{
            cell.regularizeType.text = regularizeTypeIN[indexPath.row]
        }
        
        if inTime[indexPath.row].isEmpty{
            cell.inTime.text = outTime[indexPath.row].replacingOccurrences(of: ".", with: ":")
            cell.timeLbl.text = "Out - Time"
        }else{
            cell.inTime.text = inTime[indexPath.row].replacingOccurrences(of: ".", with: ":")
            cell.timeLbl.text = "In - Time"
        }
        
        if inRemark[indexPath.row].isEmpty{
            cell.inRemarks.text = outRemark[indexPath.row]
            cell.remarksLbl.text = "Out - Remarks"
        }else{
            cell.inRemarks.text = inRemark[indexPath.row]
            cell.remarksLbl.text = "In - Remarks"
        }
        
        
        if inStatus[indexPath.row] == "Pending"{
            cell.inStatus.text = inStatus[indexPath.row]
            cell.inStatus.textColor = UIColor.flatOrangeDark
        }else if outStatus[indexPath.row] == "Pending"{
            cell.inStatus.text = outStatus[indexPath.row]
            cell.inStatus.textColor = UIColor.flatOrangeDark
            cell.statusLbl.text = "Out - Status"
        }else if inStatus[indexPath.row] == "Rejected"{
            cell.inStatus.text = inStatus[indexPath.row]
            cell.inStatus.textColor = UIColor.flatRed
        }else if outStatus[indexPath.row] == "Rejected"{
            cell.inStatus.text = outStatus[indexPath.row]
            cell.inStatus.textColor = UIColor.flatOrangeDark
            cell.statusLbl.text = "Out - Status"
        }else if inStatus[indexPath.row] == "Approved"{
            cell.inStatus.text = inStatus[indexPath.row]
            cell.inStatus.textColor = UIColor.flatGreen
        }else if outStatus[indexPath.row] == "Rejected"{
            cell.inStatus.text = outStatus[indexPath.row]
            cell.inStatus.textColor = UIColor.flatOrangeDark
            cell.statusLbl.text = "Out - Status"
        }
       
        return cell
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


