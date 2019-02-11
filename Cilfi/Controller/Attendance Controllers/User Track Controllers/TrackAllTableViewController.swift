//
//  TrackAllTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 06/08/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class TrackAllCell : UITableViewCell{
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var datebatteryLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var statusImg: UIImageView!
    
}


class TrackAllTableViewController: UITableViewController {

    var empName  = [String]()
    var checkDate  = [String]()
    var latitude  = [String]()
    var longitude  = [String]()
    var address  = [String]()
    var batterySatus  = [Int]()
    var profilePic = [URL]()
    var onlineoffline = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        getTrackAllData()
        SVProgressHUD.show()
    }

   
    func getTrackAllData(){
        
        empName  = [String]()
        checkDate  = [String]()
        latitude  = [String]()
        longitude  = [String]()
        address  = [String]()
        batterySatus  = [Int]()
        profilePic = [URL]()
        onlineoffline = [String]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/trackall", method: .get, headers : headers).responseJSON{
            response in
            
            //            print(header)
            
            let trackAllData = response.data!
            let trackAllJSON = response.result.value
            
            if response.result.isSuccess{
//                print("UserJSON: \(trackAllJSON)")
                do{
                    let trackAll = try JSONDecoder().decode(TrackAllRoot.self, from: trackAllData)
                    let dateFormatter = DateFormatter()
                    
                    for x in trackAll.taData{
                        
                        if let name = x.empName{
                            self.empName.append(name)
                        }
                        
                        if let date = x.checkDate{
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                            guard let fulldate = dateFormatter.date(from: date) else{return}
                            dateFormatter.dateFormat = "dd-MMMM-yyyy HH:mm:ss"
        
                            if abs(fulldate.timeIntervalSinceNow) < 86400 {
                                if abs(fulldate.timeIntervalSinceNow) <= 1800{
                                    self.onlineoffline.append("Online")
                                }else{
                                    self.onlineoffline.append("Offline")
                                }
                            }else{
                                self.onlineoffline.append("Inactive")
                            }
                            
                            self.checkDate.append(dateFormatter.string(from: fulldate))
                        }
                        if let lat = x.latitude{
                            self.latitude.append(lat)
                        }
                        if let lng = x.longitude{
                            self.longitude.append(lng)
                        }
                        
                        if let address = x.address{
                            self.address.append(address)
                        }
                        
                        if let battery = x.batterySatus{
                            self.batterySatus.append(battery)
                        }
                        
                        if let img = x.imgUrl{
                           
                                
                                if let url = URL(string: "\(LoginDetails.hostedIP)\(img)"){
                                    self.profilePic.append(url)
                                
                                
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
       
        return empName.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taCell", for: indexPath) as! TrackAllCell
        cell.datebatteryLbl.text = "\(checkDate[indexPath.row])    \(String(batterySatus[indexPath.row]))%"
        cell.nameLbl.text = empName[indexPath.row]
        cell.addressLbl.text = address[indexPath.row]
        cell.profilePicImg.sd_setImage(with: profilePic[indexPath.row], placeholderImage: UIImage(named: "menu-user-icon"), options: .cacheMemoryOnly, completed: nil)
     
        if onlineoffline[indexPath.row] == "Online"{
            cell.statusImg.image = UIImage(named: "sphere-green")
        }else if onlineoffline[indexPath.row] == "Offline"{
            cell.statusImg.image = UIImage(named: "sphere-red")
        }else if onlineoffline[indexPath.row] == "Inactive"{
            cell.statusImg.image = UIImage(named: "sphere-gray")
        }
       
        
        
        cell.profilePicImg.layer.borderWidth = 1.0
        cell.profilePicImg.layer.masksToBounds = false
        cell.profilePicImg.layer.borderColor = UIColor.white.cgColor
        cell.profilePicImg.layer.cornerRadius = cell.profilePicImg.frame.size.width / 2
        cell.profilePicImg.clipsToBounds = true
        
        return cell
    }
    
    
}
