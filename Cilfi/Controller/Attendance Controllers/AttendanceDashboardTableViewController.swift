//
//  AttendanceDashboardTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 14/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import Charts
import SVProgressHUD
import DatePickerDialog

class AttendanceDashboardCell : UITableViewCell{
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var inTimeLbl: UILabel!
    @IBOutlet weak var outTimeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
}


class AttendanceDashboardTableViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var code = [String]()
    var name = [String]()
    var inTime = [String]()
    var outTime = [String]()
    var inLoc = [String]()
    var outLoc = [String]()
    var status = [String]()
    
    var date = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBAction func dateBtn(_ sender: UIButton) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.dateLbl.text = formatter.string(from: dt)
                self.date = formatter.string(from: dt)
                formatter.dateFormat = "yyyy-MM-dd"
                self.getAttndDashData(dateTime: formatter.string(from: dt))
               
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateLbl.text = formatter.string(from: Date())
        date = formatter.string(from: Date())
        pieChart.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        formatter.dateFormat = "yyyy-MM-dd"
        getAttndDashData(dateTime: formatter.string(from: Date()))
        
    }

    
    
    func getAttndDashData(dateTime : String){
        
        code = [String]()
        name = [String]()
        inTime = [String]()
        outTime = [String]()
        inLoc = [String]()
        outLoc = [String]()
        status = [String]()
        
        
        let header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "employeeCode")!, "datetime": dateTime]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/Attendancedashboard", method: .get, headers : header).responseJSON{
            response in
            
            let adData = response.data!
            let adJSON = response.result.value
            
            if response.result.isSuccess{
                
                do{
                    let ad = try JSONDecoder().decode(AttendanceDashboardRoot.self, from: adData)
                    
                    
                    for x in ad.adEmployee{
                        
                        if let value = x.code{
                            self.code.append(value)
                        }
                        
                        if let value = x.name{
                            self.name.append(value)
                        }
                        
                        if let value = x.inTime{
                            self.inTime.append(value)
                        }
                        
                        if let value = x.outTime{
                            self.outTime.append(value)
                        }
                        
                        if let value = x.inLoc{
                            self.inLoc.append(value)
                        }
                        
                        if let value = x.outLoc{
                            self.outLoc.append(value)
                        }
                        
                        if let value = x.status{
                            self.status.append(value)
                        }
                    }
                    self.tableView.reloadData()
                    
                    self.updatePieChart()
                }
                catch{
                    print (error)
                }
            }
            else{
                print("Something Went wrong \(LoginDetails.hostedIP)/sales/Attendancedashboard")
            }
        }
        
        
    }
    
    func updatePiechartData() -> [Int]{
        var singlePunch = 0, present = 0, absent = 0
       
        if name.count != 0{
            for index in 1...name.count{
                if inTime[index-1] != "0.00" && outTime[index-1] != "0.00"{
                    present += 1
                }else if inTime[index-1] != "0.00" && outTime[index-1] == "0.00"{
                    singlePunch += 1
                }else if inTime[index-1] == "0.00" && outTime[index-1] == "0.00"{
                    absent += 1
                }
            }
        }
        return [singlePunch,present,absent]
    }
    
    func updatePieChart(){
        
            
            
            // 2. generate chart data entries
            let track = ["Single Punch", "Present", "Absent"]
            let values = updatePiechartData()
            
            var entries = [PieChartDataEntry]()
            for (index, value) in values.enumerated() {
                let entry = PieChartDataEntry()
                entry.y = Double(value)
                entry.label = track[index]
                entries.append( entry)
            }
        
        
            // 3. chart setup
            let set = PieChartDataSet( values: entries, label: "")
            // this is custom extension method. Download the code for more details.
            let colors: [UIColor] = [UIColor.flatYellow, UIColor.flatGreen, UIColor.flatRed]
        
        
            set.colors = colors
            let data = PieChartData(dataSet: set)
            pieChart.data = data
            pieChart.noDataText = "No data available"
            // user interaction
            pieChart.isUserInteractionEnabled = true
            
            let d = Description()
            d.text = "Attendace for \(date)"
            pieChart.chartDescription = d
            pieChart.centerText = "Focus Infosoft © 2018"
            pieChart.holeRadiusPercent = 0.5
            pieChart.transparentCircleColor = UIColor.clear
            pieChart.backgroundColor = UIColor.init(hexString: "FEF5E4")
    }
    
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return name.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as! AttendanceDashboardCell
        if name.count != 0{
            cell.nameLbl.text = name[indexPath.row]
            cell.inTimeLbl.text = inTime[indexPath.row]
            cell.outTimeLbl.text = outTime[indexPath.row]
            
            cell.locationLbl.text = inLoc[indexPath.row]
        }
       
        
        return cell
    }

}
