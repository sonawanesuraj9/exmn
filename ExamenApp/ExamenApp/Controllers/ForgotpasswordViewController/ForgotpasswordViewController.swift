//
//  ForgotpasswordViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 6/20/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire




class ForgotpasswordViewController: UIViewController, UITextFieldDelegate {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var returnKeyHandler : IQKeyboardReturnKeyHandler = IQKeyboardReturnKeyHandler()
    
//TODO: - Controls
    
    @IBOutlet weak var btnSubmitOutlet: UIButton!
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //IQKeyboardReturnKeyHandler Method
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        initialization()
    }
    
//TODO: - Function
    
    func checkMandatory() -> Bool{
        var tempFlag : Bool = Bool()
        
        if(self.txtUsername.text == ""){
             tempFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter username")
            
        }
        else if(self.txtEmailID.text == ""){
             tempFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter email address")
            
        }else if(!(self.cust.isValidEmail(self.txtEmailID.text!))){
             tempFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter valid email address")
        }else{
             tempFlag = true
        }
        
        return tempFlag
    }
    
    func initialization(){
        
        //TextView
        
        self.btnSubmitOutlet.layer.cornerRadius = self.cust.RounderCornerRadious
        
        
        
        
        self.txtEmailID.attributedPlaceholder = NSAttributedString(string:"email address",
                                                                   attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtUsername.attributedPlaceholder = NSAttributedString(string:"username",
                                                                   attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.txtUsername.delegate = self
        self.txtEmailID.delegate = self
        
    }
    
//TODO: - Web Service / API Implementation
    
    func sendPassword(){
        
        if(self.checkMandatory()){
            let param = ["username":self.txtUsername.text!,
                     "email":self.txtEmailID.text!
            ]
        
            SVProgressHUD.showWithStatus("Loading...")
            Alamofire.request(.POST, delObj.baseUrl + "forgotpass", parameters: param).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            print("param:\(param)")
            if(response.result.isSuccess){
                
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    SVProgressHUD.dismiss()
                  
                    let alertController = UIAlertController(title: "examen", message: outJSON["msg"].stringValue, preferredStyle: .Alert)
                    
                    let defaultAct = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (value:UIAlertAction) in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    
                    alertController.addAction(defaultAct)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }else{
                    SVProgressHUD.dismiss()
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "Please check internet connection")
            }
        }
        }

    }
    
//TODO: - UIButton Action
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

  
    
    @IBAction func btnSubmitClick(sender: AnyObject) {
        sendPassword()
    }
}
