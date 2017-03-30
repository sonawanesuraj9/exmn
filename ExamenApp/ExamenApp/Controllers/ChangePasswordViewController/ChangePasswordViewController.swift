//
//  ChangePasswordViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/5/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire



class ChangePasswordViewController: UIViewController {
    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    let myKeychainWrapper : KeychainWrapper = KeychainWrapper()
    
    
//TODO: - Controls
    
    @IBOutlet weak var btnChangePasswordOutlet: UIButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtOldPassword: UITextField!
//TODO: - Let's Play

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initialization()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
//TODO: - Function
    
    func initialization(){
        
        //Button
        self.btnChangePasswordOutlet.layer.cornerRadius = cust.RounderCornerRadious
        
        self.txtOldPassword.tintColor = cust.textTintColor
        self.txtNewPassword.tintColor = cust.textTintColor
        self.txtConfirmPassword.tintColor = cust.textTintColor
        
        
        
        //TextField
        self.txtOldPassword.attributedPlaceholder = NSAttributedString(string:"old password",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtNewPassword.attributedPlaceholder = NSAttributedString(string:"new password",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtConfirmPassword.attributedPlaceholder = NSAttributedString(string:"confirm password",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
    }
    
    
//TODO: - Web Service / API Implementation
    func updatePassword(){
        
        let param = ["userid":self.delObj.loginUserID,
                     "oldpass":self.txtOldPassword.text!,
                     "newpass":self.txtConfirmPassword.text!
                     ]
        
        SVProgressHUD.showWithStatus("Updating...")
        Alamofire.request(.POST, delObj.baseUrl + "ChangePass", parameters: param).responseJSON{
            response in
        
            print("output\(response.result.value)")
            
            print("param:\(param)")
            if(response.result.isSuccess){
                
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    SVProgressHUD.dismiss()
                    
                    if(self.defaults.valueForKey("is_Autologin") != nil){
                        
                        let checkLogin = self.defaults.valueForKey("is_Autologin") as! Bool
                        if(checkLogin){
                            
                            //update keychain password
                            self.myKeychainWrapper.mySetObject(self.txtConfirmPassword.text!, forKey: kSecValueData)
                            self.myKeychainWrapper.writeToKeychain()
                        }
                    }
                    let alertController = UIAlertController(title: "examen", message: outJSON["msg"].stringValue, preferredStyle: .Alert)
                    
                    let defaultAct = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (value:UIAlertAction) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    
                    alertController.addAction(defaultAct)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }else{
                    SVProgressHUD.dismiss()
                    self.delObj.displayMessage("examen", messageText: "Please check internet connection")
   
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "Please check internet connection")
            }
        }
    }
    
//TODO: - UIButton Action
    
    @IBAction func btnChangePasswordClick(sender: AnyObject) {
        
        if(self.txtOldPassword.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter old password")
        }else if(self.txtNewPassword.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter new password")
        }else if(self.txtConfirmPassword.text == ""){
              self.delObj.displayMessage("examen", messageText: "please enter confirm password")
        }else if(self.txtConfirmPassword.text != self.txtNewPassword.text){
              self.delObj.displayMessage("examen", messageText: "password does not match")
        }else{
            self.updatePassword()
        }
    }
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
