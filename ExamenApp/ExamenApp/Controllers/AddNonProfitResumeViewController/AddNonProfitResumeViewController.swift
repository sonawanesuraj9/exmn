//
//  AddNonProfitResumeViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/24/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire


class AddNonProfitResumeViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let textColor = UIColor(red: 0/255, green: 73/255, blue: 126/255, alpha: 1.0)
   
    
    let imgPicker : UIImagePickerController = UIImagePickerController()
    let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    //var is_imageUpload : Bool = Bool()
    //var base64String : NSString = NSString()
    
    
    //General Variables
    var is_endDateselected : Bool = Bool()
    
    var selectedIndex : Int = Int()
    
    var dateFormater : NSDateFormatter = NSDateFormatter()
    
    //Date comparision
    var isStartDateSelected : Bool = Bool()
    var isEndDateSelected : Bool = Bool()
    var startDate : NSDate = NSDate()
    var endDate : NSDate = NSDate()
    
//TODO: - Controls
    
    
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnCharityName: UIButton!
    @IBOutlet weak var presentSwitch: UISwitch!
    //@IBOutlet weak var txtEndDate: UITextField!
    //@IBOutlet weak var txtStartDate: UITextField!
   // @IBOutlet weak var txtCharityName: UITextField!
   // @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtTitle: UITextField!
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initialization()
    }
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       // roundedImageView()
       /* self.imgLogo.userInteractionEnabled = true
        tapGesture.addTarget(self, action: #selector(AddNonProfitResumeViewController.profileImageHasBeenTapped))
        self.imgLogo.addGestureRecognizer(tapGesture)*/
        is_endDateselected = false
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - Function
    func initialization(){
        
        self.txtTitle.tintColor = cust.textTintColor
        self.txtCompany.tintColor = cust.textTintColor
        self.txtWebsite.tintColor = cust.textTintColor
        
        //TextField
        self.txtTitle.attributedPlaceholder = NSAttributedString(string:"role",
                                                                     attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        self.txtCompany.attributedPlaceholder = NSAttributedString(string:"non-profit company",
                                                                 attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        self.txtWebsite.attributedPlaceholder = NSAttributedString(string:"website address",
                                                                   attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtTitle.autocapitalizationType = .Words
        self.txtCompany.autocapitalizationType = .Words
        
        
        self.txtWebsite.delegate = self
        self.txtTitle.resignFirstResponder()
        dateFormater.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormater.dateFormat = "MMM YYYY"
    }
    
    func profileImageHasBeenTapped(){
        print("image tapped")
       // self.askToChangeProfileImage()
    }

  /*  func roundedImageView(){
        self.imgLogo.layer.cornerRadius = self.imgLogo.frame.size.width/2
        self.imgLogo.clipsToBounds = true
    }*/
    
    
   /* func askToChangeProfileImage(){
        let alert = UIAlertController(title: "Let's get a picture", message: "choose a picture method", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        self.imgPicker.delegate = self
        
        if(is_imageUpload){
            let removeImageButton = UIAlertAction(title: "remove picture", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
                self.is_imageUpload = false
                self.imgLogo.image = self.delObj.userPlaceHolderImage
            }
            alert.addAction(removeImageButton)
        }else{
            print("No image is selected")
        }
        
        //Add AlertAction to select image from library
        let libButton = UIAlertAction(title: "select photo from library", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.imgPicker.delegate = self
            self.imgPicker.allowsEditing = true
            
            self.presentViewController(self.imgPicker, animated: true, completion: nil)
        }
        
        //Check if Camera is available, if YES then provide option to camera
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "take a picture", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
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
    }*/
    
//TODO: - UIImagePickerDelegate Methods
    /*func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let pickedImage : UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
            self.imgLogo.image = cust.rotateCameraImageToProperOrientation(pickedImage, maxResolution: 360)// pickedImage
        
            //let imageData = UIImageJPEGRepresentation(pickedImage, 0.8)
            let imageData : NSData = UIImageJPEGRepresentation(self.imgLogo.image!,0.8)!
            base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            is_imageUpload = true
          dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        is_imageUpload = false
         dismissViewControllerAnimated(true, completion: nil)
        
    }
    */
    func checkMandatory() -> Bool{
        var tmpFlg : Bool = Bool()
        
        if(self.txtTitle.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter role")
            tmpFlg  = false
        }else if(self.txtCompany.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter company")
            tmpFlg = false
        }else{
            tmpFlg = true
        }
        
        return tmpFlg
    }
    
//TODO: - Web service  / API implementation
    
    func clearNonProfitResumeArray(){
        self.delObj.selectedIsPresentArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedEndDateArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedStartDateArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedWebsiteArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedTitleArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedCompanyArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedIDArray_nonprofit.removeAll(keepCapacity: false)
       
       
    }
    
    
    func updateNonProfit(){
       
        if(isStartDateSelected && isEndDateSelected){
            
        
        let startDT = self.btnStartDate.titleLabel?.text!
        let endDT = self.btnEndDate.titleLabel?.text!
        var tmpPresentFlag : String = String()
        if(is_endDateselected){
            tmpPresentFlag = "Y"
        }else{
            tmpPresentFlag = "N"
        }

        
        let param : [String : AnyObject] = ["userid":self.delObj.loginUserID,
                     "vol_role":self.txtTitle.text!,
                     "vol_company":self.txtCompany.text!,
                     "vol_startdate":startDT!,
                     "vol_enddate":endDT!,
                     "vol_website":self.txtWebsite.text!,
                     "vol_ispresent":tmpPresentFlag]
        SVProgressHUD.showWithStatus("Updating...")
        
        print("param:\(param)")
        
        Alamofire.request(.POST, self.delObj.baseUrl + "updatevolun", parameters: param).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
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
                          
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                    
                    
                }else{
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }
                
            }else{
                //Responce failure
                SVProgressHUD.dismiss()
                print("Newtwork Error")
            }
        }
        }
        
    }

    
//TODO: - UIButton Action
    
    @IBAction func btnStartDateClick(sender: AnyObject) {
        DatePickerDialog().show("Start date", doneButtonTitle: "Done", cancelButtonTitle: "cancel", defaultDate: NSDate(), datePickerMode: UIDatePickerMode.Date) { (date) in
            self.isStartDateSelected = true
            
            //
            let dayTimePeriodFormatter = NSDateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM yyyy"
            
            let dateString = dayTimePeriodFormatter.stringFromDate(date)
            //
            
            self.startDate = date
             self.btnStartDate.setTitleColor(self.textColor, forState: UIControlState.Normal)
            self.btnStartDate.setTitle(dateString, forState: UIControlState.Normal)
        }
        
       
        
    }
    
    @IBAction func btnEndDateClick(sender: AnyObject) {
        
        DatePickerDialog().show("End date", doneButtonTitle: "Done", cancelButtonTitle: "cancel", defaultDate: NSDate(), datePickerMode: UIDatePickerMode.Date) { (date) in
           
            self.endDate = date
            
            //
            let dayTimePeriodFormatter = NSDateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM yyyy"
            
            let dateString = dayTimePeriodFormatter.stringFromDate(date)
            //
            
            
            if self.startDate.compare(self.endDate) == NSComparisonResult.OrderedDescending
            {
                NSLog("startDate after endDate");
                self.isEndDateSelected = false
                self.btnEndDate.setTitle("End date", forState: UIControlState.Normal)
                self.btnEndDate.enabled = true
                
                let confAlert = UIAlertController(title: "examen", message: "End Date must be greater than Start Date", preferredStyle: UIAlertControllerStyle.Alert)
                confAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                
                self.presentViewController(confAlert, animated: true, completion: nil)
                
            } else{
                self.isEndDateSelected = true
                self.btnEndDate.setTitleColor(self.textColor, forState: UIControlState.Normal)
                self.btnEndDate.setTitle(dateString, forState: UIControlState.Normal)
            }
            
            
            
        }
        
    }
    
    
    @IBAction func btnCloseClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnSaveClick(sender: AnyObject) {
        if(self.delObj.is_editResume){
            updateNonProfit()
        }else{
        
          //  self.delObj.selectedLogoArray_nonprofit.append(base64String)
           // self.delObj.selectedLogoImageTmp_nonprofit.append(self.imgLogo.image!)
            // self.delObj.selectedIDArray_nonprofit.append(self.supportedCharityID)
            self.delObj.selectedWebsiteArray_nonprofit.append(self.txtWebsite.text!)
            self.delObj.selectedTitleArray_nonprofit.append(self.txtTitle.text!)
            self.delObj.selectedCompanyArray_nonprofit.append(self.txtCompany.text!)
            self.delObj.selectedStartDateArray_nonprofit.append((self.btnStartDate.titleLabel?.text!)!)
            self.delObj.selectedEndDateArray_nonprofit.append((self.btnEndDate.titleLabel?.text!)!)
            var tmpPresentFlag : String = String()
            if(is_endDateselected){
                tmpPresentFlag = "Y"
            }else{
                tmpPresentFlag = "N"
            }
            self.delObj.selectedIsPresentArray_nonprofit.append(tmpPresentFlag)
        
            self.dismissViewControllerAnimated(true, completion: nil)
            print("selectedCompanyArray_nonprofit:\(self.delObj.selectedCompanyArray_nonprofit)")
        }
       
    }
    
    @IBAction func switchChanged(sender: AnyObject) {
        if(presentSwitch.on){
            
            //
            let dayTimePeriodFormatter = NSDateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM yyyy"
            
            let dateString = dayTimePeriodFormatter.stringFromDate(NSDate())
            //
            
            
            self.btnEndDate.setTitle(dateString, forState: UIControlState.Normal)
            self.btnEndDate.enabled = false
            is_endDateselected = true
            isEndDateSelected = true
            //self.btnEndDate.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
        }else{
            self.btnEndDate.setTitle("End date", forState: UIControlState.Normal)
              self.btnEndDate.enabled = true
            is_endDateselected = false
            isEndDateSelected = false
           // self.btnEndDate.setTitleColor(cust.placeholderTextColor, forState: UIControlState.Normal)
            
        }
    }
    
   

}
