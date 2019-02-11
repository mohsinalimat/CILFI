//
//  FamilyDetailsTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 07/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import DropDown

class FamilyDetailCell : UITableViewCell{
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
}

class FamilyDetailsTableViewController: UITableViewController {

    var memberName = [String]()
    
    var profileTitle = [String]()
    var profileValues = [String]()
    
    @IBOutlet weak var membersNameBtn: UIButton!
    
    @IBAction func membersNameBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.dataSource = memberName
        dropDown.anchorView = membersNameBtn
        
        
        dropDown.show()
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.membersNameBtn.setTitle(item, for: .normal)
            self.getDetails(index: index)
          
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memberName = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/FamilyDetails", method: .get, headers : headers).responseJSON{
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
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/FamilyDetails", method: .get, headers : headers).responseJSON{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "fdCell", for: indexPath) as! FamilyDetailCell
        
        cell.typeLbl.text = profileTitle[indexPath.row]
        cell.valueLbl.text = profileValues[indexPath.row]
        
        return cell
    }
}
