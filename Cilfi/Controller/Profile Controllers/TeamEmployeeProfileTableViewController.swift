//
//  TeamEmployeeProfileTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 21/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import SDWebImage
import DropDown
import SVProgressHUD
import Alamofire

class TeamEmployeeProfileCell : UITableViewCell{
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var valueLbl: UILabel!
}

class TeamEmployeeProfileTableViewController: UITableViewController {

    let team = TeamDetailModel()
    
    var profileTitle = [String]()
    var profileValues = [String]()
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userBtn: UIButton!
    
    @IBAction func userBtn(_ sender: UIButton) {
        
        let dropDown = DropDown()
        dropDown.dataSource = team.employeeName
        dropDown.anchorView = userBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.userBtn.setTitle(item, for: .normal)
            
            self.getPersonalProfileData(emp: self.team.employeeCode[index])
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImg.layer.borderWidth = 1.0
        userImg.layer.masksToBounds = true
        userImg.layer.borderColor = UIColor.white.cgColor
        userImg.layer.cornerRadius = userImg.frame.size.width / 2
        userImg.clipsToBounds = true
        
        team.getTeamData()
    }


    func getPersonalProfileData(emp : String){
        
        let header : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : emp]
        
        SVProgressHUD.show()
        
        profileTitle = [String]()
        profileValues = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/EmployeeProfile", method: .get, headers : header).responseJSON{
            response in
            
            //            print(header)
            
            let epData = response.data!
            let epJSON = response.result.value
            
            if response.result.isSuccess{
                //                print("UserJSON: \(custJSON)")
                do{
                    let ep = try JSONDecoder().decode(EmployeeProfileRoot.self, from: epData)
                    
                    for x in ep.empProfile{
                        
                        if x.title != "Photo Url"{
                            if let title = x.title{
                                self.profileTitle.append(title)
                            }
                            if let value = x.value{
                                self.profileValues.append(value)
                            }
                        }else{
                            if let img = x.value{
                                self.userImg.sd_setImage(with: URL(string: "\(LoginDetails.hostedIP)\(img)"))
                            }
                            
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
        // #warning Incomplete implementation, return the number of rows
        return profileTitle.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tppCell", for: indexPath) as! TeamEmployeeProfileCell
        
        cell.titleLbl.text = profileTitle[indexPath.row]
        cell.valueLbl.text = profileValues[indexPath.row]
        
        return cell
    }
    
}
