//
//  EmployeeProfileTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 07/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class EmployeeProfileCell:UITableViewCell{
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
}


class EmployeeProfileTableViewController: UITableViewController {

    var profileTitle = [String]()
    var profileValues = [String]()
    
    @IBOutlet weak var profileImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.layer.borderWidth = 2.0
//        profileImg.layer.masksToBounds = true
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        
        profileImg.clipsToBounds = true
        
        
        SVProgressHUD.show()
      
                if let imgurl = defaults.string(forKey: "imgURL"){
                    if imgurl != ""{
                        profileImg.sd_setImage(with: URL(string: "\(LoginDetails.hostedIP)\(imgurl)"))
                    }
                }
        
    }
        
    
    override func viewDidAppear(_ animated: Bool) {
        
        getPersonalProfileData()
    }
    
    
    func getPersonalProfileData(){
        profileTitle = [String]()
        profileValues = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/EmployeeProfile", method: .get, headers : headers).responseJSON{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "epCell", for: indexPath) as! EmployeeProfileCell
        
        cell.titleLbl.text = profileTitle[indexPath.row]
        cell.valueLbl.text = profileValues[indexPath.row]
        
        return cell
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let y = 250 - (scrollView.contentOffset.y + 250)
//        let h = max(250, y)
//        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: h)
//        profileImg.frame = rect
//
//    }
//    
}
