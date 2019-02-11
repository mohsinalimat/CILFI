//
//  ReportingModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on 06/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import Foundation


class ReportingModel{
    
    var executiveName = defaults.string(forKey: "name")!
    var executiveCode = defaults.string(forKey: "employeeCode")!
    var desig = defaults.string(forKey: "designation")!
    var visitDate = ""
    var reportDate = ""
    var reportLocation = ""
    var customerName = ""
    var visitPurpose = ""
    var visitTask = ""
    var visitAccomplished = ""
    var targetDate = ""
    var nextFollowupDate = ""

}
