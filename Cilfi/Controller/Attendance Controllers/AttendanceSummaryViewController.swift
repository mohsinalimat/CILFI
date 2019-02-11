////
////  AttendanceSummaryViewController.swift
////  Cilfi
////
////  Created by Amandeep Singh on 08/06/18.
////  Copyright © 2018 Focus Infosoft. All rights reserved.
////
//
//import UIKit
//import JTAppleCalendar
//import Alamofire
//import SwiftyJSON
//
//var selectedDate : String?
//var yearmonth = String()
//
//class customCell: JTAppleCell {
//    @IBOutlet weak var dateLabel : UILabel!
//    @IBOutlet weak var selectedView: UIView!
//    
//}
//
//
////MARK: - Attendance Summary
///***************************************************************/
//class AttendanceSummaryViewController: UIViewController{
//    var flag = 0
//    let formatter = DateFormatter()
//    let atndTypeURL = "\(LoginDetails.hostedIP)/sales/AttendanceType"
//    
//    var yrs : String?
//    var mnth : String?
//    var attendanceType : Character?
//
//    @IBOutlet weak var calendarView: JTAppleCalendarView!
//    @IBOutlet weak var month: UILabel!
//    @IBOutlet weak var year: UILabel!
//    @IBOutlet weak var heading1: UILabel!
//    @IBOutlet weak var heading2: UILabel!
//    @IBOutlet weak var heading3: UILabel!
//    @IBOutlet weak var heading4: UILabel!
//    @IBOutlet weak var heading5: UILabel!
//    @IBOutlet weak var heading6: UILabel!
//    @IBOutlet weak var label1: UILabel!
//    @IBOutlet weak var label2: UILabel!
//    @IBOutlet weak var label3: UILabel!
//    @IBOutlet weak var label4: UILabel!
//    @IBOutlet weak var label5: UILabel!
//    @IBOutlet weak var label6: UILabel!
//
//    @IBAction func todayBtn(_ sender: UIButton) {
//        today()
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //        getAttendanceTypeData(url: atndTypeURL, header: headers)
//
//        label5.isHidden = true
//        label6.isHidden = true
//        heading5.isHidden = true
//        heading6.isHidden = true
//
//        today()
//
//        //setup calendar spacing
//        setupCalendarView()
//        
//        //Setup Labels
//        calendarView.visibleDates { (visibleDates) in
//        self.setupLabelsForCalendar(from: visibleDates)
//        }
//        
//    }
//
//    func today(){
//        calendarView.scrollToDate(Date(), animateScroll: true)
//        
//        calendarView.selectDates([ Date() ])
//    }
//
//    func setupCalendarView() {
//        calendarView.minimumLineSpacing = 0
//        calendarView.minimumInteritemSpacing = 0
//    }
//    
//    func setupLabelsForCalendar(from visibleDates : DateSegmentInfo ){
//        let date = visibleDates.monthDates.first!.date
//
//        formatter.dateFormat = "MM"
//        mnth = formatter.string(from: date)
//
//
//        formatter.dateFormat = "yyyy"
//        year.text = formatter.string(from: date)
//        yrs = formatter.string(from: date)
//
//        formatter.dateFormat = "MMMM"
//        month.text = formatter.string(from: date)
//
//        yearmonth = yrs! + mnth!
//        getAttendanceTypeData(url: atndTypeURL, header: headers)
//    }
//
//    func handleCellTextColor(view: JTAppleCell?, cellState : CellState){
//        guard let validCell = view as? customCell else{return}
//
//
//        
//        let todaysDate = Date()
//        formatter.dateFormat = "yyyy MM dd"
//        let todaysDateString = formatter.string(from: todaysDate)
//
//        let monthDateString = formatter.string(from: cellState.date)
//
//        if todaysDateString == monthDateString{
//            validCell.dateLabel.textColor = UIColor.flatOrangeDark
//        }else{
//            if validCell.isSelected {
//                validCell.dateLabel.textColor = UIColor.flatWhite
//            }else{
//                if cellState.dateBelongsTo == .thisMonth{
//                    validCell.dateLabel.textColor = UIColor.flatTeal
//                }
//                else{
//                    validCell.dateLabel.textColor = UIColor.flatGray
//                }
//            }
//        }
//    }
//
//    func handleCellSelected(view: JTAppleCell?, cellState : CellState){
//        guard let validCell = view as? customCell else{return}
//
//        if validCell.isSelected {
//            validCell.selectedView.isHidden = false
//        }else{
//            validCell.selectedView.isHidden = true
//        }
//    }
//    
//
//}
//
////MARK: - Attendance Summary Calendar
///***************************************************************/
//extension AttendanceSummaryViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
//    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
//
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        handleCellSelected(view: cell, cellState: cellState)
//        handleCellTextColor(view: cell, cellState: cellState)
//        formatter.dateFormat = "MM-dd-yyyy"
//        selectedDate = formatter.string(from: date)
//        flag += 1
//        if flag > 1{
//            performSegue(withIdentifier: "goToAttendanceSummary", sender: self)
//        }
//
//
//
//    }
//    
//    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        handleCellSelected(view: cell, cellState: cellState)
//        handleCellTextColor(view: cell, cellState: cellState)
//
//        
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
//        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! customCell
//        cell.dateLabel.text = cellState.text
//
//        handleCellSelected(view: cell, cellState: cellState)
//        handleCellTextColor(view: cell, cellState: cellState)
//
//
//        return cell
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
//        setupLabelsForCalendar(from: visibleDates)
//    }
//
//    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
//        formatter.dateFormat = "yyyy MM dd"
//        formatter.timeZone = Calendar.current.timeZone
//        formatter.locale = Calendar.current.locale
//
//        let startDate = formatter.date(from: "2017 01 01")
//        let endDate = formatter.date(from: "2035 12 31")
//        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
//        return parameters
//    }
//
//    
//}
//
//
//
//
//
//
////MARK: - Networking - ALAMO FIRE
///***************************************************************/
//
////attendance type
//
//extension AttendanceSummaryViewController{
//    func getAttendanceTypeData(url : String, header : [String:String]){
//        
//        Alamofire.request(url, method: .get, headers : header).responseJSON{
//            response in
//            //
//            //        print(header)
//            
//            let atndData = response.data!
//            
//            if response.result.isSuccess{
//
//
//                do{
//                    let atnd = try JSONDecoder().decode(AttendanceTypeRoot.self, from: atndData)
//
//
//                    if let x = atnd.atndType{
//                        
//                        if x == "M" || x == "N"{
//                            
//                            let url = "\(LoginDetails.hostedIP)/sales/mnattendancesummary"
//                            let headers : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : yearmonth, "employeecode" : defaults.string(forKey: "employeeCode")!]
//
//
//
//                            self.getMNAttendanceSummaryData(url: url, header: headers)
//                        }
//                        else{
//
//                            self.heading5.isHidden = false
//                            self.heading6.isHidden = false
//                            self.label5.isHidden = false
//                            self.label6.isHidden = false
//
//                            let url = "\(LoginDetails.hostedIP)/sales/attendancesummary"
//                            let headers : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : yearmonth, "employeecode" : defaults.string(forKey: "employeeCode")!]
//                            self.getAttendanceSummaryData(url: url, header: headers)
//                        }
//
//                    }
//
//                    else {
//                        print ("Unable to fetch attendance type data")
//                    }
//
//                }
//                catch{
//                    print (error)
//                }
//
//            }
//            else{
//                print("Something Went wrong")
//            }
//        }
//    }
//
//    //MARK: - Networking - ALAMO FIRE
//    /***************************************************************/
//
//    //attendance type
//
//    func getAttendanceSummaryData(url : String, header : [String:String]){
//
//        heading1.text = "Present"
//        heading2.text = "Holiday"
//        heading3.text = "CL"
//        heading4.text = "Absent"
//        heading5.text = "SL"
//        heading6.text = "EL"
//
//        var absent = 0.0
//        var present = 0.0
//        var earnLeave = 0.0
//        var casualLeave = 0.0
//        var sickLeave = 0.0
//        var holiday = 0.0
//        //        print("we are here")
//
//        Alamofire.request(url, method: .get, headers : header).responseJSON{
//            response in
//            
//            //            print(header)
//
//            let atndData = response.data!
//
//            if response.result.isSuccess{
//                print (response.result.value)
//                do{
//                    let atnd = try JSONDecoder().decode(AttendanceSummaryRoot.self, from: atndData)
//                    for x in atnd.attendance{
//                        if let firstHalf = x.firstHalf{
//                            if firstHalf.lowercased() == "days work"{
//                                present += 0.5
//                            }
//                            else if firstHalf.lowercased() == "absent"{
//                                absent += 0.5
//                            }
//                            else if firstHalf.lowercased() == "leave without pay"{
//                                absent += 0.5
//                            }
//                            else if firstHalf.lowercased() == "casual leave"{
//                                casualLeave += 0.5
//                            }
//                            else if firstHalf.lowercased() == "earn leave"{
//                                earnLeave += 0.5
//                            }
//                            else if firstHalf.lowercased() == "sick leave"{
//                                sickLeave += 0.5
//                            }
//                            else if firstHalf.lowercased() == "holiday"{
//                                holiday += 0.5
//                            }
//
//                        }
//
//                        if let secondHalf = x.secondHalf{
//                            if secondHalf.lowercased() == "days work"{
//                                present += 0.5
//                            }
//                            else if secondHalf.lowercased() == "absent"{
//                                absent += 0.5
//                            }
//                            else if secondHalf.lowercased() == "leave without pay"{
//                                absent += 0.5
//                            }
//                            else if secondHalf.lowercased() == "casual leave"{
//                                casualLeave += 0.5
//                            }
//                            else if secondHalf.lowercased() == "earn leave"{
//                                earnLeave += 0.5
//                            }
//                            else if secondHalf.lowercased() == "sick leave"{
//                                sickLeave += 0.5
//                            }
//                            else if secondHalf.lowercased() == "holiday"{
//                                holiday += 0.5
//                            }
//                        }
//                    }
//                    
//                    
//                    
//                }
//                catch{
//                    print (error)
//                }
//                
//            }
//            else{
//                print("Something Went wrong")
//            }
//        }
//    }
//
//    //MARK: - Networking - ALAMO FIRE
//    /***************************************************************/
//
//    //attendance type
//
//    func getMNAttendanceSummaryData(url : String, header : [String:String]){
//
//        //        print("we are here")
//        
//        Alamofire.request(url, method: .get, headers : header).responseJSON{
//            response in
//
//
//
//            let atndData = response.data!
//
//            if response.result.isSuccess{
//
//
//                //                print (response.result.value)
//                do{
//                    let atnd = try JSONDecoder().decode(MNAttendanceRoot.self, from: atndData)
//
//
//                    if let holiday = atnd.holiday{
//
//                            self.label1.text = holiday
//
//
//                    }
//                    
//                    if let daysWork = atnd.daysWork{
//                       
//                            self.label2.text = daysWork
//                        
//
//                    }
//
//
//                    if let hoWork = atnd.hoWork{
//                        
//                            self.label3.text = hoWork
//
//                    }
//                    
//                    if let total = atnd.total{
//                        
//                            self.label4.text = total
//                       
//                    }
//                }
//                catch{
//                    print (error)
//                }
//
//            }
//            else{
//                print("Something Went wrong")
//            }
//        }
//    }
//    
//}
