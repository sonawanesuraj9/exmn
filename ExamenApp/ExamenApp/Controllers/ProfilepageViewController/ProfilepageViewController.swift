//
//  ProfilepageViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/2/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices


//==================================================================================


//==================================================================================


class ProfilepageViewController: UIViewController,SFSafariViewControllerDelegate, UIScrollViewDelegate {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    //Gesture recognizer
    let followersTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    let followingTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    let requestTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    
  
    
//TODO: - Controls
    /******** Personal View**/
    
    var containerView : UIView = UIView()
    @IBOutlet var heightConstraintForTopView: NSLayoutConstraint!
   // @IBOutlet weak var txtAboutMe: UILabel!
    @IBOutlet weak var experienceView: UIView!
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var lblAboutMe: UILabel!
    //@IBOutlet weak var lblUserLocation: UILabel!
    @IBOutlet weak var lblUserFullName: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var imgCoverPic: UIImageView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var btnEditCharityOutlet: UIButton!
    
    @IBOutlet weak var lblNonProfitTitle: UILabel!
   
    @IBOutlet weak var lblRequestTitle: UILabel!
    @IBOutlet weak var lblFollowersTitle: UILabel!
    @IBOutlet weak var lblFollowingTitle: UILabel!
    @IBOutlet weak var btnViewUsersPostOutlet: UIButton!
    @IBOutlet weak var btnRequestOutlet: UIButton!
    @IBOutlet weak var btnFollowerOutlet: UIButton!
    @IBOutlet weak var btnFollowingOutlet: UIButton!
    // Charity Details
  //  @IBOutlet weak var imgCharityLogo: UIImageView!
   // @IBOutlet weak var lblCharityDesc: UILabel!
    @IBOutlet weak var lblCharityWebsite: UIButton!
    @IBOutlet weak var lblCharityName: UILabel!
    
   // @IBOutlet weak var imgBusCharityLogo: UIImageView!
    @IBOutlet weak var lblBusCharityName: UILabel!
    @IBOutlet weak var btnBusCharityWebsite: UIButton!
  //  @IBOutlet weak var lblBusCharityDesc: UILabel!
    
    
    /******** Personal View**/
    
    /******** Busienss View**/
   // @IBOutlet weak var btnBusinessPostOutlet: UIButton!
    @IBOutlet weak var lblVolResumeTitle: UILabel!
    @IBOutlet weak var lblCharitySpotTitle: UILabel!
    @IBOutlet weak var lblOutlineOfCause: UILabel!
    @IBOutlet weak var lblIntroduction: UILabel!
    @IBOutlet weak var introdutionView: UIView!
    @IBOutlet weak var businessScroll: UIScrollView!
    @IBOutlet weak var businessView: UIView!
    /******** Busienss View**/
    
    
    @IBOutlet weak var personalView: UIView!
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Profile Page")
        
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
         self.delObj.isNewTimeUser = false
        
        
        if(self.delObj.is_loginUserBusiness){
            self.businessView.hidden = false
            self.personalView.hidden = true
            self.btnFollowingOutlet.hidden = true
            self.lblFollowingTitle.hidden = true
            self.btnRequestOutlet.hidden = true
            self.lblRequestTitle.hidden = true
            self.btnFollowerOutlet.setTitle("-", forState: UIControlState.Normal)
            self.heightConstraintForTopView.constant = 50
            
        }else{
            self.heightConstraintForTopView.constant = 80
            self.businessView.hidden = true
            self.personalView.hidden = false
        
        }
        self.delObj.is_editResume = false
        roundedCorerImageView()
        initializeUserDetails()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
       
        //mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.width, self.mainScrollView.frame.height + 130)
       //txtAboutMe.text = ""\u{1F44d}
        //let tmpText : NSString = "non-profit resume \u{00c9cole}"
      //  self.lblNonProfitTitle.text = "non-profit resume \u{00c9cole}"
        businessScroll.delegate = self
        if(self.delObj.is_loginUserBusiness){
        businessScroll.contentSize = CGSizeMake(self.businessScroll.frame.width, self.lblOutlineOfCause.frame.origin.y + self.lblOutlineOfCause.frame.height + 30)
        }
        mainScrollView.delegate = self
       
       fetchVolunteerActivity()
        
    }
    
    func roundedCorerImageView(){
        
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.bounds.width / 2
        self.imgProfilePic.clipsToBounds = true
        self.imgProfilePic.layer.borderColor = UIColor.whiteColor().CGColor
        self.imgProfilePic.layer.borderWidth = 1.0
    }
    
    func removeControllsFromSubView()
    {
        for view in mainScrollView.subviews {
            view.removeFromSuperview()
        }
        
    }
    
    func dynamicallycreateView(){
        
       
        for view in self.containerView.subviews {
            view.removeFromSuperview()
        }
        
        let imageWidth:CGFloat = UIScreen.mainScreen().bounds.width * 0.95
        let lableWidth : CGFloat = UIScreen.mainScreen().bounds.width / 1.4
        let lableHeight : CGFloat = 21
        let imageHeight:CGFloat = 70
        var yPosition:CGFloat =  thirdView.frame.origin.y + thirdView.frame.size.height + 10 //firstView.frame.origin.y + firstView.frame.size.height + 10
        print("yPosition: \(yPosition)")
        let TopViewSpacer = yPosition
        var scrollViewContentSize:CGFloat=0;
        let totalCount = self.delObj.selectedIDArray_nonprofit.count
        if(totalCount>0){
            
        for index in 0 ..< totalCount
        {
            print(index)
            
            //let myImage:UIImage = UIImage(named: myImages[index])!
            let myView:UIView = UIView()
            myView.backgroundColor = UIColor.whiteColor()
            
            myView.frame.size.width = imageWidth
            myView.frame.size.height = imageHeight
            myView.center = self.view.center
            myView.frame.origin.y = yPosition
            
            
            
            /*
             Border
             */
            
           /* myView.layer.borderWidth = 1
            myView.layer.cornerRadius = 5
            myView.layer.borderColor = UIColor.lightGrayColor().CGColor*/
            /*
             Border Ends
             */
            
            let lblTitle : UILabel = UILabel()
            lblTitle.textColor = UIColor.blackColor()
            lblTitle.frame = CGRectMake(8, 0, lableWidth, lableHeight)
            lblTitle.font = UIFont(name: cust.FontNameBold, size: 13)
            //lblTitle.text = self.delObj.selectedCompanyArray_nonprofit[index]
            
            let role =  " " + self.delObj.selectedTitleArray_nonprofit[index]
            let company = self.delObj.selectedCompanyArray_nonprofit[index]
            
            //Attributed Label
            let attributedString = NSMutableAttributedString(string:company)
            
            attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: self.cust.FontNameBold, size: 13)!, range: NSRange(location: 0,length:company.characters.count))
            
            let gString = NSMutableAttributedString(string:role)
            gString.addAttribute(NSFontAttributeName, value: UIFont(name: self.cust.FontName, size: 12)!, range: NSRange(location: 0,length: role.characters.count))
            
            attributedString.appendAttributedString(gString)
            lblTitle.attributedText = attributedString
            
            
            //Go aher
            let lblOrg : UIButton = UIButton(type: .System)
             lblOrg.frame = CGRectMake(8, 22, lableWidth, lableHeight)
             lblOrg.titleLabel!.font =  UIFont(name: cust.FontName, size: 12)
            lblOrg.titleLabel?.textAlignment = .Left
            lblOrg.setTitle(self.delObj.selectedWebsiteArray_nonprofit[index], forState: .Normal)
            lblOrg.tag = index
            lblOrg.contentHorizontalAlignment = .Left
            lblOrg.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            lblOrg.addTarget(self, action: #selector(ProfilepageViewController.btnWebClick(_:)), forControlEvents: .TouchUpInside)
           
            
            
            let lblDuration : UILabel = UILabel()
            lblDuration.textColor = UIColor.blackColor()
            lblDuration.frame = CGRectMake(8, 44, lableWidth, lableHeight)
            lblDuration.font = UIFont(name: cust.FontName, size: 12)
            if(self.delObj.selectedIsPresentArray_nonprofit[index] == "Y"){
                lblDuration.text = self.delObj.selectedStartDateArray_nonprofit[index] + " - " + "present"
            }else{
                lblDuration.text = self.delObj.selectedStartDateArray_nonprofit[index] + " - " + self.delObj.selectedEndDateArray_nonprofit[index]
            }
            
            
            let lblSeperator : UILabel = UILabel()
            lblSeperator.frame = CGRectMake(8, 70, UIScreen.mainScreen().bounds.width/1.1, 1)
            lblSeperator.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
            
            myView.addSubview(lblSeperator)
            myView.addSubview(lblOrg)
            myView.addSubview(lblDuration)
            myView.addSubview(lblTitle)
            //myView.addSubview(profImage)
            
            self.containerView.addSubview(myView)
            
            let spacer:CGFloat = 1
            
            yPosition+=imageHeight + spacer
            scrollViewContentSize+=imageHeight + spacer + (CGFloat(TopViewSpacer) / CGFloat(totalCount))
            
            mainScrollView.contentSize = CGSizeMake(imageWidth, scrollViewContentSize + 16)
            
        }
            mainScrollView.addSubview(containerView)
            
        }
       /*
        let btnPostByUser : UIButton = UIButton()
        btnPostByUser.frame = CGRectMake(8, yPosition+16, imageWidth, 35)
        btnPostByUser.setTitle("post by user", forState: UIControlState.Normal)
        btnPostByUser.titleLabel?.font = UIFont(name: cust.FontName, size: 14)
        btnPostByUser.backgroundColor = UIColor(red: 39/255, green: 69/255, blue: 117/255, alpha: 1.0)
        btnPostByUser.layer.cornerRadius = cust.RounderCornerRadious
        btnPostByUser.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btnPostByUser.addTarget(self, action: #selector(ProfilepageViewController.btnPostByUserClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        mainScrollView.addSubview(btnPostByUser)
        
         mainScrollView.contentSize = CGSize(width: imageWidth, height: scrollViewContentSize + (btnPostByUser.frame.height + 16))*/
        
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeUserDetails(){
        var profURL : String = String()
        var coverURL : String = String()
        
        self.btnViewUsersPostOutlet.layer.cornerRadius = self.cust.RounderCornerRadious
        //self.btnBusinessPostOutlet.layer.cornerRadius = self.cust.RounderCornerRadious
        //1
        self.lblFollowersTitle.userInteractionEnabled = true
        followersTapGesture.addTarget(self, action: #selector(ProfilepageViewController.btnFollowersClick))
        self.lblFollowersTitle.addGestureRecognizer(followersTapGesture)
        
        //2
        self.lblFollowingTitle.userInteractionEnabled = true
        followingTapGesture.addTarget(self, action: #selector(ProfilepageViewController.btnFollowingClick))
        self.lblFollowingTitle.addGestureRecognizer(followingTapGesture)
        
        //3
        self.lblRequestTitle.userInteractionEnabled = true
        requestTapGesture.addTarget(self, action: #selector(ProfilepageViewController.btnRequestClick))
        self.lblRequestTitle.addGestureRecognizer(requestTapGesture)
        
        
        //Notificatoin information
        self.btnFollowerOutlet.setTitle("-", forState: UIControlState.Normal)
        self.btnFollowingOutlet.setTitle("-", forState: UIControlState.Normal)
        self.btnRequestOutlet.setTitle("-", forState: UIControlState.Normal)
        
        fetchNotificationCount()
        
        //Corner Rad
        self.lblCharitySpotTitle.layer.cornerRadius = 5
        self.lblCharitySpotTitle.clipsToBounds = true
        self.lblVolResumeTitle.layer.cornerRadius = 5
        self.lblVolResumeTitle.clipsToBounds = true
        //Charity Informaiton
        //lblCharityDesc.hidden = true
        if defaults.valueForKey("loginUsercharityDetails") != nil{
            
            let charityDictonary = defaults.valueForKey("loginUsercharityDetails") as! NSDictionary
            
            print("charityDictonary:\(charityDictonary)")
            
            //let tmpCharityName = charityDictonary["charity_name"] as? String
            
            //check if charity was inserted at the time of register
            
                //Charity data Available
                
                self.lblCharityWebsite.hidden = true
                self.lblCharityName.text = charityDictonary["charity_name"] as? String
                if(charityDictonary["charity_website"] as? String != ""){
                    self.lblCharityWebsite.hidden = false
                    self.lblCharityWebsite.setTitle(charityDictonary["charity_website"] as? String, forState: UIControlState.Normal)
                }
            
                //Set data for business profile 
                self.lblBusCharityName.text = charityDictonary["charity_name"] as? String
                if(self.lblBusCharityName.text == ""){
                    //MARK: Hide logo if not uploaded
                   // self.imgBusCharityLogo.hidden = true
                }
                if(charityDictonary["charity_website"] as? String != ""){
                    self.btnBusCharityWebsite.hidden = false
                    self.btnBusCharityWebsite.setTitle(charityDictonary["charity_website"] as? String, forState: UIControlState.Normal)
                }
               
            //}
            
        }else{
            
        }
        
        //business profile
        if (defaults.valueForKey("busienssProfileDetalis") != nil){
             let busienssProfileDetalis = defaults.valueForKey("busienssProfileDetalis") as! NSDictionary
            self.lblIntroduction.text = busienssProfileDetalis["intro"] as? String
            self.lblOutlineOfCause.text = busienssProfileDetalis["outline"] as? String
           
        }
        
        
        /**************************************************/
        
        //Personal informaiton
        if defaults.valueForKey("loginUserDetalis") != nil{
            
            let loginUserDetalis = defaults.valueForKey("loginUserDetalis") as! NSDictionary
            print(loginUserDetalis)
            let fname = loginUserDetalis["fname"] as! String
            let lname = loginUserDetalis["lname"] as! String
            let city_State = loginUserDetalis["city_State"] as! String
            self.lblUserFullName.text = fname + " " + lname + " " + city_State
            self.lblAboutMe.text = loginUserDetalis["about_me"] as? String
            
        
            profURL = General.loadSaved("userProfilePhoto")
            coverURL = General.loadSaved("userCoverPhoto")
            
           
            
            //self.imgCoverPic.hidden = true
            
            if(profURL != ""){
                
                
                SDImageCache.sharedImageCache().queryDiskCacheForKey(profURL) { ( img:UIImage!, cacheType:SDImageCacheType) -> Void in
                    if(img != nil){
                        
                        //  self.imgProfilePic.image = self.rotateImageToActual(img)
                        self.imgProfilePic.image = self.cust.rotateCameraImageToProperOrientation(img,maxResolution: 360)
                    }else{
                        //self.cust.showLoadingCircle()
                        Alamofire.request(.GET, profURL)
                            .response { request, response, data, error in
                                print(request)
                               
                                
                                if(data != nil){
                                    let image = UIImage(data: data! )
                                    SDImageCache.sharedImageCache().storeImage(image, forKey: profURL)
                                    self.imgProfilePic.image = self.cust.rotateCameraImageToProperOrientation(image!,maxResolution: 360)
                                    //  self.imgProfilePic.image = self.rotateImageToActual(image!)
                                    
                                }else{
                                    //Display placeholder
                                    self.imgProfilePic.image = self.delObj.userPlaceHolderImage
                                }
                        }
                    }
                }
            }else{
                self.imgProfilePic.image = self.delObj.userPlaceHolderImage
            }
            
            
            if(coverURL != ""){
                // self.imgCoverPic.hidden = false
                self.imgCoverPic.image = self.delObj.coverPlaceholder
                SDImageCache.sharedImageCache().queryDiskCacheForKey(coverURL) { ( img:UIImage!, cacheType:SDImageCacheType) -> Void in
                    if(img != nil){
                        
                        //  self.imgProfilePic.image = self.rotateImageToActual(img)
                         self.imgCoverPic.image = img
                    }else{
                        //self.cust.showLoadingCircle()
                        self.imgCoverPic.hidden = false
                         Alamofire.request(.GET, coverURL)
                            .response { request, response, data, error in
                                print(request)
                                print(response)
                               // print(data)
                               // print(error)
                                
                                if(data != nil){
                                    let image = UIImage(data: data! )
                                    SDImageCache.sharedImageCache().storeImage(image, forKey: coverURL)
                                    self.imgCoverPic.image = image
                                    //  self.imgProfilePic.image = self.rotateImageToActual(image!)
                                    
                                }else{
                                   // self.imgCoverPic.hidden = true
                                    //Display placeholder
                                    self.imgCoverPic.image = self.delObj.coverPlaceholder
                                }
                        }
                    }
                }
            }else{
               self.imgCoverPic.image = self.delObj.coverPlaceholder
            }
            
        }else{
            
            //Noting to display
        }
        
        

    }

//TODO: - Web service / API implementation
    
    func fetchNotificationCount(){
        SVProgressHUD.showWithStatus("Loading...")
        
        Alamofire.request(.POST, delObj.baseUrl + "countlist", parameters: ["userid":self.delObj.loginUserID]).responseJSON{
            response in
            
            print("output::\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let followers = outJSON["data"]["user_followers"].stringValue
                    let following = outJSON["data"]["user_followings"].stringValue
                    let request = outJSON["data"]["request"].stringValue
                    
                    let notificationDetails = ["user_followers":followers,
                                                "user_followings":following,
                                                "user_request":request]
                    
                     self.defaults.setValue(notificationDetails, forKey: "notificationDetails")
                    self.btnFollowerOutlet.setTitle(followers, forState: UIControlState.Normal)
                    self.btnFollowingOutlet.setTitle(following, forState: UIControlState.Normal)
                    self.btnRequestOutlet.setTitle(request, forState: UIControlState.Normal)
                   
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "Please check internet connection")
                
            }
        }
    }
    
    func clearVolunteer(){
        //sgnup scenario
        self.delObj.selectedIDArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedWebsiteArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedTitleArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedCompanyArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedStartDateArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedEndDateArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedIsPresentArray_nonprofit.removeAll(keepCapacity: false)
        dynamicallycreateView()
    }
    
    func fetchVolunteerActivity(){
        SVProgressHUD.showWithStatus("Loading...")
        
        Alamofire.request(.POST, delObj.baseUrl + "viewnonpro", parameters: ["userid":self.delObj.loginUserID]).responseJSON{
            response in
            
            print("output::\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    let count = outJSON["response"].array?.count
                    if(count != 0){
                        self.clearVolunteer()
                        if let ct = count{
                            for index in 0...ct-1{
                                
                                self.delObj.selectedCompanyArray_nonprofit.append(outJSON["response"][index]["company_name"].stringValue)
                                self.delObj.selectedIDArray_nonprofit.append(outJSON["response"][index]["id"].stringValue)
                                self.delObj.selectedTitleArray_nonprofit.append(outJSON["response"][index]["role"].stringValue)
                                self.delObj.selectedWebsiteArray_nonprofit.append(outJSON["response"][index]["website"].stringValue)
                                self.delObj.selectedStartDateArray_nonprofit.append(outJSON["response"][index]["start_date"].stringValue)
                                self.delObj.selectedEndDateArray_nonprofit.append(outJSON["response"][index]["end_date"].stringValue)
                                self.delObj.selectedIsPresentArray_nonprofit.append(outJSON["response"][index]["is_present"].stringValue)
                                
                            }//end for loop
                            
                           print("selectedTitleArray_nonprofit: \(self.delObj.selectedTitleArray_nonprofit)")
                            self.dynamicallycreateView()
                            
                            
                            
                        }
                    }
                    
                    
                }else{
                    //self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    self.clearVolunteer()
                }
            }else{
                SVProgressHUD.dismiss()
                //self.delObj.displayMessage("examen", messageText: "Please check internet connection")
                
            }
        }
    }
    

//TODO: - UIButton Action
    @IBAction func btnWebClick(sender: AnyObject) {
        print("sender:\(sender.tag)")
        print("All:\(self.delObj.selectedWebsiteArray_nonprofit[sender.tag])")
        var url = self.delObj.selectedWebsiteArray_nonprofit[sender.tag]
        
        if url.lowercaseString.rangeOfString("http://") != nil {
            print("exists")
        }else{
            url = "http://" + url
        }
        
        
        if(UIApplication.sharedApplication().canOpenURL(NSURL(string: url)!)){
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
       
    }
        
        
    @IBAction func btnViewUsersPostClick(sender: AnyObject) {
        //Call new view controller
        
        let postVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPostByUserViewController") as! PostByUserViewController
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
    
    @IBAction func lblCharityWebsiteClick(sender: AnyObject) {
        var url = self.lblCharityWebsite.titleLabel?.text
        if url!.lowercaseString.rangeOfString("http://") != nil {
            print("exists")
        }else{
            url = "http://" + url!
        }
        
        if(UIApplication.sharedApplication().canOpenURL(NSURL(string: url!)!)){
            UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
        }
    }
    
    @IBAction func btnEditProfileClick(sender: AnyObject) {
        let editVC = self.storyboard?.instantiateViewControllerWithIdentifier("idEditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func btnFollowingClick(sender: AnyObject) {
        let followingVC = self.storyboard?.instantiateViewControllerWithIdentifier("idFollowingViewController") as! FollowingViewController
        followingVC.viewID = self.delObj.loginUserID
        self.navigationController?.pushViewController(followingVC, animated: true)
    }
    
    @IBAction func btnFollowersClick(sender: AnyObject) {
        let followersVC =
            self.storyboard?.instantiateViewControllerWithIdentifier("idFollowersViewController") as! FollowersViewController
        followersVC.selectedType = "user"
        print("self.delObj.loginUserID:\(self.delObj.loginUserID )")
         followersVC.viewID = self.delObj.loginUserID
        self.navigationController?.pushViewController(followersVC, animated: true)
    }
    
    @IBAction func btnRequestClick(sender: AnyObject) {
        
        let reqVC = self.storyboard?.instantiateViewControllerWithIdentifier("idRequestsViewController") as! RequestsViewController
        self.navigationController?.pushViewController(reqVC, animated: true)
        
    }
    
    @IBAction func btnEditNonProfitClick(sender: AnyObject) {
        
        let addVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAddNonProfitTableViewController") as! AddNonProfitTableViewController
        self.delObj.is_editResume = true
        self.presentViewController(addVC, animated: true, completion: nil)
    }
    
    @IBAction func btnEditCharityClick(sender: AnyObject) {
        self.delObj.is_updateCharity = true
        let editChVC = self.storyboard?.instantiateViewControllerWithIdentifier("idUpdateCharityViewController") as! UpdateCharityViewController
        self.navigationController?.pushViewController(editChVC, animated: true)
    }
    
    @IBAction func btnAddPostClick(sender: AnyObject) {
        let addPostVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAddPostViewController") as! AddPostViewController
        self.navigationController?.pushViewController(addPostVC, animated: true)
    }
    
    
}
