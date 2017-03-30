//
//  OtherBusinessProfileViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 7/1/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices




class OtherBusinessProfileViewController: UIViewController,SFSafariViewControllerDelegate {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var coverImage : String = String()
    var profleImage : String = String()
    var charityLogo : String = String()
    var is_alreadyFollow : Bool = Bool()
    var tmpFollowerCount : String = String()
    
    
    var reqUserID : String = String()
    
//TODO: - Controls
    
    @IBOutlet weak var lblIntroductionTItle: UILabel!
    @IBOutlet weak var lblCharityTitle: UILabel!
    @IBOutlet weak var lblOutlineTItle: UILabel!
    
    
    @IBOutlet weak var txtOutlineOfCause: UITextView!
    @IBOutlet weak var btnCharityWebsite: UIButton!
    @IBOutlet weak var lblCharityName: UILabel!
  //  @IBOutlet weak var imgCharityLogo: UIImageView!
    @IBOutlet weak var txtIntroduction: UITextView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var btnFollowersCount: UIButton!
    @IBOutlet weak var btnFollowOutlet: UIButton!
    @IBOutlet weak var btnBusinessUrl: UIButton!
    @IBOutlet weak var lblBusinessLocation: UILabel!
    @IBOutlet weak var lblBusinessName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    
//TODO: - Let's Play
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.lblIntroductionTItle.layer.cornerRadius = 5
        self.lblIntroductionTItle.clipsToBounds = true
        
        self.lblCharityTitle.layer.cornerRadius = 5
        self.lblCharityTitle.clipsToBounds = true
        
        self.lblOutlineTItle.layer.cornerRadius = 5
        self.lblOutlineTItle.clipsToBounds = true
        
        
        
        
        
        if(self.delObj.is_loginUserBusiness){
            self.btnFollowOutlet.hidden = true
        }else{
             self.btnFollowOutlet.hidden = false
        }
        self.btnFollowersCount.setTitle("-", forState: UIControlState.Normal)
        roundedCorerImageView()
        fetchUserDetails()
        
        self.btnFollowOutlet.layer.cornerRadius = self.cust.RounderCornerRadious
           mainScrollView.contentSize = CGSize(width: mainScrollView.frame.size.width , height: self.txtOutlineOfCause.frame.origin.y + self.txtOutlineOfCause.frame.size.height + 16)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - Function
    func roundedCorerImageView(){
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.width / 2
        self.imgProfile.clipsToBounds = true
        
      /*  self.imgCharityLogo.layer.cornerRadius = self.imgCharityLogo.bounds.width / 2
        self.imgCharityLogo.clipsToBounds = true*/

        
    }
    
//TODO: - Web service/API method implementation
    func fetchUserDetails(){
        
        SVProgressHUD.showWithStatus("Loading...")
        print("reqUserID:\(reqUserID)")
        Alamofire.request(.POST, delObj.baseUrl + "getBusinessprofile", parameters: ["userid":self.delObj.loginUserID ,"pid":reqUserID]).responseJSON{
            response in
            print("reqUserID:\(self.reqUserID)")
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    
                    self.lblBusinessLocation.text = outJSON["data"]["city"].stringValue  + ", " + outJSON["data"]["state"].stringValue
                    self.coverImage = outJSON["data"]["cover_photo"].stringValue
                    self.profleImage =  outJSON["data"]["profile_photo"].stringValue
                    self.lblBusinessName.text = outJSON["data"]["first_name"].stringValue
                    
                    self.btnBusinessUrl.setTitle( outJSON["data"]["url"].stringValue, forState: UIControlState.Normal)
                    
                    self.lblCharityName.text = outJSON["data"]["charity_supported"]["charity_name"].stringValue
                    self.btnCharityWebsite.setTitle(outJSON["data"]["charity_supported"]["website"].stringValue, forState: UIControlState.Normal)
                    self.charityLogo = outJSON["data"]["charity_supported"]["charity_logo"].stringValue
                    
                    if(outJSON["data"]["followstatus"].stringValue == "Y"){
                        self.is_alreadyFollow = true
                        self.btnFollowOutlet.setTitle("following", forState: UIControlState.Normal)
                    }else{
                        self.is_alreadyFollow = false
                        self.btnFollowOutlet.setTitle("follow", forState: UIControlState.Normal)
                    }
                    self.tmpFollowerCount = outJSON["data"]["user_followers"].stringValue
                    self.btnFollowersCount.setTitle(outJSON["data"]["user_followers"].stringValue, forState: UIControlState.Normal)
                    self.txtIntroduction.text = outJSON["data"]["intro"].stringValue
                    self.txtOutlineOfCause.text = outJSON["data"]["outline"].stringValue
                    
                    self.btnFollowersCount.setTitle(outJSON["data"]["user_followers"].stringValue , forState: UIControlState.Normal)
                  
                    self.loadAllImages()
                    
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
            
        }
        */
        if(profleImage != ""){
            
            
            SDImageCache.sharedImageCache().queryDiskCacheForKey(profleImage) { ( img:UIImage!, cacheType:SDImageCacheType) -> Void in
                if(img != nil){
                    
                    //  self.imgProfilePic.image = self.rotateImageToActual(img)
                    self.imgProfile.image = self.cust.rotateCameraImageToProperOrientation(img,maxResolution: 360)
                }else{
                    //self.cust.showLoadingCircle()
                    Alamofire.request(.GET, self.profleImage)
                        .response { request, response, data, error in
                            print(request)
                            
                            
                            if(data != nil){
                                let image = UIImage(data: data! )
                                SDImageCache.sharedImageCache().storeImage(image, forKey: self.profleImage)
                                self.imgProfile.image = self.cust.rotateCameraImageToProperOrientation(image!,maxResolution: 360)
                                self.imgProfile.layer.borderColor = UIColor.whiteColor().CGColor
                                self.imgProfile.layer.borderWidth = 1.0
                                //  self.imgProfilePic.image = self.rotateImageToActual(image!)
                                
                            }else{
                                //Display placeholder
                                self.imgProfile.image = self.delObj.userPlaceHolderImage
                            }
                    }
                }
            }
        }else{
            self.imgProfile.image = self.delObj.userPlaceHolderImage
        }
        
        if(coverImage != ""){
            // self.imgCoverPic.hidden = false
            self.imgCover.image = self.delObj.coverPlaceholder
            SDImageCache.sharedImageCache().queryDiskCacheForKey(coverImage) { ( img:UIImage!, cacheType:SDImageCacheType) -> Void in
                if(img != nil){
                    
                    //  self.imgProfilePic.image = self.rotateImageToActual(img)
                    self.imgCover.image = img
                }else{
                    //self.cust.showLoadingCircle()
                    self.imgCover.hidden = false
                    Alamofire.request(.GET, self.coverImage)
                        .response { request, response, data, error in
                            print(request)
                            print(response)
                            // print(data)
                            // print(error)
                            
                            if(data != nil){
                                let image = UIImage(data: data! )
                                SDImageCache.sharedImageCache().storeImage(image, forKey: self.coverImage)
                                self.imgCover.image = image
                                //  self.imgProfilePic.image = self.rotateImageToActual(image!)
                                
                            }else{
                                // self.imgCoverPic.hidden = true
                                //Display placeholder
                                self.imgCover.image = self.delObj.coverPlaceholder
                            }
                    }
                }
            }
        }else{
            self.imgCover.image = self.delObj.coverPlaceholder
        }
        
    }
    
    func followPublicUser(){
        SVProgressHUD.showWithStatus("Loading...")
        
        Alamofire.request(.POST, delObj.baseUrl + "follow", parameters: ["userid":reqUserID ,"followerid":self.delObj.loginUserID]).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    self.is_alreadyFollow = true
                    self.btnFollowersCount.setTitle(self.tmpFollowerCount + "+ you", forState: UIControlState.Normal)
                    self.btnFollowOutlet.setTitle("following", forState: UIControlState.Normal)
                    
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
                
            }
        }
    }
    
    
//TODO: - UIButton Action
    
    
    @IBAction func btnCharityWebsiteClick(sender: AnyObject) {
        
        let url = NSURL(string: (self.btnCharityWebsite.titleLabel?.text)!)
        if(UIApplication.sharedApplication().canOpenURL(url!)){
            let safariVC = SFSafariViewController(URL: url!)
            safariVC.delegate = self
            self.presentViewController(safariVC, animated: true, completion: nil)
        }
    }
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnFollowClick(sender: AnyObject) {
        // If user does not followe the charity then enable this button, otherwise display following as title
        if self.is_alreadyFollow{
            self.delObj.displayMessage("examen", messageText: "you are already following")
        }else{
            followPublicUser()
        }
    }

    @IBAction func btnFollowersCountClick(sender: AnyObject) {
        //navigate to followers listing page.
        
        
    }
}
