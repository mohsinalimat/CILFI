//
//  AttendanceSummariesViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੩੧/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import UIKit
import Cards
import DropDown
import DatePickerDialog
import SVProgressHUD
import Alamofire

class AttendanceSummariesCell : UICollectionViewCell{
    
    @IBOutlet weak var card: CardHighlight!{
        didSet{
            card.actionBtn.isHidden = true
            card.titleLbl.font = UIFont.systemFont(ofSize: 10, weight: .regular)
//          card.titleLbl.font = UIFont.systemFont(ofSize: 10.0, weight: .light)
//          card.titleLbl.adjustsFontSizeToFitWidth = true
//          card.titleLbl.lineHeight(0.70)
//          card.titleLbl.minimumScaleFactor = 0.1
            card.titleLbl.lineBreakMode = .byWordWrapping
            card.titleLbl.numberOfLines = 1
            card.itemTitleLbl.isHidden = true
        }
    }
    
    
}

class TableSummaryCell : UITableViewCell{
    
    @IBOutlet weak var colorCodeView: UIView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
    
}

class AttendanceSummariesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
   
   
    
   
    var yrs = ""
    var mnth = ""
    
    var user = ""
    var attendanceType = ""
    
    var manager = "N"
    
    let attnd = AttendanceSummariesModel()
    let team = TeamDetailModel()
    
    
    
   @IBOutlet weak var collectionView: UICollectionView!
    
    struct AtndData {
        var date : String?
        var first : String?
        var second : String?
        var inTime : String?
        var outTime : String?
    }
    
    
    struct TableAtndData {
        var color : String?
        var key : String?
        var value : String?
    }
    
    var tableData = [TableAtndData]()
    
    var summary = [AtndData]()
   
    
    @IBOutlet weak var selectUserBtn: UIButton!
    @IBAction func selectUserBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        
        dropDown.dataSource = team.employeeName
        dropDown.anchorView = selectUserBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.selectUserBtn.setTitle(item, for: .normal)
            self.user = self.team.employeeCode[index]
            self.getMNType()
        }
    }
    
    @IBOutlet weak var selectMonthBtn: UIButton!
    @IBAction func selectMonthBtn(_ sender: UIButton) {
        
        let dropDown = DropDown()
        
        dropDown.dataSource = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]
        dropDown.anchorView = selectMonthBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.selectMonthBtn.setTitle(item, for: .normal)
            self.mnth = self.attnd.months(mmmm: item)
            self.getMNType()
        }
    }
   
    @IBOutlet weak var selectYearBtn: UIButton!
    @IBAction func selectYearBtn(_ sender: UIButton) {
        
        let dropDown = DropDown()
        
        dropDown.dataSource = attnd.years()
        dropDown.anchorView = selectYearBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.selectYearBtn.setTitle(item, for: .normal)
            self.yrs = item
            self.getMNType()
        }
        
    }

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let lastmonthdate = Calendar.current.date(byAdding: .month, value: -1, to: Date()){
        
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            selectMonthBtn.setTitle(formatter.string(from: lastmonthdate), for: .normal)
            formatter.dateFormat = "MM"
            mnth = formatter.string(from: lastmonthdate)
        
            formatter.dateFormat = "yyyy"
            yrs = formatter.string(from: lastmonthdate)
            selectYearBtn.setTitle(yrs, for: .normal)
            
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        collectionView.allowsSelection = true
        collectionView.layoutIfNeeded()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        isManager()
    }

    
    func isManager(){
        
        if manager == "Y"{
            selectUserBtn.isHidden = false
            team.getTeamData()
            user = ""
            getMNType()
        }else if manager == "N"{
            selectUserBtn.isHidden = true
            user = defaults.string(forKey: "user")!
            getMNType()
        }
    }
    
    
    func getMNType(){
        let header = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : "\(yrs)\(mnth)", "employeecode" : user]
        
//        print(header)
        
        attendanceType = "Other"
        collectionView.reloadData()
        
        attnd.getMNDetails(header: header) { (type) in
            SVProgressHUD.show(withStatus: "Hold On! We are fetching the data")
            print(type)
             self.attendanceType = type
            
            if type == "M"{
                
                self.getMNAttendaceSmmary(headers: header)
                
            } else if type == "N"{
                self.getMNAttendaceSmmary(headers: header)
            }else{
                self.getAttendaceSmmary(headers: header)

            }
           
        }
        
        
        
    }
    
    func getMNAttendaceSmmary(headers: [String:String]){
       
       
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.reloadData()
        getMNAttendanceSummaryData(headers: headers)
        
        SVProgressHUD.dismiss()
        
    }
    
    func getAttendaceSmmary(headers: [String:String]){
        
        getAttendanceSummaryData(headers: headers)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        summary = [AtndData]()
        
        attnd.getAttendanceSummary(header: headers) { (date, firstHalf, secondHalf, inTime, outTime) in
            
            for x in 0..<date.count{
                self.summary.append(AtndData(date: date[x], first: firstHalf[x], second: secondHalf[x], inTime: inTime[x], outTime: outTime[x]))
            }
            
            SVProgressHUD.dismiss()
            
           self.collectionView.reloadData()
        }
         self.collectionView.reloadData()
    }
        
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ascell", for: indexPath) as! AttendanceSummariesCell
        let date = indexPath.row + 1
        let weekday = attnd.getWeekday(date: "\(date)-\(mnth)-\(yrs)")
        
        
        cell.card.itemTitleLbl.isHidden = true
        cell.card.icon = UIImage(named: "icons8-\(date)-96")
        cell.card.iconRadius = 0
        
        cell.card.titleSize = 8
        cell.card.itemTitleSize = 0
        cell.card.itemSubtitleSize = 20
        
        cell.card.backgroundColor = UIColor.white
        cell.card.title = weekday
        cell.card.itemTitle = ""
        cell.card.itemSubtitle = ""
        
        
        if attendanceType == "M"{
            if weekday == "Sunday"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "d2d7d3")
            }
        }else if attendanceType == "N"{
           
            if weekday == "Sunday"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "d2d7d3")
            }
        }else if attendanceType == "Other"{
            if weekday == "Sunday"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "d2d7d3")
            }
        }else{
            
            
            let title = attnd.attendanceSummaryCardHeading(first: summary[indexPath.row].first!, second: summary[indexPath.row].second!)
            
            if title == "Absent"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "ff9999")
            }else if title == "Days Work"{
                cell.card.itemSubtitleSize = 7
                cell.card.backgroundColor = hexStringToUIColor(hex: "ffffff")
                cell.card.itemSubtitle = "In-Time : \(summary[indexPath.row].inTime!.replacingOccurrences(of: ".", with: ":"))\nOut-Time : \(summary[indexPath.row].outTime!.replacingOccurrences(of: ".", with: ":"))"
                
            }else if title == "Leave Without Pay"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "ff9ff3")
            }else if title == "Casual Leave"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "bae0ce")
            }else if title == "Earn Leave"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "d2edf3")
            }else if title == "Sick Leave"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "fbf49c")
            }else if title == "Holiday"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "e6e6e6")
            }else if title == "Absent on ESI"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "a29bfe")
            }else if title == "National Holiday"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "e6e6e6")
            }else if title == "Festival Holiday"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "e6e6e6")
            }else if title == "Restricted Holiday"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "e6e6e6")
            }else if title == "Maternity Leave"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "fe92c9")
            }else if title == "Lay Off"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "ada8d3")
            }else if title == "Day Difference"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "B8CAF2")
            }else if title == "HO Worked"{
                cell.card.backgroundColor = hexStringToUIColor(hex: "F6EAD0")
            }
            
            
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CardContent") as! AttendanceSummaryTableViewController
        
        cell.card.shouldPresent(controller, from: self, fullscreen: false)
        controller.datelbl.text = "\(indexPath.row + 1)-\(mnth)-\(yrs)"
        controller.date = "\(yrs)-\(mnth)-\(indexPath.row + 1)"
        controller.user = user
        

        cell.card.isUserInteractionEnabled = true
        cell.card.hasParallax = false
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        print(summary.count)
        if attendanceType == "M"{
            return FetchDatesOfAMonth().getDates(year: Int(yrs)!, month: Int(mnth)!)
        }else if attendanceType == "N"{
            return FetchDatesOfAMonth().getDates(year: Int(yrs)!, month: Int(mnth)!)
        }else if attendanceType == "Other"{
            return FetchDatesOfAMonth().getDates(year: Int(yrs)!, month: Int(mnth)!)
        }else{
            return summary.count ?? 1
        }
        //        return FetchDatesOfAMonth().getDates(year: Int(yrs)!, month: Int(mnth)!)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 2.5
        layout.minimumInteritemSpacing = 2.5


        let itemsPerRow : CGFloat = 5

        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing ) / itemsPerRow

        return CGSize(width: itemWidth, height: itemWidth)
    }
    
   
    
    func getAttendanceSummaryData(headers: [String:String]){
        
        tableData = [TableAtndData]()
        
        attnd.attendanceSummaryData(header: headers) { (data) in
            var cl = 0
            var sl = 0
            var el = 0
            var present = 0
            var absent = 0
            var holiday = 0
            
            print(data)
            
            for (key, value) in data{
               
                if key == "Present"{
                    self.tableData.append(TableAtndData(color: "000000", key: key, value: String(value)))
                }else if key == "Absent"{
                    self.tableData.append(TableAtndData(color: "000000", key: key, value: String(value)))
                }else if value > 0{
                    self.tableData.append(TableAtndData(color: "000000", key: key, value: String(value)))
                }
                
                
            }
            self.tableView.reloadData()
        }
    }
        
    func getMNAttendanceSummaryData(headers: [String:String]){
        tableData = [TableAtndData]()
        
        attnd.mnattendanceSummaryData(header: headers) { (data) in
            for (key, value) in data{
                
                if Double(value)! > 0{
                    self.tableData.append(TableAtndData(color: "FFFFFF", key: key, value: String(value)))
                }
                
            }
            self.tableView.reloadData()
        }
    }
        
}


extension AttendanceSummariesViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableSummaryCell
        
        if tableData[indexPath.row].color == "000000"{
            
            if tableData[indexPath.row].key == "Absent"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "ff9999") //ff9999
            }else if tableData[indexPath.row].key == "Present"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "ffffff")//f0ffea
            }else if tableData[indexPath.row].key == "Leave Without Pay"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "ff9ff3")
            }else if tableData[indexPath.row].key == "Casual Leave"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "bae0ce")//00d2d3
            }else if tableData[indexPath.row].key == "Earn Leave"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "d2edf3")//3F99D9
            }else if tableData[indexPath.row].key == "Sick Leave"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "fbf49c")//f3a683
            }else if tableData[indexPath.row].key == "Holiday"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "#e6e6e6") //ebebeb
            }else if tableData[indexPath.row].key == "Absent on ESI"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "a29bfe")
            }else if tableData[indexPath.row].key == "National Holiday"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "e6e6e6")
            }else if tableData[indexPath.row].key == "Festival Holiday"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "e6e6e6")
            }else if tableData[indexPath.row].key == "Restricted Holiday"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "e6e6e6")
            }else if tableData[indexPath.row].key == "Maternity Leave"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "fe92c9")
            }else if tableData[indexPath.row].key == "Lay Off"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "ada8d3")
            }else if tableData[indexPath.row].key == "Day Difference"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "B8CAF2")
            }else if tableData[indexPath.row].key == "HO Worked"{
                cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: "F6EAD0")
            }
            
            
            
            
        }else{
            cell.colorCodeView.backgroundColor = hexStringToUIColor(hex: tableData[indexPath.row].color!)
        }
        
        
            cell.typeLbl.text = tableData[indexPath.row].key
            cell.valueLbl.text = tableData[indexPath.row].value
      
        
       
        
        return cell
    }
    
}

