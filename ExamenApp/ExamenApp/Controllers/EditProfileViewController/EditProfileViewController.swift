//
//  EditProfileViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/5/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire

class EditProfileViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    var returnKeyHandler : IQKeyboardReturnKeyHandler = IQKeyboardReturnKeyHandler()
    
    
    
    var base64String : NSString = NSString()
    var base64CoverString : NSString = NSString()
    var is_imageUpload : Bool = Bool()
    var is_coverUpload : Bool = Bool()
    var is_profileImageSelected : Bool = Bool()
    
    var is_nextScreenVisible : Bool = Bool()
    let imgPicker : UIImagePickerController = UIImagePickerController()
    let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    let coverTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    
    let textColor = UIColor(red: 0/255, green: 73/255, blue: 126/255, alpha: 1.0)
    
    @IBOutlet weak var btnEditProfilePicOutlet: UIButton!
    @IBOutlet weak var btnEditCoverOutlet: UIButton!
    
    //Charity Array 
    var charityIDArray : [String] = []
    var charityNameArray : [String] = []
    var charityLogoArray : [String] = []
    var charityWebsiteArray : [String] = []
    var selectedCharityID : String = String()
    
    
   
//TODO: - Controls
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var btnChangePasswordOutlet: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    
   
    @IBOutlet weak var sepLast: UILabel!
    @IBOutlet weak var btnProfileType: UIButton!
    
    //UITextField
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtAboutMe: UITextView!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var personalView: UIView!
    
    /**************** Business View ***********/
    
    @IBOutlet weak var txtOutlineofCause: UITextView!
    @IBOutlet weak var txtIntroduction: UITextView!
    @IBOutlet weak var txtBusinessZip: UITextField!
    @IBOutlet weak var txtBusinessEmail: UITextField!
    @IBOutlet weak var txtWebsiteUrl: UITextField!
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var businessScroll: UIScrollView!
    @IBOutlet weak var businessView: UIView!
     /**************** Business View ***********/
//TODO: - Let's Play
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //IQKeyboardReturnKeyHandler Method
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)

        initialization()
        roundedImageView()
        //ImageTap
        self.imgProfile.userInteractionEnabled = true
        tapGesture.addTarget(self, action: #selector(EditProfileViewController.profileImageHasBeenTapped))
        self.imgProfile.addGestureRecognizer(tapGesture)
        
        
        //Cover Tap
        self.imgCover.userInteractionEnabled = true
        coverTapGesture.addTarget(self, action: #selector(EditProfileViewController.coverImageHasBeenTapped))
        self.imgCover.addGestureRecognizer(coverTapGesture)
        
        self.txtLastName.delegate = self
        self.txtFirstName.delegate = self
        
        initializeUserDetails()
        
        //Fetch charity info
        
        // fetchCharityListing()
        
    }
    
    func initializeUserDetails(){
        var profURL : String = String()
        var coverURL : String = String()
        
        //business profile
        if (defaults.valueForKey("busienssProfileDetalis") != nil){
            let busienssProfileDetalis = defaults.valueForKey("busienssProfileDetalis") as! NSDictionary
            if(busienssProfileDetalis["intro"] as? String != ""){
                self.txtIntroduction.text = busienssProfileDetalis["intro"] as? String
                self.txtIntroduction.textColor = textColor
            }
            
            if(busienssProfileDetalis["outline"] as? String != ""){
            self.txtOutlineofCause.text = busienssProfileDetalis["outline"] as? String
            self.txtOutlineofCause.textColor = textColor
            }
            self.txtWebsiteUrl.text = busienssProfileDetalis["url"] as? String
        }
        
        
        if(defaults.valueForKey("signuptype") != nil){
            if((defaults.valueForKey("signuptype") as! String) == "FB"){
                //Login via FB
                self.btnChangePasswordOutlet.hidden = true
                
            }else{
                //Login via Manual
                  self.btnChangePasswordOutlet.hidden = false
            }
        }

        
        if defaults.valueForKey("loginUserDetalis") != nil{
            
            let loginUserDetalis = defaults.valueForKey("loginUserDetalis") as! NSDictionary
            print(loginUserDetalis)
            let fname = loginUserDetalis["fname"] as! String
            let lname = loginUserDetalis["lname"] as! String
            self.txtBusinessName.text = fname
            self.txtFirstName.text = fname
            self.txtLastName.text =  lname
            self.txtBusinessEmail.text = loginUserDetalis["emailID"] as? String
            self.txtEmailID.text = loginUserDetalis["emailID"] as? String
            self.txtBusinessZip.text = loginUserDetalis["zipcode"] as? String
            self.txtZipcode.text = loginUserDetalis["zipcode"] as? String
            
            if(loginUserDetalis["profile_type"] as! String == "Public"){
                 self.btnProfileType.setTitle("Public", forState: UIControlState.Normal)
            }else{
                self.btnProfileType.setTitle("Private", forState: UIControlState.Normal)
            }
            
            if(loginUserDetalis[""] as? String != ""){
                self.txtAboutMe.text = loginUserDetalis["about_me"] as? String
                self.txtAboutMe.textColor =  textColor
            }
            
            
            profURL = General.loadSaved("userProfilePhoto")
            coverURL = General.loadSaved("userCoverPhoto")
            
            if(profURL != ""){
                
                
                SDImageCache.sharedImageCache().queryDiskCacheForKey(profURL) { ( img:UIImage!, cacheType:SDImageCacheType) -> Void in
                    if(img != nil){
                        
                        //  self.imgProfilePic.image = self.rotateImageToActual(img)
                        self.imgProfile.image = self.cust.rotateCameraImageToProperOrientation(img,maxResolution: 360)
                    }else{
                        //self.cust.showLoadingCircle()
                        Alamofire.request(.GET, profURL)
                            .response { request, response, data, error in
                                print(request)
                                if(data != nil){
                                   let image = UIImage(data: data! )
                                    SDImageCache.sharedImageCache().storeImage(image, forKey: profURL)
                                    self.imgProfile.image = self.cust.rotateCameraImageToProperOrientation(image!,maxResolution: 360)
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
            
            self.imgCover.image = self.delObj.coverPlaceholder
            if(coverURL != ""){
                
                SDImageCache.sharedImageCache().queryDiskCacheForKey(coverURL) { ( img:UIImage!, cacheType:SDImageCacheType) -> Void in
                    if(img != nil){
                       
                        self.imgCover.image = img
                    }else{
                        //self.cust.showLoadingCircle()
                        SVProgressHUD.showWithStatus("Loading...")
                        Alamofire.request(.GET, coverURL)
                            .response { request, response, data, error in
                                print(request)
                                print(response)
                                
                                if(data != nil){
                                    SVProgressHUD.dismiss()
                                    let image = UIImage(data: data! )
                                    SDImageCache.sharedImageCache().storeImage(image, forKey: profURL)
                                    self.imgCover.image = image
                                    
                                }else{
                                    SVProgressHUD.dismiss()
                                   // self.imgCover.hidden = true
                                    //Display placeholder
                                    self.imgCover.image = self.delObj.coverPlaceholder
                                }
                        }
                    }
                }
            }else{
                 self.imgCover.image = self.delObj.coverPlaceholder
               // self.imgCover.hidden = true
            }
            
        }else{
            
            //Noting to display
        }
        
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if(self.delObj.is_loginUserBusiness){
            
            self.personalView.hidden = true
            self.businessView.hidden = false
            
            // Create update profile button
            let imageWidth:CGFloat = UIScreen.mainScreen().bounds.width * 0.95
            let ypos = sepLast.frame.size.height + sepLast.frame.origin.y
            let btnUpdateOutlet : UIButton = UIButton()
            btnUpdateOutlet.frame = CGRectMake(8, ypos + 16, imageWidth, 35)
            btnUpdateOutlet.setTitle("Update profile", forState: UIControlState.Normal)
            btnUpdateOutlet.titleLabel?.font = UIFont(name: cust.FontName, size: 14)
            btnUpdateOutlet.backgroundColor = UIColor(red: 193/255, green: 89/255, blue: 4/255, alpha: 1.0)
            btnUpdateOutlet.layer.cornerRadius = cust.RounderCornerRadious
            btnUpdateOutlet.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btnUpdateOutlet.layer.cornerRadius = cust.RounderCornerRadious
            
            btnUpdateOutlet.addTarget(self, action: #selector(EditProfileViewController.btnUpdateBusinessClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            businessScroll.addSubview(btnUpdateOutlet)
            
            
            businessScroll.contentSize = CGSize(width: self.businessScroll.frame.width, height: btnUpdateOutlet.frame.origin.y + btnUpdateOutlet.frame.size.height + 16 )

        }else{
            self.personalView.hidden = false
            self.businessView.hidden = true
            
              // Create update profile button
            let imageWidth:CGFloat = UIScreen.mainScreen().bounds.width * 0.95
            let ypos = sepLast.frame.size.height + sepLast.frame.origin.y
            let btnUpdateOutlet : UIButton = UIButton()
            btnUpdateOutlet.frame = CGRectMake(8, ypos + 16, imageWidth, 35)
            btnUpdateOutlet.setTitle("Update profile", forState: UIControlState.Normal)
            btnUpdateOutlet.titleLabel?.font = UIFont(name: cust.FontName, size: 14)
            btnUpdateOutlet.backgroundColor = UIColor(red: 193/255, green: 89/255, blue: 4/255, alpha: 1.0)
            btnUpdateOutlet.layer.cornerRadius = cust.RounderCornerRadious
            btnUpdateOutlet.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btnUpdateOutlet.layer.cornerRadius = cust.RounderCornerRadious
            
            btnUpdateOutlet.addTarget(self, action: #selector(EditProfileViewController.btnUpdateProfileClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            mainScrollView.addSubview(btnUpdateOutlet)
            
            
            mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width, height: btnUpdateOutlet.frame.origin.y + btnUpdateOutlet.frame.size.height + 16 )

        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
      
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - UITextField Delegate method Implementation
   
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == txtFirstName || textField == txtLastName){
            
        
        let alphaOnly = NSCharacterSet.init(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
        let stringFromTextField = NSCharacterSet.init(charactersInString: string)
        let strValid = alphaOnly.isSupersetOfSet(stringFromTextField)
        
        return strValid
        }else{
            return true
        }
    }

    
//TODO: - Function
    
    
    
    func initialization(){
        
        //TextView
        
        self.txtAboutMe.delegate = self
        self.txtOutlineofCause.delegate = self
        self.txtIntroduction.delegate = self
        //Button
        
        
        
        //TextField
        self.txtFirstName.attributedPlaceholder = NSAttributedString(string:"first name",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtLastName.attributedPlaceholder = NSAttributedString(string:"last name",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtEmailID.attributedPlaceholder = NSAttributedString(string:"email address",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
       
        self.txtZipcode.attributedPlaceholder = NSAttributedString(string:"zipcode",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtBusinessZip.attributedPlaceholder = NSAttributedString(string:"zipcode",
                                                                   attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtBusinessEmail.attributedPlaceholder = NSAttributedString(string:"email address",
                                                                   attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        self.txtWebsiteUrl.attributedPlaceholder = NSAttributedString(string:"website url",
                                                                         attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        
        
        //Keyboard
        self.txtBusinessName.autocorrectionType = UITextAutocorrectionType.No
         self.txtFirstName.autocorrectionType = UITextAutocorrectionType.No
         self.txtLastName.autocorrectionType = UITextAutocorrectionType.No
        self.txtEmailID.autocorrectionType = UITextAutocorrectionType.No
        self.txtZipcode.autocorrectionType = UITextAutocorrectionType.No
        self.txtBusinessZip.autocorrectionType = UITextAutocorrectionType.No
        self.txtBusinessEmail.autocorrectionType = UITextAutocorrectionType.No
        
        
        self.txtBusinessName.keyboardType = UIKeyboardType.Alphabet
        self.txtFirstName.keyboardType = UIKeyboardType.Alphabet
        self.txtLastName.keyboardType = UIKeyboardType.Alphabet
        self.txtEmailID.keyboardType = UIKeyboardType.Alphabet
        self.txtZipcode.keyboardType = UIKeyboardType.Alphabet
        self.txtBusinessZip.keyboardType = UIKeyboardType.Alphabet
        self.txtBusinessEmail.keyboardType = UIKeyboardType.Alphabet
        
        //Tint Color
        self.txtBusinessName.tintColor = cust.textTintColor
        self.txtFirstName.tintColor = cust.textTintColor
        self.txtLastName.tintColor = cust.textTintColor
        self.txtEmailID.tintColor = cust.textTintColor
        self.txtZipcode.tintColor = cust.textTintColor
        self.txtBusinessZip.tintColor = cust.textTintColor
        self.txtBusinessEmail.tintColor = cust.textTintColor
        
        
        
        initPlaceholderForTextView()
    }
    
    
    func roundedImageView(){
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        self.imgProfile.clipsToBounds = true
    }
    
    func initPlaceholderForTextView(){
        txtAboutMe.text = "about me (optional)"
        txtAboutMe.textColor = self.cust.placeholderTextColor
        
        txtIntroduction.text = "introduction"
        txtIntroduction.textColor = self.cust.placeholderTextColor
        
        txtOutlineofCause.text = "outline of cause"
        txtOutlineofCause.textColor = self.cust.placeholderTextColor
        
        
    }
    
    func profileImageHasBeenTapped(){
        print("image tapped")
        self.askToChangeProfileImage()
    }
    
    func coverImageHasBeenTapped(){
        print("cover tapped")
        asktToChangeCoverImage()
        
    }
    
    func asktToChangeCoverImage(){
        
        let alert = UIAlertController(title: "Let's get a cover picture", message: "Choose a picture method", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        self.imgPicker.delegate = self
        
        if(is_coverUpload){
            let removeImageButton = UIAlertAction(title: "Remove cover picture", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
                self.is_coverUpload = false
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
            self.is_profileImageSelected = false
            self.presentViewController(self.imgPicker, animated: true, completion: nil)
        }
        
        //Check if Camera is available, if YES then provide option to camera
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.imgPicker.allowsEditing = true
                 self.is_profileImageSelected = false
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
    
    
    
    func askToChangeProfileImage(){
        let alert = UIAlertController(title: "Let's get a picture", message: "Choose a Picture Method", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
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
             self.is_profileImageSelected = true
            self.presentViewController(self.imgPicker, animated: true, completion: nil)
        }
        
        //Check if Camera is available, if YES then provide option to camera
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.imgPicker.allowsEditing = true
                 self.is_profileImageSelected = true
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
    
    
    
    func mandatoryCheck() -> Bool {
        
        var outFlag : Bool = Bool()
        if(self.txtFirstName.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter first name")
            outFlag = false
        }else if(self.txtLastName.text == ""){
             self.delObj.displayMessage("examen", messageText: "please enter last name")
            outFlag = false
        }else if(self.txtEmailID.text == ""){
             self.delObj.displayMessage("examen", messageText: "please enter email address")
            outFlag = false
        }else if(!(self.cust.isValidEmail(self.txtEmailID.text!))){
             self.delObj.displayMessage("examen", messageText: "please enter valid email address")
            outFlag = false
        }else if(self.txtZipcode.text == ""){
             self.delObj.displayMessage("examen", messageText: "please enter zip code")
            outFlag = false
        }else if(self.btnProfileType.titleLabel?.text == ""){
             self.delObj.displayMessage("examen", messageText: "please enter select profile type")
            outFlag = false
        }else{
            outFlag = true
        }
        
        
        return outFlag
        
    }
    
    func businessMandatoryCheck() -> Bool {
        
        var outFlag : Bool = Bool()
        if(self.txtBusinessName.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter business name")
            outFlag = false
        }else if(self.txtEmailID.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter email address")
            outFlag = false
        }else if(!(self.cust.isValidEmail(self.txtEmailID.text!))){
            self.delObj.displayMessage("examen", messageText: "please enter valid email address")
            outFlag = false
        }else if(self.txtZipcode.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter zip code")
            outFlag = false
        }else{
            outFlag = true
        }
        
        
        return outFlag
        
    }
    
    
//TODO: - Web service / API for Update data
    
    func updatePersonalUserData(){
        
        if mandatoryCheck() {      
        
            let parameters = ["userid":self.delObj.loginUserID,
                              "first_name":self.txtFirstName.text!,
                              "last_name":self.txtLastName.text!,
                              "email":self.txtEmailID.text!,
                              "zip":self.txtZipcode.text!,
                              "profile_type":self.btnProfileType.titleLabel!.text!,
                              "about_me":self.txtAboutMe.text!,
                              "charity_supported":self.selectedCharityID
                            ]
        
            SVProgressHUD.showWithStatus("Updating..")
        
            Alamofire.request(.POST, delObj.baseUrl + "UpdateUser", parameters: parameters).responseJSON{
                response in
            
                    print("output\(response.result.value)")
            
                if(response.result.isSuccess){
                
                    SVProgressHUD.dismiss()
                    let outJSON = JSON(response.result.value!)
                    print("outJSON:\(outJSON)")
                    if(outJSON["status"] != "1"){
                    
                    
                    let city_State = outJSON["response"]["city"].stringValue  + ", " + outJSON["response"]["state"].stringValue
                    
                    let zipcode = outJSON["response"]["zip"].stringValue
                    
                    //Store user info for profile page
                    let loginUserDetalis = [
                        "emailID":outJSON["response"]["email"].stringValue,
                        "city_State":city_State,
                        "fname":outJSON["response"]["first_name"].stringValue,
                        "lname":outJSON["response"]["last_name"].stringValue,
                        "about_me":outJSON["response"]["about_me"].stringValue,
                        "zipcode":zipcode,
                        "profile_type":outJSON["response"]["profile_type"].stringValue
                    ]
                    
                      //  self.delObj.userProfilePhoto = outJSON["response"]["photo"].stringValue
                      //  self.delObj.userCoverPhoto = outJSON["response"]["cover_photo"].stringValue
                        
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                   
                    self.defaults.setValue(loginUserDetalis, forKey: "loginUserDetalis")
                    
                  
                    }else{
                    
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                    }
                }else{
                    SVProgressHUD.dismiss()
                    self.delObj.displayMessage("examen", messageText: "Please check internet connection")
                
                }
            }
            
        }else{
            //Mandatory check fails
        }
        
    }
    
    
    func updateBusinessUserData(){
        
        if businessMandatoryCheck() {
            
            let parameters = ["userid":self.delObj.loginUserID,
                              "businessname":self.txtBusinessName.text!,
                              "url":self.txtWebsiteUrl.text!,
                              "email":self.txtEmailID.text!,
                              "zip":self.txtZipcode.text!,
                              "profile_type":"Public",
                              "introduction":self.txtIntroduction.text!,
                              "outline":self.txtOutlineofCause.text!
            ]
            
            SVProgressHUD.showWithStatus("Updating..")
            
            Alamofire.request(.POST, delObj.baseUrl + "UpdateBusiness", parameters: parameters).responseJSON{
                response in
                 print("parameters\(parameters)")
                print("output\(response.result.value)")
                
                if(response.result.isSuccess){
                    
                    SVProgressHUD.dismiss()
                    let outJSON = JSON(response.result.value!)
                    if(outJSON["status"] != "1"){
                        
                        
                        let city_State = outJSON["response"]["city"].stringValue  + ", " + outJSON["response"]["state"].stringValue
                        
                        let zipcode = outJSON["response"]["zip"].stringValue
                        
                        //Store user info for profile page
                        let loginUserDetalis = [
                            "emailID":outJSON["response"]["email"].stringValue,
                            "city_State":city_State,
                            "fname":outJSON["response"]["first_name"].stringValue,
                            "lname":outJSON["response"]["last_name"].stringValue,
                            "about_me":outJSON["response"]["about_me"].stringValue,
                            "zipcode":zipcode,
                            "profile_type":outJSON["response"]["profile_type"].stringValue
                        ]
                        
                        /**************** Business profile data */
                        
                       /* let tmpPro = outJSON["data"]["user_profile"].stringValue
                        if(tmpPro == "true"){
                            self.delObj.is_loginUserBusiness = true
                        }else{
                            self.delObj.is_loginUserBusiness = false
                        }
                        self.defaults.setBool(self.delObj.is_loginUserBusiness, forKey: "is_loginUserBusiness")*/
                        
                        let busienssProfileDetalis = [
                            "url":outJSON["response"]["url"].stringValue,
                            "intro":outJSON["response"]["intro"].stringValue,
                            "outline":outJSON["response"]["outline"].stringValue,
                        ]
                        self.defaults.setValue(busienssProfileDetalis, forKey: "busienssProfileDetalis")
                        
                        /**************** Business profile data */
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                        self.defaults.setValue(loginUserDetalis, forKey: "loginUserDetalis")
                        
                        
                    }else{
                        
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                    }
                }else{
                    SVProgressHUD.dismiss()
                    self.delObj.displayMessage("Examen", messageText: "Please check internet connection")
                    
                }
            }
            
        }else{
            //Mandatory check fails
        }
        
    }
    
    
    func updateMyPhoto(type:String,basearray:NSString){
        
        
            let parameters = ["userid":self.delObj.loginUserID,
                              "imagefor":type,
                              "photoarray":basearray
                              
            ]
            
            SVProgressHUD.showWithStatus("Updating..")
            
            Alamofire.request(.POST, delObj.baseUrl + "uploadphoto", parameters: parameters).responseJSON{
                response in
                print("parameters\(parameters)")
                print("output\(response.result.value)")
                
                if(response.result.isSuccess){
                    
                    SVProgressHUD.dismiss()
                    let outJSON = JSON(response.result.value!)
                    if(outJSON["status"] != "1"){
                       
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                        if(type.contains("profile")){
                            General.saveData(outJSON["photo"].stringValue, name: "userProfilePhoto")
                           
                        }else{
                             General.saveData(outJSON["photo"].stringValue, name: "userCoverPhoto")
                            
                        }
                        
                    }else{
                        
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                    }
                }else{
                    SVProgressHUD.dismiss()
                    self.delObj.displayMessage("Examen", messageText: "Please check internet connection")
                    
                }
            }
        
        
    }
    
    @IBAction func btnUpdateProfileClick(sender: AnyObject) {
       updatePersonalUserData()
    }
    
    @IBAction func btnUpdateBusinessClick(sender: AnyObject) {
        updateBusinessUserData()
    }
    
   
    
//TODO: - UIImagePickerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let pickedImage : UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
      
        if(self.is_profileImageSelected){
            self.imgProfile.image = cust.rotateCameraImageToProperOrientation(pickedImage, maxResolution: 360)// pickedImage
            
            
            //let imageData = UIImageJPEGRepresentation(pickedImage, 0.8)
            let imageData : NSData = UIImageJPEGRepresentation(self.imgProfile.image!,0.8)!
            base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            is_imageUpload = true
            self.updateMyPhoto("profile", basearray: base64String)
        }else{
            
            self.imgCover.image = cust.rotateCameraImageToProperOrientation(pickedImage, maxResolution: 500)// pickedImage
            
            
            //let imageData = UIImageJPEGRepresentation(pickedImage, 0.8)
            let imageData : NSData = UIImageJPEGRepresentation(self.imgCover.image!,0.8)!
            base64CoverString = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            is_coverUpload = true
           self.updateMyPhoto("cover", basearray: base64CoverString)
        }
      
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
         if(self.is_profileImageSelected){
                is_imageUpload = false
         }else{
                is_coverUpload = false
        }
    
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
//TODO: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == self.cust.placeholderTextColor{
            textView.text = nil
            textView.textColor = textColor
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
         if textView == txtAboutMe{
            
            if textView.text.isEmpty{
                txtAboutMe.text = "about me (optional)"
                txtAboutMe.textColor = self.cust.placeholderTextColor
            }
            
         }else if(textView == txtIntroduction){
            if textView.text.isEmpty{
                txtIntroduction.text = "introduction"
                txtIntroduction.textColor = self.cust.placeholderTextColor
            }
         }else if(textView == txtOutlineofCause){
            if textView.text.isEmpty{
                txtOutlineofCause.text = "outline of cause"
                txtOutlineofCause.textColor = self.cust.placeholderTextColor
            }
        }
        
    }

    
//TODO: - UIButton Action
    
    @IBAction func btnProfileTypeClick(sender: AnyObject) {
        let profileAlert = UIAlertController(title: "Please select Profile Type", message: "Let's choose profile type", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        profileAlert.addAction(UIAlertAction(title: "Public Profile", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("Public profile selected")
            self.btnProfileType.setTitle("Public", forState: UIControlState.Normal)
        }))
        
        
        profileAlert.addAction(UIAlertAction(title: "Private Profile", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("Private profile selected")
            self.btnProfileType.setTitle("Private", forState: UIControlState.Normal)
        }))
        profileAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(profileAlert, animated: true, completion: nil)
        

    }
    
    @IBAction func btnEditCoverPicClick(sender: AnyObject) {
        asktToChangeCoverImage()
    }
    
    @IBAction func btnEditPicClick(sender: AnyObject) {
        askToChangeProfileImage()
    }
    
    @IBAction func btnChangePasswordClick(sender: AnyObject) {
        let changePWDVC = self.storyboard?.instantiateViewControllerWithIdentifier("idChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(changePWDVC, animated: true)
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}
