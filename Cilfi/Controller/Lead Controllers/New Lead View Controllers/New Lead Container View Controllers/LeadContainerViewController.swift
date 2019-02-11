//
//  LeadContainerViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 02/07/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Eureka
import GooglePlaces
class LeadContainerViewController: FormViewController, GMSAutocompleteViewControllerDelegate  {
    
    var visitDate = Date()
    
    let placePickerController = GMSAutocompleteViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addForm()
        
        
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        updateCells(places: place)
        
        
        
        //        print("Place name: \(place.name)")
        //        print("Place address: \(place.formattedAddress)")
        //        print("Place lat: \(place.coordinate.latitude)")
        //        print("Place lng: \(place.coordinate.longitude)")
        //        print("Place phone: \(place.phoneNumber)")
        //        print("Place lng: \(place.website)")
        
    
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
    func updateCells(places : GMSPlace){
        let name : TextRow? = self.form.rowBy(tag: "name")
        let address : LabelRow?  = self.form.rowBy(tag: "address")
        let phone : LabelRow? = self.form.rowBy(tag: "phone")
        let website : LabelRow? = self.form.rowBy(tag: "website")
        let city : LabelRow? = self.form.rowBy(tag: "city")
        let state : LabelRow? = self.form.rowBy(tag: "state")
        let country : LabelRow? = self.form.rowBy(tag: "country")
        let pincode : TextRow? = self.form.rowBy(tag: "pin")
        
        name?.value = places.name
        Lead.lat = String(places.coordinate.latitude)
        Lead.lng = String(places.coordinate.longitude)
        
        if let gAdd = places.formattedAddress {
            address?.value = gAdd
        }
        
        if let gAdd = places.formattedAddress {
            address?.value = gAdd
        }
        
        if let gPhone = places.phoneNumber {
            phone?.value = gPhone
        }
        
        for components in places.addressComponents!{
            if components.type == "administrative_area_level_1"  {
                state?.value = components.name
            }
            
            if components.type == "locality"  {
                city?.value = components.name
            }
            
            if components.type == "country"  {
                country?.value = components.name
            }
            
            if components.type == "postal_code"  {
                pincode?.value = components.name
            }
        }
        
        if let web = places.website?.absoluteString{
            website?.value = web
        }
        
        form.rowBy(tag: "name")?.updateCell()
        form.rowBy(tag: "phone")?.updateCell()
        form.rowBy(tag: "address")?.updateCell()
        form.rowBy(tag: "website")?.updateCell()
        form.rowBy(tag: "city")?.updateCell()
        form.rowBy(tag: "state")?.updateCell()
        form.rowBy(tag: "country")?.updateCell()
        form.rowBy(tag: "pin")?.updateCell()
    }
    
    
}




extension LeadContainerViewController{
    
    
    
    
    func addForm(){
        
       
        
        form    +++ Section("Employee Info"){
            $0.header?.height = {40}
            $0.footer?.height = {0}
            }
            <<< LabelRow(){row in
                row.title = "Created By Code"
                row.value = defaults.string(forKey: "employeeCode")!
                row.onChange({ (code) in
                    Lead.createByCode = code.value!
                })
                
            }
            <<< LabelRow(){row in
                row.title = "Created By Name"
                row.value = defaults.string(forKey: "name")!
                row.onChange({ (name) in
                    Lead.createdByName = name.value!
                })
            }
            <<< LabelRow(){row in
                row.title = "Salesman Code"
                row.value = defaults.string(forKey: "employeeCode")!
                row.onChange({ (code) in
                    Lead.salesmanCode = code.value!
                })
            }
            
            <<< PickerInlineRow<String>() {
                $0.title = "Lead Type"
                $0.options = ["Primary","Secondary"]
                $0.value = "----- Select -----"    // initially selected
                $0.tag  = "leadType"
                $0.onChange({ (status) in
                    if let stat = status.value{
                        if stat == "Primary"{
                            Lead.leadStatus = "P"
                        }else if stat == "Secondary"{
                            Lead.leadStatus = "S"
                        }
                        
                    }
                })
            }
            
            <<< PickerInlineRow<String>() {
                $0.title = "Lead Status"
                $0.options = ["New","Follow Up","Converted","Lost"]
                $0.value = "----- Select -----"    // initially selected
                $0.tag  = "leadStatus"
                $0.onChange({ (status) in
                    if let stat = status.value{
                        if stat == "New"{
                            Lead.leadStatus = "N"
                        }else if stat == "Follow Up"{
                            Lead.leadStatus = "N"
                        }else if stat == "Converted"{
                            Lead.leadStatus = "C"
                        }else if stat == "Lost"{
                            Lead.leadStatus = "L"
                        }
                        
                    }
                })
            }
            
            <<< DateInlineRow(){row in
                row.minimumDate = Date()
                row.title = "Visit Date"
                row.dateFormatter?.dateFormat = "dd/MM/yyyy"
                row.value = Date()
                row.onChange({ (visitDate) in
                    row.dateFormatter?.dateFormat = "dd/MM/yyyy"
                    Lead.visitDate = row.dateFormatter!.string(from: visitDate.value!)
                    self.visitDate = visitDate.value!
                        print(self.visitDate)
                    if let row = self.form.rowBy(tag: "nextFollowupDate") as? DateRow {
                        row.value = visitDate.value!
                        row.minimumDate = visitDate.value!
                        row.updateCell()
                        row.reload()
                    }
                   
                })
            }
            
            <<< LabelRow(){row in
                row.title = "Executive Name"
                row.value = defaults.string(forKey: "name")!
                row.onChange({ (name) in
                    
                    Lead.executiveName = name.value!
                })
            }
            
            
            <<< PickerInlineRow<String>() {
                $0.title = "Source/Ref. Information"
                $0.options = ["Director","Colleague","Customer Referance","Print Media", "Others"]
                $0.value = "----- Select -----"     // initially selected
                $0.onChange({ (srInfo) in
                    Lead.srInfo = srInfo.value!
                })
            }
            
            <<< TextRow(){ row in
                row.title = "Source/Ref. Name"
                row.placeholder = "if any"
                row.onChange({ (srName) in
                    if let name = srName.value{
                        if name.count > 1{
                            Lead.srName = name
                        }else{
                            Lead.srName = ""
                        }
                        
                    }
                    
                })
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textField.textColor = UIColor.flatRed
                        cell.textLabel?.textColor = UIColor.flatRed
                        Lead.srName = ""
                    }else if row.isValid{
                        cell.textField.textColor = .black
                        cell.textLabel?.textColor = .black
                        if let value = row.value{
                            Lead.srName = value
                        }
                    }
                })
            
            
            
            +++ Section("Address Info"){
                $0.header?.height = {30}
                $0.footer?.height = {0}
                
                
            }
            
            <<< ButtonRow() {
                $0.title = "Search for Dealer's Address"
                
                }
                .onCellSelection {  cell, row in  //do whatever you want  }
                    self.present(self.placePickerController, animated: true, completion: nil)
                    self.placePickerController.delegate = self
                    
            }
            
            +++ Section("Dealer/Distributor Info"){
                $0.header?.height = {30}
                $0.footer?.height = {0}
                
            }
            
            <<< TextRow(){row in
                row.title = "Dealer/Distributor Firm"
                row.placeholder = "enter name"
                row.add(rule: RuleRequired())
                row.tag = "name"
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textField.textColor = UIColor.flatRed
                        cell.textLabel?.textColor = UIColor.flatRed
                        Lead.ddFirm = ""
                    }else if row.isValid{
                        cell.textField.textColor = .black
                        cell.textLabel?.textColor = .black
                        if let value = row.value{
                            Lead.ddFirm = value
                        }
                    }
                })
            
            
            
            <<< LabelRow(){row in
                row.title = "Address"
                row.tag = "address"
                row.onChange({ (value) in
                    
                    Lead.address = value.value!
                })
            }
            
            
            <<< LabelRow(){row in
                row.title = "City"
                row.tag = "city"
                row.onChange({ (value) in
                    
                    Lead.city = value.value!
                })
            }
            
            <<< LabelRow(){row in
                row.title = "State"
                row.tag = "state"
                row.onChange({ (value) in
                    
                    Lead.state = value.value!
                })
            }
            
            <<< LabelRow(){row in
                row.title = "Country"
                row.tag = "country"
                row.onChange({ (value) in
                    
                    Lead.country = value.value!
                })
            }
            
            <<< PhoneRow(){row in
                row.title = "Pincode"
                row.tag = "pin"
                row.add(rule: RuleRequired())
                row.add(rule: RuleExactLength(exactLength: 6))
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textField.textColor = UIColor.flatRed
                        cell.textLabel?.textColor = UIColor.flatRed
                        Lead.pincode = ""
                        
                        
                        
                    }else if row.isValid{
                        cell.textField.textColor = .black
                        cell.textLabel?.textColor = .black
                        if let value = row.value{
                            Lead.pincode = value
                            
                        }
                    }
                })
            
            <<< LabelRow(){row in
                row.title = "Phone"
                row.tag = "phone"
                
            }
            
            <<< LabelRow(){row in
                row.title = "Website"
                row.tag = "website"
                row.onChange({ (web) in
                    Lead.website = web.value!
                })
            } 
            
            +++ Section(){
                $0.header?.height = {30}
                $0.footer?.height = {0}
            }
            <<< TextRow(){row in
                row.title = "Contact Person Name"
                row.placeholder = "name"
                row.add(rule: RuleRequired())
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textField.textColor = UIColor.flatRed
                        cell.textLabel?.textColor = UIColor.flatRed
                        Lead.contactPersonName = ""
                    }else if row.isValid{
                        cell.textField.textColor = .black
                        cell.textLabel?.textColor = .black
                        if let value = row.value{
                            Lead.contactPersonName = value
                        }
                    }
                })
            
            <<< TextRow(){row in
                row.title = "Designation"
                row.placeholder = "designation"
                row.add(rule: RuleRequired())
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textField.textColor = UIColor.flatRed
                        cell.textLabel?.textColor = UIColor.flatRed
                        Lead.designation = ""
                    }else if row.isValid{
                        cell.textField.textColor = .black
                        cell.textLabel?.textColor = .black
                        if let value = row.value{
                            Lead.designation = value
                        }
                    }
                })
            
            
            <<< PhoneRow(){row in
                row.title = "Mobile Number"
                row.placeholder = "XXXXX"
                row.add(rule: RuleExactLength(exactLength: 10))
                row.add(rule: RuleRequired())
                
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textField.textColor = UIColor.flatRed
                        cell.textLabel?.textColor = UIColor.flatRed
                        Lead.mobileNo = ""
                        
                        
                        
                    }else if row.isValid{
                        cell.textField.textColor = .black
                        cell.textLabel?.textColor = .black
                        if let value = row.value{
                            Lead.mobileNo = value
                            
                        }
                    }
                })
            
            
            <<< EmailRow().cellSetup{cell, row in
                row.title = "Email ID"
                row.placeholder = "xyz@abc.com"
                row.add(rule: RuleRequired())
                row.add(rule: RuleEmail())
                
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textField.textColor = UIColor.flatRed
                        cell.textLabel?.textColor = UIColor.flatRed
                        Lead.contactPersonEmailID = ""
                       
                        
                        
                    }else if row.isValid{
                        cell.textField.textColor = .black
                        cell.textLabel?.textColor = .black
                        if let value = row.value{
                            Lead.contactPersonEmailID = value
                           
                        }
                    }
                })
            
            
            
            <<< DateInlineRow(){ row in
                row.minimumDate = visitDate
                row.title = "Next Follow-up Date"
                row.tag = "nextFollowupDate"
                row.dateFormatter?.dateFormat = "dd/MM/yyyy"
                row.value = visitDate
                row.onChange({ (visitDate) in
                    
                    visitDate.dateFormatter?.dateFormat = "dd/MM/yyyy"
                    Lead.nextFollowUpDate = visitDate.dateFormatter!.string(from: visitDate.value!)
                })
            }
            
            <<< TimeInlineRow(){ row in
                row.title = "Next Follow-up Time"
                row.value = Date()
                row.onChange({ (visitTime) in
                    Lead.nextFollowUpTime = visitTime.dateFormatter!.string(from: visitTime.value!)
                })
                
        }
    }
    
    
    
}
