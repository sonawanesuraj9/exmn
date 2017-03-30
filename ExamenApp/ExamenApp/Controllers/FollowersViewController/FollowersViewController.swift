//
//  FollowersViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/4/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire


class FollowersTableViewCell : UITableViewCell{
    
//TODO: - Controls
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
}

class FollowersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    //Response Array 
    var userIDArray : [String] = []
    var userDisplayNameArray : [String] = []
    var userProfilePicArray : [String] = []
    var userLocationArray : [String] = []
    var userProfileType : [String] = []
    
    
    var viewID : String = String()
    var selectedType : String = String()
    
//TODO: - Controls
    
    @IBOutlet weak var tlbMain: UITableView!

//TODO: - Let's Play
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tlbMain.tableFooterView = UIView()
        
        fetchFollowersOfUser()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - API / Web service call
    func clearAllArray(){
        self.userDisplayNameArray.removeAll(keepCapacity: false)
        self.userIDArray.removeAll(keepCapacity: false)
        self.userProfilePicArray.removeAll(keepCapacity: false)
        self.userLocationArray.removeAll(keepCapacity: false)
        self.userProfileType.removeAll(keepCapacity: false)
    }
    
    func fetchFollowersOfUser(){
        SVProgressHUD.showWithStatus("Loading...")
        var tmp_viewID : String = String()
        tmp_viewID =  viewID
        /*if(selectedType == "charity"){
            tmp_viewID =  viewID

        }else{
            tmp_viewID =  self.delObj.loginUserID
        }*/
        let params = ["userid":tmp_viewID,"type":selectedType]
        Alamofire.request(.POST, delObj.baseUrl + "followerlist", parameters: params).responseJSON{
            response in
            print("params:\(params)")
            print("selectedType:\(self.selectedType)")
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let count = outJSON["data"].array?.count
                    if(count != 0){
                        self.clearAllArray()
                        SVProgressHUD.dismiss()
                        if let ct = count{
                            for index in 0..<ct{
                                
                                self.userIDArray.append(outJSON["data"][index]["id"].stringValue)
                                self.userProfileType.append(outJSON["data"][index]["profile_type"].stringValue)
                                 self.userProfilePicArray.append(outJSON["data"][index]["profile_photo"].stringValue)
                                self.userDisplayNameArray.append((outJSON["data"][index]["first_name"].stringValue) + " " + (outJSON["data"][index]["last_name"].stringValue))
                                
                                self.userLocationArray.append((outJSON["data"][index]["city"].stringValue) + "," + (outJSON["data"][index]["state"].stringValue))
                                
                            }
                            print("idArray:\(self.userIDArray)")
                            self.tlbMain.reloadData()
                        }
                    }else{
                        self.delObj.displayMessage("examen", messageText: "currently don't have any followers")
                    }
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "Please check internet connection")
                
            }
        }
    }
    
    
//TODO: - UITableViewDatasource Method Implementatino
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return userIDArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! FollowersTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let userProfURL = NSURL(string: self.userProfilePicArray[indexPath.row])
        cell.imgProfilePic.sd_setImageWithURL(userProfURL, placeholderImage: self.delObj.profilePlaceholder, options: SDWebImageOptions.RefreshCached)
        
        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.width / 2
        cell.imgProfilePic.clipsToBounds = true
        
        cell.lblName.text = self.userDisplayNameArray[indexPath.row]
        
        cell.lblAddress.text = self.userLocationArray[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("index:\(indexPath.row)")
       
        // Uncomment below to navigate to other users profile
        if(self.userIDArray[indexPath.row] != self.delObj.loginUserID){
                
                //Navigate only if user is not the same as login user 
                // - Implemented for search scenario
           let otherUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
            otherUserVC.reqUserID = self.userIDArray[indexPath.row]
            otherUserVC.reqProfileType = self.userProfileType[indexPath.row]
            
            self.navigationController?.pushViewController(otherUserVC, animated: true)
            print(indexPath.row)
        }
        
    }
    
//TODO: - Button Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}
