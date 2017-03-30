//
//  SignupFacebookBusinessViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 6/27/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire

class SignupFacebookBusinessViewController: UIViewController, UITextViewDelegate {

    
//TODO: - Gernal
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var userPersonal = [String: String]()
    let defaults  = NSUserDefaults.standardUserDefaults()
       let textColor = UIColor(red: 0/255, green: 73/255, blue: 126/255, alpha: 1.0)
    var i_agreeTerms : Bool = Bool()
   
    
//TODO: - Controls
    
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var btnSignupOutlet: UIButton!
    @IBOutlet weak var termsSwitch: UISwitch!
    @IBOutlet weak var txtIntroduction: UITextView!
    @IBOutlet weak var btnCharitySpotlight: UIButton!
    @IBOutlet weak var txtOutlineCause: UITextView!
    
    
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.txtIntroduction.delegate = self
        self.txtOutlineCause.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print(userPersonal)
        initPlaceholderForTextView()
        self.delObj.CurrentLocationIdentifier()
       // self.btnAddNonProfiltOutlet.layer.cornerRadius = cust.RounderCornerRadious
        
        if(self.delObj.is_normal_CharitySelected){
            self.btnCharitySpotlight.setTitle(self.delObj.normal_charityName, forState: UIControlState.Normal)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.btnSignupOutlet.layer.cornerRadius = cust.RounderCornerRadious
        
        self.txtBusinessName.attributedPlaceholder = NSAttributedString(string:"business name",
                                                                     attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtWebsite.attributedPlaceholder = NSAttributedString(string:"website url",
                                                                    attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        

      
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
        
    }
    
    func checkMandatoryFields() -> Bool {
        var outFlag : Bool = Bool()
        if(self.txtBusinessName.text == ""){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter business name")
        }/*else if(!self.delObj.is_normal_CharitySelected){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please select charity supported")
        }*/
        else if(!i_agreeTerms){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please accepts terms of service")
        }else{
            outFlag = true
        }
        return outFlag
    }

    
//TODO: - Web service / API call
    
    func doSignup(){
        
        if checkMandatoryFields(){
            
            if(defaults.valueForKey("fbUserDetails") != nil){
                
                let fbDetails = defaults.valueForKey("fbUserDetails") as! NSDictionary
                
                //  let name = fbDetails["Name"] as! String
               // let gender = fbDetails["gender"] as! String
                let profPic = fbDetails["profPic"] as! String
                let fid = fbDetails["fid"] as! String
                let emailID = fbDetails["emailID"] as! String
                let location = fbDetails["location"] as! String
                let cover = fbDetails["cover"] as! String
                
                print("location: \(location)")
                
                var outline_cause : String = String()
                if(self.delObj.is_business_ouline_changed){
                    outline_cause = self.txtOutlineCause.text
                }else{
                    outline_cause = ""
                }
                var intro : String = String()
                if(self.delObj.is_business_normal_introChanged){
                    intro = self.txtIntroduction.text
                }else{
                    intro = ""
                }
                
                var userZip : String = String()
                if(self.delObj.userZipcode != ""){
                    userZip = self.delObj.userZipcode
                }else{
                    userZip = location//"30017"
                }
                
                var accessToken : String = String()
                if(defaults.valueForKey("fbAccessToken") != nil){
                    accessToken = defaults.valueForKey("fbAccessToken") as! String
                }else{
                    accessToken = ""
                }
                let parameters = ["fbid": fid,
                                  "businessname":self.txtBusinessName.text!,
                                  "email":emailID,
                                  "photo":profPic,
                                  "fbaccesstoken":accessToken,
                                  "zip":userZip,
                                  "profile_type":"Public",
                                  "iagree":"Y",
                                  "dev_token":self.delObj.deviceTokenToSend,
                                  "dev_type":"iPhone",
                                  "dev_id":self.delObj.deviceUDID,
                                  "charity_supported":self.delObj.normal_supportedCharityID,
                                  "url": self.txtWebsite.text!,
                                  "introduction":intro,
                                  "outline_cause":outline_cause,
                                  "about_me":outline_cause,
                                  "cover_photo":cover
                ]
                SVProgressHUD.showWithStatus("Loading..")
                
                Alamofire.request(.POST, delObj.baseUrl + "business_fbsignup", parameters: parameters).responseJSON{
                    response in
                    print("parameters\(parameters)")
                    
                    print("output\(response.result.value)")
                    
                    if(response.result.isSuccess){
                        
                        SVProgressHUD.dismiss()
                        let outJSON = JSON(response.result.value!)
                        if(outJSON["status"] != "1"){
                            
                            self.defaults.setValue(outJSON["data"]["userid"].stringValue, forKey: "appUserID")
                            self.delObj.loginUserID = outJSON["data"]["userid"].stringValue
                            
                            self.defaults.setBool(true, forKey: "is_FBlogin")
                            let city_State = outJSON["data"]["city"].stringValue  + ", " + outJSON["data"]["state"].stringValue
                            
                            self.delObj.created_date = outJSON["data"]["created_date"].stringValue
                            self.delObj.admin_photo_URL = outJSON["data"]["admin_photo"].stringValue
                            
                            
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
                            self.delObj.isNewTimeUser = true
                            print(loginUserDetalis)
                            //clear window
                            let contVC = self.storyboard?.instantiateViewControllerWithIdentifier("idContainerViewController") as! ContainerViewController
                            self.navigationController?.pushViewController(contVC, animated: true)
                            
                        }else{
                            
                            self.delObj.displayMessage("Examen", messageText: outJSON["msg"].stringValue)
                            
                        }
                    }else{
                        SVProgressHUD.dismiss()
                        self.delObj.displayMessage("Examen", messageText: "Please check internet connection")
                        
                    }
                }
                
            }else{
                print("Ohhh, Nothing get from facebook")
            }
        }
    }
   
    
    
//TODO: - Function
    func initPlaceholderForTextView(){
        txtIntroduction.text = "introduction"
        txtIntroduction.tintColor = cust.textTintColor
        txtIntroduction.textColor = self.cust.placeholderTextColor
        self.delObj.is_business_normal_introChanged = false
        txtOutlineCause.text =  "outline of cause"
        txtOutlineCause.tintColor = cust.textTintColor
        txtOutlineCause.textColor = self.cust.placeholderTextColor
        self.delObj.is_business_ouline_changed = false
        
    }
    
    
//TODO: UITextViewDelegate Methods
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(textView == txtOutlineCause){
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
        }
        return true
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == self.cust.placeholderTextColor{
            textView.text = nil
            textView.textColor = textColor
            if(textView == txtIntroduction){
                self.delObj.is_business_normal_introChanged = true
            }else if(textView == txtOutlineCause){
                self.delObj.is_business_ouline_changed = true
            }
            
            
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == txtIntroduction{
            
            if textView.text.isEmpty{
                txtIntroduction.text = "introduction"
                txtIntroduction.textColor = self.cust.placeholderTextColor
                self.delObj.is_business_normal_introChanged = false
            }
            
        }else if(textView == txtOutlineCause){
            if textView.text.isEmpty{
                txtOutlineCause.text = "outline of cause"
                txtOutlineCause.textColor = self.cust.placeholderTextColor
                self.delObj.is_business_ouline_changed = false
            }
        }
        
    }

    
//TODO: - UIButton Action
    @IBAction func btnCharitySpotlightClick(sender: AnyObject) {
        
        let editChVC = self.storyboard?.instantiateViewControllerWithIdentifier("idUpdateCharityViewController") as! UpdateCharityViewController
        let fbDetails = defaults.valueForKey("fbUserDetails") as! NSDictionary
        let emailID = fbDetails["emailID"] as! String
        self.delObj.loginUserEmail = emailID
        self.navigationController?.pushViewController(editChVC, animated: true)
        
        
    }

    @IBAction func btnBackClick(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func btnSignupClick(sender: AnyObject) {
        doSignup()
    }
    
    @IBAction func btnTermsOfServiceClick(sender: AnyObject) {
        
        let termsVC = self.storyboard?.instantiateViewControllerWithIdentifier("idTermsOfServiceViewController") as! TermsOfServiceViewController
        self.navigationController?.pushViewController(termsVC, animated: true)
        
        
        print("Terms CLick")
        
        
    }
    
    @IBAction func switchTerms(sender: AnyObject) {
        if termsSwitch.on {
            i_agreeTerms = true
            print("Switch is ON")
        } else {
            i_agreeTerms = false
            print("Switch is Off")
        }
    }
    

}
