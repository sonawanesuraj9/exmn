//
//  OtherLikeUsersViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC3 on 03/03/17.
//  Copyright © 2017 supaint. All rights reserved.
//

import UIKit
import Alamofire

class OtherLikeUsersViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    
    //Response Variables
    
    var userIDArray : [String] = []
    var userFirstNameArray : [String] = []
    var userLastNameArray : [ String] = []
    var userProfileTypeArray : [String] = []
    var userProfileArrya : [String] = []
    var userProfilePhotoArray : [String] = []
    var userIsFollowArray : [String] = []
    var userISFollowingArray : [String] = []
    var userISRequestedArray : [String] = []
    var userLocaitonArray : [String] = []
    //data from back
    var postID : String = String()
//TODO: - Controls
    
    @IBOutlet weak var tblMain: UITableView!
    
//TODO: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.fetchListing(postID, userid: self.delObj.loginUserID)
        self.tblMain.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
//TODO: - UITableViewDatasource Method implementation
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.userFirstNameArray.count
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! FollowingTableViewCell
        
        cell.selectionStyle = .None
        
        let picURL =  NSURL(string: self.userProfilePhotoArray[indexPath.row])
        cell.imgProfilePic.sd_setImageWithURL(picURL, placeholderImage: self.delObj.userPlaceHolderImage, options: SDWebImageOptions.RefreshCached)
        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.width / 2
        cell.imgProfilePic.clipsToBounds = true
        
        cell.lblName.text = self.userFirstNameArray[indexPath.row] + " " + self.userLastNameArray[indexPath.row]
        cell.lblAddress.text = self.userLocaitonArray[indexPath.row]
        
        
        //Check if self
        if self.userIDArray[indexPath.row] == self.delObj.loginUserID{
            cell.btnUnfollow.hidden = true
        }else{
            cell.btnUnfollow.hidden = false
       
            if self.userIsFollowArray[indexPath.row] == "Y"{
                cell.btnUnfollow.setTitle("Following", forState: .Normal)
            }else{
                if self.userISFollowingArray[indexPath.row] == "Y"{
                    cell.btnUnfollow.setTitle("Following", forState: .Normal)
                }else{
                    
                    if self.userISRequestedArray[indexPath.row] == "Y"{
                        cell.btnUnfollow.setTitle("Requested", forState: .Normal)
                    }else{
                        
                        cell.btnUnfollow.setTitle("Follow", forState: .Normal)
                    }
                    
                    
                    
                }
            
            }
        }
        
        
        cell.btnUnfollow.tag = indexPath.row
        cell.btnUnfollow.layer.cornerRadius = cust.RounderCornerRadious
        cell.btnUnfollow.addTarget(self, action: #selector(OtherLikeUsersViewController.btnClick(_:)), forControlEvents: .TouchUpInside)
        
        
        
        return cell
    }
    
    
    
    @IBAction func btnClick(sender:UIButton){
        print("Click at Index: \(sender.tag)")
        
        var is_userPublic = Bool()
        let otherUID = userIDArray[sender.tag]
        
        if self.userProfileTypeArray[sender.tag] == "Public"{
            is_userPublic = true
        }else{
            is_userPublic = false
        }
        
        if self.userISFollowingArray[sender.tag] == "N"{
            
            //Check if user is Public or Private
            if(is_userPublic){
                //If User is public
                followPublicUser(otherUID, indexPath: sender.tag)
            }else{
                //If user is private
                sendRequest(otherUID, indexPath: sender.tag)
            }
        
        }
        
        
        
    }
    
    
//TODO: - Webservice / API implementation
    
    func clearPreviousData(){
        self.userIDArray.removeAll(keepCapacity: false)
        self.userProfileArrya.removeAll(keepCapacity: false)
        self.userIsFollowArray.removeAll(keepCapacity: false)
        self.userLastNameArray.removeAll(keepCapacity: false)
        self.userFirstNameArray.removeAll(keepCapacity: false)
        self.userISFollowingArray.removeAll(keepCapacity: false)
        self.userProfileTypeArray.removeAll(keepCapacity: false)
        self.userProfilePhotoArray.removeAll(keepCapacity: false)
        self.userISRequestedArray.removeAll(keepCapacity: false)
        self.userLocaitonArray.removeAll(keepCapacity: false)
    }
    
    
    /**
     Fetch Listing of like people
     
     - parameter postid: post for which like raised
     - parameter userid: user, who views that like
     */
    func fetchListing(postid:String,userid:String){
        print("postid:\(postid), userid:\(userid)")
        SVProgressHUD.showWithStatus("Loading...")
        Alamofire.request(.POST, self.delObj.baseUrl + "getuser_relation", parameters: ["postid":postid,"userid":userid]).responseJSON {
            response in
            print(response.result.value)
            print(response.request)
            if(response.result.isSuccess){
                
                
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] == "1"){
                    
                    let count = outJSON["data"].array?.count
                    if(count != 0){
                        self.clearPreviousData()
                        SVProgressHUD.dismiss()
                        if let ct = count{
                            for index in 0..<ct{
                                print("fetchListing:\(self.delObj.loginUserID)")
                                
                                    self.userIDArray.append(outJSON["data"][index]["id"].stringValue)
                                    self.userProfileArrya.append(outJSON["data"][index]["profile"].stringValue)
                                    self.userIsFollowArray.append(outJSON["data"][index]["isfollower"].stringValue)
                                    self.userLastNameArray.append(outJSON["data"][index]["last_name"].stringValue)
                                    self.userFirstNameArray.append(outJSON["data"][index]["first_name"].stringValue)
                                    self.userISFollowingArray.append(outJSON["data"][index]["isfollowing"].stringValue)
                                 self.userProfileTypeArray.append(outJSON["data"][index]["profile_type"].stringValue)
                                self.userProfilePhotoArray.append(outJSON["data"][index]["profile_photo"].stringValue)
                                self.userISRequestedArray.append(outJSON["data"][index]["isrequested"].stringValue)
                                self.userLocaitonArray.append(outJSON["data"][index]["city"].stringValue + ", " + outJSON["data"][index]["state"].stringValue)
                            }
                            print("idArray:\(self.delObj.keepIDArray)")
                            
                        }
                    }else{
                        //Display no records
                        SVProgressHUD.dismiss()
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                    }//End of ct loop
                    self.tblMain.reloadData()
                    
                    
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
    
    
    
    /**
     Follow to Other Public User
     
     - parameter reqUserID: other user ID
     - parameter indexPath: indexPath
     */
    func followPublicUser(reqUserID:String,indexPath:Int){
        SVProgressHUD.showWithStatus("Loading...")
        
        let params = ["userid":reqUserID,"followerid":self.delObj.loginUserID ]
        Alamofire.request(.POST, delObj.baseUrl + "follow", parameters:params ).responseJSON{
            response in
            print("Parmas:\(params)")
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    //Increase number of followers on success
                   self.userIsFollowArray[indexPath] = "Y"
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
    
    /**
     Send request in case of private user
     
     - parameter reqUserID: other user ID
     - parameter indexPath: indexPath
     */
    
    func sendRequest(reqUserID:String,indexPath:Int){
        
        SVProgressHUD.showWithStatus("Loading...")
        
        Alamofire.request(.POST, delObj.baseUrl + "sendrequest", parameters: ["req_from":self.delObj.loginUserID,"req_to":reqUserID]).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                   
                    self.userIsFollowArray[indexPath] = "N"
                    self.userISFollowingArray[indexPath] = "N"
                    self.userISRequestedArray[indexPath] = "Y"
                    self.tblMain.reloadData()
                    
                    
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "Please check internet connection")
                
            }
        }
    }
    
    
    
//TODO: - UIButton Action

    @IBAction func btnBackClick(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
