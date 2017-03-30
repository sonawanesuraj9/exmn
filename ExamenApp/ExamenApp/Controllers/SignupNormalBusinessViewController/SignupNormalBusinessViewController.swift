//
//  SignupNormalBusinessViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 6/27/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire


class SignupNormalBusinessViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    let myKeychainWrapper : KeychainWrapper = KeychainWrapper()
    
    var returnKeyHandler : IQKeyboardReturnKeyHandler = IQKeyboardReturnKeyHandler()
      let textColor = UIColor(red: 0/255, green: 73/255, blue: 126/255, alpha: 1.0)
    
    let imgPicker : UIImagePickerController = UIImagePickerController()
    let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
   
    var base64String : NSString = NSString()
    var is_imageUpload : Bool = Bool()
    var is_nextScreenVisible : Bool = Bool()
    var i_agreeTerms : Bool = Bool()
    
    var is_validEmailAddress : Bool = Bool()
    
//TODO: - Controls
    
    @IBOutlet weak var switchTerms: UISwitch!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var btnContinueOutlet: UIButton!
    
    //First View Outlet
    
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    
    //Second View Outlet
    
    @IBOutlet weak var btnCharitySpotlight: UIButton!
    @IBOutlet weak var txtWebsiteUrl: UITextField!
    @IBOutlet weak var txtIntroduction: UITextView!
    @IBOutlet weak var txtOutlineCause: UITextView!
    
    @IBOutlet weak var btnBackToViewOutelt: UIButton!
    @IBOutlet weak var btnSignupOutlet: UIButton!
    
    
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.txtBusinessName.delegate = self
        self.txtZipcode.delegate = self
        self.txtUsername.delegate = self
        self.txtPassword.delegate = self
        self.txtConfirmPassword.delegate = self
        self.txtEmailID.delegate = self
        self.txtOutlineCause.delegate = self
        self.txtIntroduction.delegate = self

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        viewselection_custom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    
//TODO:- Function
    
    func viewselection_custom(){
        initialization()
        roundedImageView()
      
        
        if(!delObj.tmp_next){
            firstView.hidden = false
            secondView.hidden = true
            
            self.btnBackToViewOutelt.hidden = true
            self.btnSignupOutlet.hidden = true
            self.btnContinueOutlet.hidden = false
            
            
            self.firstView.center.x = self.view.center.x
            self.secondView.center.x  += self.view.bounds.width
            
            initialization()
            roundedImageView()
            
            //ImageTap
            self.imgProfile.userInteractionEnabled = true
            tapGesture.addTarget(self, action: #selector(SignupNormalBusinessViewController.profileImageHasBeenTapped))
            self.imgProfile.addGestureRecognizer(tapGesture)
            
            
        }else{
            firstView.hidden = true
            secondView.hidden = false
            
            self.btnBackToViewOutelt.hidden = false
            self.btnSignupOutlet.hidden = false
            self.btnContinueOutlet.hidden = true
            
            self.firstView.center.x -= self.view.bounds.width
            self.secondView.center.x = self.view.center.x
            
            if(self.delObj.is_normal_CharitySelected){
                self.btnCharitySpotlight.setTitle(self.delObj.normal_charityName, forState: UIControlState.Normal)
            }
            
        }
        
    }
   
    
    func initialization(){
        
        //TextView
        
        
        //Button
        self.btnContinueOutlet.layer.cornerRadius = cust.RounderCornerRadious
         self.btnBackToViewOutelt.layer.cornerRadius = cust.RounderCornerRadious
         self.btnSignupOutlet.layer.cornerRadius = cust.RounderCornerRadious
        
        
        //ImageView
        self.imgProfile.layer.cornerRadius = cust.RounderCornerRadious
        
        
        //TextField
        self.txtBusinessName.attributedPlaceholder = NSAttributedString(string:"business name",
                                                                     attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        
        self.txtEmailID.attributedPlaceholder = NSAttributedString(string:"email address",
                                                                   attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtUsername.attributedPlaceholder = NSAttributedString(string:"username",
                                                                    attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtPassword.attributedPlaceholder = NSAttributedString(string:"password (minimum 6 characters)",
                                                                    attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtConfirmPassword.attributedPlaceholder = NSAttributedString(string:"confirm password",
                                                                           attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtZipcode.attributedPlaceholder = NSAttributedString(string:"zipcode",
                                                                   attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtWebsiteUrl.attributedPlaceholder = NSAttributedString(string:"website url",
                                                                   attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        

        //Keyboard
        self.txtBusinessName.autocorrectionType = UITextAutocorrectionType.No
        self.txtEmailID.autocorrectionType = UITextAutocorrectionType.No
        self.txtUsername.autocorrectionType = UITextAutocorrectionType.No
        self.txtPassword.autocorrectionType = UITextAutocorrectionType.No
        self.txtConfirmPassword.autocorrectionType = UITextAutocorrectionType.No
        self.txtZipcode.autocorrectionType = UITextAutocorrectionType.No
        
        self.txtBusinessName.keyboardType = UIKeyboardType.Alphabet
        self.txtEmailID.keyboardType = UIKeyboardType.Alphabet
        self.txtUsername.keyboardType = UIKeyboardType.Alphabet
        self.txtPassword.keyboardType = UIKeyboardType.Alphabet
        self.txtConfirmPassword.keyboardType = UIKeyboardType.Alphabet
        self.txtZipcode.keyboardType = UIKeyboardType.Alphabet
        
        //set cursor color
        self.txtBusinessName.tintColor = cust.textTintColor
        self.txtEmailID.tintColor = cust.textTintColor
        self.txtUsername.tintColor = cust.textTintColor
        self.txtPassword.tintColor = cust.textTintColor
        self.txtConfirmPassword.tintColor = cust.textTintColor
        self.txtZipcode.tintColor = cust.textTintColor
        self.txtWebsiteUrl.tintColor = cust.textTintColor

        
        
        
        initPlaceholderForTextView()
    }
    
    func roundedImageView(){
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        self.imgProfile.clipsToBounds = true
    }
    
    func profileImageHasBeenTapped(){
        print("image tapped")
        self.askToChangeImage()
    }
    
    func askToChangeImage(){
        let alert = UIAlertController(title: "Let's get a picture", message: "Choose a picture method", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        self.imgPicker.delegate = self
        
        if(is_imageUpload){
            let removeImageButton = UIAlertAction(title: "Remove profile picture", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
                self.is_imageUpload = false
                self.imgProfile.image = self.delObj.userPlaceHolderImage
            }
            alert.addAction(removeImageButton)
        }else{
            print("No image is selected")
        }
        
        //Add AlertAction to select image from library
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.imgPicker.delegate = self
            self.imgPicker.allowsEditing = true
            self.presentViewController(self.imgPicker, animated: true, completion: nil)
        }
        
        //Check if Camera is available, if YES then provide option to camera
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.imgPicker.allowsEditing = true
                self.presentViewController(self.imgPicker, animated: true, completion: nil)
            }
            alert.addAction(cameraButton)
        } else {
            print("Camera not available")
            
        }
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
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
    
//TODO: - UITextField Delegate Method
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
       /* if(textField == txtBusinessName){
            
            let alphaOnly = NSCharacterSet.init(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
            let stringFromTextField = NSCharacterSet.init(charactersInString: string)
            let strValid = alphaOnly.isSupersetOfSet(stringFromTextField)
            
            return strValid
        }else*/ if(textField == txtZipcode){
            let numOnly = NSCharacterSet.init(charactersInString: "0123456789")
            let stringFromTextField = NSCharacterSet.init(charactersInString: string)
            let strValid = numOnly.isSupersetOfSet(stringFromTextField)
            
            return strValid
        }else{
            return true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == self.txtEmailID){
            let tmpEmail = self.txtEmailID.text
            if(tmpEmail != ""){
                if(self.cust.isValidEmail(tmpEmail!))
                {
                    myFunction(tmpEmail!) { response in
                        print("response32432:\(response)")
                        if(response){
                            self.is_validEmailAddress = true
                            print("is_validEmailAddress true")
                        }else{
                            self.is_validEmailAddress = false
                            self.txtEmailID.text = ""
                            self.delObj.displayMessage("examen", messageText: "email address already exists")
                            print("is_validEmailAddress false")
                        }
                        
                    }
                    
                }else{
                    self.delObj.displayMessage("examen", messageText: "please enter valid email address")
                }
            }
            print("TextField did end editing method called")
        }else if(textField == self.txtPassword){
            let count = self.txtPassword.text?.characters.count
            
            if(count<=5){
                self.delObj.displayMessage("examen", messageText: "password must have minimum 6 characters")
            }
            
        }

    }
   
    
    
    func checkFirstScreenMandatory() -> Bool{
        var outFlag : Bool = Bool()
        
       if(self.txtBusinessName.text == ""){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter business name")
        }else if(self.txtUsername.text == ""){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter username")
        }
        else if(self.txtPassword.text == ""){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter password")
        }else if(self.txtConfirmPassword.text == ""){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter confirm password")
        }else if(self.txtConfirmPassword.text != self.txtPassword.text){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "password does not match")
        }else if(self.txtEmailID.text == ""){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter email address")
        }else if(!(self.cust.isValidEmail(self.txtEmailID.text!))){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter valid email address")
       }else if(!self.is_validEmailAddress){
        outFlag = false
        self.delObj.displayMessage("examen", messageText: "email address already register")
       }else if(self.txtZipcode.text == ""){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter zipcode")
        }else{
            outFlag = true
        }
        
        return outFlag
    }
    

    func checkforSecondScreenMandatory()->Bool{
        var tmpFlag : Bool = Bool()
       if(!i_agreeTerms){
            tmpFlag = false
            self.delObj.displayMessage("examen", messageText: "please accept terms of service")
       
       }/*else if(!self.delObj.is_normal_CharitySelected){
        tmpFlag = false
        self.delObj.displayMessage("examen", messageText: "please select charity supported")
       }*/
       else{
            tmpFlag = true
        }
        return tmpFlag
        
    }
    
    
    /*
     else if(self.txtWebsiteUrl.text != ""){
     if(!(cust.isValidUrl(self.txtWebsiteUrl.text!))){
     tmpFlag = false
     self.delObj.displayMessage("examen", messageText: "please enter valid website url")
     self.txtWebsiteUrl.becomeFirstResponder()
     }else{
     tmpFlag = true
     }
     */

//TODO: - Web service / API call
    
    
    func myFunction(emailID:String, completion : (Bool) -> ()) {
        SVProgressHUD.showWithStatus("Loading...")
        
        let params = ["email":emailID]
        print("params:\(params)")
        var tmpStat : Bool = Bool()
        Alamofire.request(.POST, delObj.baseUrl + "checkemail", parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .Success:
                    let outJSON = JSON(response.result.value!)
                    SVProgressHUD.dismiss()
                    if(outJSON["status"] != "1"){
                        
                        let tmpFlag = outJSON["data"]["isPresent"].stringValue
                        if(tmpFlag == "Y"){
                            // user email aldreay exist
                            tmpStat = false
                        }else{
                            // user email doesnot exist, allow this email
                            tmpStat = true
                        }
                        
                    }else{
                        // Fail Block execute
                        tmpStat = false
                    }
                    
                    completion(tmpStat)
                case .Failure(let error):
                    SVProgressHUD.dismiss()
                    print(error)
                    completion(false)
                }
        }
    }
   
    
    
    func doSignup(){
        
        if(checkFirstScreenMandatory()){
            if(checkforSecondScreenMandatory()){
                
                var introduction : String = String()
                if(self.delObj.is_business_normal_introChanged){
                    introduction = self.txtIntroduction.text
                }else{
                    introduction = ""
                }
                var outline : String = String()
                if(self.delObj.is_business_ouline_changed){
                    outline = self.txtOutlineCause.text
                }else{
                    outline = ""
                }
                
                let parameters = ["username": self.txtUsername.text!,
                                  "password":self.txtConfirmPassword.text!,
                                  "businessname":self.txtBusinessName.text!,
                                  "introduction":introduction,
                                  "outline_cause":outline,
                                  "email":self.txtEmailID.text!,
                                  "zip":self.txtZipcode.text!,
                                  "profile_type":"Public",
                                  "charity_supported":self.delObj.normal_supportedCharityID,
                                  "photo":base64String,
                                  "iagree":"1",
                                  "dev_token":self.delObj.deviceTokenToSend,
                                  "dev_type":"iPhone",
                                  "url":self.txtWebsiteUrl.text!,
                                  "dev_id":self.delObj.deviceUDID]
                
                SVProgressHUD.showWithStatus("creating profile..")
                
                Alamofire.request(.POST, delObj.baseUrl + "Business_signup", parameters: parameters).responseJSON{
                    response in
                    print("parameters:\(parameters)")
                    print("output:\(response.result.value)")
                    
                    if(response.result.isSuccess){
                        
                        SVProgressHUD.dismiss()
                        let outJSON = JSON(response.result.value!)
                        if(outJSON["status"] != "1"){
                            
                            //Successful Signup, Now login
                            self.delObj.isNewTimeUser = true
                            self.doLogin(self.txtUsername.text!, loginPassword: self.txtConfirmPassword.text!)
                            
                        }else{
                            
                            self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                            
                        }
                    }else{
                        SVProgressHUD.dismiss()
                        self.delObj.displayMessage("examen", messageText: "please check internet connection")
                        
                    }
                }
                
            }// Second Mandatory close
        }//First Mandatory close
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
                    
                    self.defaults.setBool(true, forKey: "is_Autologin")
                    let city_State = outJSON["data"]["city"].stringValue  + ", " + outJSON["data"]["state"].stringValue
                   
                    self.delObj.created_date = outJSON["data"]["created_date"].stringValue
                    self.delObj.admin_photo_URL = outJSON["data"]["admin_photo"].stringValue
                    
                    
                    let zipcode = outJSON["data"]["zip"].stringValue
                    
                    //Store user info for profile page
                    let loginUserDetalis = [
                        "emailID":outJSON["data"]["email"].stringValue,
                        "city_State":city_State,
                        "fname":outJSON["data"]["first_name"].stringValue,
                        "lname":"",
                        "about_me":outJSON["data"]["about_me"].stringValue,
                        
                        "zipcode":zipcode,
                        
                        "profile_type":outJSON["data"]["profile_type"].stringValue
                    ]
                    
                    let userProfilePhoto = outJSON["data"]["profile_photo"].stringValue
                    let userCoverPhoto = outJSON["data"]["cover_photo"].stringValue
                    
                    General.saveData(userProfilePhoto, name: "userProfilePhoto")
                    General.saveData(userCoverPhoto, name: "userCoverPhoto")
                    
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
                    
                    /***************** Volunteer Activity ************/
                    
                    
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
                   
                    
                    /**************************************************/                    let charityDetails = [
                        "charity_logo":outJSON["data"]["charity_supported"]["charity_logo"].stringValue,
                        "charity_name":outJSON["data"]["charity_supported"]["charity_name"].stringValue,
                        "charityID":outJSON["data"]["charity_supported"]["id"].stringValue,
                        "charity_website":outJSON["data"]["charity_supported"]["website"].stringValue
                    ]
                    
                    self.defaults.setValue(charityDetails, forKey: "loginUsercharityDetails")
                    self.defaults.setValue(loginUserDetalis, forKey: "loginUserDetalis")
                    
                    
                    self.defaults.synchronize()
                    print(charityDetails)
                    print(loginUserDetalis)
                    //clear window
                    //self.txtUsername.text = ""
                    // self.txtPassword.text = ""
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
    

    
//TODO: - UIImagePickerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let pickedImage : UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.imgProfile.image = cust.rotateCameraImageToProperOrientation(pickedImage, maxResolution: 360)// pickedImage
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
        self.imgProfile.clipsToBounds = true
        
        //let imageData = UIImageJPEGRepresentation(pickedImage, 0.8)
        let imageData : NSData = UIImageJPEGRepresentation(self.imgProfile.image!,0.8)!
        base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        is_imageUpload = true
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        is_imageUpload = false
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    

    

//TODO: - Button Action
    
    @IBAction func btnCharitySpotlightClick(sender: AnyObject) {
        let editChVC = self.storyboard?.instantiateViewControllerWithIdentifier("idUpdateCharityViewController") as! UpdateCharityViewController
        self.delObj.loginUserEmail = self.txtEmailID.text!
        self.navigationController?.pushViewController(editChVC, animated: true)
    }
    
    @IBAction func btnTermsOfServiceClick(sender: AnyObject) {
        let termsVC = self.storyboard?.instantiateViewControllerWithIdentifier("idTermsOfServiceViewController") as! TermsOfServiceViewController
        self.navigationController?.pushViewController(termsVC, animated: true)
        
        
        print("Terms CLick")
    }
    
    @IBAction func TermsSwitch(sender: AnyObject) {
        
        if switchTerms.on {
            i_agreeTerms = true
            print("Switch is ON")
        } else {
            i_agreeTerms = false
            print("Switch is Off")
        }
        
    }
    
    @IBAction func btnSignupClick(sender: AnyObject) {
        doSignup()
    }
    
    
    @IBAction func btnBackToViewClick(sender: AnyObject) {
        
        is_nextScreenVisible = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.secondView.center.x = self.view.center.x + self.secondView.bounds.width
            
            
        }) { (value:Bool) -> Void in
            
            self.firstView.hidden = false
            self.secondView.hidden = true
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.firstView.center.x += self.view.bounds.width
                self.btnBackToViewOutelt.hidden = true
                self.btnSignupOutlet.hidden = true
                self.btnContinueOutlet.hidden = false
                self.delObj.tmp_next = false
                self.viewselection_custom()
            }) { (value:Bool) -> Void in
                // self.SecondView.center.x = self.view.center.x
            }
            
            
        }

        
    }
    
    @IBAction func btnContinueClick(sender: AnyObject) {
        if checkFirstScreenMandatory() {
            
            is_nextScreenVisible = true
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.firstView.center.x -= self.view.bounds.width
            }) { (value:Bool) -> Void in
                
                self.firstView.hidden = true
                self.secondView.hidden = false
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.secondView.center.x = self.view.center.x
                    self.btnBackToViewOutelt.hidden = false
                    self.btnSignupOutlet.hidden = false
                    self.btnContinueOutlet.hidden = true
                    self.delObj.tmp_next = true
                }) { (value:Bool) -> Void in
                    // self.SecondView.center.x = self.view.center.x
                }
                
            }
            
        }
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
