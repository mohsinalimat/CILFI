//
//  StructDecodeModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 21/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//MARK: - Menu Struct
/***************************************************************/
struct Root : Decodable {
    private enum CodingKeys : String, CodingKey {
        case menudata = "menuData"
        
    }
    let menudata : [menuData]
    
}

struct menuData : Decodable {
    private enum CodingKeys : String, CodingKey { case getmenu = "getMenu" }
    let getmenu : [getMenu]
}

struct getMenu : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "Code"
        case menuname = "MenuName"
        case menuid = "MenuID"
        case type = "Type"
    }
    let code : String?
    let menuname : String?
    let menuid : String?
    let type : String?
}



//MARK: - Dash Struct
/***************************************************************/
struct DashRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case attendanceChart = "attendanceChart"
        case leaveChart = "leaveChart"
        case eventDetail = "eventDetail"
    }
    let attendanceChart : [AttendanceChart]
    let leaveChart : [LeaveChart]
    let eventDetail : [EventDetail]
}


struct AttendanceChart : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "Title"
        case value = "Value"
        
    }
    let title : String?
    let value : String?
    
}

struct LeaveChart : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "Title"
        case credit = "Credit"
        case consume = "Consume"
        
    }
    let title : String?
    let credit : String?
    let consume : String?
}

struct EventDetail : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case employeeName = "EmployeeName"
        case employeeCode = "EmployeeCode"
        case designation = "Designation"
        case eventDate = "EventDate"
        case eventType = "EventType"
        case profileUrl = "ProfileUrl"
        
    }
    let employeeName : String?
    let employeeCode : String?
    let designation : String?
    let eventDate : String?
    let eventType : String?
    let profileUrl : String?
}


//MARK: - AttendenceFencing Struct
/***************************************************************/

struct FencingRoot : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case fenceDetails = "geoFencing"
        case allowGeo = "AllowGeo"
    }
    let fenceDetails : [FencingDetail]
    let allowGeo :String?
}

struct FencingDetail : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empName = "EmpName"
        case empCode = "EmpCode"
        case distance = "Distance"
        case lat = "Lat"
        case lng = "Lng"
        case allowGeo = "AllowGeo"
        case fenceCode = "FencingCode"
        
    }
    let empName : String?
    let empCode : String?
    let distance : Int?
    let lat : Double?
    let lng : Double?
    let allowGeo : String?
    let fenceCode : String?
}


//MARK: - UserDetail Struct
/***************************************************************/


struct TeamDetailRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case teamdetail = "teamDetail"}
    let teamdetail : [TeamDetail]
    
}


struct TeamDetail : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empName = "EmployeeName"
        case empCode = "EmployeeCode"
        
    }
    let empName : String?
    let empCode : String?
    
}

//MARK: - UserTrack Struct
/***************************************************************/


struct UserTrackRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case userTrack = "userTracks"}
    let userTrack : [UserTracks]
    
}


struct UserTracks : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empName = "EmpName"
        case empCode = "EmpCode"
        case checkDate = "checkDate"
        case _checkDate = "_CheckDate"
        case lat = "Lat"
        case lng = "Lng"
        case macAddress = "MacAddress"
        case imei = "Imei"
        case address = "Address"
        case simnumber = "SimNumber"
        case checkType = "CheckType"
        case meters = "Meters"
        case metersWalking = "MetersWalking"
        case metersCar = "MetersCar"
        case metersTransit = "MetersTransit"
        case metersCycle = "MetersCycle"
        case metersBike = "MetersBike"
        case imgURL = "ImageUrl"
        case batteryStatus = "BatteryStatus"
        case locationMode = "LocationMode"
        case geoFencing = "GeoFencing"
        case notificationSent = "NotificationSent"
        
    }
    let empName : String?
    let empCode : String?
    let checkDate : String?
    let _checkDate : String?
    let lat : String?
    let lng : String?
    let macAddress : String?
    let imei : String?
    let address : String?
    let simnumber : String?
    let checkType : String?
    let meters : Int?
    let metersWalking : Int?
    let metersCar : Int?
    let metersTransit : Int?
    let metersCycle : Int?
    let metersBike : Int?
    let imgURL : String?
    let batteryStatus : String?
    let locationMode : String?
    let geoFencing : String?
    let notificationSent : String?
    
}


//MARK: - Leave Names Struct
/***************************************************************/


struct LeaveNamesRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case leaveNames = "leaveNames"}
    let leaveNames : [LeaveNames]
    
}


struct LeaveNames : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case leaveType = "LeaveType"
        case leaveDetail = "LeaveDetails"
    }
    let leaveType : String?
    let leaveDetail : String?
}

//MARK: - Leave Summary Struct
/***************************************************************/


struct LeaveSummaryRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case leaveSummary = "leaveSummary"}
    let leaveSummary : [LeaveSummary]
    
}


struct LeaveSummary : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case leaveType = "LeaveType"
        case opening = "Opening"
        case credited = "Credited"
        case consumed = "Consumed"
        case closing = "Closing"
    }
    let leaveType : String?
    let opening : String?
    let credited : String?
    let consumed : String?
    let closing : String?
}


//MARK: - Leave Status Struct
/***************************************************************/


struct LeaveStatusRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case leaveStatus = "leaveStatus"}
    let leaveStatus : [LeaveStatus]
    
}


struct LeaveStatus : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case reqDate = "RequestDate"
        case leaveType = "LeaveType"
        case fromDate = "FromDate"
        case tillDate = "TillDate"
        case remarks = "Remark"
        case status = "Status"
        case reason = "Reason"
        
    }
    let reqDate : String?
    let leaveType : String?
    let fromDate : String?
    let tillDate : String?
    let remarks : String?
    let status : String?
    let reason : String?
    
}

//MARK: - Leave Detail Struct
/***************************************************************/


struct LeaveDetailRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case leaveInfo = "leaveInfo"}
    let leaveInfo : [LeaveInfo]
    
}


struct LeaveInfo : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empName = "EmpName"
        case empCode = "EmpCode"
        case leaveType = "LeaveType"
        case fromDate = "FromDate"
        case toDate = "ToDate"
        case fromDateHalf = "FromDateHalf"
        case toDateHalf = "ToDateHalf"
        case remark = "Remark"
        case rowSeq = "RowSeq"
        case approvalDate = "ApprovalDate"
        case reason = "Reason"
        case mgrRemark = "MgrRemark"
        case mgrStatus = "MgrStatus"
        case reqDate = "RequestDate"
        
        
    }
    let empName : String?
    let empCode : String?
    let leaveType : String?
    let fromDate : String?
    let toDate : String?
    let fromDateHalf : String?
    let toDateHalf : String?
    let remark : String?
    let rowSeq : String?
    let approvalDate : String?
    let reason : String?
    let mgrRemark : String?
    let mgrStatus : String?
    let reqDate : String?
    
    
}

//MARK: - Attendance Type Struct
/***************************************************************/


struct AttendanceTypeRoot : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case atndType = "AtndType"
    }
    let atndType : String?
    
}


//MARK: - MNAttendance Struct
/***************************************************************/


struct MNAttendanceRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case left = "Left"
        case absent = "Absent"
        case absOnEsi = "AbsOnEsi"
        case holiday = "Holiday"
        case hoWork = "HoWork"
        case nh = "NH"
        case fh = "FH"
        case el = "EL"
        case cl = "CL"
        case sl = "SL"
        case rh = "RH"
        case ml = "ML"
        case layOff = "LayOff"
        case newCom = "NewCom"
        case daysWork = "DaysWork"
        case daysPaid = "DaysPaid"
        case total = "Total"
    }
    
    let left : String?
    let absent : String?
    let absOnEsi : String?
    let holiday : String?
    let hoWork : String?
    let nh : String?
    let fh : String?
    let el : String?
    let cl : String?
    let sl : String?
    let rh : String?
    let ml : String?
    let layOff : String?
    let newCom : String?
    let daysWork : String?
    let daysPaid : String?
    let total : String?
    
}

//MARK: - Attendance Summary Struct
/***************************************************************/


struct AttendanceSummaryRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case month = "Month"
        case attendance = "attendance"
    }
    let month : String?
    let attendance : [Attendance]
    
}


struct Attendance : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case attDate = "AttDate"
        case firstHalf = "FirstHalf"
        case secondHalf = "SecondHalf"
        case inTime = "InTime"
        case outTime = "OutTime"
    }
    let attDate : String
    let firstHalf : String?
    let secondHalf : String?
    let inTime : String?
    let outTime : String?
}


//MARK: - Attendance Track Struct
/***************************************************************/


struct AttendanceTrackRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case userTracks = "userTracks"  }
    let userTracks : [AttendanceTrack]
    
}


struct AttendanceTrack : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empName = "EmpName"
        case empCode = "EmpCode"
        case checkDate = "checkDate"
        case lat = "Lat"
        case lng = "Lng"
        case macAddress = "MacAddress"
        case imei = "Imei"
        case address = "Address"
        case simNo = "SimNumber"
        case checkTypee = "CheckType"
        case Meters = "Meters"
        case imgURL = "GhostImage"
    }
    let empName : String?
    let empCode : String?
    let checkDate : String?
    let lat : String?
    let lng : String?
    let macAddress : String?
    let imei : String?
    let address : String?
    let simNo : String?
    let checkTypee : String?
    let Meters : String?
    let imgURL : String?
    
    
}

//MARK: - Attendance Track Struct
/***************************************************************/

// FOR BOTH REGULARIZE STATUS & REGULARIZE APPROVE

struct RegularizeAttendanceRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case regularizeStatus = "regularizeStatus"  }
    let regularizeStatus : [RegularizeStatus]
    
}


struct RegularizeStatus : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empCode = "EmpCode"
        case empName = "EmpName"
        case atnDate = "AtnDate"
        case regularizeTypeIn = "RegularizeTypeIn"
        case regularizeTypeOut = "RegularizeTypeOut"
        case fromDate = "FromDate"
        case toDate = "ToDate"
        case inTime = "InTime"
        case statusIn = "StatusIn"
        case remarkIn = "RemarkIn"
        case outTime = "OutTime"
        case statusOut = "StatusOut"
        case remarkOut = "RemarkOut"
        case rowSeq = "RowSeq"
    }
    
    let empCode : String?
    let empName : String?
    let atnDate : String?
    let regularizeTypeIn : String?
    let regularizeTypeOut : String?
    let fromDate : String?
    let toDate : String?
    let inTime : String?
    let statusIn : String?
    let remarkIn : String?
    let outTime : String?
    let statusOut : String?
    let remarkOut : String?
    let rowSeq : String?
    
    
}

//MARK: - Pay Slip Struct
/***************************************************************/

struct PaySlipRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case paySlip = "PaySlipUrl"  }
    let paySlip : String?
    
}

//MARK: - Pay Slip Struct
/***************************************************************/

struct Form16Root : Decodable {
    private enum CodingKeys : String, CodingKey { case form16 = "FormNo16Url"  }
    let form16 : String?
    
}

//MARK: - Salary Ledger Struct
/***************************************************************/

struct SalaryLedgerRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case slData = "salaryLedgerData"  }
    let slData : [SalaryLedgerData]
    
}

struct SalaryLedgerData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case netPay = "NetPay"
        case paid = "Paid"
        case due = "Due"
        case code = "Code"
        case name = "Name"
        case yearmonth = "YearMonth"
        
    }
    
    let netPay : String?
    let paid : String?
    let due : String?
    let code : String?
    let name : String?
    let yearmonth : String?
    
    
    
}

//MARK: - Reimbursement Type Struct
/***************************************************************/

struct ReimbursementTypeRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case rType = "reimburseType"  }
    let rType : [ReimbursementTypeData]
    
}

struct ReimbursementTypeData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case name = "Name"
        case fn = "FullName"
        case rtype = "ReimburseType"
        case code = "Code"
        
        
    }
    
    let name : String?
    let fn : String?
    let rtype : String?
    let code : String?
}


//MARK: - Reimbursement Rate Struct
/***************************************************************/

struct ReimbursementRateRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case rate = "ReimburseRate"  }
    let rate : String?
    
}

//MARK: - Reimbursement Status Struct
/***************************************************************/

struct ReimbursementStatusRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case statInfo = "statusInfo"  }
    let statInfo : [ReimbursementStatusData]
    
}

struct ReimbursementStatusData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case rType = "ReimburseType"
        case expenseDate = "ExpenseDate"
        case remark = "Remark"
        case amount = "Amount"
        case mgrRemarks = "MgrRemark"
        case mgrStatus = "MgrStatus"
        case hrMgrRemark = "HrMgrRemark"
        case hrMgrStatus = "HrMgrStatus"
        case imgURL = "ImageUrl"
        
        
        
    }
    
    let rType : String?
    let expenseDate : String?
    let remark : String?
    let amount : String?
    let mgrRemarks : String?
    let mgrStatus : String?
    let hrMgrRemark : String?
    let hrMgrStatus : String?
    let imgURL : String?
}

//MARK: - Reimbursement Detail Struct
/***************************************************************/

struct ReimbursementDetailRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case rInfo = "reimburseInfo"  }
    let rInfo : [ReimbursementDetailData]
    
}

struct ReimbursementDetailData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case amnt = "Amount"
        case rate = "Rate"
        case empname = "EmpName"
        case empcode = "EmpCode"
        case dtype = "Dtyp"
        case ltype = "Ltyp"
        case remark = "Remark"
        case expensedate = "ExpenseDate"
        case reimbursetype = "ReimburseType"
        case mgrstatus = "MgrStatus"
        case paidStatus = "PaidStatus"
        case mgrremark = "MgrRemark"
        case rowSeq = "RowSeq"
        case imgUrl = "ImageUrl"
        case kms = "Kilometer"
        case trackedKms = "TrackingKMS"
        case rType = "RType"
        case _expenseDate = "_ExpenseDate"
        case fullName = "FullName"
        case locationCode = "LocationCode"
        case locationName = "LocationName"
        case approvedAmmount = "ApprovedAmount"
        case approvedKMS = "ApprovedKms"

        
    }
    
    let amnt : String?
    let rate : String?
    let empname : String?
    let empcode : String?
    let dtype : String?
    let ltype : String?
    let remark : String?
    let expensedate : String?
    let reimbursetype : String?
    let mgrstatus : String?
    let paidStatus : String?
    let mgrremark : String?
    let rowSeq : String?
    let imgUrl : String?
    let kms : Double?
    let trackedKms : Double?
    let rType : String?
    let _expenseDate : String?
    let fullName : String?
    let locationCode : String?
    let locationName : String?
    let approvedAmmount : Double?
    let approvedKMS : Double?
}


//MARK: - Reimbursement Report Struct
/***************************************************************/

struct ReimbursementReportRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case rReport = "reimbursementReport"  }
    let rReport : [ReimbursementReportData]
    
}

struct ReimbursementReportData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "Code"
        case name = "Name"
        case claimDate = "ClaimDate"
        case actualKMS = "ActualKMS"
        case trackingKMS = "TrackingKMS"
        case diffrenceKMS = "DifferenceKMS"
        case status = "Status"
        
        
        
        
    }
    
    let code : String?
    let name : String?
    let claimDate : String?
    let actualKMS : Double?
    let trackingKMS : Double?
    let diffrenceKMS : Double?
    let status : String?
    
}


//MARK: - Ticketing Approve Struct
/***************************************************************/

// used for Ticket Approve Data & Ticket Status Data
struct TicketApproveRoot : Decodable {
    private enum CodingKeys : String, CodingKey { case taData = "ticketApproveData"  }
    let taData : [TicketApproveData]
    
}

struct TicketApproveData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case name = "Name"
        case code = "Code"
        case dept = "Dept"
        case tID = "TicketID"
        case category = "Category"
        case sla = "Sla"
        case request = "Request"
        case otTime = "OpenTicketTime"
        case clTime = "CloseTicketTime"
        case status = "Status"
        case reason = "Reason"
        case remark = "Remark"
        
        
    }
    
    let name : String?
    let code : String?
    let dept : String?
    let tID : String?
    let category : String?
    let sla : String?
    let request : String?
    let otTime : String?
    let clTime : String?
    let status : String?
    let reason : String?
    let remark : String?
}


//MARK: - Ticketing Department & Ticketing Category Struct
/***************************************************************/

// used for Ticket Dept Data & Ticket Category Data
struct TicketDeptCatRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case tdeptcategotyData = "ticketDeptData"
        
    }
    let tdeptcategotyData : [TicketDeptCatData]
    
}

struct TicketDeptCatData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case name = "Name"
        case code = "Code"
        case email = "Email"
        case sla = "Sla"
        
    }
    
    let name : String?
    let code : String?
    let email : String?
    let sla : String?
    
}


//MARK: - Lead Data Struct
/***************************************************************/



struct LeadDataRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case leadData = "leadGenerateData"
        
    }
    let leadData : [LeadData]
    
}

struct LeadData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        
        case createdByCode = "CreatedByCode"
        case createdByName = "CreatedByName"
        case code = "Code"
        case leadID = "LeadID"
        case executiveName = "ExecutiveName"
        case salesCommit = "CommitSales"
        case firmAddress = "FirmAddress"
        case fage = "FirmAge"
        case farea = "FirmArea"
        case fcity = "FirmCity"
        case country = "Country"
        case pin = "PinCode"
        case fcontactPerson = "FirmContactPerson"
        case firmcontactPersonDesg = "FirmContactPersonDesg"
        case fcontactPersonEmail = "FirmContactPersonEmail"
        case firmContactPersonMobile = "FirmContactPersonMobile"
        case fgstin = "FirmGstn"
        case fname = "FirmName"
        case fpan = "FirmPan"
        case fpropType = "FirmPropType"
        case firmState = "FirmState"
        case ftype = "FirmType"
        case fweb = "FirmWeb"
        case fGodown = "GodownArea"
        case fGodownPropType = "GodownPropType"
        case nextDate = "NextDate"
        case otherDistributor = "OtherDistributor"
        case prod = "Product"
        case prodDealsIn = "ProductDealsIn"
        case reffsourceTitle = "ReffSourceTitle"
        case  reffSource = "ReffSource"
        case  rowSeq = "RowSeq"
        case  soft = "Software"
        case  status = "Status"
        case  tfnRef1 = "TradeRef1FirmName"
        case  tpnRef1 = "TradeRef1PersonName"
        case tmnRef1 = "TradeRef1MobileNo"
        case tfnRef2 = "TradeRef2FirmName"
        case tpnRef2 = "TradeRef2PersonName"
        case tmnRef2 = "TradeRef2MobileNo"
        case tfnRef3 = "TradeRef3FirmName"
        case tpnRef3 = "TradeRef3PersonName"
        case tmnRef3 = "TradeRef3MobileNo"
        case turnOver1 = "TurnOver1"
        case turnOver2 = "TurnOver2"
        case turnOver3 = "TurnOver3"
        case visitDate = "VisitDate"
        case vcImg = "VisitingCardImage"
        case fsImg = "FrontOfShopImage"
        case stockinGodownImg = "StockInGodownImage"
        case adjShopsImg =  "AdjoiningShopsImage"
        case attatchData = "AttachData"
        case attatchType = "AttachType"
        case lat = "Lat"
        case lng = "Lng"
        case leadType = "LeadType"
        case remarks = "Remarks"
    }
    
    let createdByCode : String?
    let createdByName : String?
    let code : String?
    let leadID : String?
    let executiveName : String?
    let salesCommit : String?
    let firmAddress : String?
    let fage : String?
    let farea : String?
    let fcity : String?
    let country : String?
    let pin : String?
    let fcontactPerson : String?
    let firmcontactPersonDesg : String?
    let fcontactPersonEmail : String?
    let firmContactPersonMobile : String?
    let fgstin : String?
    let fname : String?
    let fpan : String?
    let fpropType : String?
    let firmState : String?
    let ftype : String?
    let fweb : String?
    let fGodown : String?
    let fGodownPropType : String?
    let nextDate : String?
    let otherDistributor : String?
    let prod : String?
    let prodDealsIn : String?
    let reffsourceTitle : String?
    let  reffSource : String?
    let  rowSeq : String?
    let  soft : String?
    let  status : String?
    let  tfnRef1 : String?
    let  tpnRef1 : String?
    let tmnRef1 : String?
    let tfnRef2 : String?
    let tpnRef2 : String?
    let tmnRef2 : String?
    let tfnRef3 : String?
    let tpnRef3 : String?
    let tmnRef3 : String?
    let turnOver1 : String?
    let turnOver2 : String?
    let turnOver3 : String?
    let visitDate : String?
    let vcImg : String?
    let fsImg : String?
    let stockinGodownImg : String?
    let adjShopsImg : String?
    let attatchData : String?
    let attatchType : String?
    let lat : String?
    let lng : String?
    let leadType : String?
    let remarks : String?
}


//MARK: - NearBy Lead Struct
/***************************************************************/

struct NearbyLeadRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case nbl = "leaddetails"
        
    }
    let nbl : [NBLData]
    
}

struct NBLData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case firmName = "FirmName"
        case firmContactPerson = "FirmContactPerson"
        case firmContactPersonMobile = "FirmContactPersonMobile"
        case executiveName = "ExecutiveName"
        case address = "Address"
        case lat = "Latitude"
        case lng = "longitude"
        case stat = "Status"
        
    }
    
    let firmName : String?
    let firmContactPerson : String?
    let firmContactPersonMobile : String?
    let executiveName : String?
    let address : String?
    let lat : Double?
    let lng : Double?
    let stat : String?
    
}


//MARK: - Ledger Account Struct
/***************************************************************/

struct LedgerAccountRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case customerData = "customerData"
        
    }
    let customerData : [LedgerAccountData]
    
}

struct LedgerAccountData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case custCode = "CustomerCode"
        case custName = "Name"
        case custAddress1 = "Address1"
        case custAddress2 = "Address2"
        case custAddress3 = "Address3"
        case city = "City"
        case dist = "District"
        case state = "State"
        case pin = "PinCode"
        case region = "Region"
        case groupCode = "GroupCode"
        case mobile = "Mobile"
        case telephone = "Telephone"
        case contactPerson = "ContactPerson"
        case gstin = "GstIN"
        case email =  "EmailID"
        
    }
    
    let custCode : String?
    let custName : String?
    let custAddress1 : String?
    let custAddress2 : String?
    let custAddress3 : String?
    let city : String?
    let dist : String?
    let state : String?
    let pin: String?
    let region : String?
    let groupCode : String?
    let mobile : String?
    let telephone : String?
    let contactPerson : String?
    let gstin : String?
    let email : String?
    
}


//MARK: - Ledger Data Struct
/***************************************************************/

struct LedgerDataRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case ledgerData = "ledgerData"
        
    }
    let ledgerData : [LedgerData]
    
}

struct LedgerData : Decodable {
    private enum CodingKeys : String, CodingKey {
        case ledgerDetail = "ledgerDetail"
        
    }
    let ledgerDetail : [LedgerDetails]
    
}

struct LedgerDetails : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "Title"
        case value = "Value"
        
    }
    
    let title : String?
    let value : String?
}

//MARK: - Group Name Data Struct
/***************************************************************/

struct GroupRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case groupData = "groupData"
        
    }
    let groupData : [GroupData]
    
}

struct GroupData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "GroupCode"
        case name = "GroupName"
        
    }
    
    let code : String?
    let name : String?
}


//MARK: - Item Struct
/***************************************************************/

struct ItemRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case itemData = "itemData"
        
    }
    let itemData : [ItemData]
    
}

struct ItemData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "ItemCode"
        case name = "ItemName"
        case alt = "Alt"
        case mrp = "Mrp"
        case color = "Color"
        case discount = "Discount"
        case msp = "Msp"
        case dispatchTime = "DispatchTime"
        case monTotal = "MonTotal"
        case minOrderQty = "MinOrderQty"
        
    }
    
    let code : String?
    let name : String?
    let alt : String?
    let mrp : String?
    let color : String?
    let discount : String?
    let msp : String?
    let dispatchTime : String?
    let monTotal : String?
    let minOrderQty : String?
}


//MARK: - Customer Outstanding Struct
/***************************************************************/

struct CustomerOutstandingRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case codata = "customerOutstanding"
        
    }
    let codata : [CustomerOutstangingData]
    
}

struct CustomerOutstangingData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case account = "Account"
        case vDate = "Vdate"
        case billNo = "BillNo"
        case ammount = "Amount"
        
        
    }
    
    let account : String?
    let vDate : String?
    let billNo : String?
    let ammount : String?
    
}


//MARK: - Target Struct
/***************************************************************/

struct TargetRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case tData = "targetData"
        
    }
    let tData : [TargetData]
    
}

struct TargetData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case account = "Account"
        case customerName = "CustomerName"
        case customerCode = "CustomerCode"
        case primarySale = "PrimarySale"
        case secondarySale = "SecondarySale"
        case itemGroup = "ItemGroup"
        case groupName = "GroupName"
        case achivedPrimary = "AchievedPrimary"
        case achievedSecondary = "AchievedSecondary"
        
    }
    
    let account : String?
    let customerName : String?
    let customerCode : String?
    let primarySale : String?
    let secondarySale : String?
    let itemGroup : String?
    let groupName : String?
    let achivedPrimary : String?
    let achievedSecondary : String?
}


//MARK: - My Visit Struct
/***************************************************************/

struct VisitingReportRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case visitingReport = "visitingReport"
        
    }
    let visitingReport : [VisitingReportData]
    
}

struct VisitingReportData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case executiveName = "ExecutiveName"
        case executiveCode = "ExecutiveCode"
        case designation = "Designation"
        case visitDate = "VisitDate"
        case reportDate = "ReportDate"
        case reportLocation = "ReportLocation"
        case customerName = "CustomerName"
        case customerAccount = "CustomerAccount"
        case visitPuporse = "VisitPurpose"
        case visitTask = "VisitTask"
        case visitAchived = "VisitAchieved"
        case targetDate = "TargetDate"
        case nextDate = "NextDate"
        case target_date = "_TargetDate"
        case next_date = "_NextDate"
        case visit_date = "_VisitDate"
        case report_date = "_ReportDate"
        
        
    }
    
    let executiveName : String?
    let executiveCode : String?
    let designation : String?
    let visitDate : String?
    let reportDate : String?
    let reportLocation : String?
    let customerName : String?
    let customerAccount : String?
    let visitPuporse : String?
    let visitTask : String?
    let visitAchived : String?
    let targetDate : String?
    let nextDate : String?
    let target_date : String?
    let next_date : String?
    let visit_date : String?
    let report_date : String?
}


//MARK: - Track All Struct
/***************************************************************/

struct TrackAllRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case taData = "userTracks"
        
    }
    let taData : [TrackAllData]
    
}

struct TrackAllData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empName = "EmpName"
        case empCode = "EmpCode"
        case checkDate = "checkDate"
        case latitude = "Lat"
        case longitude = "Lng"
        case macAddress = "MacAddress"
        case imei = "Imei"
        case address = "Address"
        case simNumber = "SimNumber"
        case checkType = "CheckType"
        case meters = "Meters"
        case imgUrl = "ImageUrl"
        case batterySatus = "BatteryStatus"
        case locationMode = "LocationMode"
        
    }
    
    let empName : String?
    let empCode : String?
    let checkDate : String?
    let latitude : String?
    let longitude : String?
    let macAddress : String?
    let imei : String?
    let address : String?
    let simNumber : String?
    let checkType : String?
    let meters : String?
    let imgUrl : String?
    let batterySatus : Int?
    let locationMode : String?
}


//MARK: - Employee Profile Struct
/***************************************************************/

struct EmployeeProfileRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case empProfile = "employeeProfile"
        
    }
    let empProfile : [EmployeeProfileData]
    
}

struct EmployeeProfileData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "Title"
        case value = "Value"
        
    }
    
    let title : String?
    let value : String?
    
}

//MARK: - Family Profile Struct
/***************************************************************/

struct FamilyProfileRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case famData = "familyData"
        
    }
    let famData : [FamilyData]
    
}

struct FamilyData : Decodable {
    private enum CodingKeys : String, CodingKey {
        case famDetail = "familyDetail"
        
    }
    let famDetail : [FamilyDetail]
    
}

struct FamilyDetail : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "Title"
        case value = "Value"
        
    }
    
    let title : String?
    let value : String?
    
}

//MARK: - Reimbursement Ledger Struct
/***************************************************************/

struct ReimbursementLedgerRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case rlgList = "reimburseLedgerGroupList"
        
    }
    let rlgList : [ReimburseLedgerGroupList]
    
}

struct ReimburseLedgerGroupList : Decodable {
    private enum CodingKeys : String, CodingKey {
        case rll = "reimburseLedgerList"
        case groupTitle = "GroupTitle"
    }
    let rll : [ReimburseLedgerList]
    let groupTitle : String?
}

struct ReimburseLedgerList : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "Code"
        case name = "Name"
        case city = "City"
        case amnt = "Amount"
        case reimType = "ReimType"
        case dType = "Dtyp"
        case lType = "Ltyp"
        case expenseDate = "ExpenseDate"
        case oBal = "OpeningBal"
        case paidAmmnt = "PaidAmt"
        case dueAmmnt = "DueAmt"
        case entAmmnt = "EntAmt"
        case totalAmmnt = "TotalAmt"
        case status = "Status"
        case _expDate = "_ExpenseDate"
    }
    
    let code  : String?
    let name : String?
    let city : String?
    let amnt : String?
    let reimType : String?
    let dType : String?
    let lType : String?
    let expenseDate : String?
    let oBal : String?
    let paidAmmnt : String?
    let dueAmmnt : String?
    let entAmmnt : String?
    let totalAmmnt : String?
    let status : String?
    let _expDate : String?
    
}

//MARK: - Absent Struct
/***************************************************************/

struct AbsentRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case absentEmployee = "absentEmp"
        
    }
    let absentEmployee : [AbsentData]
    
}

struct AbsentData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "EmpCode"
        case name = "EmpName"
        case absent = "Absent"
        
    }
    
    let code : String?
    let name : String?
    let absent : String?
    
}


//MARK: - Attendance Dashboard Struct
/***************************************************************/

struct AttendanceDashboardRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case adEmployee = "attendanceDashboard"
        
    }
    let adEmployee : [AttendanceDashboardData]
    
}

struct AttendanceDashboardData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "EmpCode"
        case name = "EmpName"
        case inTime = "InTime"
        case outTime = "OutTime"
        case inLoc = "InLocation"
        case outLoc = "OutLocation"
        case status = "Status"
    }
    
    let code : String?
    let name : String?
    let inTime : String?
    let outTime : String?
    let inLoc : String?
    let outLoc : String?
    let status : String?
    
}

//MARK: - Employee Attendance Report Struct
/***************************************************************/

struct EmployeeAttendanceRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case eaEmployee = "attendanceReport"
        
    }
    let eaEmployee : [EmployeeAttendanceData]
    
}

struct EmployeeAttendanceData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case inTime = "InTime"
        case sInTime = "SinTime"
        case outTime = "OutTime"
        case sOutTime = "SoutTime"
        case atnDate = "AtnDate"
        case code = "Code"
        case name = "Name"
        case totalHours =  "TotalHours"
        case status =  "Status"
        case subStatus =  "SubStatus"
    }
    
    let inTime : String?
    let sInTime : String?
    let outTime : String?
    let sOutTime : String?
    let atnDate : String?
    let code : String?
    let name : String?
    let totalHours : String?
    let status : String?
    let subStatus : String?
}

//MARK: - Manager Struct
/***************************************************************/
struct ManagerRoot : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case isManager = "IsManager"
        case managerCode = "ManagerCode"
        case managerName = "ManagerName"
        case upperManagerCode = "UpperManagerCode"
        case upperManagerName = "UpperManagerName"
        
    }
    
    let isManager : String?
    let managerCode : String?
    let managerName : String?
    let upperManagerCode : String?
    let upperManagerName : String?
    
}


//MARK: - Employee Attendance Report Struct
/***************************************************************/

struct MeetingRequestRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case mrData = "employeeMeeting"
        
    }
    let mrData : [MeetingRequestData]
    
}

struct MeetingRequestData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "Code"
        case name = "Name"
        case additionalDetails = "AdditionalDetail"
        case meetingWith = "MeetingWith"
        case proposalDate = "ProposalDate"
        case proposalTime = "ProposalTime"
        case purpose = "Purpose"
        case requestedBy = "RequestedBy"
        case meetingLocation = "MeetingLocation"
        case status = "Status"
        case rowSeq = "Rowseq"
        case requesteeFeedback = "RequesteeFeedback"
        case managerFeedback = "ManagerFeedback"
        case managerRemark = "ManagerRemark"
        
    }
    
    let code : String?
    let name : String?
    let additionalDetails : String?
    let meetingWith: String?
    let proposalDate : String?
    let proposalTime : String?
    let purpose : String?
    let requestedBy : String?
    let meetingLocation : String?
    let status : String?
    let rowSeq : String?
    let requesteeFeedback : String?
    let managerFeedback : String?
    let managerRemark : String?
}



//MARK: - Hosted IP Struct
/***************************************************************/


struct HostedIPRoot : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case hostedIP = "HostedIP"
        case shortName = "ShortName"
        case fullName = "FullName"
       
        
    }
    
    let hostedIP : String?
    let shortName : String?
    let fullName : String?
    
}



//MARK: - Salary Details Struct
/***************************************************************/

struct SalaryDetailRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case grossEarning = "GrossEarning"
        case grossEarningData = "GrossEarningData"
        case deduction = "Deduction"
        case deductionData = "DeductionData"
        case netPay = "NetPay"
        case attendance = "Attendance"
        case attendanceData = "AttendanceData"

    }
    let grossEarning : String?
    let grossEarningData : [GrossEarningData]
    let deduction : String?
    let deductionData : [DeductionData]
    let netPay : String?
    let attendance : String?
    let attendanceData : [AttendanceData]
    
}

struct GrossEarningData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "Title"
        case value = "Value"
        
    }
    
    let title : String?
    let value : String?
    
}

struct DeductionData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "Title"
        case value = "Value"
        
    }
    
    let title : String?
    let value : String?
    
}

struct AttendanceData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case title = "Title"
        case value = "Value"
        
    }
    
    let title : String?
    let value : String?
    
}


//MARK: - Attendance Last In Out Time Struct
/***************************************************************/

struct AttendanceLastInOutTimeRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case inTime = "InTime"
        case outTime = "OutTime"
    }
    let inTime : String?
    let outTime : String?
}

//MARK: - Pay Location List Struct
/***************************************************************/

struct PayLocationListRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case payList = "payLocation"
        
    }
    let payList : [PayLocationListData]
    
}

struct PayLocationListData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "Code"
        case name = "Name"
        case address = "Address"
        case country = "Country"
        case city = "City"
        case state = "State"
        case pin = "Pin"
        case contactPerson = "ContactPerson"
        case mobileNo = "MobileNo"
        case telephone = "Telephone"
        case esiApplicaple = "EsiApplicable"
        case pfApplicable = "PfApplicable"
        case active = "Active"
        
        
    }
    
    let code : String?
    let name : String?
    let address : String?
    let country: String?
    let city : String?
    let state : String?
    let pin : String?
    let contactPerson : String?
    let mobileNo : String?
    let telephone : String?
    let esiApplicaple : String?
    let pfApplicable : String?
    let active : String?
    
}

//MARK: - Loan Type Struct
/***************************************************************/

struct LoanTypeRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case loanType = "loanType"
        
    }
    let loanType : [LoanTypeData]
    
}

struct LoanTypeData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "Code"
        case name = "Name"
        case fullName = "FullName"
    }
    
    let code : String?
    let name : String?
    let fullName : String?
   
}

//MARK: - Loan Type Struct
/***************************************************************/

struct LoanStatusRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case loanStat = "loanData"
        
    }
    let loanStat : [LoanStatusData]
    
}

struct LoanStatusData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empCode = "EmployeeCode"
        case amount = "Amount"
        case noOfInstallment = "NoOfInstallment"
        case installmentAmnt = "InstallmentAmount"
        case applyAmnt = "ApplyAmount"
        case applyNoOfInstallment = "ApplyNoOfInstallment"
        case applyInstallmentAmount = "ApplyInstallmentAmount"
        case mgrAmnt = "MgrAmount"
        case mgrNoOfInstallment = "MgrNoOfInstallment"
        case mgrInstallmentAmount = "MgrInstallmentAmount"
        case intrestRate = "InterestRate"
        case startDeduction = "StartDeduction"
        case lType = "Ltyp"
        case dType = "Dtyp"
        case loanType = "LoanType"
        case remark = "Remark"
        case seqNo = "SeqNo"
        case transactionDate = "TransactionDate"
        case applyTransactionDate = "ApplyTransactionDate"
        case mgrTransactionDate = "MgrTransactionDate"
        case installmentFirst = "InstallmentFirst"
        case installmentLast = "InstallmentLast"
        case compoundAt = "CompoundAt"
        case mgrStatus = "MgrStatus"
        case mgrRemark = "MgrRemark"
        case rowSeq = "RowSeq"
    }
    
    let empCode : String?
    let amount : Double?
    let noOfInstallment : Double?
    let installmentAmnt : Double?
    let applyAmnt : Double?
    let applyNoOfInstallment : Double?
    let applyInstallmentAmount : Double?
    let mgrAmnt: Double?
    let mgrNoOfInstallment : Double?
    let mgrInstallmentAmount : Double?
    let intrestRate : Double?
    let startDeduction : String?
    let lType : String?
    let dType : String?
    let loanType : String?
    let remark : String?
    let seqNo : String?
    let transactionDate : String?
    let applyTransactionDate : String?
    let mgrTransactionDate : String?
    let installmentFirst : Double?
    let installmentLast : Double?
    let compoundAt : String?
    let mgrStatus : String?
    let mgrRemark : String?
    let rowSeq : String?
    
}


//MARK: - Loan Apply Struct
/***************************************************************/

struct LoanApplyRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case loanApply = "loanData"
        
    }
    let loanApply : [LoanApplyData]
    
}

struct LoanApplyData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empName = "EmployeeName"
        case empCode = "EmployeeCode"
        case amount = "Amount"
        case noOfInstallment = "NoOfInstallment"
        case installmentAmnt = "InstallmentAmount"
        case applyAmnt = "ApplyAmount"
        case applyNoOfInstallment = "ApplyNoOfInstallment"
        case applyInstallmentAmount = "ApplyInstallmentAmount"
        case mgrAmnt = "MgrAmount"
        case mgrNoOfInstallment = "MgrNoOfInstallment"
        case mgrInstallmentAmount = "MgrInstallmentAmount"
        case intrestRate = "InterestRate"
        case startDeduction = "StartDeduction"
        case lType = "Ltyp"
        case dType = "Dtyp"
        case loanType = "LoanType"
        case remark = "Remark"
        case seqNo = "SeqNo"
        case transactionDate = "TransactionDate"
        case applyTransactionDate = "ApplyTransactionDate"
        case mgrTransactionDate = "MgrTransactionDate"
        case installmentFirst = "InstallmentFirst"
        case installmentLast = "InstallmentLast"
        case compoundAt = "CompoundAt"
        case mgrStatus = "MgrStatus"
        case mgrRemark = "MgrRemark"
        case rowSeq = "RowSeq"
    }
    let empName : String?
    let empCode : String?
    let amount : Double?
    let noOfInstallment : Double?
    let installmentAmnt : Double?
    let applyAmnt : Double?
    let applyNoOfInstallment : Double?
    let applyInstallmentAmount : Double?
    let mgrAmnt: Double?
    let mgrNoOfInstallment : Double?
    let mgrInstallmentAmount : Double?
    let intrestRate : Double?
    let startDeduction : String?
    let lType : String?
    let dType : String?
    let loanType : String?
    let remark : String?
    let seqNo : String?
    let transactionDate : String?
    let applyTransactionDate : String?
    let mgrTransactionDate : String?
    let installmentFirst : Double?
    let installmentLast : Double?
    let compoundAt : String?
    let mgrStatus : String?
    let mgrRemark : String?
    let rowSeq : String?
    
}


//MARK: - Asset Type Struct
/***************************************************************/

struct AssetsTypeRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case asset = "assetsType"
        
    }
    let asset : [AssetsTypeeData]
    
}

struct AssetsTypeeData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "ItemCode"
        case name = "ItemName"
        case alt = "Alt"
    }
    
    let code : String?
    let name : String?
    let alt : String?
    
}


//MARK: - Asset Data Struct
/***************************************************************/

struct AssetsDataRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case asset = "assetsData"
        
    }
    let asset : [AssetsDataData]
    
}

struct AssetsDataData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empCode = "EmployeeCode"
        case empName = "EmployeeName"
        case quantity = "Quantity"
        case applyQuantity = "ApplyQuantity"
        case mgrQuantity = "MgrQuantity"
        case product = "Product"
        case applyProduct = "ApplyProduct"
        case mrgProduct = "MgrProduct"
        case productName = "ProductName"
        case remark = "Remark"
        case transactionDate = "TransDate"
        case applyTransactionDate = "ApplyTransDate"
        case mgrTransactionDate = "MgrTransDate"
        case applyDate = "ApplyDate"
        case mgrStatus = "MgrStatus"
        case mgrRemarks = "MgrRemark"
        case paidStatus = "PaidStatus"
        case paidRemarks = "PaidRemark"
        case assetsNo = "AssetsNo"
    }
    
    let empCode : String?
    let empName : String?
    let quantity : Int?
    let applyQuantity : Int?
    let mgrQuantity : Int?
    let product : String?
    let applyProduct : String?
    let mrgProduct : String?
    let productName : String?
    let remark : String?
    let transactionDate : String?
    let applyTransactionDate : String?
    let mgrTransactionDate : String?
    let applyDate : String?
    let mgrStatus : String?
    let mgrRemarks : String?
    let paidStatus: String?
    let paidRemarks : String?
    let assetsNo : String?
    
}


//MARK: - Asset Approval / Issue Struct
/***************************************************************/

struct AssetsApprovalRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case asset = "assetsData"
        
    }
    let asset : [AssetsApprovalData]
    
}

struct AssetsApprovalData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case empCode = "EmployeeCode"
        case empName = "EmployeeName"
        case quantity = "Quantity"
        case applyQuantity = "ApplyQuantity"
        case mgrQuantity = "MgrQuantity"
        case product = "Product"
        case applyProduct = "ApplyProduct"
        case mrgProduct = "MgrProduct"
        case productName = "ProductName"
        case remark = "Remark"
        case transactionDate = "TransDate"
        case applyTransactionDate = "ApplyTransDate"
        case mgrTransactionDate = "MgrTransDate"
        case mgrDate = "MgrDate"
        case mgrStatus = "MgrStatus"
        case mgrRemarks = "MgrRemark"
        case paidStatus = "PaidStatus"
        case paidRemarks = "PaidRemark"
        case assetsNo = "AssetsNo"
        case rowSeq = "RowSeq"
    }
    
    let empCode : String?
    let empName : String?
    let quantity : Int?
    let applyQuantity : Int?
    let mgrQuantity : Int?
    let product : String?
    let applyProduct : String?
    let mrgProduct : String?
    let productName : String?
    let remark : String?
    let transactionDate : String?
    let applyTransactionDate : String?
    let mgrTransactionDate : String?
    let mgrDate : String?
    let mgrStatus : String?
    let mgrRemarks : String?
    let paidStatus: String?
    let paidRemarks : String?
    let assetsNo : String?
    let rowSeq : String?
}


//MARK: - Letter Type Struct
/***************************************************************/

struct LetterTypeRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case letter = "letterTypes"
        
    }
    let letter : [LetterTypeData]
    
}

struct LetterTypeData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case id = "LetterID"
        case category = "MainCategory"
        case name = "LetterMainName"
        
        case subtype = "letterSubTypes"
    }
    
    let id : String?
    let category : String?
    let name : String?
    
    let subtype : [LetterSubTypeData]
}

struct LetterSubTypeData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case subCategory = "SubCategory"
        case subName = "LetterSubName"
        case subLink = "LetterLink"
        case subRemark = "LetterRemark"
    }
    
    let subCategory : String?
    let subName : String?
    let subLink : String?
    let subRemark : String?
}


//MARK: - Attendace In Out Struct
/***************************************************************/

struct AttendanceInOutRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case inTime = "InTime"
        case outTime = "OutTime"
        case atnDate = "AtnDate"
    }
    let inTime : String?
    let outTime : String?
    let atnDate : String?
}


//MARK: - Letter Type Struct
/***************************************************************/

struct LetterStatusRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case letter = "letterGeneration"
        
    }
    let letter : [LetterStatusData]
    
}

struct LetterStatusData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case id = "LetterID"
        case code = "EmployeeCode"
        case name = "EmployeeName"
        case mainCategory = "LetterMainCategory"
        case mainName = "LetterMainName"
        case subCategory = "LetterSubCategory"
        case subName = "LetterSubName"
        case format = "LetterFormat"
        case generateType = "LetterGenerateType"
        case remark = "Remark"
        case mgrStatus = "MgrStatus"
        case mgrRemark = "MgrRemark"
        case trDate = "TrDate"
        case applyDate = "ApplyDate"
        case attachment = "Attachment"
        case rowseq = "RowSeq"
    }
    
    let id : String?
    let code : String?
    let name : String?
    let mainCategory : String?
    let mainName : String?
    let subCategory : String?
    let subName : String?
    let format : String?
    let generateType : String?
    let remark : String?
    let mgrStatus : String?
    let mgrRemark : String?
    let trDate : String?
    let applyDate : String?
    let attachment : String?
    let rowseq : String?
}


//MARK: - Dynamic Dashboard Struct
/***************************************************************/

struct DynamicDashboardRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case dashboard = "dynamicDashboard"
        
    }
    let dashboard : [DynamicDashboardData]
    
}

struct DynamicDashboardData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "Code"
        case menuName = "MenuName"
        case menuID = "MenuID"
        case type = "Type"
        
    }
    
    let code : String?
    let menuName : String?
    let menuID : String?
    let type : String?
}

//MARK: - Profile Directory Struct
/***************************************************************/

struct ProfileDirectoryRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case directory = "profileDirectory"
        
    }
    let directory : [ProfileDirectoryData]
    
}

struct ProfileDirectoryData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "Code"
        case name = "Name"
        case manager = "Manager"
        case managerName = "ManagerName"
        
        case mobile = "Mobile"
        case designation = "Designation"
        case department = "Department"
        case img = "Image"
        
        case location = "Location"
        case address = "Address"
        case emailID = "EmailID"
        case facebookID = "FacebookID"
        
        case instagramID = "InstagramID"
        case linkedinID = "LinkedinID"
        case skypeID = "SkypeID"
        case twitterID = "TwitterID"
        
    }
    
    let code : String?
    let name : String?
    let manager : String?
    let managerName : String?
    
    let mobile : String?
    let designation : String?
    let department : String?
    let img : String?
    
    let location : String?
    let address : String?
    let emailID : String?
    let facebookID : String?
    
    let instagramID : String?
    let linkedinID : String?
    let skypeID : String?
    let twitterID : String?
}


//MARK: - Profile Directory Struct
/***************************************************************/

struct NewsFeedRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
    }
    let status : String?
    let totalResults : Int?
    let articles : [NewsArticlesData]
    
}

struct NewsArticlesData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
//        case source = "source"
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
    
//    let source : [NewsSourceData]
    let author : String?
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String?
    let content : String?
    
}

struct NewsSourceData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    let id : String?
    let name : String?
    
}


//MARK: - Empolyee Feedback Struct
/***************************************************************/

struct EmployeeFeedbackRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case empFeedback = "empFeedback"
    }
    let empFeedback : [EmployeeFeedbackData]
    
}

struct EmployeeFeedbackData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case code = "Code"
        case name = "Name"
        case image = "Image"
        case remarkDate = "RemarkDate"
        case remarkBy = "RemarkBy"
        case remarkByName = "RemarkByName"
        case remarks = "Remarks"
        case feedbackId = "FeedbackId"
        case status = "Status"
        case likes = "Likes"
        case comments = "Comments"
        case rowseq = "Rowseq"
        
    }
    
    let code : String?
    let name : String?
    let image : String?
    let remarkDate : String?
    let remarkBy : String?
    let remarkByName : String?
    let remarks : String?
    let feedbackId : String?
    let status : String?
    let likes : String?
    let comments : String?
    let rowseq : String?
    
    
}



//MARK: - Manage Profile Struct
/***************************************************************/

struct ManageProfileRoot : Decodable {
    private enum CodingKeys : String, CodingKey {
        case profile = "employee"
    }
    let profile : [ManageProfileData]
    
}

struct ManageProfileData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case education = "education"
        case experience = "experience"
        case certificate = "certificate"
        case managerHead = "ManagerHead"
        case aboutMe = "AboutMe"
        case address = "Address"
        case department = "Department"
        case hobbies = "Hobbies"
        case skill = "Skill"
        
        
    }
    
    let education : [ManageProfileEducationData]
    let experience : [ManageProfileExperienceData]
    let certificate : [ManageProfileCertificateData]
    let managerHead : String?
    let aboutMe : String?
    let address : String?
    let department : String?
    let hobbies : String?
    let skill : String?
    
    
}


struct ManageProfileExperienceData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        
        case companyName = "companyName"
        case designation = "designation"
        case fromDate = "fromDate"
        case toDate = "uptoDate"
        
    }
    
    
    let companyName : String?
    let designation : String?
    let fromDate : String?
    let toDate : String?
    
}

struct ManageProfileCertificateData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        
        case authority = "Authority"
        case licenseNo = "LicenseNo"
        case fromDate = "FromDate"
        case toDate = "ToDate"
        case name = "Name"
    }
    
    
    let authority : String?
    let licenseNo : String?
    let fromDate : String?
    let toDate : String?
    let name : String?
}


struct ManageProfileEducationData : Decodable {
    
    private enum CodingKeys : String, CodingKey {
        
        case degree = "Degree"
        case university = "universityName"
        case year = "year"
        
    }
    
    
    let degree : String?
    let university : String?
    let year : String?
    
}
