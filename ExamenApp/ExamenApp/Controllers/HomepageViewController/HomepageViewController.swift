//
//  HomepageViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/2/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire



class HomeTableViewCell : UITableViewCell{
    
    
//TODO: - General
    
    @IBOutlet weak var btnOthers: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet  var imgHeightConstraint: NSLayoutConstraint!
    //@IBOutlet var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnMore: UIButton!
    //@IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
   // @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
   // @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnProfilePicClick: UIButton!
    @IBOutlet weak var txtPostData: UITextView!
    //@IBOutlet weak var txtPostData: UITextView!
    
}

class HomepageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    let likeColor = UIColor(red: 14/255, green: 76/255, blue: 126/255, alpha: 1.0)
    var indexOfExpandedCell : NSIndexPath = NSIndexPath()
    var shouldCellBeExpanded : Bool = Bool()
    var appUserID : String = String()
    var imageAvailableArray : [String] = []
    var isWSCall : Bool = Bool()
    var welcomeMessageText : String = String()
    //Array
    
    var postDateArray : [String] = []
    var postImageArray : [String] = []
    var postTextArray : [String] = []
    var postIDArray : [String] = []
    var postByNameArray : [String] = []
    var postUserPhotoArray : [String] = []
    var postbyidArray : [String] = []
    var postbyProfile_type : [String] = []
    var postByArray : [String] = []
    var postIsWelcome : [String] = []
    var postLikeArray : [String] = []
    var isPostLikeArray : [String] = []
    
//TODO: - Controls
    
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var btnLoadNewPostOutlet: UIButton!
    var refreshControl : UIRefreshControl = UIRefreshControl()
    
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("HomePage")
        
        
        mainTableView.rowHeight = UITableViewAutomaticDimension
        mainTableView.estimatedRowHeight = 140
        
        
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.whiteColor()
        refreshControl.tintColor = UIColor(red: 70/255, green: 149/255, blue: 212/255, alpha: 1.0)
        let attr = [NSForegroundColorAttributeName:UIColor(red: 49/255, green: 49/255, blue: 49/255, alpha: 1.0)]
        refreshControl.attributedTitle = NSAttributedString(string: "loading new post", attributes:attr)
        refreshControl.addTarget(self, action: #selector(HomepageViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.mainTableView.addSubview(refreshControl)
        
        let tmp1 = defaults.valueForKey("loginUserDetalis") as! NSDictionary
        
        
          print("loginUserDetalis:\(tmp1)")
        
        
         let str : NSString = "\" \u{1f60e} Thank you for downloading examen, positively an app worth sharing! \""
         self.linkLabel.text = str as String
        
        
        
        //clear all data before loading new one
       /* if !self.delObj.isFirstTimeUser{
            self.clearAllArray()
            LoadPost(delObj.loginUserID)
            self.mainTableView.hidden = false
        }else{
            self.mainTableView.hidden = true
        }*/
       
        
    }
    

    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        welcomeMessageText = "\" \u{1f60e} examen is your social media app to post positive messages and share volunteer activities. Celebrate the joy of living and the spirit of giving. examen your day, examen your life www.examenlife.com \""
        
        
        
        print("self.delObj.isFirstTimeUser:\(self.delObj.isNewTimeUser)")
        if !self.delObj.isNewTimeUser{
            self.clearAllArray()
            LoadPost(delObj.loginUserID)
            self.mainTableView.hidden = false
            self.linkView.hidden = true
        }else{
            self.mainTableView.hidden = true
            self.linkView.hidden = false
        }

        
        
        
        //Add Observer from appdelegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomepageViewController.updateDeviceToken(_:)), name: "GotDeviceToken", object: nil)
        
        self.btnLoadNewPostOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnLoadNewPostOutlet.hidden = true
        if(self.delObj.isNewPostAdded){
           // self.btnLoadNewPostOutlet.hidden = false
            self.clearAllArray()
            self.LoadPost(delObj.loginUserID)
            self.delObj.isNewPostAdded = false
            
        }
      
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - Update Device Token API / Webservice
    func updateDeviceToken(notification:NSNotification){
        
        if(delObj.deviceTokenToSend != ""){
        Alamofire.request(.POST, delObj.baseUrl + "updatetoken", parameters : ["userid":delObj.loginUserID,"devicetoken":delObj.deviceTokenToSend]).responseJSON{
            response in
            
            print(response.result.value)
            
            if(response.result.isSuccess){
                print("Device token updated")
            }else{
                print("Device token updation failed")
            }
        }
      }
    }
    
    
//TODO: - Webservice / API call
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
       // self.clearAllArray()
      //  LoadPost(delObj.loginUserID)
        self.mainTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    
    /**
     Clear all array before loading them with new data
     */
    
    func clearAllArray(){
        
        postByNameArray.removeAll(keepCapacity: false)
        postImageArray.removeAll(keepCapacity: false)
        postTextArray.removeAll(keepCapacity:false)
        postIDArray.removeAll(keepCapacity:false)
        postDateArray.removeAll(keepCapacity:false)
        postUserPhotoArray.removeAll(keepCapacity: false)
        imageAvailableArray.removeAll(keepCapacity: false)
        postbyidArray.removeAll(keepCapacity: false)
        postbyProfile_type.removeAll(keepCapacity: false)
        postByArray.removeAll(keepCapacity: false)
        postLikeArray.removeAll(keepCapacity: false)
        isPostLikeArray.removeAll(keepCapacity: false)
    }
    
    /**
     Fetch all post to Home screen
     
     - parameter uID: Login UserID
     */
    func LoadPost(uID : String){
        
        if(!isWSCall){
        SVProgressHUD.showWithStatus("Loading..")
        self.isWSCall = true
        var tmpIndex : String = String()
        
        if(self.postIDArray.count>0){
            tmpIndex = String(self.postIDArray.count)
        }else{
            tmpIndex = "0"
        }
        
        let parameters = ["user_id":uID,
                          "index":tmpIndex,
                          "limit":"5"]
        
        print("All Post parameters: \(parameters)")
        
        Alamofire.request(.POST, delObj.baseUrl + "allpost", parameters: parameters).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                   
                    let count = outJSON["data"].array?.count
                    self.isWSCall = false
                    if(count != 0){
                        if let ct = count{
                            
                            for index in 0...ct-1{
                                
                                self.postIsWelcome.append("N")
                                    self.postIDArray.append(outJSON["data"][index]["post_id"].stringValue)
                                    self.postDateArray.append(outJSON["data"][index]["date"].stringValue)
                                    self.postImageArray.append(outJSON["data"][index]["image"].stringValue)
                                    if(outJSON["data"][index]["image"].stringValue != ""){
                                        self.imageAvailableArray.append("1")
                                    }else{
                                        self.imageAvailableArray.append("0")
                                    }
                                    self.postTextArray.append(outJSON["data"][index]["post"].stringValue)
                                
                                
                                if(outJSON["data"][index]["postbyname"].stringValue == "Admin"){
                                    self.postByNameArray.append("examen")
                                }else{
                                    self.postByNameArray.append(outJSON["data"][index]["postbyname"].stringValue)
                                }
                                
                                
                                    //self.postByNameArray.append(outJSON["data"][index]["postbyname"].stringValue)
                                  self.postUserPhotoArray.append(outJSON["data"][index]["user_photo"].stringValue)
                                self.postbyidArray.append(outJSON["data"][index]["postbyid"].stringValue)
                                self.postbyProfile_type.append(outJSON["data"][index]["profile_type"].stringValue)
                                self.postByArray.append(outJSON["data"][index]["postBy"].stringValue)
                                self.postLikeArray.append(outJSON["data"][index]["likes"].stringValue)
                                self.isPostLikeArray.append(outJSON["data"][index]["islike"].stringValue)

                            }//end for loop
                            
                            print("imageAvailableArray: \(self.imageAvailableArray)")
                        }//end ct loop
                        
                        self.mainTableView.hidden = false
                        self.linkView.hidden = true
                        self.mainTableView.reloadData()
                          self.btnLoadNewPostOutlet.hidden = true
                        //self.mainTableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                    }else{
                        //MARK: Check if it's first time or from scrolldown
                        if(self.postIsWelcome.count==0){
                        self.postIsWelcome.append("Y")
                        self.postIDArray.append("0")
                        self.postDateArray.append(self.delObj.created_date) //changed from login
                        self.postImageArray.append("") //Keep this blank
                        self.imageAvailableArray.append("0")
                        self.postTextArray.append(self.welcomeMessageText)
                        self.postByNameArray.append("examen")
                        self.postUserPhotoArray.append(self.delObj.admin_photo_URL) //changed from login
                        self.postbyidArray.append("0")
                        self.postbyProfile_type.append("Public")
                        self.postByArray.append("admin")
                        self.postLikeArray.append("0")
                        self.isPostLikeArray.append("")
                        self.mainTableView.hidden = false
                        self.linkView.hidden = true
                        self.mainTableView.reloadData()
                        self.btnLoadNewPostOutlet.hidden = true
                        }
                    }
                    
                }else{
                    self.isWSCall = false
                    //self.delObj.displayMessage("Examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.isWSCall = false
                self.delObj.displayMessage("Examen", messageText: "Please check internet connection")
                
            }
        }
        }else{
            print("Already WS call")
        }
    }
    
    func getLabelHeight(label: UILabel) -> CGFloat {
        let constraint: CGSize = CGSizeMake(label.frame.size.width, 20000.0)
        var size: CGSize
        let context: NSStringDrawingContext = NSStringDrawingContext()
        let boundingBox: CGSize = label.text!.boundingRectWithSize(constraint, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: context).size
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height))
       // print("Height:\(label) : \(size.height)")
        return size.height
    }
    
    /**
     Web service to Like Post
     
     - parameter uID:       login userID
     - parameter postID:    Post which you want to like
     - parameter indexPath: indexPath for like button
     */
    func likePostClick(uID:String,postID:String,indexPath:Int){
        if(!isWSCall){
            let parameters = ["userid":uID,
                          "postid":postID,
                          ]
        
            print("like Post parameters: \(parameters)")
        
            Alamofire.request(.POST, delObj.baseUrl + "likepost", parameters: parameters).responseJSON{
            response in
            
            print("output\(response.result.value!)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"].stringValue == "1"){
                    let like_count = outJSON["like_count"].stringValue
                    self.postLikeArray[indexPath] = like_count
                    self.isPostLikeArray[indexPath] = "Y"
                    self.isWSCall = false
                    self.mainTableView.reloadData()
                    
                }else{
                    self.isWSCall = false
                    //self.delObj.displayMessage("Examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.isWSCall = false
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
                
            }
        }
     }else{
        print("Already WS call")
     }

    }
    
    /**
     Web service to Dislike Previously like post
     
     - parameter uID:       Loing userID
     - parameter postID:    Post which user want to dislike
     - parameter indexPath: index path for dislike button
     */
    func disLikePostClick(uID:String,postID:String,indexPath:Int){
        if(!isWSCall){
            let parameters = ["userid":uID,
                              "postid":postID,
                              ]
            
            print("All Post parameters: \(parameters)")
            
            Alamofire.request(.POST, delObj.baseUrl + "dislikepost", parameters: parameters).responseJSON{
                response in
                
                print("output\(response.result.value)")
                
                if(response.result.isSuccess){
                    
                    SVProgressHUD.dismiss()
                    let outJSON = JSON(response.result.value!)
                    if(outJSON["status"].stringValue == "1"){
                        let like_count = outJSON["like_count"].stringValue
                        self.postLikeArray[indexPath] = like_count
                        self.isPostLikeArray[indexPath] = "N"
                        self.isWSCall = false
                        self.mainTableView.reloadData()
                        
                    }else{
                        self.isWSCall = false
                    }
                }else{
                    SVProgressHUD.dismiss()
                    self.isWSCall = false
                    self.delObj.displayMessage("Examen", messageText: "Please check internet connection")
                    
                }
            }
        }else{
            print("Already WS call")
        }
        
    }
    
    
//TODO: - UITableViewDatasource Method Implementation
    
    
    //Detect last cell
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastSectionIndex : NSInteger = mainTableView.numberOfSections - 1
        let lastRowIndex : NSInteger = mainTableView.numberOfRowsInSection(lastSectionIndex) - 1
        if(lastRowIndex > 2){
        if (indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex){
            print("You are at last cell")
             LoadPost(delObj.loginUserID)
        }
        }
    }
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postIDArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! HomeTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        // Username
        cell.btnName.setTitle(self.postByNameArray[indexPath.row], forState: UIControlState.Normal)
        cell.btnName.tag = indexPath.row
        cell.btnName.addTarget(self, action:#selector(HomepageViewController.postByNameClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.imgPost.frame.size.width = UIScreen.mainScreen().bounds.width*0.9
        
        //Date
        cell.lblDate.text = postDateArray[indexPath.row]
        
        // Post Description
        cell.lblDescription.text = postTextArray[indexPath.row]
        cell.txtPostData.text = postTextArray[indexPath.row]
        print(cell.lblDescription.text?.characters.count)
        if(self.postIsWelcome[indexPath.row] == "N"){
        if(cell.lblDescription.text?.characters.count >= 150){
            
            var abc : String = (cell.lblDescription.text! as NSString).substringWithRange(NSRange(location: 0, length: 150))
            abc += "...See More"
            cell.lblDescription.text = abc
            let textCount = cell.lblDescription.text?.characters.count
            
            let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: cell.lblDescription.text!)
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: self.cust.FontName, size: 13)!, range: NSMakeRange(0, textCount!))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 6/255, green: 6/255, blue: 6/255, alpha: 1.0), range: NSMakeRange(150, 11))
            
            
            let moreAttributedString : NSMutableAttributedString = NSMutableAttributedString(string: "...See More")
            //moreAttributedString.addAttribute(NSLinkAttributeName, value: "...ReadMore", range: NSRange(location: 0, length: 11))
          
            moreAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 19/255, green: 19/255, blue: 19/255, alpha: 1.0), range: NSMakeRange(0, 11))
            moreAttributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSRange(location: 0, length: 11))
            
             cell.lblDescription.attributedText = attributedString
            
            cell.txtPostData.attributedText = attributedString
           // print(attributedString)
            //selectedItemArray[indexPath.row] = "0"
        }else{
            cell.lblDescription.frame.size = CGSizeMake(cell.lblDescription.frame.width, getLabelHeight(cell.lblDescription))
        }
        }
        // Profile Pic
        cell.imgProfilePic.layer.cornerRadius = cell.imgProfilePic.frame.size.width/2
        cell.imgProfilePic.clipsToBounds = true
        
        cell.imgProfilePic.image = delObj.profilePlaceholder
        if(postUserPhotoArray[indexPath.row] != ""){
         let userProfURL = NSURL(string:postUserPhotoArray[indexPath.row])
            
             cell.imgProfilePic.sd_setImageWithURL(userProfURL, placeholderImage: self.delObj.profilePlaceholder, options: SDWebImageOptions.RefreshCached)
            
        }else{
            cell.imgProfilePic.image = delObj.profilePlaceholder
        }
        
        cell.imgPost.image = self.delObj.userPlaceHolderImage
        
        cell.imgPost.autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin , UIViewAutoresizing.FlexibleHeight , UIViewAutoresizing.FlexibleRightMargin , UIViewAutoresizing.FlexibleLeftMargin , UIViewAutoresizing.FlexibleTopMargin , UIViewAutoresizing.FlexibleWidth]
        cell.imgPost.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        if(imageAvailableArray[indexPath.row] == "1"){
            cell.imgHeightConstraint.constant = cell.imgPost.frame.size.width
            cell.imgPost.hidden = false
            if(postImageArray[indexPath.row] != ""){
                let postURL =  NSURL(string: postImageArray[indexPath.row])
                
                cell.imgPost.sd_setImageWithURL(postURL, placeholderImage: self.delObj.userPlaceHolderImage, options: SDWebImageOptions.RefreshCached)
            
            }else{
                cell.imgProfilePic.image = delObj.userPlaceHolderImage
            }
           // cell.imgPost.image = UIImage(named: postImageArray[indexPath.row])
            
            
        }else{
            cell.imgHeightConstraint.constant = 0
             cell.imgPost.hidden = true
          // cell.imgPost.image = UIImage(named: "blue_bg.png")
        }
        
        //Photo click
        cell.btnProfilePicClick.tag = indexPath.row
        cell.btnProfilePicClick.addTarget(self, action:#selector(HomepageViewController.postByNameClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        
       // MARK: More option
        if(self.postbyidArray[indexPath.row] != self.delObj.loginUserID){
            
            if(self.postbyidArray[indexPath.row] == "0"){
                cell.btnMore.hidden = true
            }else{
                cell.btnMore.hidden = false
            }
            
        }else{
            cell.btnMore.hidden = true
        }
        
        cell.btnMore.tag = indexPath.row
        cell.btnMore.setImage(UIImage(named: "img_more_inner"), forState: .Normal)
        cell.btnMore.setTitle("", forState: .Normal)
        cell.btnMore.addTarget(self, action: #selector(HomepageViewController.btnMoreClick(_:)), forControlEvents: .TouchUpInside)
        
        
        //Sunglasses Emoji
        if self.isPostLikeArray[indexPath.row] == "Y"{
             cell.btnLike.setTitle("\u{1F60E} Like", forState: .Normal)
            cell.btnLike.setTitleColor(likeColor, forState: .Normal)
        }else{
             cell.btnLike.setTitle("Like", forState: .Normal)
           cell.btnLike.setTitleColor(UIColor.grayColor(), forState: .Normal)
        }
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(HomepageViewController.btnLikeClick(_:)), forControlEvents: .TouchUpInside)
        
        
        //Like Counter 
        var likeCount = self.postLikeArray[indexPath.row]
        if likeCount == "0"{
            likeCount = ""
        }else{
            likeCount = likeCount + "  "
        }
        cell.btnOthers.setTitle(likeCount, forState: .Normal)
        cell.btnOthers.tag = indexPath.row
        cell.btnOthers.addTarget(self, action: #selector(HomepageViewController.btnOthersListNavigate(_:)), forControlEvents: .TouchUpInside)
        
        return cell
        
    }
    
    @IBAction func btnOthersListNavigate(sender:UIButton){
        
        print("Others List Navigate At index: \(sender.tag)")
        
       let otherVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherLikeUsersViewController") as! OtherLikeUsersViewController
        otherVC.postID = self.postIDArray[sender.tag]
        self.navigationController?.pushViewController(otherVC, animated: true)
        
    }
    
    
    
    @IBAction func btnLikeClick(sender:UIButton){
        
      print("Like Click At index: \(sender.tag)")
        let postID = self.postIDArray[sender.tag]
        if self.isPostLikeArray[sender.tag] == "Y"{
            //User has already like post, now dislike post
             self.disLikePostClick(delObj.loginUserID, postID: postID, indexPath: sender.tag)
        }else{
            //User has not liked post now allow them to like
             self.likePostClick(delObj.loginUserID, postID: postID, indexPath: sender.tag)
        }
        
        UIView.animateWithDuration(0.6, animations: { 
            sender.transform = CGAffineTransformMakeScale(1.4, 1.4)
            
            
        }) { (value:Bool) in
                //
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                sender.transform = CGAffineTransformIdentity
                sender.tintColor = UIColor(red: CGFloat(0.54), green: CGFloat(0.24), blue: CGFloat(0), alpha: CGFloat(1))
                }, completion: nil)
        }
        
    }
    
    @IBAction func btnMoreClick(sender:UIButton){
        
        let postID = self.postIDArray[sender.tag]
        let reportBy = self.delObj.loginUserID //self.appUserID
        
        let action = UIAlertController(title: "", message: "Perform Following Action", preferredStyle: .ActionSheet)
        
        if(self.postbyidArray[sender.tag] != self.delObj.loginUserID){
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

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let postDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPostDetailViewController") as! PostDetailViewController
        
        postDTVC.username = self.postByNameArray[indexPath.row]
        postDTVC.userlogoUrl = self.postUserPhotoArray[indexPath.row]
        postDTVC.userpostDesc = self.postTextArray[indexPath.row]
        postDTVC.userpostImage = self.postImageArray[indexPath.row]
        postDTVC.userpostdate = self.postDateArray[indexPath.row]
        postDTVC.postByArray = self.postByArray[indexPath.row]
        postDTVC.postbyidArray = self.postbyidArray[indexPath.row]
        postDTVC.postbyProfile_type = self.postbyProfile_type[indexPath.row]
        self.navigationController?.pushViewController(postDTVC, animated: false)
    }
    
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if(imageAvailableArray[indexPath.row] == "1"){
            return 285
        }else{
            return 150
        }
        
        //return 150
    }*/
    
    
    
//TODO: - UIButton Action
    
    @IBAction func btnAddClick(sender: AnyObject) {
        let findFriendVC = self.storyboard?.instantiateViewControllerWithIdentifier("idFindFriendsViewController") as! FindFriendsViewController
        self.navigationController?.pushViewController(findFriendVC, animated: true)
    }
    
     @IBAction func postByNameClick(sender: AnyObject){
         let index = sender.tag
        print(self.postByArray)
        if(self.postByArray[index] == "charity"){
            let charityDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idCharityDetailViewController") as! CharityDetailViewController
            charityDTVC.charityID = self.postbyidArray[index]
            self.navigationController?.pushViewController(charityDTVC, animated: true)
        }else if(self.postByArray[index] == "business"){
            let businessDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherBusinessProfileViewController") as! OtherBusinessProfileViewController
            businessDTVC.reqUserID = self.postbyidArray[index]
            self.navigationController?.pushViewController(businessDTVC, animated: true)
        }else if(self.postByArray[index] == "user"){
        
            print("self.appUserID\(self.delObj.loginUserID)")
            print("self.postbyidArray[index]\(self.postbyidArray[index])")
            if(self.postbyidArray[index] != self.delObj.loginUserID){
                //Check if user is same as app user
                let otherUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
       
                otherUserVC.reqUserID = self.postbyidArray[index]
                otherUserVC.reqProfileType = self.postbyProfile_type[index]
        
                self.navigationController?.pushViewController(otherUserVC, animated: true)
            }
        }
    }
    
    @IBAction func btnLoadNewPostClick(sender: AnyObject) {
        self.clearAllArray()
        LoadPost(delObj.loginUserID)
        self.delObj.isNewPostAdded = false
    }
    
    @IBAction func btnPostClick(sender: AnyObject) {
        let postVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAddPostViewController") as! AddPostViewController
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
    
    
    @IBAction func btnInviteClick(sender: AnyObject) {
        
        let shareVC = self.storyboard?.instantiateViewControllerWithIdentifier("idInviteFriendsViewController") as! InviteFriendsViewController
        
        self.navigationController?.pushViewController(shareVC, animated: true)

        
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
