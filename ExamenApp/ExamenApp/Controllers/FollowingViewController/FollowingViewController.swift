//
//  FollowingViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/4/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire


class FollowingTableViewCell : UITableViewCell{
    
//TODO: - Controls
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var btnUnfollow: UIButton!
    
}


class FollowingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//TODO: - General
    let cust : CustomClass_Dev = CustomClass_Dev()
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var viewID : String = String()
    
    //Response Array
    var userIDArray : [String] = []
    var userDisplayNameArray : [String] = []
    var userProfilePicArray : [String] = []
    var userLocationArray : [String] = []
    var userprofiletypeArray : [String] = []
    
    
//TODO: - Controls
    
    
    @IBOutlet weak var tblMain: UITableView!
    
//TODO: - Let's Play
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tblMain.tableFooterView = UIView()
        fetchFollowersOfUser()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - Web service / API implementation
    
    func clearArrayData(){
        self.userLocationArray.removeAll(keepCapacity: false)
        self.userProfilePicArray.removeAll(keepCapacity: false)
        self.userIDArray.removeAll(keepCapacity: false)
        self.userDisplayNameArray.removeAll(keepCapacity: false)
        self.userprofiletypeArray.removeAll(keepCapacity: false)
    }
    
    func fetchFollowersOfUser(){
        SVProgressHUD.showWithStatus("Loading...")
        
        Alamofire.request(.POST, delObj.baseUrl + "followinglist", parameters: ["userid":viewID]).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let count = outJSON["data"].array?.count
                    if(count != 0){
                        self.clearArrayData()
                        SVProgressHUD.dismiss()
                        if let ct = count{
                            for index in 0..<ct{
                                
                                self.userIDArray.append(outJSON["data"][index]["id"].stringValue)
                                self.userProfilePicArray.append(outJSON["data"][index]["profile_photo"].stringValue)
                                self.userprofiletypeArray.append(outJSON["data"][index]["profile_type"].stringValue)
                                self.userDisplayNameArray.append((outJSON["data"][index]["first_name"].stringValue) + " " + (outJSON["data"][index]["last_name"].stringValue))
                                self.userLocationArray.append((outJSON["data"][index]["city"].stringValue) + "," + (outJSON["data"][index]["state"].stringValue))
                                
                            }
                            print("idArray:\(self.userIDArray)")
                            self.tblMain.reloadData()
                        }
                    }else{
                        self.delObj.displayMessage("examen", messageText: "Currently don't have any followers")
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
    
    func unfollowUser(fid:String){
        SVProgressHUD.showWithStatus("Loading...")
        
        let params = ["userid":self.delObj.loginUserID,"followerid":fid]
        print("params:\(params)")
        Alamofire.request(.POST, delObj.baseUrl + "unfollow", parameters:params ).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                  SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    for ind in 0...self.userIDArray.count-1{
                        if(fid == self.userIDArray[ind]){
                            self.userIDArray.removeAtIndex(ind)
                            self.userProfilePicArray.removeAtIndex(ind)
                            self.userLocationArray.removeAtIndex(ind)
                            self.userDisplayNameArray.removeAtIndex(ind)
                            break;
                        }
                    }
                    self.tblMain.reloadData()
                    
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
                
            }
        }
    }
    
 
//TODO: - UITableViewDatasource Method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.userIDArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! FollowingTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.lblName.text = self.userDisplayNameArray[indexPath.row]
        cell.lblAddress.text = self.userLocationArray[indexPath.row]
        
        let userProfURL = NSURL(string: self.userProfilePicArray[indexPath.row])
        cell.imgProfilePic.sd_setImageWithURL(userProfURL, placeholderImage: self.delObj.profilePlaceholder, options: SDWebImageOptions.RefreshCached)
        
        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.width/2
        cell.imgProfilePic.clipsToBounds = true
        
        //Hide unfollow button for other users
        if(self.delObj.loginUserID == self.viewID){
             cell.btnUnfollow.hidden = false
        }else{
            cell.btnUnfollow.hidden = true
        }
        cell.btnUnfollow.tag = indexPath.row
        cell.btnUnfollow.layer.cornerRadius = cust.RounderCornerRadious
        cell.btnUnfollow.addTarget(self, action: #selector(FollowingViewController.btnUnfollowClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Uncomment below to navigate to other users profile
        if(self.userIDArray[indexPath.row] != self.delObj.loginUserID){
            
            //Navigate only if user is not the same as login user
            // - Implemented for search scenario
            let otherUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
            otherUserVC.reqUserID = self.userIDArray[indexPath.row]
            otherUserVC.reqProfileType = self.userprofiletypeArray[indexPath.row]
            
            self.navigationController?.pushViewController(otherUserVC, animated: true)
            print(indexPath.row)
        }
    }
    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func btnUnfollowClick(sender:UIButton){
        print("Unfollow: \(sender.tag)")
        
        let fidNo = String(userIDArray[sender.tag])
        self.unfollowUser(fidNo)
        
    }
}
