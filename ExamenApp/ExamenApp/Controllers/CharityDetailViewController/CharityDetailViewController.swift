//
//  CharityDetailViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 6/13/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices


class CharityDetailViewController: UIViewController,SFSafariViewControllerDelegate {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var charityID : String  = String()
    var charityLogo : String = String()
    var charityCover : String = String()
    var charityWebsite : String = String()
    
    let followersTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    
//TODO: - Controls
    
    @IBOutlet weak var lblAboutCharityTitle: UILabel!
    @IBOutlet weak var lblFollowersTitle: UILabel!
    @IBOutlet weak var btnFollowersCount: UIButton!
    @IBOutlet weak var txtCharityInfo: UITextView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var btnCharityWebsiteOutlet: UIButton!
    //@IBOutlet weak var lblAboutCharity: UILabel!
    @IBOutlet weak var imgCharityCover: UIImageView!
    @IBOutlet weak var lblCharityLocation: UILabel!
    @IBOutlet weak var lblCharityName: UILabel!
    @IBOutlet weak var imgCharityLogo: UIImageView!
    
//TODO: - Let's Play
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgCharityLogo.layer.cornerRadius = self.imgCharityLogo.frame.size.height / 2
        self.imgCharityLogo.clipsToBounds = true
       
        self.btnFollowersCount.setTitle("-", forState: UIControlState.Normal)
        
       
        
        // Do any additional setup after loading the view.
        fetchCharityDetails()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //1
        self.lblFollowersTitle.userInteractionEnabled = true
        followersTapGesture.addTarget(self, action: #selector(CharityDetailViewController.FollowerClick))
        self.lblFollowersTitle.addGestureRecognizer(followersTapGesture)
        self.lblAboutCharityTitle.layer.cornerRadius = 5
        self.lblAboutCharityTitle.clipsToBounds = true
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func FollowerClick(){
        let followersVC = self.storyboard?.instantiateViewControllerWithIdentifier("idFollowersViewController") as! FollowersViewController
        followersVC.selectedType = "charity"
        followersVC.viewID = charityID
        self.navigationController?.pushViewController(followersVC, animated: true)
    }
    
//TODO: - Web service / API implementation
    
    func fetchCharityDetails(){
        
        SVProgressHUD.showWithStatus("Loading...")
       
        Alamofire.request(.POST, delObj.baseUrl + "charityprofile", parameters: ["id":self.charityID]).responseJSON{
            response in
            print("charityID:\(self.charityID)")
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    
                    self.lblCharityName.text = outJSON["data"]["charity_name"].stringValue
                    self.lblCharityLocation.text =  outJSON["data"]["city"].stringValue +   ", " +  outJSON["data"]["state"].stringValue
                   // self.charityCover = outJSON["data"]["cover_photo"].stringValue
                    self.charityLogo =  outJSON["data"]["charity_logo"].stringValue
                    self.lblCharityName.text = outJSON["data"]["charity_name"].stringValue
                    let aboutChartiy = outJSON["data"]["about_charity"].stringValue
                    
                    
                    let attrStr = try! NSAttributedString(
                        data: aboutChartiy.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                        options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                        documentAttributes: nil)
                    self.txtCharityInfo.attributedText = attrStr
                    
                    self.btnFollowersCount.setTitle( outJSON["data"]["followers"].stringValue, forState: UIControlState.Normal)
                    
                    
                   self.charityWebsite =  outJSON["data"]["website"].stringValue
                    if(self.charityWebsite != ""){
                        self.btnCharityWebsiteOutlet.setTitle(self.charityWebsite, forState: UIControlState.Normal)
                    }else{
                        self.btnCharityWebsiteOutlet.setTitle("-", forState: UIControlState.Normal)
                    }
                    
                    
                    
                    self.loadAllImages()
                    
                }else{
                    
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
                
            }
        }
        
    }
    
    
//TODO: - SFSafariViewController Delegate Method
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
//TODO: - Function
    
    func loadAllImages(){
        
        if(charityLogo != ""){
            let charityLogoURL = NSURL(string: charityLogo)!
            
            self.imgCharityLogo.sd_setImageWithURL(charityLogoURL, placeholderImage: self.delObj.userPlaceHolderImage, options: SDWebImageOptions.RefreshCached)
            
        }else{
            
            //display charity placeholder
            self.imgCharityLogo.image = self.delObj.userPlaceHolderImage
            
        }
        
        if(charityCover != ""){
              self.imgCharityCover.hidden = false
            
            SDImageCache.sharedImageCache().queryDiskCacheForKey(charityCover) { ( img:UIImage!, cacheType:SDImageCacheType) -> Void in
                if(img != nil){
                    
                    //  self.imgProfilePic.image = self.rotateImageToActual(img)
                    self.imgCharityCover.image = img
                }else{
                    //self.cust.showLoadingCircle()
                    Alamofire.request(.GET, self.charityCover)
                        .response { request, response, data, error in
                            print(request)
                            print(response)
                            // print(data)
                            // print(error)
                            
                            if(data != nil){
                                let image = UIImage(data: data! )
                                SDImageCache.sharedImageCache().storeImage(image, forKey: self.charityCover)
                                self.imgCharityCover.image = image
                                //  self.imgProfilePic.image = self.rotateImageToActual(image!)
                                
                            }else{
                                // self.imgCoverPic.hidden = true
                                //Display placeholder
                                self.imgCharityCover.image = self.delObj.coverPlaceholder
                            }
                    }

                }
            }
        }else{
            self.imgCharityCover.hidden = true
            self.imgCharityCover.image = self.delObj.userPlaceHolderImage
        }
        
        
    }
    
//TODO: - UIButton Action
    
    @IBAction func btnCharityWebsiteClick(sender: AnyObject) {
      
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: self.charityWebsite)!){
            let safariVC = SFSafariViewController(URL: NSURL(string: self.charityWebsite)!)
             safariVC.delegate = self
            self.presentViewController(safariVC, animated: true, completion: nil)

        }else{
            self.delObj.displayMessage("examen", messageText: "unable to opne website")
        }
        
        
    }
    
    @IBAction func btnFollowersCountClick(sender: AnyObject) {
        FollowerClick()
    }
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
