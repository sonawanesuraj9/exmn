//
//  UpdateCharityViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 6/3/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
    }
}

class UpdateCharityViewController: UIViewController {
    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    var is_suggestVisible : Bool = Bool()
    
    //Charity Array 
    var charityIDArray : [String] = []
    var charityNameArray : [String] = []
    var charityLogoArray : [String] = []
    var charityWebsiteArray : [String] = []
    
    //var charityselected 
    var selectedCharityID : String = String()
    var selectedCharityName : String = String()
    var selectedCharityLogo : String = String()
    var selectedCharityWeb : String = String()
    
//TODO: - Controls
    
    @IBOutlet weak var lblLastCharity: UILabel!
    
    @IBOutlet weak var suggestCharityView: UIView!
    
    @IBOutlet weak var btnSuggestCharity: UIButton!
    @IBOutlet weak var txtNewCharityEmail: UITextField!
    @IBOutlet weak var txtNewCharityName: UITextField!
    
    
    ////
    @IBOutlet weak var btnUpdateCharityOutlet: UIButton!
    @IBOutlet weak var txtCharityInput: UITextField!
    @IBOutlet weak var btnSearchOutlet: UIButton!
    
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var btnCharityWebsite: UIButton!
    @IBOutlet weak var imgCharityLogo: UIImageView!
    @IBOutlet weak var lblCharityName: UILabel!
    
//TODO: - Let' play

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchCharityListing()
        
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.suggestCharityView.hidden = true
        is_suggestVisible = false
        
        viewResult.hidden = true
        self.btnSearchOutlet.layer.cornerRadius = self.cust.RounderCornerRadious
        self.btnUpdateCharityOutlet.layer.cornerRadius = self.cust.RounderCornerRadious
        self.btnSuggestCharity.layer.cornerRadius = self.cust.RounderCornerRadious
        
        self.txtNewCharityEmail.attributedPlaceholder = NSAttributedString(string:"charity web address",
                                                                   attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        //Keyboard
        self.txtNewCharityEmail.autocorrectionType = UITextAutocorrectionType.No
        
        self.txtNewCharityName.attributedPlaceholder = NSAttributedString(string:"charity name",
                                                                   attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        self.txtNewCharityName.autocapitalizationType = .Words
        self.txtCharityInput.autocapitalizationType = .Words
        //Keyboard
        self.txtNewCharityName.autocorrectionType = UITextAutocorrectionType.No
        
        self.txtNewCharityName.tintColor = cust.textTintColor
        self.txtNewCharityEmail.tintColor = cust.textTintColor
        
        //MARK:- Display last selected charity if available
        if(self.delObj.is_updateCharity){
            if defaults.valueForKey("loginUsercharityDetails") != nil{
                let charityDictonary = defaults.valueForKey("loginUsercharityDetails") as! NSDictionary
                let name : String = charityDictonary["charity_name"] as! String
                self.lblLastCharity.text = "current charity: \(name)"
               
            }
            
            
            
            self.btnUpdateCharityOutlet.setTitle("update charity", forState: UIControlState.Normal)
        }else{
            self.btnUpdateCharityOutlet.setTitle("set charity", forState: UIControlState.Normal)
        }
    }
    
    
//TODO: - API / Web service call
    
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
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    }
                    
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                print("Newtwork Error")
                
            }
        }
    }
    
    func updateCharity(userID:String,SelectedID:String){
        
        let param = ["userid":userID,"charityid":SelectedID]
        SVProgressHUD.showWithStatus("Updating...")
        
        Alamofire.request(.POST, self.delObj.baseUrl + "updatecharity", parameters: param).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                  
                    let charityDetails = [
                        "charity_logo":outJSON["data"]["charity_supported"]["charity_logo"].stringValue,
                        "charity_name":outJSON["data"]["charity_supported"]["charity_name"].stringValue,
                        "charityID":outJSON["data"]["charity_supported"]["id"].stringValue,
                        "charity_website":outJSON["data"]["charity_supported"]["website"].stringValue
                    ]
                    
                     self.defaults.setValue(charityDetails, forKey: "loginUsercharityDetails")
                    
                   
                    let alertController = UIAlertController(title: "examen", message: outJSON["msg"].stringValue, preferredStyle: .Alert)
                    
                    let defaultAct = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (value:UIAlertAction) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    
                    alertController.addAction(defaultAct)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
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

    func selectCharity(char:String){
        
        let charityAlert = UIAlertController(title: "please select supporting charity", message: "let's choose charity name", preferredStyle: UIAlertControllerStyle.Alert)
        
        charityAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        if(charityIDArray.count>1){
            
            for i in 0...charityIDArray.count-1{
                print("self.charityNameArray[i]:\(self.charityNameArray[i])")
                if(self.charityNameArray[i].contains(char)){
                  //display only those charity
               
                charityAlert.addAction(UIAlertAction(title: charityNameArray[i], style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
                    print("\(self.charityNameArray[i]) selected")
                    self.selectedCharityName = self.charityNameArray[i]
                    self.selectedCharityID = self.charityIDArray[i]
                    self.delObj.normal_supportedCharityID = self.charityIDArray[i]
                    self.delObj.normal_charityName = self.charityNameArray[i]
                    self.selectedCharityWeb = self.charityWebsiteArray[i]
                    self.selectedCharityLogo = self.charityLogoArray[i]
                    //Display output on hidder view
                    self.displayOutput()
                }))
               }//end of if loop
            }
        }
        charityAlert.addAction(UIAlertAction(title: "don't have charity, please let us know", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
          //  print("Private profile selected click")
            self.suggestCharityView.hidden = false
            
        }))
        
        self.presentViewController(charityAlert, animated: true, completion: nil)
        
    }
    
    func displayOutput(){
        viewResult.hidden = false
        self.lblCharityName.text = self.selectedCharityName
        self.btnCharityWebsite.setTitle(self.selectedCharityWeb, forState: UIControlState.Normal)
        let charityURL = NSURL(string: self.selectedCharityLogo)
        self.imgCharityLogo.layer.cornerRadius = self.imgCharityLogo.frame.size.height/2
        self.imgCharityLogo.clipsToBounds = true
        self.imgCharityLogo.sd_setImageWithURL(charityURL, placeholderImage: self.delObj.userPlaceHolderImage, options: SDWebImageOptions.RefreshCached)
        
    }
    
    func checkNewCharityMandatory() -> Bool{
        var tmpFlag : Bool = Bool()
        if(self.txtNewCharityName.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter charity name")
            tmpFlag = false
        }else if(self.txtNewCharityEmail.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter charity web address")
            tmpFlag = false
        }else if(!(self.cust.verifyUrl(self.txtNewCharityEmail.text!))){
            self.delObj.displayMessage("examen", messageText: "please enter valid web address")
            tmpFlag = false
        }else{
            tmpFlag = true
        }
        return tmpFlag
        
    }
    
    func addCharity(){
        if(checkNewCharityMandatory()){
           
        let param = ["charityname":self.txtNewCharityName.text!,
                     "charityemail":self.txtNewCharityEmail.text!,
                     "user_email":self.delObj.loginUserEmail
                     ]
        SVProgressHUD.showWithStatus("Loading...")
        
        Alamofire.request(.POST, self.delObj.baseUrl + "addNewCharity", parameters: param).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    //self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                     self.updateCharity(self.delObj.loginUserID,SelectedID: outJSON["data"]["charityid"].stringValue)
                    
                    /********** Update charity for signup page *******/
                    self.selectedCharityName = outJSON["data"]["charityName"].stringValue
                    self.selectedCharityID = outJSON["data"]["id"].stringValue
                    self.delObj.normal_supportedCharityID = outJSON["data"]["charityid"].stringValue
                    self.delObj.normal_charityName = outJSON["data"]["charityName"].stringValue
                    self.selectedCharityWeb = ""
                    self.selectedCharityLogo = ""
                    self.delObj.is_normal_CharitySelected = true
                    
                    /********** Update charity for signup page *******/
                    
                    
                    /*let charityDetails = [
                        "charity_logo":"",
                        "charity_name":outJSON["data"]["charityName"].stringValue,
                        "charityID":outJSON["data"]["charityid"].stringValue,
                        "charity_website":""
                    ]
                    
                    self.defaults.setValue(charityDetails, forKey: "loginUsercharityDetails")
                    
                    let alertController = UIAlertController(title: "examen", message: outJSON["msg"].stringValue, preferredStyle: .Alert)
                    
                    let defaultAct = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (value:UIAlertAction) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    
                    alertController.addAction(defaultAct)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)*/
                    
                }else{
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }
                
            }else{
                //Responce failure
                SVProgressHUD.dismiss()
                print("Newtwork Error")
            }
        }
        }else{
            print("invalid charity detail")
        }
    }
    
//TODO: - UIButton Action
    
    @IBAction func btnUpdateCharityClick(sender: AnyObject) {
        if(self.delObj.is_updateCharity){
            if(selectedCharityID != ""){
                updateCharity(self.delObj.loginUserID,SelectedID: self.selectedCharityID)
            }
           
        }else{
            if(self.delObj.normal_supportedCharityID != ""){
                self.delObj.is_normal_CharitySelected = true
            
                let alert = UIAlertController(title: "examen", message: "charity selected", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (value:UIAlertAction) in
                self.navigationController?.popViewControllerAnimated(true)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                self.delObj.displayMessage("examen", messageText: "please select charity")
            }
        }
    }
    
    @IBAction func btnSuggestCharityClick(sender: AnyObject) {
        //add web service for charity
        self.addCharity()
        
    }
    @IBAction func btnSearchClick(sender: AnyObject) {
        let trimmedString = self.txtCharityInput.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        if(trimmedString != ""){
            selectCharity(trimmedString)
        }else{
            self.delObj.displayMessage("examen", messageText: "please enter text")
        }
    }
   
    @IBAction func btnBackClick(sender: AnyObject) {
        if(is_suggestVisible){
            self.suggestCharityView.hidden = true
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
