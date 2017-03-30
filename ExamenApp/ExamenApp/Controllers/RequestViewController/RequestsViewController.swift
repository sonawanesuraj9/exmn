//
//  RequestsViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/4/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire


class RequestTableViewCell : UITableViewCell{
    
    
//TODO: - Controls
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
}


class RequestsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    //Response array 
    var userIDArray : [String] = []
    var userDisplayNameArray : [String] = []
    var userProfilePicArray : [String] = []
    var userRequestIDArray : [String] = []
    var userProfileTypeArray : [String] = []
    var userAddressArray : [String] = []
    
    var rid : String = String()
    var requestIndex : Int = Int()
    
    var requestIndexPath : NSIndexPath = NSIndexPath()
    
//TODO: - Controls
    
    @IBOutlet weak var mainTableView: UITableView!
    
//TODO: - Let's Play
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchRequestForUser()
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - Web service / API implementatin
    
    func clearArray(){
        self.userIDArray.removeAll(keepCapacity: false)
        self.userDisplayNameArray.removeAll(keepCapacity: false)
        self.userProfilePicArray.removeAll(keepCapacity: false)
        self.userRequestIDArray.removeAll(keepCapacity: false)
        self.userProfileTypeArray.removeAll(keepCapacity: false)
        self.userAddressArray.removeAll(keepCapacity: false)
    }
    
    func fetchRequestForUser(){
        SVProgressHUD.showWithStatus("Loading...")
        
        Alamofire.request(.POST, delObj.baseUrl + "requestlist", parameters: ["req_to":self.delObj.loginUserID]).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let count = outJSON["data"].array?.count
                     if(count != 0){
                        self.clearArray()
                        SVProgressHUD.dismiss()
                        if let ct = count{
                            for index in 0..<ct{
                                
                                self.userIDArray.append(outJSON["data"][index]["id"].stringValue)
                                self.userProfilePicArray.append(outJSON["data"][index]["profile_photo"].stringValue)
                                self.userDisplayNameArray.append((outJSON["data"][index]["fnm"].stringValue) + " " + (outJSON["data"][index]["lnm"].stringValue))
                                self.userProfileTypeArray.append(outJSON["data"][index]["ptype"].stringValue)
                                self.userRequestIDArray.append(outJSON["data"][index]["rid"].stringValue)
                                let city_state = outJSON["data"][index]["city"].stringValue + ", " + outJSON["data"][index]["state"].stringValue
                                self.userAddressArray.append(city_state)
                                
                            }
                            print("idArray:\(self.userIDArray)")
                            self.mainTableView.reloadData()
                        }
                     }else{
                        self.delObj.displayMessage("examen", messageText: "Currently don't have any request")
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
    
    
    func acceptRequest(){
        
        Alamofire.request(.POST, delObj.baseUrl + "acceptrequest", parameters: ["rid":rid]).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let count = outJSON["data"].array?.count
                    if(count != 0){
                        self.userIDArray.removeAtIndex(self.requestIndex)
                        self.userDisplayNameArray.removeAtIndex(self.requestIndex)
                        self.userProfilePicArray.removeAtIndex(self.requestIndex)
                        self.userRequestIDArray.removeAtIndex(self.requestIndex)                        
                        self.mainTableView.deleteRowsAtIndexPaths([self.requestIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    }else{
                        self.delObj.displayMessage("examen", messageText: "Currently don't have any request")
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
    
    func declineRequst(){
        
        Alamofire.request(.POST, delObj.baseUrl + "declinerequest", parameters: ["rid":rid]).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                SVProgressHUD.dismiss()
                
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    self.userIDArray.removeAtIndex(self.requestIndex)
                    self.userDisplayNameArray.removeAtIndex(self.requestIndex)
                    self.userProfilePicArray.removeAtIndex(self.requestIndex)
                    self.userRequestIDArray.removeAtIndex(self.requestIndex)
                    
                    self.mainTableView.deleteRowsAtIndexPaths([self.requestIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "Please check internet connection")
                
            }
        }
    }
    
    
//TODO: - UITableViewDatasource Method implementation
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return userIDArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! RequestTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let userProfURL = NSURL(string: self.userProfilePicArray[indexPath.row])
        cell.imgProfile.sd_setImageWithURL(userProfURL, placeholderImage: self.delObj.profilePlaceholder, options: SDWebImageOptions.RefreshCached)
        
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
        cell.imgProfile.clipsToBounds = true
        cell.lblName.text = self.userDisplayNameArray[indexPath.row]
        cell.lblAddress.text = self.userAddressArray[indexPath.row]
        cell.btnAccept.tag = indexPath.row
        cell.btnAccept.layer.cornerRadius = cust.RounderCornerRadious
        cell.btnAccept.addTarget(self, action: #selector(RequestsViewController.btnAcceptRequestClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
         cell.btnDecline.tag = indexPath.row
        cell.btnDecline.layer.cornerRadius = cust.RounderCornerRadious
        cell.btnDecline.addTarget(self, action: #selector(RequestsViewController.btnDeclineRquestClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Uncomment below to navigate to other users profile
        if(self.userIDArray[indexPath.row] != self.delObj.loginUserID){
            
            //Navigate only if user is not the same as login user
            // - Implemented for search scenario
            let otherUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
            otherUserVC.reqUserID = self.userIDArray[indexPath.row]
            otherUserVC.reqProfileType = self.userProfileTypeArray[indexPath.row]
            
            self.navigationController?.pushViewController(otherUserVC, animated: true)
            print(indexPath.row)
        }
    }
    

//TODO: - Button Action
    
    func btnAcceptRequestClick(sender:UIButton){
        print("Accept: \(sender.tag)")
        requestIndex = sender.tag
        requestIndexPath = NSIndexPath(forRow: requestIndex, inSection: 0)
        rid = self.userRequestIDArray[sender.tag]
        self.acceptRequest()
        
    }
    
    func btnDeclineRquestClick(sender: UIButton){
        print("Decline: \(sender.tag)")
        requestIndex = sender.tag
        requestIndexPath = NSIndexPath(forRow: requestIndex, inSection: 0)

        rid = self.userRequestIDArray[sender.tag]
        declineRequst()
       
        
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}
