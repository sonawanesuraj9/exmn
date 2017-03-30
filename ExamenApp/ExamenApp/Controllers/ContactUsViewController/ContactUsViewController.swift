//
//  ContactUsViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/7/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire

class ContactUsViewController: UIViewController, UITextViewDelegate {

    
    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var is_message_enter : Bool = Bool()
//TODO: - Controls
    
    @IBOutlet weak var btnSubmitOutlet: UIButton!
    @IBOutlet weak var txtMessage: UITextView!
   
    
//TODO: - Let's Play
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initialiazation()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODO: - Function
    func initialiazation(){
        //TextField
       
        self.btnSubmitOutlet.layer.cornerRadius = cust.RounderCornerRadious
        
        self.txtMessage.text = "message"
        self.txtMessage.textColor = self.cust.placeholderTextColor
        
       self.txtMessage.tintColor = cust.textTintColor
        self.txtMessage.layer.borderWidth = 1.0
        self.txtMessage.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).CGColor
         self.txtMessage.layer.cornerRadius = cust.RounderCornerRadious
        is_message_enter = false
    }
    
    
//TODO: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == self.cust.placeholderTextColor{
            textView.text = nil
            is_message_enter = true
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == txtMessage{
            
            if textView.text.isEmpty{
                is_message_enter = false
                txtMessage.text = "message"
                txtMessage.textColor = self.cust.placeholderTextColor
            }
            
        }
        
    }
    
//TODO: - Web service / API implementation
    
    func sendQueryToAppAdmin(){
        SVProgressHUD.showWithStatus("Loading...")
       
        let params = ["userid":self.delObj.loginUserID,"message":self.txtMessage.text!]
        Alamofire.request(.POST, delObj.baseUrl + "contactus", parameters: params).responseJSON{
            response in
            print("params:\(params)")
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let charityAlert = UIAlertController(title: "examen", message: "we will surely get back to you soon..!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    charityAlert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                        //Navigate to update chariy screen
                       self.navigationController?.popViewControllerAnimated(true)
                    }))                    
                    
                    self.presentViewController(charityAlert, animated: true, completion: nil)
                    
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "Please check internet connection")
                
            }
     
    }
    }
    
//TODO: - Button Action

    @IBAction func btnSubmitClick(sender: AnyObject) {
        if(is_message_enter){
            //Call to web service / API
            sendQueryToAppAdmin()
        }else{
            self.delObj.displayMessage("examen", messageText: "please enter message")
        }
    }
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
