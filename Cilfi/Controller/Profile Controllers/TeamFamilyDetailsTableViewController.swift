//
//  TeamFamilyDetailsTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 21/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
import Alamofire

class TeamFamilyDetailsCell : UITableViewCell{
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
}

class TeamFamilyDetailsTableViewController: UITableViewController {
    
    let team = TeamDetailModel()
    
    var memberName = [String]()
    var profileTitle = [String]()
    var profileValues = [String]()
    
    var employee = ""
    
    @IBOutlet weak var familyBtn: UIButton!
    @IBOutlet weak var userBtn: UIButton!
    @IBAction func userBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = team.employeeName
        dropDown.anchorView = userBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.userBtn.setTitle(item, for: .normal)
            self.familyBtn.setTitle("--- Select Family Member ---", for: .normal)
            self.employee = self.team.employeeCode[index]
            self.getFamilyData()
            self.profileTitle = [String]()
            self.profileValues = [String]()
            self.tableView.reloadData()
            SVProgressHUD.show()
        }
        
    }
    
    @IBAction func familyBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = memberName
        dropDown.anchorView = familyBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.familyBtn.setTitle(item, for: .normal)
            self.getDetails(index: index)
            SVProgressHUD.show()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        team.getTeamData()
    }
    
    
    func getFamilyData(){
        
        memberName = [String]()
        
        let header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : employee]
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/FamilyDetails", method: .get, headers : header).responseJSON{
            response in
            
            //            print(header)
            
            let fpData = response.data!
            let fpJSON = response.result.value
            
            if response.result.isSuccess{
                //                print("UserJSON: \(custJSON)")
                do{
                    let fp = try JSONDecoder().decode(FamilyProfileRoot.self, from: fpData)
                    
                    for x in fp.famData{
                        for y in x.famDetail{
                            if y.title == "Member Name"{
                                self.memberName.append(y.value!)
                            }
                        }
                    }
                    
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
    
    func getDetails(index: Int){
        
        profileTitle = [String]()
        profileValues = [String]()
        
        
        let header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : employee]
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/FamilyDetails", method: .get, headers : header).responseJSON{
            response in
            
            //            print(header)
            
            let fpData = response.data!
            let fpJSON = response.result.value
            
            if response.result.isSuccess{
                //                print("UserJSON: \(custJSON)")
                do{
                    let fp = try JSONDecoder().decode(FamilyProfileRoot.self, from: fpData)
                    
                    for x in fp.famData[index].famDetail{
                        
                        if let title = x.title{
                            self.profileTitle.append(title)
                        }
                        if let value = x.value{
                            self.profileValues.append(value)
                        }
                    }
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
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
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return profileTitle.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tfdCell", for: indexPath) as! TeamFamilyDetailsCell
        
        cell.typeLbl.text = profileTitle[indexPath.row]
        cell.valueLbl.text = profileValues[indexPath.row]
        
        return cell
    }

    
}

