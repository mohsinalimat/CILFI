//
//  SalaryDetailsTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 28/09/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import DatePickerDialog

struct cellData{
    
    var opened = Bool()
    var title = String()
    var value = String()
    var sectionDataTitle = [String]()
    var sectionDataValues = [String]()
}


class SalaryCell1 : UITableViewCell{
    
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
    
    
}



class SalaryDetailsTableViewController: UITableViewController {
    
    var tableviewdata = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        dateLbl.text = formatter.string(from: Date())
        
        formatter.dateFormat = "yyyyMM"
        getSalaryData(yearmonth: formatter.string(from: Date()))
        
        
    }
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBAction func dateBtn(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM yyyy"
                self.dateLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyyMM"
                self.getSalaryData(yearmonth: formatter.string(from: dt))
                SVProgressHUD.show()
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    func getSalaryData(yearmonth : String){
        
        tableviewdata = [cellData]()
        
        var grossdatatitle = [String]()
        var grossdatavalues = [String]()
        var deductiondatatitle = [String]()
        var deductiondatavalues = [String]()
        var attendancedatatitle = [String]()
        var attendancedatavalues = [String]()
        
        let header = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : yearmonth, "employeecode" : defaults.string(forKey: "employeeCode")!]
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/SalaryDetails", method: .get, headers : header).responseJSON{
            response in
            
//            print(header)
            
            let sData = response.data!
            let sJSON = response.result.value
            
            if response.result.isSuccess{
//                print("UserJSON: \(sJSON)")
                do{
                    let sd = try JSONDecoder().decode(SalaryDetailRoot.self, from: sData)
                    
                    for x in sd.grossEarningData{
                        
                        if let value = x.title{
                            grossdatatitle.append(value)
                        }
                        if let value = x.value{
                            grossdatavalues.append(value)
                        }
                        
                    }
                    
                    for x in sd.deductionData{
                        
                        if let value = x.title{
                            deductiondatatitle.append(value)
                        }
                        if let value = x.value{
                            deductiondatavalues.append(value)
                        }
                    }
                    
                    for x in sd.attendanceData{
                        
                        if let value = x.title{
                            attendancedatatitle.append(value)
                        }
                        if let value = x.value{
                            attendancedatavalues.append(value)
                        }
                    }
                    
                    if let value = sd.grossEarning{
                        self.tableviewdata.append(cellData(opened: false, title: "Gross Earning", value: value, sectionDataTitle: grossdatatitle, sectionDataValues: grossdatavalues))
                    }
                    
                    if let value = sd.deduction{
                        self.tableviewdata.append(cellData(opened: false, title: "Deduction", value: value, sectionDataTitle: deductiondatatitle, sectionDataValues: deductiondatavalues))
                    }
                    
                    if let value = sd.netPay{
                        self.tableviewdata.append(cellData(opened: false, title: "Net Pay", value: value, sectionDataTitle: [], sectionDataValues: []))
                    }
                    
                    if let value = sd.attendance{
                        self.tableviewdata.append(cellData(opened: false, title: "Attendance", value: value, sectionDataTitle: attendancedatatitle, sectionDataValues: attendancedatavalues))
                    }
                    
                    SVProgressHUD.dismiss()
                    
                    self.updateTableValues()
                    
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
    
    
    
    func updateTableValues(){
        
        print(tableviewdata)
        
        tableView.reloadData()
        
    
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableviewdata.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableviewdata[section].opened == true{
            return tableviewdata[section].sectionDataTitle.count + 1
        }else{
            
            return 1
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sdcell1", for: indexPath) as! SalaryCell1

            cell.view.backgroundColor = UIColor.flatWhiteDark
            cell.backgroundColor = UIColor.flatWhiteDark
            cell.typeLbl.text = tableviewdata[indexPath.section].title
            cell.valueLbl.text = tableviewdata[indexPath.section].value
            
            if tableviewdata[indexPath.section].opened{
                cell.imgView.image = UIImage(named: "salary-table-downarrow")
            }else{
                cell.imgView.image = UIImage(named: "salary-table-minus")
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sdcell1", for: indexPath) as! SalaryCell1
            cell.typeLbl.text = tableviewdata[indexPath.section].sectionDataTitle[dataIndex]
            cell.valueLbl.text = tableviewdata[indexPath.section].sectionDataValues[dataIndex]
            cell.backgroundColor = UIColor.flatWhite
            cell.imgView.image = nil
            cell.view.backgroundColor = UIColor.flatWhite
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if tableviewdata[indexPath.section].opened == true{
                tableviewdata[indexPath.section].opened = false
                
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }else{
                tableviewdata[indexPath.section].opened = true
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .automatic)
            }
        }
    }
    
    
}
