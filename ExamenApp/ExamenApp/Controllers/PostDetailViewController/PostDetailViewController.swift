//
//  PostDetailViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/27/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    
    
    //Information from previous screen
    var username : String = String()
    var userlogoUrl : String = String()
    var userpostDesc : String = String()
    var userpostImage : String = String()
    var userpostdate : String = String()
    var is_imageAvailable : Bool = Bool()
    var postByArray : String = String()
    var postbyidArray : String = String()
    var postbyProfile_type : String = String()
    //let userID : String = String()
    
    
//TODO: - Controls
    
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    //@IBOutlet weak var txtPostText: UITextView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnUserName: UIButton!
    
    @IBOutlet weak var mainScroll: UIScrollView!
    
    
//TODO: - Let's Play
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDate.text = userpostdate
        
            self.lblPost.text = userpostDesc
            //self.lblPost.scrollEnabled = false
            let fixedWidth = lblPost.frame.size.width
            print("fixedWidth\(fixedWidth)")
            lblPost.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            let newSize = lblPost.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            print("newSize\(newSize)")
            var newFrame = lblPost.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            lblPost.frame = newFrame;
            print(lblPost.frame)
            self.lblPost.font = UIFont(name: cust.FontName, size: cust.FontSizeText)
            lblPost.textAlignment = NSTextAlignment.Left
            //lblPost.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0)
        
            lblPost.layoutIfNeeded()
            print(lblPost.frame)
       
        
        self.btnUserName.setTitle(username, forState: UIControlState.Normal)
        
        if(userpostImage != ""){
            let postURL = NSURL(string: userpostImage)
            self.imgPost.hidden = false
            print(self.imgPost.frame)
            // view.setNeedsLayout()
            self.imgPost.layoutIfNeeded()
            print(self.imgPost.frame)
            self.imgPost.sd_setImageWithURL(postURL, placeholderImage: self.delObj.userPlaceHolderImage, options: SDWebImageOptions.RefreshCached)
        }else{
            self.imgPost.hidden = true
        }
        
        let profURL = NSURL(string: userlogoUrl)
        self.imgUserProfile.sd_setImageWithURL(profURL, placeholderImage: self.delObj.profilePlaceholder, options: SDWebImageOptions.RefreshCached)
        
        self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.height / 2
        self.imgUserProfile.clipsToBounds = true
        
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
       
        self.imgHeightConstraint.constant = UIScreen.mainScreen().bounds.width * 0.9
        self.view.needsUpdateConstraints()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        self.mainScroll.contentSize = CGSize(width: self.mainScroll.frame.width, height: self.imgPost.frame.origin.y + self.imgPost.frame.size.height + 20)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//TODO: - Function
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func btnOtheruserClick(sender: AnyObject) {
        
        if postByArray  == "charity"{
            let charityDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idCharityDetailViewController") as! CharityDetailViewController
            charityDTVC.charityID = self.postbyidArray
            self.navigationController?.pushViewController(charityDTVC, animated: true)
        }else if postByArray  == "business"{
            let businessDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherBusinessProfileViewController") as! OtherBusinessProfileViewController
            businessDTVC.reqUserID = self.postbyidArray
            self.navigationController?.pushViewController(businessDTVC, animated: true)
        }else if postByArray  == "user"{
            
            print("self.appUserID\(self.delObj.loginUserID)")
            print("self.postbyidArray[index]\(self.postbyidArray)")
            if self.postbyidArray != self.delObj.loginUserID{
                //Check if user is same as app user
                let otherUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
                
                otherUserVC.reqUserID = postbyidArray
                otherUserVC.reqProfileType = self.postbyProfile_type
                
                self.navigationController?.pushViewController(otherUserVC, animated: true)
            }
        }
        
        
        
    }

}
