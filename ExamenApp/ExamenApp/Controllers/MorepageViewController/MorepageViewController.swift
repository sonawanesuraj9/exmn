//
//  MorepageViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/2/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit

class MorepageViewController: UIViewController {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust: CustomClass_Dev = CustomClass_Dev()
    let defaults = NSUserDefaults.standardUserDefaults()
    let logVC : LoginViewController = LoginViewController()
//TODO: - Controls
    
    @IBOutlet weak var btnContactUsOutlet: UIButton!
    @IBOutlet weak var btnShareWithFriendsOutlet: UIButton!
    @IBOutlet weak var btnTermsofserviceOutlet: UIButton!
    @IBOutlet weak var btnPrivacyPolicyOutlet: UIButton!
    
    @IBOutlet weak var btnAboutUsOutlet: UIButton!
    @IBOutlet weak var btnLogoutOutlet: UIButton!
//TODO; - Let's Play
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("More Page")
        
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.delObj.isNewTimeUser = false
       // InitializationOfView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//TODOO: - Functions
    
    func InitializationOfView(){
        self.btnAboutUsOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnContactUsOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnPrivacyPolicyOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnShareWithFriendsOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnTermsofserviceOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnLogoutOutlet.layer.cornerRadius = cust.RounderCornerRadious
         self.btnAboutUsOutlet.center.x -= self.view.bounds.width
        self.btnLogoutOutlet.center.x -= self.view.bounds.width
         self.btnTermsofserviceOutlet.center.x -= self.view.bounds.width
        self.btnContactUsOutlet.center.x -= self.view.bounds.width
        self.btnPrivacyPolicyOutlet.center.x -= self.view.bounds.width
        self.btnShareWithFriendsOutlet.center.x -= self.view.bounds.width
        
        buttonAnimation()

    }
    
    func buttonAnimation(){
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
           
            }) { (value:Bool) -> Void in
              
                UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.TransitionCurlDown,animations: { () -> Void in
                    //FIrst Button
                    self.btnTermsofserviceOutlet.center.x = self.view.center.x
                    
                    }) { (value:Bool) -> Void in
                        
                        UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.TransitionCurlDown, animations: { () -> Void in
                            //Second Button
                            self.btnPrivacyPolicyOutlet.center.x = self.view.center.x
                            
                            }) { (value:Bool) -> Void in
                                UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.TransitionCurlDown, animations: { () -> Void in
                                    //Third Button
                                    self.btnShareWithFriendsOutlet.center.x = self.view.center.x
                                    
                                    }) { (value:Bool) -> Void in
                                        UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.TransitionCurlDown, animations: { () -> Void in
                                            //fourth button
                                            self.btnAboutUsOutlet.center.x = self.view.center.x
                                            
                                            }) { (value:Bool) -> Void in
                                                
                                                UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.TransitionCurlDown, animations: { 
                                                    self.btnContactUsOutlet.center.x = self.view.center.x
                                                    
                                                    }, completion: { (Value:Bool) in
                                                        //button Fifth
                                                        UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.TransitionCurlDown, animations: {
                                                            self.btnLogoutOutlet.center.x = self.view.center.x
                                                            
                                                            }, completion: { (Value:Bool) in
                                                                //Code next
                                                                
                                                        })
                                                })
                                                // self.SecondView.center.x = self.view.center.x
                                        }
                                }
                        }
                }
                
                
        }
    }
    
//TODO: - UIButton Action
    
    @IBAction func btnAddNewPostClick(sender: AnyObject) {
        let postVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAddPostViewController") as! AddPostViewController
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
    @IBAction func btnContactUsClick(sender: AnyObject) {
        let contVC = self.storyboard?.instantiateViewControllerWithIdentifier("idContactUsViewController") as! ContactUsViewController
        
        self.navigationController?.pushViewController(contVC, animated: true)
        
    }
    @IBAction func btnShareWithFriendClick(sender: AnyObject) {
        let shareVC = self.storyboard?.instantiateViewControllerWithIdentifier("idInviteFriendsViewController") as! InviteFriendsViewController
        
        self.navigationController?.pushViewController(shareVC, animated: true)
    }
    @IBAction func btnPrivacyClick(sender: AnyObject) {
        let privacyVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPrivacyPolicyViewController") as! PrivacyPolicyViewController
        
        self.navigationController?.pushViewController(privacyVC, animated: true)

    }
    @IBAction func btnLogoutClick(sender: AnyObject) {
        
        
        let logoutAlert = UIAlertController(title: "", message: "are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        logoutAlert.addAction(UIAlertAction(title: "logout", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("log out selected")
           //Remove all suggestions
            let tmpArray : [String] = []
            self.defaults.setValue(tmpArray, forKey: "suggestionArray")
            
            
            //Remove all Cached Images
            self.delObj.imageCache.removeAllObjects()
            
            self.defaults.setBool(false, forKey: "is_Autologin")
            self.defaults.setBool(false, forKey: "is_FBlogin")
            
            self.defaults.synchronize()
            
            //self.logVC.myKeychainWrapper.resetKeychainItem()
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }))
       
        logoutAlert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(logoutAlert, animated: true, completion: nil)
        

        
    }
    @IBAction func btnTermsClick(sender: AnyObject) {
        let termsVC = self.storyboard?.instantiateViewControllerWithIdentifier("idTermsOfServiceViewController") as! TermsOfServiceViewController
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @IBAction func btnAboutUsClick(sender: AnyObject) {
        let aboutVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAboutUsViewController") as! AboutUsViewController
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    
}
