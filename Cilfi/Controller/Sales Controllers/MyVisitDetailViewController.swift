//
//  MyVisitDetailViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 28/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit

class MyVisitDetailViewController: UIViewController {

    var executiveName = ""
    var executiveCode = ""
    var designation = ""
    var visitDate = ""
    var reportDate = ""
    var reportLocation = ""
    var customerName = ""
    var customerAccount = ""
    var visitPurpose = ""
    var visitTask = ""
    var visitAchieve = ""
    var targetDate = ""
    var nextDate = ""
    
    @IBOutlet weak var eCodeLbl: UILabel!
    @IBOutlet weak var eNameLbl: UILabel!
    @IBOutlet weak var vDateLbl: UILabel!
    @IBOutlet weak var rDateLbl: UILabel!
    @IBOutlet weak var rLocLbl: UILabel!
    @IBOutlet weak var cCodeLbl: UILabel!
    @IBOutlet weak var cNameLbl: UILabel!
    @IBOutlet weak var vPurposeLbl: UILabel!
    @IBOutlet weak var vTaskLbl: UILabel!
    @IBOutlet weak var vAccompLbl: UILabel!
    @IBOutlet weak var tDateLbl: UILabel!
    @IBOutlet weak var nfuDateLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        eCodeLbl.text = executiveCode
        eNameLbl.text = executiveName
        vDateLbl.text = visitDate
        rDateLbl.text = reportDate
        rLocLbl.text = reportLocation
        cCodeLbl.text = customerAccount
        cCodeLbl.textColor = UIColor.flatPlum
        cNameLbl.text = customerName
        vPurposeLbl.text = visitPurpose
        vTaskLbl.text = visitTask
        vAccompLbl.text = visitAchieve
        tDateLbl.text = targetDate
        nfuDateLbl.text = nextDate
        
       
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        executiveName = ""
        executiveCode = ""
        designation = ""
        visitDate = ""
        reportDate = ""
        reportLocation = ""
        customerName = ""
        customerAccount = ""
        visitPurpose = ""
        visitTask = ""
        visitAchieve = ""
        targetDate = ""
        nextDate = ""
    }

}
