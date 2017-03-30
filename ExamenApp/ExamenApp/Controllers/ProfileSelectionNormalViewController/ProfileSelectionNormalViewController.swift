//
//  ProfileSelectionNormalViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 6/27/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit

class ProfileSelectionNormalViewController: UIViewController {

//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    var is_normal : Bool = Bool()
    
    var userPersonal = [String: String]()
    
    
//TODO: - Controls
    
    @IBOutlet weak var btnBusinessProfileOutlet: UIButton!
    @IBOutlet weak var btnProfileOutlet: UIButton!
//TODO: - Let's Play
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.btnBusinessProfileOutlet.layer.cornerRadius = self.cust.RounderCornerRadious
        self.btnProfileOutlet.layer.cornerRadius = self.cust.RounderCornerRadious
        
        self.delObj.tmp_next = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.delObj.normal_supportedCharityID = ""
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnPublicProfileClick(sender: AnyObject) {
        if(is_normal){
            let normalVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupNormalViewController") as! SignupNormalViewController
            self.navigationController?.pushViewController(normalVC, animated: true)
            
        }else{
            let fSignupVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupFacebookViewController") as! SignupFacebookViewController
            fSignupVC.userPersonal = userPersonal 
            self.navigationController?.pushViewController(fSignupVC, animated: true)
        }
    }
    
    
    @IBAction func btnBusinessProfileClick(sender: AnyObject) {
        if(is_normal){
            let businessVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupNormalBusinessViewController") as! SignupNormalBusinessViewController
            self.navigationController?.pushViewController(businessVC, animated: true)
        }else{
            let fSignupVC = self.storyboard?.instantiateViewControllerWithIdentifier("idSignupFacebookBusinessViewController") as! SignupFacebookBusinessViewController
            fSignupVC.userPersonal = userPersonal 
            self.navigationController?.pushViewController(fSignupVC, animated: true)
        }
        
    }
    
}
