import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

var mainMenuList = [String]()
var fullmenu = [String:Any]()

struct Category{
    static var mainMenuname = [String]()
    static var mainMenuId = [String]()
    static var submenu = [String]()
    static var subMenuID = [String]()
    static var menuID = ""
    
    
    static var sub = [String]()
}


class MenuModel{
    
    
    
    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getMenuData(url : String, parameter : [String:String]){
        
        mainMenuList = [String]()
        fullmenu = [String:Any]()
        Category.mainMenuId = [String]()
        Category.mainMenuname = [String]()
        Category.submenu = [String]()
        Category.subMenuID = [String]()
        Category.sub = [String]()
        
        var menuID = ""
        var len = 0
        
        
//        print (headers)
        Alamofire.request(url, method: .get, headers : headers).responseJSON{
            response in
            
            
            let menuData = response.data!
            
            if response.result.isSuccess{
//                                print(response.result.value)
                do{
                    var menu = try JSONDecoder().decode(Root.self, from: menuData)
                    
                    for x in menu.menudata{
                        for y in x.getmenu{
                        
                            
                                if y.type == "M"{
                                    
                                    mainMenuList.append(y.menuname!)
                                    Category.mainMenuId.append(y.menuid!)
                                    Category.mainMenuname.append(y.menuname!)
                                    Category.menuID = y.code!
                            }
                           
                            if y.type == "A"{
                                Category.subMenuID.append(y.menuid!)
                                Category.sub.append(y.menuname!)
                            }
                            
                            if y.type == "A" && (y.code?.contains(Category.menuID))!{
                                
                                Category.submenu.append(y.menuname!)
                                
                            }
                        }
                        
                        fullmenu.updateValue(Category.submenu as Any, forKey: Category.mainMenuname[len])
//                        fullmenu[self.mainMenu.mainMenuname[len]] = self.mainMenu.submenu
//                            print(self.mainMenu.mainMenuname[len])
//                            print(self.mainMenu.submenu)
                            len += 1
                        
                        Category.submenu = [String]()
                        
                       
                    }
                    SVProgressHUD.dismiss()
//                   print(fullmenu)
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
    
    
    func mainMenu(menuName : String){
        
        
        
//        mainMenuList.append(menuName)
        //        print(menuList.last)
        //defaults.set(menuList, forKey: "MenuList")
    
        
    
    }
    
    
    
}
