//
//  UserTrackTableViewController.swift
//  Cilfi
//
//  Created by Amandeep Singh on 31/05/18.
//  Copyright © 2018 Focus Infosoft. All rights reserved.
//

import UIKit
import DropDown
import DatePickerDialog
import Alamofire

class UserTrackTableViewCell : UITableViewCell{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
}
class UserTrackTableViewController: UITableViewController, UITextFieldDelegate {
    var address = [String]()
    var time = [String]()
    
    var flag = 0
    var date = ""
    var userid = ""
    var username = ""
    var tracktype = "m"
   
    let user = UserTrackModel()
    let userDataurl = "\(LoginDetails.hostedIP)/sales/teamdetail"
    let userTrackDataurl = "\(LoginDetails.hostedIP)/sales/usertrack"
    let dropDown = DropDown()
    
    let dropdownusersheaders : [String:String] = ["username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : defaults.string(forKey: "user")!]

    
    @IBOutlet weak var usersButton: UIButton!
    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("uuuuuuuuuuuuussssssssseeeeeeeeerrrrr\(username)")
        user.getUsersData(url: userDataurl, header: dropdownusersheaders)
        
        dropDown.direction = .bottom
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 1, y:120)
        dropDown.dismissMode = .onTap
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        
    
        userIdTF.text = userid
        usersButton.setTitle(username, for: .normal)
        dateButton.setTitle(date, for: .normal)
        
        getAddressTime()
    }

    
    @IBAction func selectUsersButton(_ sender: UIButton) {
    
        dropDown.dataSource = user.userDetails
        dropDown.anchorView = view
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //            print("Selected item: \(item) at index: \(index)")
            self.usersButton.setTitle(item, for: .normal)
            self.userIdTF.text = self.user.empcode[index]
            self.userid = self.user.empcode[index]
        
            self.getAddressTime()
        }
    }
    
    
    @IBAction func selectDateButton(_ sender: UIButton) {
    
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                self.dateButton.setTitle(formatter.string(from: dt), for: .normal)
                self.date = formatter.string(from: dt)
                
                self.getAddressTime()
                
            }
        }
    
    
    }
    
    
    
    
    func getAddressTime(){
        
        
        if date != "" && userid != ""{
        
            let headers : [String:String] = [ "username" : defaults.string(forKey: "user")! , "password" : defaults.string(forKey: "password")! , "companycode" : defaults.string(forKey: "company")!, "yearmonth" : defaults.string(forKey: "yearMonth")!, "employeecode" : userid, "datetime" : date, "tracktype" : tracktype ]
          
            getUserTrackDataTable(url: userTrackDataurl, header: headers)
            
            loadItems()
            
        }
       
        }
        
        
    
    
    func loadItems(){
        
//        print(address)
//        print("hello")
        tableView.reloadData()
        
    }
   
    
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return address.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTrackTableViewCell
        
        
        let addre = address[indexPath.row]
        cell.addressLabel.text = addre
        
        cell.timeLabel.text = time[indexPath.row]
        //        let fruitName = fruits[indexPath.row]
        //        cell.label?.text = fruitName
        //        cell.fruitImageView?.image = UIImage(named: fruitName)
        //
        return cell
    }
    
    
    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getUsersData for dropdown method here:
    func getUserTrackDataTable(url : String, header : [String:String]){
        
        address = [String]()
        time = [String]()
        //      print("we are here")
        Alamofire.request(url, method: .get, headers : header).responseJSON{
            response in
            //            var times = [String]()
            //            var addresss = [String]()
            
            let userTrackDetailData = response.data!
            let userTrackDetailJSON = response.result.value
            if response.result.isSuccess{
//                print("UserTrackJSON: \(userTrackDetailJSON)")
                do{
                    let track = try JSONDecoder().decode(UserTrackRoot.self, from: userTrackDetailData)
                    
                    for x in track.userTrack{
                        if let y = x.address{
                            self.address.append(y)
                            self.loadItems()
                        }
                        else{
                            print("No Data in address")
                        }
                        
                        if let z = x.checkDate{
                            let dateformatter = DateFormatter()
                            dateformatter.dateFormat = "MM/dd/yy h:mm:ss a"
                            let now = dateformatter.date(from: z)
                            let time = DateFormatter.localizedString(from: now!, dateStyle: .none, timeStyle: .short)
                            self.time.append(time)
                            self.loadItems()
                        }
                        else{
                            print("No Data in Time")
                        }
                    }
                    //                    self.address = addresss
                    //                    self.time = times
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
    
    

}
