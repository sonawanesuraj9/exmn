//
//  SearchByNameViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/6/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire



class SearchResultTableViewCell : UITableViewCell{
    
    
    //TODO: - Controls
    
    @IBOutlet var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblName: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
}

/*
 
 Comment: - All response array are declared in AppDelegate
 
 */

class SearchByNameViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var searchType : String = String()
    var searchString : String = String()
    var tmpName : String = String()
   
    
//TODO: - Controls
    
    @IBOutlet weak var tblNameResult: UITableView!
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblNameResult.tableFooterView = UIView()
        
        print("searchString:\(self.delObj.searchString)")
        if(self.delObj.searchString != ""){
            print(self.delObj.searchType)
            
            //If normal search
            if(!self.delObj.detailSelected){
                if(self.delObj.searchType == "1"){
                    SeachByName("SearchName")
                }else if(self.delObj.searchType == "2"){
                     SeachByVolunteer("SearchVolun")
                }else if(self.delObj.searchType == "3"){
                   SeachByCharity("SearchCharity")
                }else{
                    print("invalid serach type")
                }
                tblNameResult.reloadData()
                
            }else{
                //display old record as it is
                
                print("idArray:\(self.delObj.keepIDArray)")
                delObj.detailSelected = false                
                 tblNameResult.reloadData()
            }
        }else{
            tblNameResult.reloadData()
            print("search text is blank")
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //Add Observer from seachContainer
        tblNameResult.reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//TODO: - Web service / API call
    
    func clearPreviousData(){
        self.delObj.keepIDArray.removeAll(keepCapacity: false)
        self.delObj.keepNameArray.removeAll(keepCapacity: false)
        self.delObj.keepLogoArray.removeAll(keepCapacity: false)
        self.delObj.keepProfile_type.removeAll(keepCapacity: false)
        self.delObj.keepFollowstatusArray.removeAll(keepCapacity: false)
        self.delObj.keepProfileArray.removeAll(keepCapacity: false)
    }
    
    func SeachByName(searchType:String){
        
        SVProgressHUD.showWithStatus("Loading...")
        Alamofire.request(.POST, self.delObj.baseUrl + "" + searchType , parameters: ["searchtext":self.delObj.searchString,"user_id":self.delObj.loginUserID]).responseJSON {
            response in
            print(response.result.value)
            print(response.request)
            if(response.result.isSuccess){
                
            
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let count = outJSON["data"].array?.count
                    if(count != 0){
                        self.clearPreviousData()
                        SVProgressHUD.dismiss()
                        if let ct = count{
                            for index in 0..<ct{
                                print("loginUserID:\(self.delObj.loginUserID)")
                                if(self.delObj.loginUserID != outJSON["data"][index]["id"].stringValue){
                                    self.delObj.keepIDArray.append(outJSON["data"][index]["id"].stringValue)
                                    self.delObj.keepNameArray.append((outJSON["data"][index]["first_name"].stringValue) + " " + (outJSON["data"][index]["last_name"].stringValue))
                                    self.delObj.keepLogoArray.append(outJSON["data"][index]["profile_photo"].stringValue)
                                    self.delObj.keepFollowstatusArray.append(outJSON["data"][index]["followstatus"].stringValue)
                                    self.delObj.keepProfile_type.append(outJSON["data"][index]["profile_type"].stringValue)
                                    self.delObj.keepProfileArray.append(outJSON["data"][index]["profile"].stringValue)
                                }
                                
                            }
                            print("idArray:\(self.delObj.keepIDArray)")
                          
                        }
                    }else{
                        //Display no records
                        SVProgressHUD.dismiss()
                         self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                    }//End of ct loop
                    self.tblNameResult.reloadData()
                    
                    
                }else{
                     SVProgressHUD.dismiss()
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }
                
            }else{
                
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
            }
            
        }
    }
   
    func SeachByCharity(searchType:String){
        
        SVProgressHUD.showWithStatus("Loading...")
        Alamofire.request(.POST, self.delObj.baseUrl + "" + searchType , parameters: ["searchtext":self.delObj.searchString,"user_id":self.delObj.loginUserID]).responseJSON {
            response in
            print(response.result.value)
            print(response.request)
            if(response.result.isSuccess){
                
                
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let count = outJSON["data"].array?.count
                    if(count != 0){
                        self.clearPreviousData()
                        SVProgressHUD.dismiss()
                        if let ct = count{
                            for index in 0..<ct{
                                self.delObj.keepIDArray.append(outJSON["data"][index]["id"].stringValue)
                                self.delObj.keepNameArray.append(outJSON["data"][index]["charity_name"].stringValue)
                                self.delObj.keepLogoArray.append(outJSON["data"][index]["charity_logo"].stringValue)
                                
                            }
                            print("idArray:\(self.delObj.keepIDArray)")
                        }
                    }else{
                        //Display no records
                        SVProgressHUD.dismiss()
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                    }//End of ct loop
                    self.tblNameResult.reloadData()
                    
                    
                }else{
                    SVProgressHUD.dismiss()
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }
                
            }else{
                
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
            }
            
        }
    }
    
    func SeachByVolunteer(searchType:String){
        
        SVProgressHUD.showWithStatus("Loading...")
        print("searchtext:\(self.delObj.searchString)")
         print("userid:\(self.delObj.loginUserID)")
        
        
        Alamofire.request(.POST, self.delObj.baseUrl + "" + searchType , parameters: ["searchtext":self.delObj.searchString,"userid":self.delObj.loginUserID]).responseJSON {
            response in
            print(response.result.value)
            print(response.request)
            print("op:\(response.result.value)")
            if(response.result.isSuccess){
                
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let count = outJSON["data"].array?.count
                    if(count != 0){
                        self.clearPreviousData()
                        SVProgressHUD.dismiss()
                        if let ct = count{
                            for index in 0..<ct{
                                
                                self.delObj.keepIDArray.append(outJSON["data"][index]["id"].stringValue)
                                self.delObj.keepNameArray.append(outJSON["data"][index]["company_name"].stringValue)
                                self.delObj.keepLogoArray.append(outJSON["data"][index]["logo"].stringValue)
                                
                            }
                            print("idArray:\(self.delObj.keepIDArray)")
                        }
                    }else{
                        //Display no records
                        SVProgressHUD.dismiss()
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                    }//End of ct loop
                    self.tblNameResult.reloadData()
                    
                }else{
                    SVProgressHUD.dismiss()
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }
                
            }else{
                
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
            }
            
        }
    }
    

//TODO: - UITableViewDatasource Method Implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       print("ct:\(self.delObj.keepIDArray.count)")
     return self.delObj.keepIDArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
            let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! SearchResultTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            let userProfURL = NSURL(string: self.delObj.keepLogoArray[indexPath.row])
            cell.imgProfile.sd_setImageWithURL(userProfURL, placeholderImage: self.delObj.profilePlaceholder, options: SDWebImageOptions.RefreshCached)
        
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.width / 2
            cell.imgProfile.clipsToBounds = true
        
        print("self.delObj.searchType:\(self.delObj.searchType)")
            if(self.delObj.searchType == "2"){
                cell.imgHeightConstraint.constant = 0
            }else{
                cell.imgHeightConstraint.constant = 70
            }
            /*if(searchType == "Name"){
               
            }else if(searchType == "Volunteer"){
                tmpName = "Volunteer Activity"
            }else if(searchType == "Charity"){
                tmpName = "Charity Name"
            }*/
            
            tmpName = self.delObj.keepNameArray[indexPath.row]
            cell.lblName.setTitle(tmpName, forState: UIControlState.Normal)
            cell.lblName.tag = indexPath.row
            cell.lblName.addTarget(self, action: #selector(SearchByNameViewController.DisplayNameClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
            
            
    }
    
    func DisplayNameClick(sender:AnyObject){
        let index = sender.tag
        if(self.delObj.searchType == "1"){
            
            self.delObj.detailSelected = true
            
            if(self.delObj.keepProfileArray[index] == "Business"){
                let businessDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherBusinessProfileViewController") as! OtherBusinessProfileViewController
                businessDTVC.reqUserID = self.delObj.keepIDArray[index]
                self.navigationController?.pushViewController(businessDTVC, animated: true)
                
            }else{
                let otherUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
                otherUserVC.reqUserID = self.delObj.keepIDArray[index]
                print("self.delObj.keepProfile_type:\(self.delObj.keepProfile_type)")
                print("[indexPath.row:\(index)")
                otherUserVC.reqProfileType = self.delObj.keepProfile_type[index]
                
                self.navigationController?.pushViewController(otherUserVC, animated: true)
            }
            
            print(index)
        }else if(self.delObj.searchType == "2"){
            
            print(index)
        }else if(self.delObj.searchType == "3"){
            self.delObj.detailSelected = true
            let charityDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idCharityDetailViewController") as! CharityDetailViewController
               charityDTVC.charityID = self.delObj.keepIDArray[index]
            
            self.navigationController?.pushViewController(charityDTVC, animated: true)
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            print(indexPath.row)
        if(self.delObj.searchType == "1"){
            self.delObj.detailSelected = true
            if(self.delObj.keepProfileArray[indexPath.row] == "Business"){
                let businessDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherBusinessProfileViewController") as! OtherBusinessProfileViewController
                businessDTVC.reqUserID = self.delObj.keepIDArray[indexPath.row]
                self.navigationController?.pushViewController(businessDTVC, animated: true)
                
            }else{
                
                let otherUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
                otherUserVC.reqUserID = self.delObj.keepIDArray[indexPath.row]
                print("self.delObj.keepProfile_type:\(self.delObj.keepProfile_type)")
                print("[indexPath.row:\(indexPath.row)")
                otherUserVC.reqProfileType = self.delObj.keepProfile_type[indexPath.row]
            
                self.navigationController?.pushViewController(otherUserVC, animated: true)
            }
           print(indexPath.row)
        }else if(self.delObj.searchType == "2"){
          
            print(indexPath.row)
        }else if(self.delObj.searchType == "3"){
            self.delObj.detailSelected = true
            let charityDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idCharityDetailViewController") as! CharityDetailViewController
            charityDTVC.charityID = self.delObj.keepIDArray[indexPath.row]
            self.navigationController?.pushViewController(charityDTVC, animated: true)
            
            print(indexPath.row)
        }
        
        
    }
}
