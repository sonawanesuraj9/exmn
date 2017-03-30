//
//  LoginViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 4/28/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire
import Security
import CoreData

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}


class LoginViewController: UIViewController {

    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var returnKeyHandler : IQKeyboardReturnKeyHandler = IQKeyboardReturnKeyHandler()
    let defaults = NSUserDefaults.standardUserDefaults()
    let myKeychainWrapper : KeychainWrapper = KeychainWrapper()
    
    
//TODO: - Control
    
    @IBOutlet weak var imgLauch: UIImageView!
    @IBOutlet weak var launchView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLoginOutlet: UIButton!
    
    @IBOutlet weak var btnLoginWithFacebookOutlet: UIButton!
    @IBOutlet weak var btnForgotPasswordOutlet: UIButton!
    
    @IBOutlet weak var btnSignupOutlet: UIButton!
    
    
    //NSAutolayout
    
    
    @IBOutlet  var usernameTop: NSLayoutConstraint!
    @IBOutlet  var logoTop: NSLayoutConstraint!
    
//TODO: - Let's Play
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //IQKeyboardReturnKeyHandler Method
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        
        //Add target to fvblogin
        
        btnLoginWithFacebookOutlet.addTarget(self, action: #selector(LoginViewController.LoginWithFacebookClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //Comment following
        var myScreenIndex : Int = Int()
        var tmpInd : Int = Int()
        if(self.defaults.valueForKey("launchScreenIndex") != nil){
            
            tmpInd = self.defaults.valueForKey("launchScreenIndex") as! Int
            if(tmpInd == 5){
                tmpInd = 0
                myScreenIndex = tmpInd
            }else{
                myScreenIndex = tmpInd
                tmpInd = tmpInd + 1
            }
        }else{
            tmpInd = 0
            myScreenIndex = tmpInd
        }
        
        self.defaults.setValue(tmpInd, forKey: "launchScreenIndex")
        
        // let myArray = [1, 2, 3, 4, 5, 6]
        
        
        let delay = self.delObj.splashSec * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        print("myItem:\(myScreenIndex)")
        let imageName = "\(myScreenIndex)\(self.delObj.deviceName)"
        print("imageName:\(imageName)")
        self.launchView.hidden = false
        self.imgLauch.hidden = false
        self.imgLauch.image = UIImage(named: imageName)
        
        self.launchView.backgroundColor = UIColor.clearColor()
        
        self.delObj.tmp_next = false
        self.txtUsername.text = ""
        self.txtPassword.text = ""
        //self.txtUsername.becomeFirstResponder()
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            // here code perfomed with delay
            self.delObj.splashSec = 0.0
            UIView.animateWithDuration(0.6, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                // self.imgLauch.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.imgLauch.alpha = 0.0
                
                //self.launchView.transform = CGAffineTransformMakeScale(0.1, 0.1)
                }, completion: { (value:Bool) in
                    self.launchView.hidden = true
                    self.imgLauch.hidden = true
            })
            
            
            
            if(self.defaults.valueForKey("is_Autologin") != nil){
                
                let checkLogin = self.defaults.valueForKey("is_Autologin") as! Bool
                if(checkLogin){
                    
                    let uname = self.defaults.valueForKey("usernameTemp") as! String
                    let pwd = self.myKeychainWrapper.myObjectForKey("v_Data") as? String //defaults.valueForKey("passwordTemp") as! String
                    self.txtUsername.text = uname
                    self.txtPassword.text = pwd
                    self.doLogin(uname, loginPassword: pwd!)
                }else{
                    print("NormalLogin")
                }
                
            }else{
                print("Normal Login")
            }
            
            
            //Check if login with facebook
            if(self.defaults.valueForKey("is_FBlogin") != nil){
                print("FB Login")
                let fbFlag = self.defaults.valueForKey("is_FBlogin") as! Bool
                
                if(fbFlag){
                    //Login with facebook
                    if(self.defaults.valueForKey("appUserID") != nil){
                        //assign user id
                        self.delObj.loginUserID = self.defaults.valueForKey("appUserID") as! String
                        //assign loginUsertype
                        if(self.defaults.valueForKey("is_loginUserBusiness") != nil){
                            self.delObj.is_loginUserBusiness = self.defaults.valueForKey("is_loginUserBusiness") as! Bool
                        }
                        let contVC = self.storyboard?.instantiateViewControllerWithIdentifier("idContainerViewController") as! ContainerViewController
                        self.navigationController?.pushViewController(contVC, animated: true)
                    }else{
                        print("FB signup no user id found")
                    }
                }
                
            }else{
                print("No FB")
            }
        })

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if(self.delObj.screenHeight < 568){
            self.logoTop.constant = 20
            self.usernameTop.constant = 30
        }
        
        //Init
        initialization()
        clearNonProfitResumeArray()
    
        //SVProgressHUD.showWithStatus("Loading..")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clearNonProfitResumeArray(){
        self.delObj.selectedIsPresentArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedEndDateArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedStartDateArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedWebsiteArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedTitleArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedCompanyArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedIDArray_nonprofit.removeAll(keepCapacity: false)
      
    }

//TODO: - Function
    
    //Desing initialization
    
    func initialization(){
        
        //Login button
        self.btnLoginOutlet.layer.cornerRadius = cust.RounderCornerRadious
        
        //TextBoxes
        
      
        //Placeholder color
        
        
        self.txtPassword.attributedPlaceholder = NSAttributedString(string:"password",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtUsername.attributedPlaceholder = NSAttributedString(string:"username",
            attributes:[NSForegroundColorAttributeName:  cust.placeholderTextColor])
        
        
        self.txtPassword.autocorrectionType = UITextAutocorrectionType.No
        self.txtUsername.autocorrectionType = UITextAutocorrectionType.No
        
        self.txtUsername.keyboardType = UIKeyboardType.Alphabet
        self.txtPassword.keyboardType = UIKeyboardType.Alphabet

        self.txtPassword.tintColor = cust.textTintColor
        self.txtUsername.tintColor = cust.textTintColor
    }
    
    func doLogin(loginUsername:String,loginPassword:String){
     
        let parameters = ["username": loginUsername,"password":loginPassword]
        SVProgressHUD.showWithStatus("Loading..")
        
        Alamofire.request(.POST, delObj.baseUrl + "login", parameters: parameters).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    self.defaults.setValue(loginUsername, forKey: "usernameTemp")
                    
                    //Save password into keychain
                    self.myKeychainWrapper.mySetObject(loginPassword, forKey: kSecValueData)
                    self.myKeychainWrapper.writeToKeychain()
                    
                    
                    self.defaults.setValue(outJSON["data"]["userid"].stringValue, forKey: "appUserID")
                    self.delObj.loginUserID = outJSON["data"]["userid"].stringValue
                    self.delObj.loginUserEmail = outJSON["data"]["email"].stringValue
                    self.delObj.created_date = outJSON["data"]["created_date"].stringValue
                    self.delObj.admin_photo_URL = outJSON["data"]["admin_photo"].stringValue
                    self.defaults.setBool(true, forKey: "is_Autologin")
                    let city_State = outJSON["data"]["city"].stringValue  + ", " + outJSON["data"]["state"].stringValue
                    let zipcode = outJSON["data"]["zip"].stringValue
                    
                    //Store user info for profile page
                    let loginUserDetalis = [
                        "emailID":outJSON["data"]["email"].stringValue,
                        "city_State":city_State,
                        "fname":outJSON["data"]["first_name"].stringValue,
                        "lname":outJSON["data"]["last_name"].stringValue,
                        "about_me":outJSON["data"]["about_me"].stringValue,
                        "zipcode":zipcode,
                         "profile_type":outJSON["data"]["profile_type"].stringValue
                    ]
                    
                    let userProfilePhoto = outJSON["data"]["profile_photo"].stringValue
                    let userCoverPhoto = outJSON["data"]["cover_photo"].stringValue
                    
                    General.saveData(userProfilePhoto, name: "userProfilePhoto")
                    General.saveData(userCoverPhoto, name: "userCoverPhoto")
                    
                    let charityDetails = [
                    "charity_logo":outJSON["data"]["charity_supported"]["charity_logo"].stringValue,
                     "charity_name":outJSON["data"]["charity_supported"]["charity_name"].stringValue,
                        "charityID":outJSON["data"]["charity_supported"]["id"].stringValue,
                        "charity_website":outJSON["data"]["charity_supported"]["website"].stringValue
                    ]
                    
                    let notificationDetails = [
                        "user_followers":outJSON["data"]["user_followers"].stringValue,
                        "user_followings":outJSON["data"]["user_followings"].stringValue,
                         "user_request":outJSON["data"]["request"].stringValue
                    ]
                    /***************** Volunteer Activity ************/
                    
                     self.clearNonProfitResumeArray()
                    let count = outJSON["data"]["volunteer_activity"].array?.count
                    if(count != 0){
                        
                        if let ct = count{
                            for index in 0...ct-1{
                                
                                self.delObj.selectedCompanyArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["company_name"].stringValue)
                                self.delObj.selectedIDArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["id"].stringValue)
                                self.delObj.selectedWebsiteArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["website"].stringValue)
                                self.delObj.selectedTitleArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["role"].stringValue)
                                self.delObj.selectedStartDateArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["start_date"].stringValue)
                                self.delObj.selectedEndDateArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["end_date"].stringValue)
                                self.delObj.selectedIsPresentArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["is_present"].stringValue)
                                
                            }//end for loop
                            
                            print("vol_company_name: \(self.delObj.selectedCompanyArray_nonprofit)")
                            
                        }
                    }
                    /**************************************************/
                    self.defaults.setValue(notificationDetails, forKey: "notificationDetails")
                    self.defaults.setValue(charityDetails, forKey: "loginUsercharityDetails")
                    self.defaults.setValue(outJSON["data"]["signuptype"].stringValue, forKey: "signuptype")
                    self.defaults.setValue(loginUserDetalis, forKey: "loginUserDetalis")
                   
                    /**************** Business profile data */
                    
                    let tmpPro = outJSON["data"]["user_profile"].stringValue
                    if(tmpPro == "true"){
                        self.delObj.is_loginUserBusiness = true
                    }else{
                        self.delObj.is_loginUserBusiness = false
                    }
                   self.defaults.setBool(self.delObj.is_loginUserBusiness, forKey: "is_loginUserBusiness")
                    
                    let busienssProfileDetalis = [
                        "url":outJSON["data"]["url"].stringValue,
                        "intro":outJSON["data"]["intro"].stringValue,
                        "outline":outJSON["data"]["outline"].stringValue,
                    ]
                    self.defaults.setValue(busienssProfileDetalis, forKey: "busienssProfileDetalis")
                    
                    /**************** Business profile data */
                    
                    
                    self.defaults.synchronize()
                    print(charityDetails)
                    print(loginUserDetalis)
                    //clear window
                    //self.txtUsername.text = ""
                   // self.txtPassword.text = ""
                    
                    
                    //Clear Facebook Token 
                    if FBSDKAccessToken.currentAccessToken() != nil {
                        FBSDKLoginManager().logOut()
                        //return
                    }
                    
                    
                    
                    let contVC = self.storyboard?.instantiateViewControllerWithIdentifier("idContainerViewController") as! ContainerViewController
                    self.navigationController?.pushViewController(contVC, animated: true)
                    
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
               SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
                
            }
        }
        
    }
    
    
    
//TODO: - Button Action
    
    func LoginWithFacebookClick(sender:UIButton){
        
        
        let login : FBSDKLoginManager = FBSDKLoginManager()
        login.loginBehavior =  FBSDKLoginBehavior.Native //Native //FBSDKLoginBehaviorNative

        login.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self) { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            SVProgressHUD.showWithStatus("Fetching data...")
            if((error) != nil){
                
                //Process the error
            }else if (result.isCancelled){
                print(result)
                //handle the cancel result
            }else{
                //Login Success
                 
                if (result.grantedPermissions.contains("email")){
                    
                    print("Facebook Access token:  \(FBSDKAccessToken.currentAccessToken().tokenString)")
                    self.defaults.setValue(FBSDKAccessToken.currentAccessToken().tokenString, forKey: "fbAccessToken")
                    self.defaults.synchronize()
                    
                    if ((FBSDKAccessToken.currentAccessToken()) != nil){
                        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture, birthday, gender , email, location,cover"])
                        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                            
                           
                            if ((error) != nil)
                            {
                                // Process error
                                print("Error: \(error)")
                            }
                            else
                            {
                                var name : String = String()
                                var fname : String = String()
                                var lname : String = String()
                                var gender : String = String()
                                var profPic : String = String()
                                var fid : String = String()
                                var emailID : String = String()
                                var location : String = String()
                                var cover : String = String()
                                
                                print("fetched user: \(result)")
                                
                                let coverSource = result.valueForKey("cover") as! NSDictionary
                                print("124: \(coverSource["source"])")
                                
                                cover = coverSource["source"] as! String
                                
                                if(result.valueForKey("id") != nil){
                                    fid = result.valueForKey("id") as! String
                                }
                                if(result.valueForKey("name") != nil){
                                   name = result.valueForKey("name") as! String
                                }
                                if(result.valueForKey("first_name") != nil){
                                    fname = result.valueForKey("first_name") as! String
                                }
                                if(result.valueForKey("last_name") != nil){
                                   lname = result.valueForKey("last_name") as! String
                                }
                                if(result.valueForKey("gender") != nil){
                                    gender = result.valueForKey("gender") as! String
                                }
                                
                                if(result.valueForKey("email") != nil){
                                     emailID = result.valueForKey("email") as! String
                                }
                                if(result.valueForKey("location") != nil){
                                    location = result.valueForKey("location") as! String
                                }
                                
                                if(fid != ""){
                                 profPic = "https://graph.facebook.com/\(fid)/picture?type=large"
                                }
                                SVProgressHUD.dismiss()
                                
                                
                                //Perfom FB login for already registerd user
                               
                                let  parameterDict = ["Name":name,
                                    "lName":lname,
                                    "fname":fname,
                                    "gender":gender,
                                    "profPic":profPic,
                                    "fid":fid,
                                    "emailID":emailID,
                                    "location":location,
                                    "cover":cover]
                                
                                self.defaults.setValue(parameterDict, forKey: "fbUserDetails")
                                print("parameterDict:\(parameterDict)")
                                
                                //Facebook login checkup function
                                self.IfUserAlreadyLoginWithFB(fid, emailID: emailID, dict: parameterDict)
                                
                            
                            }
                        })
                        
                        
                        // Friend list code here
                         let params = ["fields": "id, name, first_name, last_name, picture, birthday, gender , email, location,cover"]
                        
                        // //friends
                         let fbRequest = FBSDKGraphRequest(graphPath:"me/friends", parameters: params);
                        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                            
                            if error == nil {
                                print("result:\(result)")
                                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                                {
                                    self.delObj.clearFacebookArray()
                                    if userNameArray.count>0{
                                        for i in 0...userNameArray.count-1{
                                            print("*\(i)*\(userNameArray[i].valueForKey("id"))")
                                            let name = userNameArray[i].valueForKey("name") as! String
                                            self.delObj.facebookFriendNameArray.append(name)
                                            print("*\(i)*\(userNameArray[i].valueForKey("name"))")
                                             self.delObj.facebookFriendTypeArray.append("0")
                                            
                                            //ID
                                            let fid = userNameArray[i].valueForKey("id") as! String
                                            self.delObj.facebookFriendIDArray.append(fid)
                                            print("*\(i)*\(userNameArray[i].valueForKey("name"))")
                                            
                                            //Profile
                                            var profPic : String = String()
                                            if(fid != ""){
                                                profPic = "https://graph.facebook.com/\(fid)/picture?type=large"
                                            }
                                            self.delObj.facebookFriendImageArray.append(profPic)
                                            
                                            
                                            
                                            
                                            
                                        }
                                    }
                                }
                               
                                //Store into defaults
                                self.defaults.setValue(self.delObj.facebookFriendNameArray, forKey: "facebookFriendNameArray")
                                self.defaults.setValue(self.delObj.facebookFriendTypeArray, forKey: "facebookFriendTypeArray")
                                 self.defaults.setValue(self.delObj.facebookFriendImageArray, forKey: "facebookFriendImageArray")
                                 self.defaults.setValue(self.delObj.facebookFriendIDArray, forKey: "facebookFriendIDArray")
                                
                                
                            }
                            else {
                                
                                print("Error Getting Friends \(error)");
                                
                            }
                            
                        }
                        
                        //Other Facebook taggable_Friend
                        let OtherFBRequest = FBSDKGraphRequest(graphPath:"me/taggable_friends", parameters: params);
                        OtherFBRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                            
                            if error == nil {
                                print("result:\(result)")
                                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                                {
                                    if userNameArray.count>0{
                                        for i in 0...userNameArray.count-1{
                                            print("*\(i)*\(userNameArray[i].valueForKey("id"))")
                                            //Name
                                            let name = userNameArray[i].valueForKey("name") as! String
                                            self.delObj.facebookFriendNameArray.append(name)
                                            self.delObj.facebookFriendTypeArray.append("1")
                                            
                                            //ID
                                            self.delObj.facebookFriendIDArray.append("")
                                            self.delObj.facebookFriendImageArray.append("")
                                            
                                        }
                                    }
                                }
                                
                                //Store into defaults
                                self.defaults.setValue(self.delObj.facebookFriendNameArray, forKey: "facebookFriendNameArray")
                                self.defaults.setValue(self.delObj.facebookFriendTypeArray, forKey: "facebookFriendTypeArray")
                                self.defaults.setValue(self.delObj.facebookFriendImageArray, forKey: "facebookFriendImageArray")
                                self.defaults.setValue(self.delObj.facebookFriendIDArray, forKey: "facebookFriendIDArray")
                            }
                            else {
                                
                                print("Error Getting Friends \(error)");
                                
                            }
                            
                        }
                        //Other Facebook friend ends
                    }
                }
            }
        }
    }
    
    
    func IfUserAlreadyLoginWithFB(fid:String,emailID:String,dict:NSDictionary){
        
        let parameterDict = dict
        
        let parameters = ["fid": fid,"email":emailID]
        print("parameters:\(parameters)")
        SVProgressHUD.showWithStatus("Loading..")
        
        Alamofire.request(.POST, delObj.baseUrl + "fblogin", parameters: parameters).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    self.defaults.setValue(outJSON["data"]["userid"].stringValue, forKey: "appUserID")
                    self.delObj.loginUserID = outJSON["data"]["userid"].stringValue
                    self.delObj.created_date = outJSON["data"]["created_date"].stringValue
                    self.delObj.admin_photo_URL = outJSON["data"]["admin_photo"].stringValue

                    self.defaults.setBool(true, forKey: "is_FBlogin")
                    let city_State = outJSON["data"]["city"].stringValue  + ", " + outJSON["data"]["state"].stringValue
                    
                    
                    //Store user info for profile page
                    let loginUserDetalis = [
                        "emailID":outJSON["data"]["email"].stringValue,
                        "city_State":city_State,
                        "fname":outJSON["data"]["first_name"].stringValue,
                        "lname":outJSON["data"]["last_name"].stringValue,
                        "about_me":outJSON["data"]["about_me"].stringValue,
                        "profile_type":outJSON["data"]["profile_type"].stringValue
                    ]
                    
                    
                    let userProfilePhoto = outJSON["data"]["profile_photo"].stringValue
                    let userCoverPhoto = outJSON["data"]["cover_photo"].stringValue
                   
                    General.saveData(userProfilePhoto, name: "userProfilePhoto")
                    General.saveData(userCoverPhoto, name: "userCoverPhoto")
                    
                    
                    self.defaults.setValue(loginUserDetalis, forKey: "loginUserDetalis")
                    /**************** Business profile data */
                    
                    let tmpPro = outJSON["data"]["bus_pro"].stringValue
                    if(tmpPro == "true"){
                        self.delObj.is_loginUserBusiness = true
                    }else{
                        self.delObj.is_loginUserBusiness = false
                    }
                     self.defaults.setBool(self.delObj.is_loginUserBusiness, forKey: "is_loginUserBusiness")
                    
                    let busienssProfileDetalis = [
                        "url":outJSON["data"]["url"].stringValue,
                        "intro":outJSON["data"]["intro"].stringValue,
                        "outline":outJSON["data"]["outline"].stringValue,
                    ]
                    self.defaults.setValue(busienssProfileDetalis, forKey: "busienssProfileDetalis")
                    /**************** Business profile data */
                    
                    /***************** Volunteer Activity ************/
                    
                    self.clearNonProfitResumeArray()
                    let count = outJSON["data"]["volunteer_activity"].array?.count
                    if(count != 0){
                        
                        if let ct = count{
                            for index in 0...ct-1{
                                
                                self.delObj.selectedCompanyArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["company_name"].stringValue)
                                self.delObj.selectedIDArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["id"].stringValue)
                                self.delObj.selectedWebsiteArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["website"].stringValue)
                                self.delObj.selectedTitleArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["role"].stringValue)
                                self.delObj.selectedStartDateArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["start_date"].stringValue)
                                self.delObj.selectedEndDateArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["end_date"].stringValue)
                                self.delObj.selectedIsPresentArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["is_present"].stringValue)
                                
                            }//end for loop
                            
                            print("vol_company_name: \(self.delObj.selectedCompanyArray_nonprofit)")
                            
                        }
                    }
                    /**************************************************/
                    
                    
                    let charityDetails = [
                        "charity_logo":outJSON["data"]["charity_supported"]["charity_logo"].stringValue,
                        "charity_name":outJSON["data"]["charity_supported"]["charity_name"].stringValue,
                        "charityID":outJSON["data"]["charity_supported"]["id"].stringValue,
                        "charity_website":outJSON["data"]["charity_supported"]["website"].stringValue
                    ]
                    
                    let notificationDetails = [
                        "user_followers":outJSON["data"]["user_followers"].stringValue,
                        "user_followings":outJSON["data"]["user_followings"].stringValue,
                        "user_request":outJSON["data"]["request"].stringValue
                        
                    ]
                    
                    self.defaults.setValue(notificationDetails, forKey: "notificationDetails")
                    
                    self.defaults.setValue(charityDetails, forKey: "loginUsercharityDetails")
                    
                    self.defaults.setValue(outJSON["data"]["signuptype"].stringValue, forKey: "signuptype")
                    
                    self.defaults.synchronize()                    
                    
                    print(loginUserDetalis)
                    
                    //clear window
                    let contVC = self.storyboard?.instantiateViewControllerWithIdentifier("idContainerViewController") as! ContainerViewController
                    self.navigationController?.pushViewController(contVC, animated: true)
                    
                }else{
                    //If new user signup with facebook
                    
                    let profSelectionVC = self.storyboard?.instantiateViewControllerWithIdentifier("idProfileSelectionNormalViewController") as! ProfileSelectionNormalViewController
                    profSelectionVC.is_normal = false
                    profSelectionVC.userPersonal = parameterDict as! [String : String]
                    self.navigationController?.pushViewController(profSelectionVC, animated: true)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
                
            }
        }
        
    }
    
    
    @IBAction func btnLoginWithFBClick(sender: AnyObject) {
    }
    
    @IBAction func btnForgotPasswordClick(sender: AnyObject) {        
        let forgotVC = self.storyboard?.instantiateViewControllerWithIdentifier("idForgotpasswordViewController") as! ForgotpasswordViewController
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    @IBAction func btnSignupClick(sender: AnyObject) {
        let profSelectionVC = self.storyboard?.instantiateViewControllerWithIdentifier("idProfileSelectionNormalViewController") as! ProfileSelectionNormalViewController
        profSelectionVC.is_normal = true
        self.navigationController?.pushViewController(profSelectionVC, animated: true)
    }
    
    @IBAction func btnLoginClick(sender: AnyObject) {
        
        if(self.txtUsername.text != "" && self.txtPassword.text != ""){
            self.doLogin(self.txtUsername.text!, loginPassword: self.txtPassword.text!)
        }else{
            self.delObj.displayMessage("examen", messageText: "please enter username or password")
        }
        
    }
   
}
