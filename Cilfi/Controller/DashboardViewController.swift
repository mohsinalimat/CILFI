//
//  DashboardViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 15/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage

class DashTableViewCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationLabe: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventTypeImg: UIImageView!
    
}


class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var empCode = [String]()
    var empName = [String]()
    var desg = [String]()
    var eventDate = [String]()
    var eventType = [String]()
    var profileUrl = [URL]()
    
    let graphs = DashGraphModel()
    
    @IBOutlet var chtChart: LineChartView!
    @IBOutlet var barChtChart: BarChartView!
    @IBOutlet weak var tableView: UITableView!
    
    let tempurl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        // tapRecognizer, placed in viewDidLoad
        //        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        //        self.tableView.addGestureRecognizer(longPressRecognizer)
        
        chtChart.noDataText = ""
        barChtChart.noDataText = ""
        
        let parameters : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")! , "employeecode" : defaults.string(forKey: "user")!]
        //
        getDashData(url: "\(LoginDetails.hostedIP)/sales/dashboard", parameter: parameters)
        
    }
    
    
    
    //MARK: - Networking - ALAMO FIRE
    /***************************************************************/
    
    func getDashData(url : String, parameter : [String:String]){
        
        print(url)
        
        Alamofire.request(url, method: .get, headers : parameter).responseJSON{
            response in
            
            let dashData = response.data!
            
            if response.result.isSuccess{
                
                do{
                    let dash = try JSONDecoder().decode(DashRoot.self, from: dashData)
                    //line chart
                    
                    for x in dash.attendanceChart{
                        self.graphs.values.append(x.value!)
                        self.graphs.title.append(x.title!)
                    }
                    //bar chart
                    
                    for y in dash.leaveChart{
                        self.graphs.bartitle.append(y.title!)
                        self.graphs.credit.append(y.credit!)
                        self.graphs.consume.append(y.consume!)
                    }
                    
                    for z in dash.eventDetail{
                        
                        self.empCode.append(z.employeeCode!)
                        self.empName.append(z.employeeName!)
                        self.desg.append(z.designation!)
                        self.eventDate.append(z.eventDate!)
                        self.eventType.append(z.eventType!)
                        if let value = z.profileUrl{
                            if let url = URL(string: "\(LoginDetails.hostedIP)\(value)"){
                                self.profileUrl.append(url)
                            }
                        }
                        
                        
                    }
                    //calling both methods
                    self.lineChartView(lineChartValues: self.graphs.values.reversed(), months: self.graphs.title.reversed())
                    self.barChartView(barChartValues1: self.graphs.credit.reversed(), barChartValues2: self.graphs.consume.reversed(), months: self.graphs.bartitle.reversed())
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
    
    
    //MARK: - Line Chart Method
    /***************************************************************/
    func lineChartView(lineChartValues : [String], months : [String]){
        var lineChartEntry = [ChartDataEntry]()
        var a = 0.0
        
        if lineChartValues.count != 0{
            for x in 1...lineChartValues.count{
                
                let value = ChartDataEntry(x: a, y: (lineChartValues[x-1] as NSString).doubleValue )
                a+=1
                
                
                lineChartEntry.append(value)
            }
            
            let line1 = LineChartDataSet(values: lineChartEntry, label: "Attendance in %")
            line1.setColor(UIColor(red: 242/255, green: 247/255, blue: 158/255, alpha: 1))
            
            let dataa = LineChartData()
            dataa.addDataSet(line1)
            
            chtChart.data = dataa
            chtChart.animate(xAxisDuration: 1)
            chtChart.pinchZoomEnabled = true
            chtChart.dragEnabled = true
            chtChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
            chtChart.xAxis.granularity = 1
            chtChart.chartDescription?.text = "Attendance from last 12 months"
            chtChart.noDataText = "Unable to fetch data"
            chtChart.noDataTextColor = .red
        }else{
            chtChart.noDataText = "Unable to fetch data"
            chtChart.noDataTextColor = .red
            
        }
        
    }
    
    
    //MARK: - Bar Chart Method
    /***************************************************************/
    func barChartView(barChartValues1 : [String], barChartValues2 : [String], months : [String]) {
        
        barChtChart.noDataText = "Unable to fetch data"
        barChtChart.noDataTextColor = .red
        
        var barChartEntry1 = [BarChartDataEntry]()
        var barChartEntry2 = [BarChartDataEntry]()
        var a = 0.0
        var b = 0.0
        
        
        for x in 1...barChartValues1.count{
            //            print (barChartValues1[x-1])
            let value1 = BarChartDataEntry(x: a, y: (barChartValues1[x-1] as NSString).doubleValue)
            a+=1
            barChartEntry1.append(value1)
        }
        
        for x in 1...barChartValues2.count{
            //            print (barChartValues2[x-1])
            let value2 = BarChartDataEntry(x: b, y:(barChartValues2[x-1] as NSString).doubleValue)
            b+=1
            barChartEntry2.append(value2)
        }
        
        
        
        let line1 = BarChartDataSet (values: barChartEntry1, label: "Credits")
        line1.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
        let line2 = BarChartDataSet(values: barChartEntry2, label: "Consume")
        line2.setColor(UIColor(red: 255/255, green: 30/255, blue: 0/255, alpha: 1))
        
        let dataaa: [BarChartDataSet] = [line1,line2]
        let chartData = BarChartData(dataSets: dataaa)
        
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = months.count
        let startYear = 0
        
        
        chartData.barWidth = barWidth;
        barChtChart.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        //        print("Groupspace: \(gg)")
        barChtChart.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barChtChart.notifyDataSetChanged()
        barChtChart.pinchZoomEnabled = true
        barChtChart.dragEnabled = true
        barChtChart.data = chartData
        barChtChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        barChtChart.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .linear)
        barChtChart.xAxis.granularity = 1
        barChtChart.chartDescription?.text = "Attendance from last 12 months"
        barChtChart.noDataText = "Unable to fetch data"
        
    }
}

extension DashboardViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empName.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashCell", for: indexPath) as! DashTableViewCell
        
        
        
        cell.userImg.sd_setImage(with: profileUrl[indexPath.row], placeholderImage: UIImage(named: "cilfislpash-logo"), options: .cacheMemoryOnly, completed: nil)
        cell.nameLabel.text = ("\(empName[indexPath.row])   \(empCode[indexPath.row])")
        cell.designationLabe.text = desg[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        
        if let date = formatter.date(from: eventDate[indexPath.row]){
            formatter.dateFormat = "MMMM dd"
            cell.dateLabel.text = formatter.string(from: date)
        }
        
        if eventType[indexPath.row] == "Birthday" {
            cell.eventTypeImg.image = UIImage(named: "birthday-cake")
        }
        else if eventType[indexPath.row] == "Anniversary"{
            cell.eventTypeImg.image = UIImage(named: "anniversary")
        }
        else if eventType[indexPath.row] == "Work Anniversary"{
            cell.eventTypeImg.image = UIImage(named: "work-anniversary")
        }
        
        cell.userImg.layer.borderWidth = 1.0
        cell.userImg.layer.masksToBounds = false
        cell.userImg.layer.borderColor = UIColor.white.cgColor
        cell.userImg.layer.cornerRadius = cell.userImg.frame.size.width / 2
        cell.userImg.clipsToBounds = true
        
        return cell
        
        
    }
    
    
}



