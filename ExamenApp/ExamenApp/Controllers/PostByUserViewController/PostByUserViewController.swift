//
//  PostByUserViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/4/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire


class PostByUserTableViewCell : UITableViewCell{
    
    
//TODO: - Controls
    
    @IBOutlet var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDate: UILabel!
       
    @IBOutlet weak var txtPost: UITextView!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lblPost: UILabel!
}


// ==================================================================================

// ==================================================================================


class PostByUserViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    
    //Response array
    var postTypeArray : [String] = []
    var postIDArray : [String] = []
    var postByNameArray : [String] = []
    var postByImageArray : [String] = []
    var postDescArray : [String] = []
    var postImageArray : [String] = []
    var postDateArray : [String] = []
    var imageAvailableArray : [String] = []
    
//TODO: - Controls
    
    @IBOutlet weak var mainTableView: UITableView!
    
//TODO: - Let's Play
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        mainTableView.rowHeight = UITableViewAutomaticDimension
        mainTableView.estimatedRowHeight = 140
        
        
        
        mainTableView.tableFooterView = UIView()
        fetchUserPost()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
//TODO: - Web service / API method
    
    func clearPreviousData(){
        
        self.postDateArray.removeAll(keepCapacity: false)
        self.postDescArray.removeAll(keepCapacity: false)
        self.postImageArray.removeAll(keepCapacity:false)
        self.postIDArray.removeAll(keepCapacity:false)
        self.postByImageArray.removeAll(keepCapacity:false)
        self.postByNameArray.removeAll(keepCapacity: false)
        self.postTypeArray.removeAll(keepCapacity: false)
        self.imageAvailableArray.removeAll(keepCapacity: false)
    }
    
    func fetchUserPost(){
        
        SVProgressHUD.showWithStatus("Loading..")
        
        Alamofire.request(.POST, delObj.baseUrl + "getuserpost", parameters: ["user_id":self.delObj.loginUserID]).responseJSON{
            response in
            
            print("self.delObj.loginUserID::\(self.delObj.loginUserID)")
            print("output\(response.result.value)")
            print(response.request)
            print(response.response)
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    
                    let count = outJSON["data"].array?.count
                    if(count != 0){
                        
                        //clear all data before loading new one
                        self.clearPreviousData()
                        
                        
                        if let ct = count{
                            for index in 0...ct-1{
                                
                                self.postTypeArray.append(outJSON["data"][index]["post_type"].stringValue)
                                self.postByNameArray.append(outJSON["data"][index]["postbyname"].stringValue)
                                self.postByImageArray.append(outJSON["data"][index]["user_photo"].stringValue)
                                
                                self.postIDArray.append(outJSON["data"][index]["post_id"].stringValue)
                                if(outJSON["data"][index]["image"].stringValue == ""){
                                    self.imageAvailableArray.append("0")
                                }else{
                                      self.imageAvailableArray.append("1")
                                }
                                self.postImageArray.append(outJSON["data"][index]["image"].stringValue)
                                self.postDescArray.append(outJSON["data"][index]["post"].stringValue)
                                self.postDateArray.append(outJSON["data"][index]["date"].stringValue)
                                
                            }//end for loop
                            
                            print("imageAvailableArray: \(self.imageAvailableArray)")
                        }//end ct loop
                        self.mainTableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                    
                }else{
                    
                    self.delObj.displayMessage("Examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("Examen", messageText: "Please check internet connection")
                
            }
        }
    }    
    
    func getLabelHeight(label: UILabel) -> CGFloat {
        let constraint: CGSize = CGSizeMake(label.frame.size.width, 20000.0)
        var size: CGSize
        let context: NSStringDrawingContext = NSStringDrawingContext()
        let boundingBox: CGSize = label.text!.boundingRectWithSize(constraint, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: context).size
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height))
        print("Height:\(label) : \(size.height)")
        return size.height
    }
    
    
//TODO: - UITableViewDatasource Method implementation
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postIDArray.count
    }
    
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! PostByUserTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.lblDate.text = self.postDateArray[indexPath.row]
        cell.lblPost.text = self.postDescArray[indexPath.row]
        cell.txtPost.text = self.postDescArray[indexPath.row]
    
    cell.imgPost.frame.size.width = UIScreen.mainScreen().bounds.width*0.9
    
    if(cell.lblPost.text?.characters.count >= 150){
        
        var abc : String = (cell.lblPost.text! as NSString).substringWithRange(NSRange(location: 0, length: 150))
        abc += "...See More"
        cell.lblPost.text = abc
        let textCount = cell.lblPost.text?.characters.count
        
        let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: cell.lblPost.text!)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: self.cust.FontName, size: 13)!, range: NSMakeRange(0, textCount!))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 6/255, green: 6/255, blue: 6/255, alpha: 1.0), range: NSMakeRange(150, 11))
        
        
        let moreAttributedString : NSMutableAttributedString = NSMutableAttributedString(string: "...See More")
       
        moreAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 19/255, green: 19/255, blue: 19/255, alpha: 1.0), range: NSMakeRange(0, 11))
        moreAttributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSRange(location: 0, length: 11))
        
        cell.lblPost.attributedText = attributedString
         cell.txtPost.attributedText = attributedString
        
        }else{
            cell.lblPost.frame.size = CGSizeMake(cell.lblPost.frame.width, getLabelHeight(cell.lblPost))
        }
    
        cell.imgPost.image = self.delObj.userPlaceHolderImage
    
        if(imageAvailableArray[indexPath.row] == "1"){
            cell.imgHeightConstraint.constant = cell.imgPost.frame.size.width
            cell.imgPost.hidden = false
            
            if(postImageArray[indexPath.row] != ""){
                let postURL =  NSURL(string: postImageArray[indexPath.row])
            
                cell.imgPost.sd_setImageWithURL(postURL, placeholderImage: self.delObj.userPlaceHolderImage, options: SDWebImageOptions.RefreshCached)
                
            
            }else{
                cell.imgHeightConstraint.constant = 0
                cell.imgPost.image = delObj.userPlaceHolderImage
            }
        
        
        }else{
            cell.imgHeightConstraint.constant = 0
            cell.imgPost.hidden = true
            // cell.imgPost.image = UIImage(named: "blue_bg.png")
        }
    
    
    
        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let postDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idPostDetailViewController") as! PostDetailViewController
        
        postDTVC.username = self.postByNameArray[indexPath.row]
        postDTVC.userlogoUrl = self.postByImageArray[indexPath.row]
        postDTVC.userpostDesc = self.postDescArray[indexPath.row]
        postDTVC.userpostImage = self.postImageArray[indexPath.row]
        postDTVC.userpostdate = self.postDateArray[indexPath.row]
        postDTVC.postbyidArray = self.delObj.loginUserID
        var postByArray = ""
        if self.delObj.is_loginUserBusiness {
            postByArray = "business"
        }else{
            postByArray = "user"
        }
        postDTVC.postByArray = postByArray //self.postByArray[indexPath.row]
        
        var type = ""
        let loginUserDetalis = NSUserDefaults.standardUserDefaults().valueForKey("loginUserDetalis") as! NSDictionary
        type = loginUserDetalis["profile_type"] as! String
        postDTVC.postbyProfile_type = type
        
        self.navigationController?.pushViewController(postDTVC, animated: false)
    }


    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if(imageAvailableArray[indexPath.row] == "1"){
            return 285
        }else{
            return 150
        }
        
        //return 150
    }
*/


//TODO: - Button Action

    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }


}
