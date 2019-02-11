//
//  AttendanceSummariesModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੩੧/੧੦/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire
class AttendanceSummariesModel {
    
    
    func years()->[String]{
        
        var yrs = [String]()
        
        let date = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        for x in 1999..<Int(formatter.string(from: date!))!{
            yrs.append(String(x))
        }
        
        
        
       return yrs
    }
    
    
    func months(mmmm : String) -> String{
        
        switch mmmm {
        case "Jan":
            return "01"
        case "Feb":
            return "02"
        case "Mar":
            return "03"
        case "Apr":
            return "04"
        case "May":
            return "05"
        case "Jun":
            return "06"
        case "Jul":
            return "07"
        case "Aug":
            return "08"
        case "Sep":
            return "09"
        case "Oct":
            return "10"
        case "Nov":
            return "11"
        case "Dec":
            return "12"
        default:
            return "0"
        }
    }
    
    func getWeekday(date : String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        guard let dt = formatter.date(from: date) else {return "Unable to fetch"}
        formatter.dateFormat = "EEEE"
        return formatter.string(from: dt)
    }
    
    func getMNDetails(header : [String:String], completion : @escaping(String)->Void){
        Alamofire.request("\(LoginDetails.hostedIP)/sales/AttendanceType", method: .get, headers : header).responseJSON{
            response in
            
            let aData = response.data!
            let aJSON = response.result.value
            
            if response.result.isSuccess{
                //                                                                             print("UserJSON: \(ledgerJSON)")
                
                do{
                    let atnd = try JSONDecoder().decode(AttendanceTypeRoot.self, from: aData)
                    
                    //                    print(aJSON)
                    if let value = atnd.atndType{
                        completion(value)
                    }
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

    
    
    func getAttendanceSummary(header : [String:String], completion : @escaping(([String],[String],[String],[String],[String])->Void)){
        
        var date = [String]()
        var firstHalf = [String]()
        var secondHalf = [String]()
        var inTime = [String]()
        var outTime = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/attendancesummary", method: .get, headers : header).responseJSON{
            response in
            
            //            print(header)
            
            let atndData = response.data!
            
            if response.result.isSuccess{
                //                            print (response.result.value)
                do{
                    let atnd = try JSONDecoder().decode(AttendanceSummaryRoot.self, from: atndData)
                    
                    print(response.result.value)
                    for x in atnd.attendance{
                        
                        date.append(x.attDate)
                        
                        if let value = x.firstHalf{
                            firstHalf.append(value)
                        }
                        
                        if let value = x.secondHalf{
                            secondHalf.append(value)
                        }
                        
                        if let value = x.inTime{
                            inTime.append(value)
                        }
                        
                        if let value = x.outTime{
                            outTime.append(value)
                        }
                        
                    }
                    completion(date,firstHalf,secondHalf, inTime, outTime)
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
    
    
    
    func attendanceSummaryCardHeading(first: String, second : String)->String{
        
        
        if first == second{
            return first ?? second
        }else{
            if first == "Absent"{
                return "Second Half"
            }else if second == "Absent"{
                return "First Half"
            }else {
                return "No Data" 
            }
        }
    }
    
    
    func getMNAttendanceSummary(header : [String:String], completion : @escaping(([String],[String],[String])->Void)){
        
        var date = [String]()
        var firstHalf = [String]()
        var secondHalf = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/attendancesummary", method: .get, headers : header).responseJSON{
            response in
            
            //            print(header)
            
            let atndData = response.data!
            
            if response.result.isSuccess{
                //                            print (response.result.value)
                do{
                    let atnd = try JSONDecoder().decode(AttendanceSummaryRoot.self, from: atndData)
                    
//                    print(response.result.value)
                    for x in atnd.attendance{
                        
                        date.append(x.attDate)
                        
                        if let value = x.firstHalf{
                            firstHalf.append(value)
                        }
                        
                        if let value = x.secondHalf{
                            secondHalf.append(value)
                        }
                        
                    }
                    completion(date,firstHalf,secondHalf)
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
    
    
    
    func attendanceSummaryData(header : [String:String], completion : @escaping ([String:Double]) -> Void){
        
        var absent = 0.0
        var present = 0.0
//        var leaveWithoutPay = 0.0
        var earnLeave = 0.0
        var casualLeave = 0.0
        var sickLeave = 0.0
        var holiday = 0.0
    
//        var absentOnESI = 0.0
//        var nationalHoliday = 0.0
//        var festivalHoliday = 0.0
//        var restrictedHoliday = 0.0
        var maternityLeave = 0.0
        var layOff = 0.0
        var dayDiffrence = 0.0
        var hoWorked = 0.0

        
        //        print("we are here")
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/attendancesummary", method: .get, headers : header).responseJSON{
            response in
            
            //            print(header)
            
            let atndData = response.data!
            
            if response.result.isSuccess{
//                print (response.result.value)
                do{
                    let atnd = try JSONDecoder().decode(AttendanceSummaryRoot.self, from: atndData)
                    for x in atnd.attendance{
                        if let firstHalf = x.firstHalf{
                            if firstHalf.lowercased() == "days work"{
                                present += 0.5
                            }
                            else if firstHalf.lowercased() == "absent"{
                                absent += 0.5
                            }
                            else if firstHalf.lowercased() == "leave without pay"{
                                absent += 0.5
                            }
                            else if firstHalf.lowercased() == "casual leave"{
                                casualLeave += 0.5
                            }
                            else if firstHalf.lowercased() == "earn leave"{
                                earnLeave += 0.5
                            }
                            else if firstHalf.lowercased() == "sick leave"{
                                sickLeave += 0.5
                            }
                            else if firstHalf.lowercased() == "holiday"{
                                holiday += 0.5
                            }
                            else if firstHalf.lowercased() == "absent on esi"{
                                absent += 0.5
                            }
                            else if firstHalf.lowercased() == "national holiday"{
                                holiday += 0.5
                            }
                            else if firstHalf.lowercased() == "festival holiday"{
                                holiday += 0.5
                            }
                            else if firstHalf.lowercased() == "restricted holiday"{
                                holiday += 0.5
                            }
                            else if firstHalf.lowercased() == "maternity leave"{
                                maternityLeave += 0.5
                            }
                            else if firstHalf.lowercased() == "lay off"{
                                layOff += 0.5
                            }
                            else if firstHalf.lowercased() == "day diffrence"{
                                dayDiffrence += 0.5
                            }
                            else if firstHalf.lowercased() == "ho worked"{
                                hoWorked += 0.5
                            }
                            
                        }
                        
                        if let secondHalf = x.secondHalf{
                            if secondHalf.lowercased() == "days work"{
                                present += 0.5
                            }
                            else if secondHalf.lowercased() == "absent"{
                                absent += 0.5
                            }
                            else if secondHalf.lowercased() == "leave without pay"{
                                absent += 0.5
                            }
                            else if secondHalf.lowercased() == "casual leave"{
                                casualLeave += 0.5
                            }
                            else if secondHalf.lowercased() == "earn leave"{
                                earnLeave += 0.5
                            }
                            else if secondHalf.lowercased() == "sick leave"{
                                sickLeave += 0.5
                            }
                            else if secondHalf.lowercased() == "holiday"{
                                holiday += 0.5
                            }
                            else if secondHalf.lowercased() == "absent on esi"{
                                absent += 0.5
                            }
                            else if secondHalf.lowercased() == "national holiday"{
                                holiday += 0.5
                            }
                            else if secondHalf.lowercased() == "festival holiday"{
                                holiday += 0.5
                            }
                            else if secondHalf.lowercased() == "restricted holiday"{
                                holiday += 0.5
                            }
                            else if secondHalf.lowercased() == "maternity leave"{
                                maternityLeave += 0.5
                            }
                            else if secondHalf.lowercased() == "lay off"{
                                layOff += 0.5
                            }
                            else if secondHalf.lowercased() == "day diffrence"{
                                dayDiffrence += 0.5
                            }
                            else if secondHalf.lowercased() == "ho worked"{
                                hoWorked += 0.5
                            }
                            
                        }
                    }
                    
                    completion(["Absent" : absent, "Present" : present,"Casual Leave" :  casualLeave, "Earn Leave" : earnLeave, "Sick Leave" : sickLeave, "Holiday":holiday, "Maternity Leave": maternityLeave, "Lay Off" : layOff, "Day Difference" : dayDiffrence, "HO Worked" : hoWorked])
                    
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
    
    func mnattendanceSummaryData(header : [String:String], completion : @escaping ([String:String]) -> Void){
        Alamofire.request("\(LoginDetails.hostedIP)/sales/mnattendancesummary", method: .get, headers : header).responseJSON{
            response in
            
            //            print(header)
            
            let atndData = response.data!
            
            if response.result.isSuccess{
                //                            print (response.result.value)
                do{
                    let atnd = try JSONDecoder().decode(MNAttendanceRoot.self, from: atndData)
                    completion(["Left" : atnd.left!, "Absent" : atnd.absent!, "Absent on ESI" : atnd.absOnEsi!, "Holiday" : atnd.holiday!, "HO Work": atnd.hoWork!, "National Holiday" : atnd.nh!, "Festival Holiday" : atnd.fh!, "Earned Leave": atnd.el!, "Sick Leave" : atnd.sl!, "Casual Leave" : atnd.cl!, "Restricted Holiday": atnd.rh!, "Maternity Leave" : atnd.ml!, "Lay Off" : atnd.layOff!, "New Com" : atnd.newCom!, "Days Work": atnd.daysWork!, "Days Paid" : atnd.daysPaid!, "Total" : atnd.total!])
                   
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
