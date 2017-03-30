//
//  SearchByDateViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/6/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire


class SearchByDateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
//TODO: - General
    let cust : CustomClass_Dev = CustomClass_Dev()
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate

    
 //   var imageAvailableArray : [String] = ["0","1","0","0","1","0","0","1","0"]
    
    
    //Response Array
   /* var postDateArray : [String] = []
    var postImageArray : [String] = []
    var postTextArray : [String] = []
    var postIDArray : [String] = []
    var postByNameArray : [String] = []
    var postUserPhotoArray : [String] = []*/
    
    
//TODO: - Controls
    
    @IBOutlet weak var tblDateResult: UITableView!
//TODO: - Let's Play
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblDateResult.tableFooterView = UIView()
        tblDateResult.rowHeight = UITableViewAutomaticDimension
        tblDateResult.estimatedRowHeight = 140
        
        
        
        print("searchString:\(self.delObj.searchString)")
        if(self.delObj.searchString != ""){
            if(!self.delObj.detailSelected){
                tblDateResult.reloadData()
                fetchSearchResult()
                
            }else{
                delObj.detailSelected = false
                tblDateResult.reloadData()
               
            }
            
            
        }else{
            tblDateResult.reloadData()
            print("search text is blank")
        }

        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        print("**************viewDidDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postByNameClick(sender: AnyObject){
        let index = sender.tag
        if(self.delObj.keepPostByArray[index] == "charity"){
              self.delObj.detailSelected = true
            let charityDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idCharityDetailViewController") as! CharityDetailViewController
            charityDTVC.charityID = self.delObj.keepPostByIDArray[index]
            self.navigationController?.pushViewController(charityDTVC, animated: true)
        }else{
            
            //MARK: Navigate only when post by user is other than login user
            if(self.delObj.keepPostByIDArray[index] != self.delObj.loginUserID){
                if(self.delObj.keepProfileArray[index] == "Business"){
                      self.delObj.detailSelected = true
                    let businessDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherBusinessProfileViewController") as! OtherBusinessProfileViewController
                    businessDTVC.reqUserID = self.delObj.keepIDArray[index]
                    self.navigationController?.pushViewController(businessDTVC, animated: true)
                    
                }else{
                      self.delObj.detailSelected = true
                let otherUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
            
                otherUserVC.reqUserID = self.delObj.keepPostByIDArray[index]
                otherUserVC.reqProfileType = self.delObj.keepPostbyProfile_type[index]
            
                self.navigationController?.pushViewController(otherUserVC, animated: true)
                }
            }
        }
    }
    
//TODO: - Web service / API call
    
    func clearPreviousData(){
        
        self.delObj.keepPostByNameArray.removeAll(keepCapacity: false)
        self.delObj.keepPostImageArray.removeAll(keepCapacity: false)
        self.delObj.keepPostTextArray.removeAll(keepCapacity:false)
        self.delObj.keepPostIDArray.removeAll(keepCapacity:false)
        self.delObj.keepPostDateArray.removeAll(keepCapacity:false)
        self.delObj.keepPostUserPhotoArray.removeAll(keepCapacity: false)
        self.delObj.keepImageAvailableArray.removeAll(keepCapacity: false)
        self.delObj.keepPostByArray.removeAll(keepCapacity: false)
        self.delObj.keepPostByIDArray.removeAll(keepCapacity: false)
        self.delObj.keepPostbyProfile_type.removeAll(keepCapacity: false)
        self.delObj.keepProfileArray.removeAll(keepCapacity: false)

    }
    
    func fetchSearchResult(){
        
        SVProgressHUD.showWithStatus("Loading..")
        let parameters = ["user_id":self.delObj.loginUserID,
                          "date":self.delObj.searchString]
        Alamofire.request(.POST, delObj.baseUrl + "SearchDate", parameters:parameters ).responseJSON{
            response in
            
            print("parameters:\(parameters)")
            print("output\(response.result.value)")
            print(response.request)
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let count = outJSON["data"].array?.count
                    if(count != 0){
                        
                        //clear all data before loading new one
                        self.clearPreviousData()
                        
                        
                        if let ct = count{
                            for index in 0...ct-1{
                                
                                self.delObj.keepPostIDArray.append(outJSON["data"][index]["post_id"].stringValue)
                                self.delObj.keepPostDateArray.append(outJSON["data"][index]["date"].stringValue)
                               self.delObj.keepPostImageArray.append(outJSON["data"][index]["image"].stringValue)
                                if(outJSON["data"][index]["image"].stringValue != ""){
                                    self.delObj.keepImageAvailableArray.append("1")
                                }else{
                                    self.delObj.keepImageAvailableArray.append("0")
                                }
                                self.delObj.keepPostTextArray.append(outJSON["data"][index]["post"].stringValue)
                                
                                if(outJSON["data"][index]["postbyname"].stringValue == "Admin"){
                                    self.delObj.keepPostByNameArray.append("examen")
                                }else{
                                    self.delObj.keepPostByNameArray.append(outJSON["data"][index]["postbyname"].stringValue)
                                }
                                //self.delObj.keepPostByNameArray.append(outJSON["data"][index]["postbyname"].stringValue)
                                self.delObj.keepPostUserPhotoArray.append(outJSON["data"][index]["user_photo"].stringValue)
                                
                                
                                self.delObj.keepPostByIDArray.append(outJSON["data"][index]["postbyid"].stringValue)
                                self.delObj.keepPostbyProfile_type.append(outJSON["data"][index]["profile_type"].stringValue)
                                self.delObj.keepPostByArray.append(outJSON["data"][index]["postBy"].stringValue)
                                self.delObj.keepProfileArray.append(outJSON["profile"][index]["postBy"].stringValue)
                                
                            }//end for loop
                            
                            print("imageAvailableArray: \(self.delObj.keepImageAvailableArray)")
                        }//end ct loop
                        self.tblDateResult.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                    
                }else{
                    
                    self.delObj.displayMessage("Examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("Examen", messageText: "Please check internet connection")
                
            }
        }
    }

    
    
//TODO: - UITableViewDatasource Method Implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.delObj.keepPostIDArray.count
       
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      
            
            //var cell : HomeTableViewCell = HomeTableViewCell()
            let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! HomeTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.imgPost.frame.size.width = UIScreen.mainScreen().bounds.width*0.9
        
            // Username
        
            cell.btnName.setTitle(self.delObj.keepPostByNameArray[indexPath.row], forState: UIControlState.Normal)
            cell.btnName.tag = indexPath.row
            cell.btnName.addTarget(self, action:#selector(SearchByDateViewController.postByNameClick), forControlEvents: UIControlEvents.TouchUpInside)
        
            //Date
            cell.lblDate.text = self.delObj.keepPostDateArray[indexPath.row]
            
            // Post Description
            cell.txtPostData.text = self.delObj.keepPostTextArray[indexPath.row]
        
            print(cell.txtPostData.text?.characters.count)
            
            if(cell.txtPostData.text?.characters.count >= 150){
                
                var abc : String = (cell.txtPostData.text! as NSString).substringWithRange(NSRange(location: 0, length: 150))
                abc += "...See More"
                cell.txtPostData.text = abc
                let textCount = cell.txtPostData.text?.characters.count
                
                let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: cell.txtPostData.text!)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: self.cust.FontName, size: 13)!, range: NSMakeRange(0, textCount!))
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 6/255, green: 6/255, blue: 6/255, alpha: 1.0), range: NSMakeRange(150, 11))
                
                
                let moreAttributedString : NSMutableAttributedString = NSMutableAttributedString(string: "...See More")
               
                
                moreAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 19/255, green: 19/255, blue: 19/255, alpha: 1.0), range: NSMakeRange(0, 11))
                moreAttributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSRange(location: 0, length: 11))
                cell.txtPostData.tag = indexPath.row
                
                cell.txtPostData.attributedText = attributedString
                
            }
            
            // Profile Pic
            cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.width/2
            cell.imgProfilePic.clipsToBounds = true
        
        
            cell.imgProfilePic.image = delObj.profilePlaceholder
            if(self.delObj.keepPostUserPhotoArray[indexPath.row] != ""){
            
            let userProfURL = NSURL(string:self.delObj.keepPostUserPhotoArray[indexPath.row])
            
            cell.imgProfilePic.sd_setImageWithURL(userProfURL, placeholderImage: self.delObj.profilePlaceholder, options: SDWebImageOptions.RefreshCached)
            

            }else{
                cell.imgProfilePic.image = delObj.profilePlaceholder
            }
        
        
            cell.imgPost.image = self.delObj.userPlaceHolderImage
        
            if(self.delObj.keepImageAvailableArray[indexPath.row] == "1"){
                cell.imgPost.hidden = false
                 cell.imgHeightConstraint.constant = cell.imgPost.frame.size.width
                if(self.delObj.keepPostImageArray[indexPath.row] != ""){
                    let profURL =  NSURL(string: self.delObj.keepPostImageArray[indexPath.row])
                    
                    cell.imgPost.sd_setImageWithURL(profURL, placeholderImage: self.delObj.userPlaceHolderImage, options: SDWebImageOptions.RefreshCached)
                    
                }else{
                     cell.imgProfilePic.image = delObj.userPlaceHolderImage
                }
                
            }else{
                cell.imgPost.hidden = true
                cell.imgHeightConstraint.constant = 0
                // cell.imgPost.image = UIImage(named: "blue_bg.png")
            }
        
        
        // Profile pic click
        cell.btnProfilePicClick.tag = indexPath.row
        cell.btnProfilePicClick.addTarget(self, action:#selector(SearchByDateViewController.postByNameClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        // MARK: More option
        if(self.delObj.keepPostByIDArray[indexPath.row] != self.delObj.loginUserID){
            cell.btnMore.hidden = false
        }else{
            cell.btnMore.hidden = true
        }
        cell.btnMore.tag = indexPath.row
        cell.btnMore.setTitle(":", forState: .Normal)
        cell.btnMore.addTarget(self, action: #selector(SearchByDateViewController.btnMoreClick(_:)), forControlEvents: .TouchUpInside)
            
            return cell
            
       
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let postDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPostDetailViewController") as! PostDetailViewController
        
        postDTVC.username = self.delObj.keepPostByNameArray[indexPath.row]
        postDTVC.userlogoUrl = self.delObj.keepPostUserPhotoArray[indexPath.row]
        postDTVC.userpostDesc = self.delObj.keepPostTextArray[indexPath.row]
        postDTVC.userpostImage = self.delObj.keepPostImageArray[indexPath.row]
        postDTVC.userpostdate = self.delObj.keepPostDateArray[indexPath.row]
        postDTVC.postByArray = self.delObj.keepPostByArray[indexPath.row]
        postDTVC.postbyProfile_type = self.delObj.keepProfile_type[indexPath.row]
        postDTVC.postbyidArray = self.self.delObj.keepPostByIDArray[indexPath.row]
        self.delObj.detailSelected = true
        self.navigationController?.pushViewController(postDTVC, animated: false)

        
    }
    
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cnt : CGFloat = CGFloat()
        
        if(self.delObj.keepImageAvailableArray[indexPath.row] == "1"){
                  cnt = 285
        }else{
                cnt = 157
        }
        
       
        return cnt
    }*/

    
//MARK: Button More click
    
    @IBAction func btnMoreClick(sender:UIButton){
        
        let postID = self.delObj.keepPostByIDArray[sender.tag]//self.postIDArray[sender.tag]
        let reportBy = self.delObj.loginUserID //self.appUserID
        
        let action = UIAlertController(title: "", message: "Perform Following Action", preferredStyle: .ActionSheet)
        
        if(self.delObj.keepPostByIDArray[sender.tag] != self.delObj.loginUserID){
            action.addAction(UIAlertAction(title: "Block User", style: .Default, handler: { (value:UIAlertAction) in
                //
                
                let confAlert = UIAlertController(title: "Do you want to Block User", message: "", preferredStyle: .Alert)
                confAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (value:UIAlertAction) in
                    //
                    print("Block Yes")
                    self.sendBlockUser(postID, report_by: reportBy)
                }))
                confAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (value:UIAlertAction) in
                    //
                    print("Block No")
                }))
                
                self.presentViewController(confAlert, animated: true, completion: nil)
            }))
            
            action.addAction(UIAlertAction(title: "Report Post", style: .Default, handler: { (value:UIAlertAction) in
                //
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                let innerAlert = UIAlertController(title: "", message: "Report Reason", preferredStyle: .ActionSheet)
                innerAlert.addAction(UIAlertAction(title: "It's Spam", style: .Destructive, handler: { (value:UIAlertAction) in
                    //
                    let ct = "It's Spam"
                    print("Report Post >> It's Spam")
                    self.sendReportPost(postID, report_by: reportBy, content_type: ct)
                    
                }))
                
                innerAlert.addAction(UIAlertAction(title: "It's Abusive", style: .Destructive, handler: { (value:UIAlertAction) in
                    //
                    let ct = "It's Abusive"
                    self.sendReportPost(postID, report_by: reportBy, content_type: ct)
                    
                    print("Report Post >> It's Abusive")
                }))
                
                innerAlert.addAction(UIAlertAction(title: "Security Issue", style: .Destructive, handler: { (value:UIAlertAction) in
                    //
                    let ct = "Security Issue"
                    self.sendReportPost(postID, report_by: reportBy, content_type: ct)
                    print("Report Post >> Security Issue")
                }))
                
                innerAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (value:UIAlertAction) in
                    //
                }))
                self.presentViewController(innerAlert, animated: true, completion: nil)
                
            }))
            
            action.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (value:UIAlertAction) in
                //
            }))

        }
        
        
        self.presentViewController(action, animated: true, completion: nil)
        
    }
    
    func sendReportPost(postid : String,report_by:String,content_type:String){
        
        
        SVProgressHUD.showWithStatus("Loading..")
        
        
        
        let parameters = ["postid":postid,
                          "report_by":report_by,
                          "content_type":content_type]
        
        print("All Post parameters: \(parameters)")
        
        Alamofire.request(.POST, delObj.baseUrl + "reportpost", parameters: parameters).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    self.delObj.displayMessage("Examen", messageText: outJSON["msg"].stringValue)
                }else{
                    self.delObj.displayMessage("Examen", messageText: outJSON["msg"].stringValue)
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("Examen", messageText: "Please check internet connection")
                
            }
        }
    }
    
    
    
    func sendBlockUser(postid : String, report_by:String){
        
        
        SVProgressHUD.showWithStatus("Loading..")
        
        let parameters = ["postid":postid,
                          "report_by":report_by
        ]
        
        print("sendReportPost parameters: \(parameters)")
        
        Alamofire.request(.POST, delObj.baseUrl + "reportuser", parameters: parameters).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "Please check internet connection")
                
            }
        }
    }
    
}
