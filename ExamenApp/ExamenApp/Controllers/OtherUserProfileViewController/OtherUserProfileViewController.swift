//
//  OtherUserProfileViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 6/3/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices


class OtherUserProfileViewController: UIViewController,SFSafariViewControllerDelegate {

    
//TODO: - General
    let defaults = NSUserDefaults.standardUserDefaults()
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    
    var coverImage : String = String()
    var profleImage : String = String()
    var charityLogo : String = String()
    var is_alreadyRequest : Bool = Bool()
    var is_alreadyFollow : Bool = Bool()
    var is_userPublic : Bool = Bool()
    
    
    //Volunteer Array
    var CompanyArray_nonprofit : [String] = []
    var IDArray_nonprofit  : [String] = []
    var websiteArray_nonprofit : [String] = []
    var TitleArray_nonprofit : [String] = []
    var StartDateArray_nonprofit : [String] = []
    var EndDateArray_nonprofit : [String] = []
    var IsPresentArray_nonprofit : [String] = []
    
    //data from previous screen
    
    var reqUserID : String = String()
    var reqProfileType : String = String()
    
    
//TODO: - Controls
    
    //CoverView
    
    @IBOutlet weak var lblAboutMe: UILabel!
    //@IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var imgCoverPic: UIImageView!
    
    //Notification View
    
    @IBOutlet weak var btnRequestOutlet: UIButton!
    @IBOutlet weak var btnFollowingOutlet: UIButton!
   
    @IBOutlet weak var btnFollowersOutlet: UIButton!
    
    //ScrollView
    
    @IBOutlet weak var mainScroll: UIScrollView!
    
 //   @IBOutlet weak var firstView: UIView!
   // @IBOutlet weak var lblAboutUser: UILabel!
    @IBOutlet weak var lblFirstSeperator: UILabel!
    
    @IBOutlet weak var lblCharitySpotlight: UILabel!
    
    @IBOutlet weak var secondView: UIView!
    //@IBOutlet weak var imgCharityLogo: UIImageView!
    @IBOutlet weak var lblCharityName: UILabel!
    @IBOutlet weak var btnCharityWebsite: UIButton!
    //@IBOutlet weak var lblCharityDesc: UILabel!
    
    @IBOutlet weak var lblNonProfitResume: UILabel!
    
    @IBOutlet weak var thirdView: UIView!
    
//TODO: - Let's Play

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if(self.delObj.is_loginUserBusiness){
            self.btnRequestOutlet.hidden = true
        }else{
             self.btnRequestOutlet.hidden = false
        }
        roundedCorerImageView()
        initializeUserDetails()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
      self.clearNonProfitArray()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
    func initializeUserDetails(){
        self.btnRequestOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnFollowersOutlet.setTitle("-", forState: UIControlState.Normal)
         self.btnFollowingOutlet.setTitle("-", forState: UIControlState.Normal)
        self.lblName.text = ""
        //self.lblLocation.text = ""
       // self.lblAboutUser.text = ""
       // self.lblCharityDesc.text = ""
        self.lblCharityName.text = ""
        
       for i in 0..<self.delObj.keepFollowstatusArray.count{
            if(self.delObj.keepIDArray[i] == self.reqUserID){
                if(self.delObj.keepFollowstatusArray[i] == "N"){
                    self.btnRequestOutlet.setTitle("request to follow", forState: UIControlState.Normal)
                }else{
                    
                    self.btnRequestOutlet.setTitle("requested", forState: UIControlState.Normal)
                }
            }
        }

        
        if(reqProfileType == "Public"){
            is_userPublic = true
            self.btnRequestOutlet.setTitle("follow", forState: UIControlState.Normal)
        }else{
          //  firstView.hidden = true
            lblFirstSeperator.hidden = true
            lblCharitySpotlight.hidden = true
            secondView.hidden = true
            self.view.layoutIfNeeded()
            is_userPublic = false
            self.btnRequestOutlet.setTitle("request to follow", forState: UIControlState.Normal)
        }
        
        
        //Charity Informaiton
       // lblCharityDesc.hidden = true
        
       // self.imgCharityLogo.layer.cornerRadius = self.imgCharityLogo.frame.size.width/2
       // self.imgCharityLogo.clipsToBounds = true
       
        self.lblCharitySpotlight.layer.cornerRadius = 5
        self.lblCharitySpotlight.clipsToBounds = true
        self.lblNonProfitResume.layer.cornerRadius = 5
        self.lblNonProfitResume.clipsToBounds = true
        
        self.fetchUserDetails()
        
    }
    
    func roundedCorerImageView(){
        
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.bounds.width / 2
        self.imgProfilePic.clipsToBounds = true
        self.imgProfilePic.layer.borderColor = UIColor.whiteColor().CGColor
        self.imgProfilePic.layer.borderWidth = 1.0
    }
    
    func dynamicallycreateView(){
        
        
        
        let imageWidth:CGFloat = UIScreen.mainScreen().bounds.width * 0.95
        let lableWidth : CGFloat = UIScreen.mainScreen().bounds.width / 1.4
        let lableHeight : CGFloat = 21
        let imageHeight:CGFloat = 90
        var yPosition:CGFloat=CGFloat()
        yPosition =  lblNonProfitResume.frame.origin.y + lblNonProfitResume.frame.size.height + 10
        
        /*if(reqProfileType == "Public"){
            yPosition =  thirdView.frame.origin.y + thirdView.frame.size.height + 10
        }else{
            yPosition =  firstView.frame.origin.y
            //firstView.frame.origin.y + firstView.frame.size.height + 10
        }*/
        print("yPosition: \(yPosition)")
        print("thirdView: \(lblNonProfitResume.frame)")
        let TopViewSpacer = yPosition
        var scrollViewContentSize:CGFloat=0;
        let count_all = self.IDArray_nonprofit.count
        for index in 0 ..< count_all
        {
            print(index)
            
            //let myImage:UIImage = UIImage(named: myImages[index])!
            let myView:UIView = UIView()
            myView.backgroundColor = UIColor.whiteColor()
            
            myView.frame.size.width = imageWidth
            myView.frame.size.height = imageHeight
            myView.center = self.view.center
            myView.frame.origin.y = yPosition
            
            
            /********** Rounded Image View Starts **********/
            
           // let profImage : UIImageView = UIImageView()
           /* let profURL = self.LogoURL_nonprofit[index]
            if(profURL != ""){
                
                
                SDImageCache.sharedImageCache().queryDiskCacheForKey(profURL) { ( img:UIImage!, cacheType:SDImageCacheType) -> Void in
                    if(img != nil){
                        profImage.image = self.cust.rotateCameraImageToProperOrientation(img,maxResolution: 360)
                    }else{
                         Alamofire.request(.GET, profURL)
                            .response { request, response, data, error in
                                print(request)
                                
                                
                                if(data != nil){
                                    let image = UIImage(data: data! )
                                    if(image != nil){
                                    SDImageCache.sharedImageCache().storeImage(image, forKey: profURL)
                                    profImage.image = self.cust.rotateCameraImageToProperOrientation(image!,maxResolution: 360)
                                    }
                                    
                                }else{
                                    //Display placeholder
                                    profImage.image = UIImage(named: "profile-placeholder")
                                }
                        }
                    }
                }
            }else{
                profImage.image = UIImage(named: "profile-placeholder")
            }

            profImage.frame = CGRectMake(8, 8, 70, 70)
            profImage.layer.cornerRadius = profImage.frame.size.width/2
            profImage.clipsToBounds = true*/
            /********** Rounded Image View ends **********/
           
            /********** Title Label Starts **********/
            
            let lblTitle : UILabel = UILabel()
            lblTitle.textColor = UIColor.blackColor()
            lblTitle.frame = CGRectMake(8, 8, lableWidth, lableHeight)
            lblTitle.font = UIFont(name: cust.FontNameBold, size: 13)
            lblTitle.text = self.TitleArray_nonprofit[index]
            /********** Title Label ends **********/
            
             /********** Organization Label Starts **********/
            let lblOrg : UILabel = UILabel()
            lblOrg.textColor = UIColor.blackColor()
            lblOrg.frame = CGRectMake(8, 30, lableWidth, lableHeight)
            lblOrg.font = UIFont(name: cust.FontName, size: 12)
            lblOrg.text = self.CompanyArray_nonprofit[index]
             /********** Organization Label Ends **********/
            
             /********** Duration Label Starts **********/
            let lblDuration : UILabel = UILabel()
            lblDuration.textColor = UIColor.blackColor()
            lblDuration.frame = CGRectMake(8, 52, lableWidth, lableHeight)
            lblDuration.font = UIFont(name: cust.FontName, size: 12)
            if(self.IsPresentArray_nonprofit[index] == "Y"){
                lblDuration.text = self.StartDateArray_nonprofit[index] + " - " + "present"
            }else{
                lblDuration.text = self.StartDateArray_nonprofit[index] + " - " + self.EndDateArray_nonprofit[index]
            }
            /********** Duration Label Starts **********/
            
            let lblSeperator : UILabel = UILabel()
            lblSeperator.frame = CGRectMake(8, 90, UIScreen.mainScreen().bounds.width/1.1, 1)
            lblSeperator.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
            
            myView.addSubview(lblSeperator)
            myView.addSubview(lblOrg)
            myView.addSubview(lblDuration)
            myView.addSubview(lblTitle)
            //myView.addSubview(profImage)
            
            mainScroll.addSubview(myView)
            
            let spacer:CGFloat = 1
            
            yPosition+=imageHeight + spacer
            scrollViewContentSize+=imageHeight + spacer + (CGFloat(TopViewSpacer) / CGFloat(count_all))
            
            mainScroll.contentSize = CGSize(width: imageWidth, height: scrollViewContentSize)
            
        }
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - API/Web service call
    
    func clearNonProfitArray(){
        self.CompanyArray_nonprofit.removeAll(keepCapacity: false)
        self.IDArray_nonprofit.removeAll(keepCapacity: false)
        self.websiteArray_nonprofit.removeAll(keepCapacity: false)
        self.TitleArray_nonprofit.removeAll(keepCapacity: false)
        self.StartDateArray_nonprofit.removeAll(keepCapacity: false)
        self.EndDateArray_nonprofit.removeAll(keepCapacity: false)
        self.IsPresentArray_nonprofit.removeAll(keepCapacity: false)
        //self.dynamicallycreateView()
    }
    
    func fetchUserDetails(){
        
        SVProgressHUD.showWithStatus("Loading...")
        print("reqUserID:\(reqUserID)")
        Alamofire.request(.POST, delObj.baseUrl + "getprofile", parameters: ["userid":self.delObj.loginUserID ,"pid":reqUserID]).responseJSON{
            response in
            print("reqUserID:\(self.reqUserID)")
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                   
                  //  self.lblLocation.text = outJSON["data"]["city"].stringValue  + ", " + outJSON["data"]["state"].stringValue
                    self.coverImage = outJSON["data"]["cover_photo"].stringValue
                    self.profleImage =  outJSON["data"]["profile_photo"].stringValue
                    self.lblName.text = outJSON["data"]["first_name"].stringValue + " " + outJSON["data"]["last_name"].stringValue + " " + outJSON["data"]["city"].stringValue  + ", " + outJSON["data"]["state"].stringValue
                    self.lblAboutMe.text = outJSON["data"]["about_me"].stringValue
                    
                    self.lblCharityName.text = outJSON["data"]["charity_supported"]["charity_name"].stringValue
                    self.btnCharityWebsite.setTitle(outJSON["data"]["charity_supported"]["website"].stringValue, forState: UIControlState.Normal)
                    self.charityLogo = outJSON["data"]["charity_supported"]["charity_logo"].stringValue
                    
                    self.reqProfileType = outJSON["data"]["profile_type"].stringValue
                    if( outJSON["data"]["profile_type"].stringValue == "Private"){
                        if(outJSON["data"]["requestsent"].stringValue == "Y"){
                            self.is_alreadyRequest = true
                            self.btnRequestOutlet.setTitle("requested", forState: UIControlState.Normal)
                        }else{
                            
                            //MARK: Chek if already following
                            if(outJSON["data"]["followstatus"].stringValue == "Y"){
                                self.is_alreadyFollow = true
                                self.btnRequestOutlet.setTitle("following", forState: UIControlState.Normal)
                            }else{
                                self.is_alreadyRequest = false
                                self.btnRequestOutlet.setTitle("request to follow", forState: UIControlState.Normal)
                            }
                        }

                    }else{
                        if(outJSON["data"]["followstatus"].stringValue == "Y"){
                            self.is_alreadyFollow = true
                            self.btnRequestOutlet.setTitle("following", forState: UIControlState.Normal)
                        }else{
                            self.is_alreadyFollow = false
                            self.btnRequestOutlet.setTitle("follow", forState: UIControlState.Normal)
                        }

                    }
                    
                    
                    
                    self.btnFollowersOutlet.setTitle(outJSON["data"]["user_followers"].stringValue , forState: UIControlState.Normal)
                    self.btnFollowingOutlet.setTitle(outJSON["data"]["user_followings"].stringValue , forState: UIControlState.Normal)

                    /***************** Volunteer Activity ************/
                    self.clearNonProfitArray()
                    let count = outJSON["data"]["volunteer_activity"].array?.count
                    if(count != 0){
                        
                        if let ct = count{
                            for index in 0...ct-1{
                                
                                self.CompanyArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["company_name"].stringValue)
                                self.IDArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["id"].stringValue)
                                self.websiteArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["vol_website"].stringValue)
                                self.TitleArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["role"].stringValue)
                                self.StartDateArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["start_date"].stringValue)
                                self.EndDateArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["end_date"].stringValue)
                                self.IsPresentArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["is_present"].stringValue)
                                
                            }//end for loop
                        }
                    }
                    /**************************************************/
                    

                   
                    self.loadAllImages()
                     self.dynamicallycreateView()
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "Please check internet connection")
                
            }
        }
        
    }
    
    
    func loadAllImages(){
        
        /*if(charityLogo != ""){
            let charityLogoURL = NSURL(string: charityLogo)!
            
            self.imgCharityLogo.sd_setImageWithURL(charityLogoURL, placeholderImage: self.delObj.userPlaceHolderImage, options: SDWebImageOptions.RefreshCached)
            
        }else{
            
            //display charity placeholder
            self.imgCharityLogo.image = self.delObj.userPlaceHolderImage
            
        }*/
        
        if(profleImage != ""){
            
            
            SDImageCache.sharedImageCache().queryDiskCacheForKey(profleImage) { ( img:UIImage!, cacheType:SDImageCacheType) -> Void in
                if(img != nil){
                    
                    //  self.imgProfilePic.image = self.rotateImageToActual(img)
                    self.imgProfilePic.image = self.cust.rotateCameraImageToProperOrientation(img,maxResolution: 360)
                }else{
                    //self.cust.showLoadingCircle()
                    Alamofire.request(.GET, self.profleImage)
                        .response { request, response, data, error in
                            print(request)
                            
                            
                            if(data != nil){
                                let image = UIImage(data: data! )
                                SDImageCache.sharedImageCache().storeImage(image, forKey: self.profleImage)
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
        
        if(coverImage != ""){
            // self.imgCoverPic.hidden = false
            self.imgCoverPic.image = self.delObj.coverPlaceholder
            SDImageCache.sharedImageCache().queryDiskCacheForKey(coverImage) { ( img:UIImage!, cacheType:SDImageCacheType) -> Void in
                if(img != nil){
                    
                    //  self.imgProfilePic.image = self.rotateImageToActual(img)
                    self.imgCoverPic.image = img
                }else{
                    //self.cust.showLoadingCircle()
                    self.imgCoverPic.hidden = false
                    Alamofire.request(.GET, self.coverImage)
                        .response { request, response, data, error in
                            print(request)
                            print(response)
                            // print(data)
                            // print(error)
                            
                            if(data != nil){
                                let image = UIImage(data: data! )
                                SDImageCache.sharedImageCache().storeImage(image, forKey: self.coverImage)
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
        
    }
    
    func followPublicUser(){
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
                    let currentFollowers : Int = Int((self.btnFollowersOutlet.titleLabel?.text)!)!
                    let newFollowers = currentFollowers + 1
                    self.btnFollowersOutlet.setTitle("\(newFollowers)", forState: UIControlState.Normal)
                    
                    
                    self.is_alreadyRequest = true
                    self.btnRequestOutlet.setTitle("following", forState: UIControlState.Normal)
                    
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
                
            }
        }
    }
    
    func sendRequest(){
        
        SVProgressHUD.showWithStatus("Loading...")
     
        Alamofire.request(.POST, delObj.baseUrl + "sendrequest", parameters: ["req_from":self.delObj.loginUserID,"req_to":reqUserID]).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                      self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                      self.btnRequestOutlet.setTitle("requested", forState: UIControlState.Normal)
                    self.is_alreadyRequest = true
                    for i in 0..<self.delObj.keepFollowstatusArray.count{
                        if(self.delObj.keepIDArray[i] == self.reqUserID){
                            self.delObj.keepFollowstatusArray[i] = "Y"
                        }
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

//UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnCharityWebsiteClick(sender: AnyObject) {
        
        let url = NSURL(string: (self.btnCharityWebsite.titleLabel?.text)!)
        if(UIApplication.sharedApplication().canOpenURL(url!)){
            let safariVC = SFSafariViewController(URL: url!)
            safariVC.delegate = self
            self.presentViewController(safariVC, animated: true, completion: nil)
        }

        
    }
    
    @IBAction func btnFollowingClick(sender: AnyObject) {
        let followingVC = self.storyboard?.instantiateViewControllerWithIdentifier("idFollowingViewController") as! FollowingViewController
        followingVC.viewID = reqUserID
        self.navigationController?.pushViewController(followingVC, animated: true)
    }
    
    @IBAction func btnFollowersClick(sender: AnyObject) {
        let followersVC =
            self.storyboard?.instantiateViewControllerWithIdentifier("idFollowersViewController") as! FollowersViewController
        followersVC.selectedType = "user"
        print("reqUserID:\(reqUserID)")
        followersVC.viewID = reqUserID
        self.navigationController?.pushViewController(followersVC, animated: true)
    }
    
    @IBAction func btnSendRequestClick(sender: AnyObject) {
        
        
        if(is_alreadyRequest || is_alreadyFollow){
            print("is_userPublic:\(is_userPublic)")
            if(is_userPublic){
                self.delObj.displayMessage("examen", messageText: "you are following")
            }else{
                self.delObj.displayMessage("examen", messageText: "you have already requested")
            }
            
        }else{
            if(is_userPublic){
                followPublicUser()
            }else{
                sendRequest()
            }
        }
       /* for i in 0..<self.delObj.keepFollowstatusArray.count{
            if(self.delObj.keepIDArray[i] == self.reqUserID){
                if(self.delObj.keepFollowstatusArray[i] == "N"){
                    sendRequest()
                }else{
                    self.delObj.displayMessage("examen", messageText: "You have already requested")
                    self.btnRequestOutlet.setTitle("requested", forState: UIControlState.Normal)
                }
            }
        }*/
        
    }

}
