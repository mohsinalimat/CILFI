//
//  DashboardTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 01/06/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
//import Alamofire
//
//
//
//
//
//
//
//class DashboardTableViewController: UITableViewController {
//
//    let dashheaders : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "user")!]
//    let tempurl = "http://80.241.216.95:82/sales/dashboard"
//
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        getDashData(url: tempurl, parameter: dashheaders)
//
//        tableView.reloadData()
//    }
//
//
//    //MARK: - Networking - ALAMO FIRE
//    /***************************************************************/
//
//    func getDashData(url : String, parameter : [String:String]){
//
//        Alamofire.request(url, method: .get, headers : parameter).responseJSON{
//            response in
//
//            let dashData = response.data!
//            let dashJSON = response.result.value
//
//            if response.result.isSuccess{
//
//                do{
//                    let dash = try JSONDecoder().decode(DashRoot.self, from: dashData)
//                    //tableView
//
//
//                    for x in dash.eventDetail{
//                        self.empCode.append(x.employeeCode!)
//                        self.empName.append(x.employeeName!)
//                        self.desg.append(x.designation!)
//                        self.eventDate.append(x.eventDate!)
//                        self.eventType.append(x.eventType!)
//                        self.profileUrl.append(x.profileUrl!)
//
//                    }
//
//                   print("hhdjankjcndsjvnkejlfi")
//                }
//                catch{
//                    print (error)
//                }
//
//            }
//            else{
//                print("Something Went wrong")
//            }
//        }
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return empName.count ?? 1
//
//    }
//
//
//
//        func loadItems(){
//
//            tableView.reloadData()
//
//        }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("hhdjankjcndsjvnkejlfi")
//
//        print(empName)
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "dashCell", for: indexPath) as! DashTableViewCell
//
//        cell.nameLabel.text = ("\(empName[indexPath.row])   \(empCode[indexPath.row])")
//        cell.designationLabe.text = desg[indexPath.row]
//        cell.dateLabel.text = eventDate[indexPath.row]
//        if eventType[indexPath.row] == "Birthday" {
//            cell.userImg.image = UIImage(named: "birthday-cake")
//        }
//        else if eventType[indexPath.row] == "Anniversary"{
//            cell.userImg.image = UIImage(named: "anniversary")
//        }
//        //add cilfi IMG
//        return cell
//    }
//
//}
