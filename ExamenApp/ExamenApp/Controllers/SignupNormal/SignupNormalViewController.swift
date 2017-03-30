//
//  SignupNormalViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 4/28/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire


class SignupNormalViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var returnKeyHandler : IQKeyboardReturnKeyHandler = IQKeyboardReturnKeyHandler()
    let myKeychainWrapper : KeychainWrapper = KeychainWrapper()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let loginVC : LoginViewController = LoginViewController()
    
    
    let boderColor_textfield : UIColor = UIColor(red: 130/255, green: 161/255, blue: 182/255, alpha: 1.0)
    let borderWidth_textfield : CGFloat = 1
    let TextColor : UIColor = UIColor(red: 0/255, green: 73/255, blue: 126/255, alpha: 1.0)
    
   
    var base64String : NSString = NSString()
    var is_imageUpload : Bool = Bool()
    var is_nextScreenVisible : Bool = Bool()
     let imgPicker : UIImagePickerController = UIImagePickerController()
    let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    var i_agreeTerms : Bool = Bool()
    var is_publicProfile : Bool = Bool()
    let textColor = UIColor(red: 66/255, green: 110/255, blue: 216/255, alpha: 1.0)
    var nonProfitResumeToSend : [Dictionary<String,AnyObject>] = []
    
    var is_validEmailAddress : Bool = Bool()
    var didyouGotResponse : Bool = Bool()
    //API Variables
    
    var supportedCharityID : String = String()
    var charityNameArray : [String] = []
    var charityIDArray : [String] = []
    var charityWebsiteArray : [String] = []
    var charityLogoArray : [String] = []
    
    
//TODO: - Control
    
    //SecondView Controls
    @IBOutlet weak var btnProfileTypeOutlet: UIButton!
    @IBOutlet weak var sep10: UILabel!
    @IBOutlet weak var btnAddNonProfiltOutlet: UIButton!
    
    @IBOutlet weak var lblRemainCharacter: UILabel!
    @IBOutlet weak var btnCharitySpotlight: UIButton!
  //  @IBOutlet weak var txtCharitySupported: UITextField!
   // @IBOutlet weak var txtProfileType: UITextField!
    @IBOutlet weak var txtAboutUser: UITextView!
  //  @IBOutlet weak var txtVolunteerActivity: UITextView!
    @IBOutlet weak var btnContinueOutlet: UIButton!
    @IBOutlet weak var btnBackToViewOutlet: UIButton!
    @IBOutlet weak var SecondView: UIView!
   
    @IBOutlet weak var btnTermsOfServiceOutlet: UIButton!
    @IBOutlet weak var lblIAgreeTitle: UILabel!
    
    @IBOutlet weak var profileTypeSwitch: UISwitch!
    
    //FirstView Controls
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var switchTerms: UISwitch!
    @IBOutlet weak var btnSignupOutlet: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    
    
//TODO: - Let's Play

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //IQKeyboardReturnKeyHandler Method
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)

       
        // mainScroll.contentSize=CGSizeMake(mainScroll.frame.size.width, mainScroll.frame.size.height+400);
        
        
        //Charity Listing fetch
       // fetchCharityListing()
        
        i_agreeTerms = false
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtZipcode.delegate = self
        self.txtUsername.delegate = self
        self.txtPassword.delegate = self
        self.txtConfirmPassword.delegate = self
        self.txtEmailID.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
       // is_nextScreenVisible = false
        
       viewselection_custom()
       
        
        
    }
    
   
    
    func viewselection_custom(){
        if(!delObj.tmp_next){
            FirstView.hidden = false
            SecondView.hidden = true
            
            self.btnBackToViewOutlet.hidden = true
            self.btnSignupOutlet.hidden = true
            self.btnContinueOutlet.hidden = false
            
            
            self.FirstView.center.x = self.view.center.x
            self.SecondView.center.x  += self.view.bounds.width
            
            initialization()
            roundedImageView()
            
            //ImageTap
            self.imgProfilePic.userInteractionEnabled = true
            tapGesture.addTarget(self, action: #selector(SignupNormalViewController.profileImageHasBeenTapped))
            self.imgProfilePic.addGestureRecognizer(tapGesture)
            
            
        }else{
            FirstView.hidden = true
            SecondView.hidden = false
            
            self.btnBackToViewOutlet.hidden = false
            self.btnSignupOutlet.hidden = false
            self.btnContinueOutlet.hidden = true
           
            //self.FirstView.center.x = self.view.center.x
            //self.SecondView.center.x  += self.view.bounds.width
            self.FirstView.center.x -= self.view.bounds.width
            self.SecondView.center.x = self.view.center.x
            
            if(self.delObj.is_normal_CharitySelected){
                self.btnCharitySpotlight.setTitle(self.delObj.normal_charityName, forState: UIControlState.Normal)
            }
           // dynamicallycreateView()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - UITextField Delegate Method    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == txtFirstName || textField == txtLastName){           
            
            let alphaOnly = NSCharacterSet.init(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
            let stringFromTextField = NSCharacterSet.init(charactersInString: string)
            let strValid = alphaOnly.isSupersetOfSet(stringFromTextField)
            
            return strValid
        }else if(textField == txtZipcode){
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
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if(textField == txtEmailID){
            print("TextField should end editing method called")
        }
        return true;
    }
    
    
//TODO: - Function    
    
    func initialization(){
        
        //TextView
        
       // self.txtVolunteerActivity.delegate = self
        self.txtAboutUser.delegate = self

        //Button
        self.btnSignupOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnContinueOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnBackToViewOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnAddNonProfiltOutlet.layer.cornerRadius = cust.RounderCornerRadious
       
        //ImageView
        self.imgProfilePic.layer.cornerRadius = cust.RounderCornerRadious
    
        
        //TextField
        self.txtFirstName.attributedPlaceholder = NSAttributedString(string:"first name",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtLastName.attributedPlaceholder = NSAttributedString(string:"last name",
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
        
        //Keyboard
        self.txtFirstName.autocorrectionType = UITextAutocorrectionType.No
        self.txtLastName.autocorrectionType = UITextAutocorrectionType.No
        self.txtEmailID.autocorrectionType = UITextAutocorrectionType.No
        self.txtUsername.autocorrectionType = UITextAutocorrectionType.No
        self.txtPassword.autocorrectionType = UITextAutocorrectionType.No
        self.txtConfirmPassword.autocorrectionType = UITextAutocorrectionType.No
        self.txtZipcode.autocorrectionType = UITextAutocorrectionType.No

        self.txtFirstName.keyboardType = UIKeyboardType.Alphabet
        self.txtLastName.keyboardType = UIKeyboardType.Alphabet
        self.txtEmailID.keyboardType = UIKeyboardType.Alphabet
         self.txtUsername.keyboardType = UIKeyboardType.Alphabet
        self.txtPassword.keyboardType = UIKeyboardType.Alphabet
        self.txtConfirmPassword.keyboardType = UIKeyboardType.Alphabet
        self.txtZipcode.keyboardType = UIKeyboardType.Alphabet
        
        self.txtFirstName.tintColor = cust.textTintColor
        self.txtLastName.tintColor = cust.textTintColor
        self.txtEmailID.tintColor = cust.textTintColor
        self.txtUsername.tintColor = cust.textTintColor
        self.txtPassword.tintColor = cust.textTintColor
        self.txtConfirmPassword.tintColor = cust.textTintColor
        self.txtZipcode.tintColor = cust.textTintColor

        
      //  self.txtCharitySupported.attributedPlaceholder = NSAttributedString(string:"Charity spotlight",attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
       
        //Init counter
        setCountAttributedLabel("0", Outof: "/120 Characters")
        
        
        
        initPlaceholderForTextView()
    }

    func roundedImageView(){
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width/2
        self.imgProfilePic.clipsToBounds = true
    }
    
    func initPlaceholderForTextView(){
        txtAboutUser.text = "about me (optional)"
        txtAboutUser.textColor = self.cust.placeholderTextColor
        txtAboutUser.tintColor = cust.textTintColor
        self.delObj.is_normal_aboutmechange = false
        //txtVolunteerActivity.text =  "Volunteer activity"
        //txtVolunteerActivity.textColor = self.cust.placeholderTextColor
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
                self.imgProfilePic.image = self.delObj.userPlaceHolderImage
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
    
    func checkFirstScreenMandatory() -> Bool{
        var outFlag : Bool = Bool()
        
        if(self.txtFirstName.text == ""){
             outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter first name")
            
        }else if(self.txtLastName.text == ""){
             outFlag = false
             self.delObj.displayMessage("examen", messageText: "please enter last name")
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
        
        /*if(!self.delObj.is_normal_profileType){
            tmpFlag = false
            self.delObj.displayMessage("examen", messageText: "please select profile type")
        }*/
            
        /*else if(!self.delObj.is_normal_CharitySelected){
            tmpFlag = false
             self.delObj.displayMessage("examen", messageText: "please select charity spotlight")
        }*/
        
        if(!i_agreeTerms){
            tmpFlag = false
             self.delObj.displayMessage("examen", messageText: "please accept terms of service")
        }else{
            tmpFlag = true
        }
        return tmpFlag
        
    }
    
   
    
    func updateCharacterCount() {
        print("txtAboutMe.text.characters.count:\(txtAboutUser.text.characters.count)")
        let ct = "\(txtAboutUser.text.characters.count)"
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
    
    
//TODO: - WebService / API Call
    
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
    
//TODO: - Signup API / Web Service
    
    func doSignup(){
        
        if(checkFirstScreenMandatory()){
            if(checkforSecondScreenMandatory()){
                
                var profType : String = String()
                if(is_publicProfile){
                    profType = "Public"
                }else{
                    profType = "Private"
                }
                
                var aboutMeText : String = String()
                if(self.delObj.is_normal_aboutmechange){
                    aboutMeText = self.txtAboutUser.text
                }else{
                    aboutMeText = ""
                }
                
                let tmpCount = String(self.delObj.selectedCompanyArray_nonprofit.count)
                var parameters : [String : AnyObject] = ["username": self.txtUsername.text!,
                                  "password":self.txtConfirmPassword.text!,
                                  "first_name":self.txtFirstName.text!,
                                  "last_name":self.txtLastName.text!,
                                  "email":self.txtEmailID.text!,
                                  "zip":self.txtZipcode.text!,
                                  "profile_type":profType,
                                  "about_me":aboutMeText,
                                  "charity_supported":self.delObj.normal_supportedCharityID,
                                  "photo":base64String,
                                  "iagree":"1",
                                   "dev_token":self.delObj.deviceTokenToSend,
                                   "dev_type":"iPhone",
                                   "vol_count":tmpCount,
                                   
                                   "dev_id":self.delObj.deviceUDID]
                
                
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
                    parameters["vol_website"] = ""
                    parameters["vol_startdate"] = ""
                    parameters["vol_enddate"] = ""
                    parameters["vol_ispresent"] = ""
                }
                
        
                SVProgressHUD.showWithStatus("creating profile..")
           print("parameters:\(parameters)")
                Alamofire.request(.POST, delObj.baseUrl + "signup1", parameters: parameters).responseJSON{
                    response in
                 
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
            
            print("doLogin output\(response.result.value)")
            
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
                    
                    let zipcode = outJSON["data"]["zip"].stringValue
                    let user_profile = outJSON["data"]["user_profile"].stringValue
                    
                    self.delObj.created_date = outJSON["data"]["created_date"].stringValue
                    self.delObj.admin_photo_URL = outJSON["data"]["admin_photo"].stringValue
                    
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
                    
                    
                    
                    
                    let tmpPro = outJSON["data"]["user_profile"].stringValue
                    if(tmpPro == "true"){
                        self.delObj.is_loginUserBusiness = true
                    }else{
                        self.delObj.is_loginUserBusiness = false
                    }
                     self.defaults.setBool(self.delObj.is_loginUserBusiness, forKey: "is_loginUserBusiness")
                    
                    if(user_profile == "true"){
                        let busienssProfileDetalis = [
                            "url":outJSON["data"]["url"].stringValue,
                            "intro":outJSON["data"]["intro"].stringValue,
                            "outline":outJSON["data"]["outline"].stringValue,
                        ]
                        self.defaults.setValue(busienssProfileDetalis, forKey: "busienssProfileDetalis")
                    }
                   
                    let charityDetails = [
                        "charity_logo":outJSON["data"]["charity_supported"]["charity_logo"].stringValue,
                        "charity_name":outJSON["data"]["charity_supported"]["charity_name"].stringValue,
                        "charityID":outJSON["data"]["charity_supported"]["id"].stringValue,
                        "charity_website":outJSON["data"]["charity_supported"]["website"].stringValue
                    ]
                    
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
                    
                    /**************************************************/
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
                self.delObj.displayMessage("examen", messageText: "Please check internet connection")
                
            }
        }
        
    }
    

//TODO: - UIImagePickerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let pickedImage : UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.imgProfilePic.image = cust.rotateCameraImageToProperOrientation(pickedImage, maxResolution: 360)// pickedImage
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.height / 2
        self.imgProfilePic.clipsToBounds = true
       
        //let imageData = UIImageJPEGRepresentation(pickedImage, 0.8)
        let imageData : NSData = UIImageJPEGRepresentation(self.imgProfilePic.image!,0.8)!
        base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        is_imageUpload = true
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        is_imageUpload = false
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
//TODO: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == self.cust.placeholderTextColor{
            textView.text = nil
            textView.textColor = textColor
            self.delObj.is_normal_aboutmechange = true
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == txtAboutUser{
            
            if textView.text.isEmpty{
                txtAboutUser.text = "about me (optional)"
                txtAboutUser.textColor = self.cust.placeholderTextColor
                self.delObj.is_normal_aboutmechange = false
            }
            
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        if(textView == txtAboutUser){
            self.updateCharacterCount()
            return txtAboutUser.text.characters.count +  (text.characters.count - range.length) <= 120
        }
        return true
    }
    
    
//TODO: - Button Action
    
    @IBAction func profileTypeSwitchClick(sender: AnyObject) {
        if profileTypeSwitch.on {
            print("Profile Type is Private")
            is_publicProfile = false
        } else {
            print("Profile Type is Public")
            is_publicProfile = true
        }
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
    
    @IBAction func btnTermsOfServiceClick(sender: AnyObject) {
        let termsVC = self.storyboard?.instantiateViewControllerWithIdentifier("idTermsOfServiceViewController") as! TermsOfServiceViewController
        self.navigationController?.pushViewController(termsVC, animated: true)
        
        
        print("Terms CLick")
    }
    
    @IBAction func btnAddNonProfitClick(sender: AnyObject) {
        //present add non profit viewcontroller
    
        let addVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAddNonProfitTableViewController") as! AddNonProfitTableViewController
        
      /*  addVC.charityIDArray = self.charityIDArray
        addVC.charityNameArray = self.charityNameArray
        addVC.supportedCharityLogo = self.charityLogoArray*/
        self.presentViewController(addVC, animated: true, completion: nil)
        
    }
    
    @IBAction func btnProfileTypeClick(sender: AnyObject) {
        let profileAlert = UIAlertController(title: "Please select profile type", message: "Let's choose profile type", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        profileAlert.addAction(UIAlertAction(title: "Public profile", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("Public profile selected")
            self.is_publicProfile = true
            self.delObj.is_normal_profileType = true
            self.btnProfileTypeOutlet.setTitle("public profile", forState: UIControlState.Normal)
        }))
        
        
        profileAlert.addAction(UIAlertAction(title: "Private profile", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("Private profile selected")
            self.is_publicProfile = false
            self.delObj.is_normal_profileType = true
            self.btnProfileTypeOutlet.setTitle("private profile", forState: UIControlState.Normal)
            
        }))
        profileAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(profileAlert, animated: true, completion: nil)
        

    }
    
    @IBAction func btnCharitySpotlightClick(sender: AnyObject) {
      let editChVC = self.storyboard?.instantiateViewControllerWithIdentifier("idUpdateCharityViewController") as! UpdateCharityViewController
        self.delObj.loginUserEmail = self.txtEmailID.text!
        self.navigationController?.pushViewController(editChVC, animated: true)

    }
    
    @IBAction func btnSignupClick(sender: AnyObject) {
        
       doSignup()
        
        
       /* UIView.animateWithDuration(0.5, animations: {
            //self.FirstView.hidden = true
           // self.SecondView.hidden = false
            self.SecondView.center.x -= self.view.bounds.width
            // self.username.center.x += self.view.bounds.width
        })*/
    }
    
    @IBAction func btnBackViewClick(sender: AnyObject) {
        
        is_nextScreenVisible = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
             self.SecondView.center.x = self.view.center.x + self.SecondView.bounds.width
            
            
            }) { (value:Bool) -> Void in
                
                self.FirstView.hidden = false
                self.SecondView.hidden = true
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                   self.FirstView.center.x += self.view.bounds.width
                    self.btnBackToViewOutlet.hidden = true
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
                self.FirstView.center.x -= self.view.bounds.width
                }) { (value:Bool) -> Void in
                
                    self.FirstView.hidden = true
                    self.SecondView.hidden = false
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.SecondView.center.x = self.view.center.x
                        self.btnBackToViewOutlet.hidden = false
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
        self.delObj.tmp_next = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
