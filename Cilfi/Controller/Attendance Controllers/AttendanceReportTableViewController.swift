//
//  AttendanceReportTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 17/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog
import Alamofire
import SVProgressHUD
import SimplePDF
import PDFKit

class AttendanceReportCell : UITableViewCell{
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var inTime: UILabel!
    @IBOutlet weak var outTime: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var status: UILabel!
    
}


class AttendanceReportTableViewController: UITableViewController {

    var date = [Date]()
    var dt = [String]()
    var inTime = [String]()
    var outTime = [String]()
    var hours = [String]()
    var sInTime = [String]()
    var sOutTime = [String]()
    var status = [String]()
    
    var monthYear = ""
    
    
    let previousdate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBAction func dateBtn(_ sender: UIButton) {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel",maximumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM yyyy"
                self.dateLbl.text = formatter.string(from: dt)
                formatter.dateFormat = "yyyyMM"
                self.getAttendanceReportData(yearMonth: formatter.string(from: dt))
                formatter.dateFormat = "MMMM - yy"
                self.monthYear = formatter.string(from: dt)
                SVProgressHUD.show()
            }
        }
    }
    @IBAction func savePDFBtn(_ sender: UIButton) {
    
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize)
        var dataArray = [Any]()
        
       
       
        if !dt.isEmpty{
            for x in 1...dt.count{
                dataArray.append([String(x),dt[x-1],dayOfWeek(date: date[x-1]), inTime[x-1], outTime[x-1], hours[x-1],status[x-1]])
            }
        
        
        
        
        pdf.addImage(UIImage(named: "Cilfi-Logo-For-PDF")!)
        pdf.setContentAlignment(.center)
        pdf.addText("Attendance Report\n\n", font: UIFont.boldSystemFont(ofSize: 20), textColor: UIColor.flatOrange)
        pdf.addTable(1, columnCount: 7, rowHeight: 10, columnWidth: 79, tableLineWidth: 0, font: UIFont.boldSystemFont(ofSize: 09), dataArray: [["","",defaults.string(forKey: "name")!,defaults.string(forKey: "user")!,monthYear," "," "]])
        pdf.addText("\n")
        pdf.addLineSeparator()
        // or
        // pdf.addText("Hello World!", font: myFont, textColor: myTextColor)
        pdf.addText("\n")
        pdf.setContentAlignment(.center)
        pdf.addTable(1, columnCount: 7, rowHeight: 20, columnWidth: 79, tableLineWidth: 0.5, font: UIFont.boldSystemFont(ofSize: 09), dataArray: [["S.No.","Attendance Date","Attendance Day","In-Time","Out-Time","Duty Hours","Status"]])
        pdf.addText("\n")
            pdf.setContentAlignment(.center)
        pdf.addTable(dataArray.count, columnCount: 7, rowHeight: 10.0, columnWidth: 79, tableLineWidth: 0, font: UIFont.systemFont(ofSize: 7.0), dataArray: dataArray as! Array<Array<String>>)
    
         pdf.addText("\n-------------------------------x-------------------------------")
        
        let pdfData = pdf.generatePDFdata()
        
        let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
        // save as a local file
//        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
//
//            let fileName = "\(defaults.string(forKey: "name")!)_attendance_report_\(monthYear).pdf"
//            let documentsFileName = documentDirectories + "/" + fileName
//
//            let pdfData = pdf.generatePDFdata()
//
//            let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
//            present(activityViewController, animated: true, completion: nil)
//
//            do{
//               try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomic)
//                print("\nThe generated pdf can be found at:")
//                print("\n\t\(documentsFileName)\n")
//
//
//                SVProgressHUD.showSuccess(withStatus: "Successfully downloaded your attendance report.\n\(documentsFileName)")
//                SVProgressHUD.dismiss(withDelay: 3)
//
//
//            }catch{
//                print(error)
//            }
//        }
//
        }else{
            SVProgressHUD.showInfo(withStatus: "No Data Available")
        }
    }
    
    func dayOfWeek(date : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        dateLbl.text = formatter.string(from: previousdate!)
        formatter.dateFormat = "yyyyMM"
        getAttendanceReportData(yearMonth: formatter.string(from: previousdate!))
        SVProgressHUD.show()
        formatter.dateFormat = "MMMM - yy"
        monthYear = formatter.string(from: previousdate!)
    }

    
    
    func getAttendanceReportData(yearMonth : String){
        date = [Date]()
        dt = [String]()
        inTime = [String]()
        outTime = [String]()
        hours = [String]()
        sInTime = [String]()
        sOutTime = [String]()
        status = [String]()
        
        let header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : yearMonth, "employeecode" : defaults.string(forKey: "employeeCode")!]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/employeeattendance", method: .get, headers : header).responseJSON{
            response in
            
            let arData = response.data!
            let arJSON = response.result.value
            
            if response.result.isSuccess{
                
                do{
                    let ar = try JSONDecoder().decode(EmployeeAttendanceRoot.self, from: arData)
                    
                    
                    for x in ar.eaEmployee{
                        
                        if let value = x.atnDate{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                            self.date.append(formatter.date(from: value)!)
                        }
                        
                        if let inTime = x.inTime{
                            self.inTime.append(inTime)
                        }
                        if let outTime = x.outTime{
                            self.outTime.append(outTime)
                        }
                        if let hrs = x.totalHours{
                            self.hours.append(hrs)
                        }
                        
                        if let sin = x.sInTime{
                            self.sInTime.append(sin)
                        }
                        if let sout = x.outTime{
                            self.sOutTime.append(sout)
                        }
                        
                        if let status = x.subStatus{
                            self.status.append(status)
                        }
                        
                    }
                    
                    for x in self.date{
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy"
                        self.dt.append(formatter.string(from: x))
                    }
                    
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    
                }
                catch{
                    print (error)
                }
            }
            else{
                print("Something Went wrong \(LoginDetails.hostedIP)/sales/employeeattendance")
            }
        }
        
        
    }
   
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dt.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arCell", for: indexPath) as! AttendanceReportCell
        
        if dt.count != 0{
            
            
            cell.dateLbl.text = dt[indexPath.row]
            
            cell.inTime.text = inTime[indexPath.row]
            cell.outTime.text = outTime[indexPath.row]
            
            cell.hours.text = hours[indexPath.row]
            cell.status.text = status[indexPath.row]
        }
        
        
        return cell
    }
    
   
}
