//
//  DirectoryModel.swift
//  Cilfi
//
//  Created by Amandeep Singh on ੬/੧੨/੧੮.
//  Copyright © ੨੦੧੮ Focus Infosoft. All rights reserved.
//

import Foundation
import Alamofire


class DirectoryModel{
    
    public struct EmpFeedback{
        
        var code : String?
        var name : String?
        var image : String?
        var remarkDate : String?
        var remarkBy : String?
        var remarkByName : String?
        var remarks : String?
        var feedbackId : String?
        var status : String?
        var likes : String?
        var comments : String?
        var rowseq : String?
        
        
    }
    
    //MARK: - Manage Profile Struct
    /***************************************************************/
    
    public struct ManageProfile{
        var education : [Education]
        var experience : [Experince]
        var certificate : [Certificate]
        var managerHead : String?
        var aboutMe : String?
        var address : String?
        var department : String?
        var hobbies : String?
        var skills : String?
    }
    
    struct Experince {
        var company : String?
        var designation : String?
        var fromDate : String?
        var toDate : String?
    }
    
    struct Certificate {
        var auth : String?
        var licenseNo : String?
        var fromDate : String?
        var toDate : String?
        var name : String?
    }
    
    struct Education {
        var degree : String?
        var university : String?
        var year : String?
    }
    
    
    func getFeedback(header : [String : String], completion : @escaping (([EmpFeedback])->Void)){
        
        var feedback = [EmpFeedback]()
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/empfeedback", method: .get, headers : headers).responseJSON{
            response in
            
            //            print(header)
            
            let epData = response.data!
            let epJSON = response.result.value
            
            if response.result.isSuccess{
                //                print("UserJSON: \(custJSON)")
                do{
                    let ep = try JSONDecoder().decode(EmployeeFeedbackRoot.self, from: epData)
                    
                    for x in ep.empFeedback{
                        
                        feedback.append(EmpFeedback(code: x.code, name: x.name, image: x.image, remarkDate: x.remarkDate, remarkBy: x.remarkBy, remarkByName: x.remarkByName, remarks: x.remarks, feedbackId: x.feedbackId, status: x.status, likes: x.likes, comments: x.comments, rowseq: x.rowseq))
                        
                        
                    }
                    completion(feedback)
                    
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
    
    
    
    
    func getManageProfile(header : [String : String], completion : @escaping ([ManageProfile])-> Void) {
        
        var manage = [ManageProfile]()
        
        
            
            
            Alamofire.request("\(LoginDetails.hostedIP)/sales/manageprofile", method: .get, headers : header).responseJSON{
                response in
                
                //            print(header)
                
                let epData = response.data!
                let epJSON = response.result.value
                
                if response.result.isSuccess{
                    //                print("UserJSON: \(custJSON)")
                    do{
                        let ep = try JSONDecoder().decode(ManageProfileRoot.self, from: epData)
                        
                        for x in ep.profile{
                            var exp = [Experince]()
                            var cert = [Certificate]()
                            var edu = [Education]()
                            
                            for y in x.experience{
                                exp.append(Experince(company: y.companyName!, designation: y.designation!, fromDate: y.fromDate!, toDate: y.toDate!))
                            }
                            
                            for y in x.certificate{
                                cert.append(Certificate(auth: y.authority!, licenseNo: y.licenseNo!, fromDate: y.fromDate!, toDate: y.toDate!, name: y.name!))
                            }
                            
                            for y in x.education{
                                edu.append(Education(degree: y.degree!, university: y.university!, year: y.year!))
                            }
                            
                            manage.append(ManageProfile(education: edu, experience: exp, certificate: cert, managerHead: x.managerHead, aboutMe: x.aboutMe, address: x.address, department: x.department, hobbies: x.hobbies, skills: x.skill))
                            
                            
                            
                        }
                        completion(manage)
                        
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
    
    
    
    func getEmployeeFeedback(header : [String:String], completion : @escaping ([String:Any])->Void){
    
        var remarkBy = [String]()
        var remark = [String]()
        var feedbackId = [String]()
        var rowSeq = [String]()
        var image = [String]()
        var date = [String]()
        
        
        Alamofire.request("\(LoginDetails.hostedIP)/sales/empfeedback", method: .get, headers : header).responseJSON{
            response in
            
            //            print(header)
            
            let epData = response.data!
            let epJSON = response.result.value
            
            if response.result.isSuccess{
                //                print("UserJSON: \(custJSON)")
                do{
                    let ef = try JSONDecoder().decode(EmployeeFeedbackRoot.self, from: epData)
                    
                    for x in ef.empFeedback{
                        if let value = x.remarks{
                            remark.append(value)
                        }
                        if let value = x.remarkByName{
                            remarkBy.append(value)
                        }
                    
                        if let value = x.feedbackId{
                            feedbackId.append(value)
                        }
                        if let value = x.rowseq{
                            rowSeq.append(value)
                        }
                        
                        if let value = x.image{
                            image.append(value)
                        }
                        
                        if let value = x.remarkDate{
                            date.append(value)
                        }
                    }
                    
                    completion(["feedbackId": feedbackId, "rowSeq" : rowSeq,"remarks" : remark, "remarksBy" : remarkBy, "image" : image, "date":date])
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
