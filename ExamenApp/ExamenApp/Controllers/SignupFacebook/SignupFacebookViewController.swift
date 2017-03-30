//
//  SignupFacebookViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/2/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire

class SignupFacebookViewController: UIViewController,UITextViewDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var userPersonal = [String: String]()
    let defaults  = NSUserDefaults.standardUserDefaults()
    
    var profileType_selected : Bool = Bool()
    var is_charitySelected : Bool = Bool()
    var i_agreeTerms : Bool = Bool()
    var is_publicProfile : Bool = Bool()
    var is_aboutUserChanged : Bool = Bool()
    
    //Charity variable
    var supportedCharityID : String = String()
    var charityNameArray : [String] = []
    var charityIDArray : [String] = []
    var charityWebsiteArray : [String] = []
    var charityLogoArray : [String] = []

    let textColor = UIColor(red: 66/255, green: 110/255, blue: 216/255, alpha: 1.0)
//TODO: - Controls
    
   // @IBOutlet weak var txtProfileType: UITextField!
    
    
    @IBOutlet weak var btnCharitySpotlightOutlet: UIButton!
    
    @IBOutlet weak var lblRemainCharacter: UILabel!
    
    @IBOutlet weak var btnAddNonProfiltOutlet: UIButton!
    
    @IBOutlet weak var btnProfileTypeOutlet: UIButton!
    @IBOutlet weak var btnSignupOutlet: UIButton!
    @IBOutlet weak var profileTypeSwitch: UISwitch!
    @IBOutlet weak var termsSwitch: UISwitch!
    //@IBOutlet weak var txtVolunteerActivity: UITextView!
    @IBOutlet weak var txtDescription: UITextView!
  //  @IBOutlet weak var txtCharitySupported: UITextField!
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchCharityListing()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print(userPersonal)
        initPlaceholderForTextView()
        self.delObj.CurrentLocationIdentifier()
        self.btnAddNonProfiltOutlet.layer.cornerRadius = cust.RounderCornerRadious
        
        if(self.delObj.is_normal_CharitySelected){
            self.btnCharitySpotlightOutlet.setTitle(self.delObj.normal_charityName, forState: UIControlState.Normal)
        }
        
        //Init counter
        setCountAttributedLabel("0", Outof: "/120 Characters")
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        self.btnSignupOutlet.layer.cornerRadius = cust.RounderCornerRadious
        
        
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
//TODO: - Function
    
    func initPlaceholderForTextView(){
        txtDescription.text = "about me (optional)"
        txtDescription.tintColor = cust.textTintColor
        txtDescription.textColor = self.cust.placeholderTextColor
        
    }
    
    func checkMandatoryFields() -> Bool {
        var outFlag : Bool = Bool()
        
        /*if(!profileType_selected){
            self.delObj.displayMessage("examen", messageText: "please select profile type")
            outFlag = false
        }else if(!self.delObj.is_normal_CharitySelected){
           outFlag = false
            self.delObj.displayMessage("examen", messageText: "please select charity supported")
        }*/
        
        if(!i_agreeTerms){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please accepts terms of service")
        }else{
           outFlag = true
        }
        return outFlag
    }
    
    
    func updateCharacterCount() {
        print("txtDescription.text.characters.count:\(txtDescription.text.characters.count)")
        let ct = "\(txtDescription.text.characters.count)"
        setCountAttributedLabel(ct, Outof: "/120 Characters")
    }
    
    
    func setCountAttributedLabel(first:String,Outof:String){
        let max = Outof
        let current = first
        
        //Attributed Label
        let attributedString = NSMutableAttributedString(string:current)
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 1, green: 0, blue: 0, alpha: 1.0), range: NSRange(location: 0,length:current.characters.count))
        
        let gString = NSMutableAttributedString(string:max)
        gString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255/255, green: 153/255, blue: 0/255, alpha: 1.0), range: NSRange(location: 0,length: max.characters.count))
        
        attributedString.appendAttributedString(gString)
        self.lblRemainCharacter.attributedText = attributedString
    }

    
//TODO: - Web Service / API Call
    
    func clearCharityArray(){
        self.charityIDArray.removeAll(keepCapacity: false)
        self.charityNameArray.removeAll(keepCapacity: false)
        self.charityLogoArray.removeAll(keepCapacity: false)
        self.charityWebsiteArray.removeAll(keepCapacity: false)
    }
    
    func fetchCharityListing(){
        
        SVProgressHUD.showWithStatus("Fetching charity list...")
        Alamofire.request(.POST, delObj.baseUrl + "charitylist").responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                //Clear previous array data
                self.clearCharityArray()
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let count = outJSON["data"].array?.count
                    if(count != 0){
                        
                        if let ct = count{
                            for index in 0...ct-1{
                                
                                self.charityIDArray.append(outJSON["data"][index]["charity_id"].stringValue)
                                self.charityNameArray.append(outJSON["data"][index]["charity_name"].stringValue)
                                self.charityWebsiteArray.append(outJSON["data"][index]["charity_website"].stringValue)
                                self.charityLogoArray.append(outJSON["data"][index]["charity_logo"].stringValue)
                                
                            }//end for loop
                            
                            print("charityNameArray: \(self.charityNameArray)")
                        }
                        
                    }else{
                        self.delObj.displayMessage("Examen", messageText: outJSON["msg"].stringValue)
                    }
                    
                }else{
                    
                    self.delObj.displayMessage("Examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                print("Newtwork Error")
                
            }
        }
    }
    
    func doSignup(){
        
        if checkMandatoryFields(){
            
            if(defaults.valueForKey("fbUserDetails") != nil){
            
                let fbDetails = defaults.valueForKey("fbUserDetails") as! NSDictionary
            
                //  let name = fbDetails["Name"] as! String
                let lname = fbDetails["lName"] as! String
                let fname = fbDetails["fname"] as! String
                // let gender = fbDetails["gender"] as! String
                let profPic = fbDetails["profPic"] as! String
                let fid = fbDetails["fid"] as! String
                let emailID = fbDetails["emailID"] as! String
                let location = fbDetails["location"] as! String
                let cover = fbDetails["cover"] as! String
                
                var profileType : String = String()
            
                print("location: \(location)")
                if( is_publicProfile){
                    profileType = "Public"
                }else{
                    profileType = "Private"
                }
                
                var aboutUser : String = String()
                if(is_aboutUserChanged){
                   aboutUser = self.txtDescription.text
                }else{
                   aboutUser = ""
                }
                
                var userZip : String = String()
                if(self.delObj.userZipcode != ""){
                    userZip = self.delObj.userZipcode
                }else{
                    userZip = location //"30017"
                }
                
                var accessToken : String = String()
                if(defaults.valueForKey("fbAccessToken") != nil){
                    accessToken = defaults.valueForKey("fbAccessToken") as! String
                }else{
                    accessToken = ""
                }
                let tmpCount = String(self.delObj.selectedCompanyArray_nonprofit.count)
                
                
                var parameters : [String : AnyObject] = ["fbid": fid,
                              "first_name":fname,
                              "last_name":lname,
                              "email":emailID,
                              "photo":profPic,
                              "fbaccesstoken":accessToken,
                              "zip":userZip,
                              "profile_type":profileType,
                              "iagree":"Y",
                              "dev_token":self.delObj.deviceTokenToSend,
                              "dev_type":"iPhone",
                              "dev_id":self.delObj.deviceUDID,
                              "charity_supported":self.delObj.normal_supportedCharityID,
                              "about_me":aboutUser,
                              "vol_count":tmpCount,
                              "cover_photo" : cover
                    
                            ]
                
                if(Int(tmpCount) > 0){
                    parameters["vol_role"] = self.delObj.selectedTitleArray_nonprofit
                    parameters["vol_company"] = self.delObj.selectedCompanyArray_nonprofit
                    parameters["vol_startdate"] = self.delObj.selectedStartDateArray_nonprofit
                    parameters["vol_enddate"] = self.delObj.selectedEndDateArray_nonprofit
                    parameters["vol_ispresent"] = self.delObj.selectedIsPresentArray_nonprofit
                    parameters["vol_website"] = self.delObj.selectedWebsiteArray_nonprofit
                }else{
                    parameters["vol_role"] = ""
                    parameters["vol_company"] = ""
                    parameters["vol_startdate"] = ""
                    parameters["vol_enddate"] = ""
                    parameters["vol_ispresent"] = ""
                    parameters["vol_website"] = ""
                }
                
                
                
                
                        SVProgressHUD.showWithStatus("Loading..")
            
                        Alamofire.request(.POST, delObj.baseUrl + "fbsignup", parameters: parameters as? [String : AnyObject]).responseJSON{
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
                                    
                                    
                                    
                                    let tmpPro = outJSON["data"]["bus_pro"].stringValue
                                    
                                    if(tmpPro == "true"){
                                        self.delObj.is_loginUserBusiness = true
                                    }else{
                                        self.delObj.is_loginUserBusiness = false
                                    }
                                     self.defaults.setBool(self.delObj.is_loginUserBusiness, forKey: "is_loginUserBusiness")
                                    
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
                        
                                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                                }
                            }else{
                                SVProgressHUD.dismiss()
                                self.delObj.displayMessage("examen", messageText: "please check internet connection")
                    
                            }
                    }
            
                }else{
                    print("Oouch, Nothing get from facebook")
                }
            }
    }
    
    
    
    
    
//TODO: - UITextField Delegate Method
    
   /* func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        var vals : Bool = Bool()
        
        
          /*  if(textField == txtProfileType){
                
                let profileAlert = UIAlertController(title: "Please select Profile Type", message: "Let's choose profile type", preferredStyle: UIAlertControllerStyle.ActionSheet)
                
                profileAlert.addAction(UIAlertAction(title: "Public Profile", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
                    print("Public profile selected")
                    self.txtProfileType.text = "Public Profile"
                }))
                
                
                profileAlert.addAction(UIAlertAction(title: "Private Profile", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
                    print("Private profile selected")
                    self.txtProfileType.text = "Private Profile"
                }))
                profileAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.presentViewController(profileAlert, animated: true, completion: nil)
                
                vals = false
            }else */
        if(textField == txtCharitySupported){
                vals = false
                
                let charityAlert = UIAlertController(title: "Please select Supporting Charity", message: "Let's choose Charity name", preferredStyle: UIAlertControllerStyle.Alert)
                
                charityAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                
                
                
                for i in 0..<self.charityIDArray.count{
                    charityAlert.addAction(UIAlertAction(title: self.charityNameArray[i], style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
                        self.is_charitySelected = true
                        self.txtCharitySupported.text = self.charityNameArray[i]
                        self.supportedCharityID = self.charityIDArray[i]
                    }))
                }
                
                charityAlert.addAction(UIAlertAction(title: "Don't have Charity, Please let us know", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
                   
                    
                }))
                
                self.presentViewController(charityAlert, animated: true, completion: nil)
                
                
            }
        return vals
    }*/
    
    
//TODO: - UITextViewDelegate Method 
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == self.cust.placeholderTextColor{
            textView.text = nil
            is_aboutUserChanged = true
            textView.textColor = textColor
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
         if textView == txtDescription{
            
            if textView.text.isEmpty{
                is_aboutUserChanged = false
                txtDescription.text = "about me (optional)"
                txtDescription.textColor = self.cust.placeholderTextColor
            }
            
        }
        
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        if(textView == txtDescription){
            self.updateCharacterCount()
            return txtDescription.text.characters.count +  (text.characters.count - range.length) <= 120
        }
        return true
    }
    
    
//TODO: Button Action
    
    @IBAction func btnProfileTypeClick(sender: AnyObject) {
        let profileAlert = UIAlertController(title: "Please select Profile Type", message: "Let's choose profile type", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        profileAlert.addAction(UIAlertAction(title: "Public Profile", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("Public profile selected")
            self.is_publicProfile = true
            self.profileType_selected = true
            self.btnProfileTypeOutlet.setTitle("Public profile", forState: UIControlState.Normal)
        }))
        
        
        profileAlert.addAction(UIAlertAction(title: "Private Profile", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("Private profile selected")
             self.is_publicProfile = false
            self.profileType_selected = true
            self.btnProfileTypeOutlet.setTitle("Private profile", forState: UIControlState.Normal)
            
        }))
        profileAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(profileAlert, animated: true, completion: nil)
        
    }
    @IBAction func btnCharitySpotlightClick(sender: AnyObject) {
        
        let editChVC = self.storyboard?.instantiateViewControllerWithIdentifier("idUpdateCharityViewController") as! UpdateCharityViewController
        let fbDetails = defaults.valueForKey("fbUserDetails") as! NSDictionary        
        let emailID = fbDetails["emailID"] as! String
        self.delObj.loginUserEmail = emailID
        self.navigationController?.pushViewController(editChVC, animated: true)
        
    }
    @IBAction func btnAddNonProfiltClick(sender: AnyObject) {
        
        let addVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAddNonProfitTableViewController") as! AddNonProfitTableViewController
        self.presentViewController(addVC, animated: true, completion: nil)
    }
    @IBAction func btnSignupClick(sender: AnyObject) {
        
        doSignup()
      /*  let contVC = self.storyboard?.instantiateViewControllerWithIdentifier("idContainerViewController") as! ContainerViewController
        self.navigationController?.pushViewController(contVC, animated: true)*/
        
    }
    @IBAction func btnTermsClick(sender: AnyObject) {
        let termsVC = self.storyboard?.instantiateViewControllerWithIdentifier("idTermsOfServiceViewController") as! TermsOfServiceViewController
        self.navigationController?.pushViewController(termsVC, animated: true)
        

        
    }
    @IBAction func profileTypeSwitchChange(sender: AnyObject) {
        if profileTypeSwitch.on {
            print("Profile Type is Private")
            is_publicProfile = false
        } else {
            print("Profile Type is Public")
            is_publicProfile = true
        }
        
    }
    @IBAction func termsValueChanged(sender: AnyObject) {
        if termsSwitch.on {
            print("Switch is ON")
            i_agreeTerms = true
        } else {
            print("Switch is Off")
            i_agreeTerms = false
        }

    }
    @IBAction func btnBackClick(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

}
