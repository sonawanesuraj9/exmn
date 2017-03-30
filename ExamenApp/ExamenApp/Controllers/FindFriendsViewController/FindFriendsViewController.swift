//
//  FindFriendsViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC3 on 09/03/17.
//  Copyright © 2017 supaint. All rights reserved.
//

import UIKit
import Alamofire
import Contacts


class FindFriendsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, FBSDKAppInviteDialogDelegate {

    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let defaults = NSUserDefaults.standardUserDefaults()
    let cust: CustomClass_Dev = CustomClass_Dev()
    
    var emailArray : [String] = []
    //0 >> select all active , 1 >> deleselct all active
    var selectButtonValue : Int = Int()
    //0 for uncheck, 1 for check
    var nameArray : [String] = []
    var checkArray : [String] = []
    var is_emailEnter : Bool = Bool()
    var tmpEmail : String = String()
    var imageData : [UIImage] = []
    
    // Other user Data
    var OtherUserID : String = String()
    var OtherUserProfileType : String = String()
    var OtherUserProfile : String = String()
    
    //Twitter
    //var serviceWrapper: TwitterServiceWrapper = TwitterServiceWrapper()
    //var followers = [TwitterFollower]()

    
//TODO: - Controls
    
    
    @IBOutlet weak var btnInviteFriends: UIButton!
    @IBOutlet weak var lblCountOf: UILabel!
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
//TODO: - Let's Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblMain.tableFooterView = UIView()
        
        
        self.btnInviteFriends.layer.cornerRadius = 5
      
        
        
        //Fetch Contact PopUp
        let status = CNContactStore.authorizationStatusForEntityType(.Contacts)
        if status == .Denied || status == .Restricted {
            // user previously denied, so tell them to fix that in settings
            return
        }else{
            // Uncomnnet below line to fetch contact
            let askAlert = UIAlertController(title: "examen", message: "examen would like to access your contacts", preferredStyle: UIAlertControllerStyle.Alert)
            askAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) in
                //Fetch code will be here
                self.fetchContacts()
            }))
            
            askAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (value:UIAlertAction) in
                
            }))
            
            self.presentViewController(askAlert, animated: true, completion: nil)
            
            // fetchContacts()
        }
        tblMain.reloadData()
     
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let count = self.countOfValue()
        self.lblCountOf.text = "\(count) friend(s) added."
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
//TODO: - UITableViewDatasource Method Implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("Count:\(self.nameArray.count)")
        
        var returnCount : Int = Int()
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            returnCount = self.nameArray.count
        case 1:
            print("image :\(self.delObj.facebookFriendImageArray)")
            returnCount = self.delObj.facebookFriendNameArray.count
            
        case 2:
            returnCount = 0 //followers.count
        default:
            break;
        }
        return returnCount
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! InviteFriendsTableViewCell
        
        cell.selectionStyle = .None
        print("index:\(indexPath.row)")
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            //Peopele from Contact
            cell.imgProfile.image = self.imageData[indexPath.row]
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
            cell.imgProfile.clipsToBounds = true
            
            cell.lblName.text = self.nameArray[indexPath.row]
            cell.btnCheck.hidden = false
            cell.btnCheck.setImage(UIImage(named: "check_icon"), forState: .Normal)
            
            
            
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.addTarget(self, action: #selector(InviteFriendsViewController.btnAddClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            if(self.checkArray[indexPath.row] == "1"){
                cell.btnCheck.setImage(UIImage(named: "check_icon"), forState: .Normal)
                
            }else{
                cell.btnCheck.setImage(UIImage(named: "uncheck_icon"), forState: .Normal)
                
            }
            
            
        case 1:
             //Peopele from Facebook
            var placeHolder : String = String()
            
            if self.delObj.facebookFriendImageArray[indexPath.row] == ""{
                placeHolder = "profile-placeholder"
            }else{
                
                placeHolder = self.delObj.facebookFriendImageArray[indexPath.row]
            }
            let userProfURL = NSURL(string: placeHolder)
             cell.imgProfile.sd_setImageWithURL(userProfURL, placeholderImage: self.delObj.profilePlaceholder, options: SDWebImageOptions.RefreshCached)
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
            cell.imgProfile.clipsToBounds = true
            
            if self.delObj.facebookFriendTypeArray[indexPath.row] == "1"{
                // All facebook Friends
                cell.btnCheck.hidden = true
                cell.btnCheck.setImage(UIImage(named: "check_icon"), forState: .Normal)
            }else{
                //Friends used examen before
                cell.btnCheck.hidden = false
               cell.btnCheck.setImage(UIImage(named: "eIcon"), forState: .Normal)
            }
            cell.lblName.text = self.delObj.facebookFriendNameArray[indexPath.row]
            
        case 2:
            print("Second Segment selected");
            
            /*let follower = followers[indexPath.row] as TwitterFollower
            
            cell.lblName.text = follower.name
            let userProfURL = NSURL(string: follower.profileURL!)
            cell.imgProfile.sd_setImageWithURL(userProfURL, placeholderImage: self.delObj.profilePlaceholder, options: SDWebImageOptions.RefreshCached)
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
            cell.imgProfile.clipsToBounds = true

             cell.btnCheck.hidden = true
            
            self.tblMain.reloadData()*/
        default:
            break;
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("indexPath:\(indexPath.row)")
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            print("First selected");
        case 1:
             if self.delObj.facebookFriendTypeArray[indexPath.row] != "1"{
                //Examen User signup with Facebook
                let fid = self.delObj.facebookFriendIDArray[indexPath.row]
                self.fetchMyID(fid, completion: { (response:Bool) in
                    if response{
                        //Got User ID
                        
                        if(self.OtherUserProfile == "Business"){
                            let businessDTVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherBusinessProfileViewController") as! OtherBusinessProfileViewController
                            businessDTVC.reqUserID = self.OtherUserID
                            self.navigationController?.pushViewController(businessDTVC, animated: true)
                            
                        }else{
                            let otherUserVC = self.storyboard?.instantiateViewControllerWithIdentifier("idOtherUserProfileViewController") as! OtherUserProfileViewController
                            otherUserVC.reqUserID = self.OtherUserID
                            otherUserVC.reqProfileType = self.OtherUserProfileType
                            self.navigationController?.pushViewController(otherUserVC, animated: true)
                        }
                        
                        
                    }else{
                        print("No User ID Return from Databse")
                    }
                })
                
             }else{
                print("Non-examen User, send them invitation")
             }
            print("Second Segment selected");
        case 2:
            print("Second Segment selected");            
        default:
            break;
        }
    }
    
    
//TODO: - TwitterFollowerDelegate methods
    /*
    func finishedDownloading(follower: TwitterFollower) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.followers.append(follower)
            self.tblMain.reloadData()
        })
    }
    */
//TODO: - Function
    
    
    /**
     Fetch Contact Information from device
     */
    func fetchContacts(){
        // open it
        
        let store = CNContactStore()
        store.requestAccessForEntityType(.Contacts) { granted, error in
            guard granted else {
                dispatch_async(dispatch_get_main_queue(), {
                    // code here
                    print(error)
                })
                
                return
            }
            
            // get the contacts
            
            var contacts = [CNContact]()
            let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactMiddleNameKey, CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactImageDataKey,CNSocialProfileServiceGameCenter, CNContactFormatter.descriptorForRequiredKeysForStyle(.PhoneticFullName)])
            do {
                try store.enumerateContactsWithFetchRequest(request) { contact, stop in
                    contacts.append(contact)
                }
            } catch {
                print(error)
            }
            
            // do something with the contacts array (e.g. print the names)
            
            let formatter = CNContactFormatter()
            formatter.style = .PhoneticFullName
            self.emailArray.removeAll(keepCapacity: false)
            self.checkArray.removeAll(keepCapacity: false)
            self.nameArray.removeAll(keepCapacity: false)
            self.imageData.removeAll(keepCapacity: false)
            for contact in contacts {
                if(contact.emailAddresses.first?.value as? String != nil){
                    
                    // let emailVal = contact.emailAddresses.first!.value as? String
                    // print(emailVal)
                    let emailVal1 = contact.emailAddresses.count
                    
                    for em in 0...emailVal1-1{
                        print("\(em): \(contact.emailAddresses[em].value as? String)")
                        let finalEmail = contact.emailAddresses[em].value as? String
                        
                        if(contact.imageData != nil){
                            let img = UIImage(data: contact.imageData!)
                            self.imageData.append(img!)
                        }else{
                            self.imageData.append(self.delObj.userPlaceHolderImage)
                        }
                        self.emailArray.append(finalEmail!)
                        self.nameArray.append(contact.givenName + " " + contact.familyName)
                        self.checkArray.append("0")
                    }
                    print("**\(emailVal1)")
                    //self.emailArray.append(emailVal!)
                    print("emailArray-inner:\(self.emailArray)")
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                // code here
                //self.checkArray.append("0")
                //self.emailArray.append("")
               // self.nameArray.append("")
                print("emailArray:\(self.nameArray)")
                print("emailArray:\(self.imageData)")

                print("emailArray:\(self.emailArray)")
                let checkCount = self.countOfValue()
                self.lblCountOf.text = "\(checkCount) friend(s) added."
                self.tblMain.reloadData()
            })
            
        }
        
    }
    
    func FacebookSetup(){
        
        
        // If user is not login with FB then alert and ask them to login using FB

        if ((FBSDKAccessToken.currentAccessToken()) != nil){
            
            //FBSDKAccessToken.setCurrentAccessToken(nil)
            
            // End of Season
            let array : [String] = self.defaults.valueForKey("facebookFriendNameArray") as! [String]
            let typeArray : [String]  = self.defaults.valueForKey("facebookFriendTypeArray") as! [String]
            let idArray : [String]  = self.defaults.valueForKey("facebookFriendIDArray") as! [String]
            let imageArray : [String]  = self.defaults.valueForKey("facebookFriendImageArray") as! [String]
            
            self.delObj.facebookFriendImageArray = imageArray
            self.delObj.facebookFriendIDArray = idArray
            self.delObj.facebookFriendNameArray = array
            self.delObj.facebookFriendTypeArray = typeArray

            self.tblMain.reloadData()
        }else{
            //User is not login with facebook previously
            fetchDataFromFacebook({ (response:Bool) in
                if response{
                    //Success Block
                    
                    // End of Season
                    let array  : [String] = self.defaults.valueForKey("facebookFriendNameArray") as! [String]
                    let typeArray  : [String] = self.defaults.valueForKey("facebookFriendTypeArray") as! [String]
                    let idArray : [String]  = self.defaults.valueForKey("facebookFriendIDArray") as! [String]
                    let imageArray : [String]  = self.defaults.valueForKey("facebookFriendImageArray") as! [String]
                    
                    self.delObj.facebookFriendImageArray = imageArray
                    self.delObj.facebookFriendIDArray = idArray
                    self.delObj.facebookFriendNameArray = array
                    self.delObj.facebookFriendTypeArray = typeArray
                    
                    self.tblMain.reloadData()
                }else{
                    //Failure Block
                    print("Unable to fetch Facebook Friends")
                }
            })
        }
        
        
    }
    
    func fetchDataFromFacebook(completion:(Bool)->()){
        let login : FBSDKLoginManager = FBSDKLoginManager()
        login.loginBehavior =  FBSDKLoginBehavior.Native //Native //FBSDKLoginBehaviorNative
        
        login.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self) { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if((error) != nil){
                
                //Process the error
                 print(error)
            }else if (result.isCancelled){
                print(result)
                //handle the cancel result
            }else{
                //Login Success
                
                if (result.grantedPermissions.contains("email")){
                    
                    print("Facebook Access token:  \(FBSDKAccessToken.currentAccessToken().tokenString)")
                    self.defaults.setValue(FBSDKAccessToken.currentAccessToken().tokenString, forKey: "fbAccessToken")
                    self.defaults.synchronize()
                    
                    if ((FBSDKAccessToken.currentAccessToken()) != nil){
                        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture, birthday, gender , email, location,cover"])
                        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                            
                            
                            if ((error) != nil)
                            {
                                // Process error
                                print("Error: \(error)")
                            }
                            else
                            {
                                print("fetched user: \(result)")
                                
                            }
                        })
                        
                        
                        // Friend list code here
                        let params = ["fields": "id, name, first_name, last_name, picture, birthday, gender , email, location,cover"]
                        
                        // friends
                        let fbRequest = FBSDKGraphRequest(graphPath:"me/friends", parameters: params);
                        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                            
                            if error == nil {
                                print("result:\(result)")
                                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                                {
                                    self.delObj.clearFacebookArray()
                                    if userNameArray.count>0{
                                        for i in 0...userNameArray.count-1{
                                            print("*\(i)*\(userNameArray[i].valueForKey("id"))")
                                            let name = userNameArray[i].valueForKey("name") as! String
                                            self.delObj.facebookFriendNameArray.append(name)
                                            print("*\(i)*\(userNameArray[i].valueForKey("name"))")
                                            self.delObj.facebookFriendTypeArray.append("0")
                                            
                                            //ID
                                            let fid = userNameArray[i].valueForKey("id") as! String
                                            self.delObj.facebookFriendIDArray.append(fid)
                                            print("*\(i)*\(userNameArray[i].valueForKey("name"))")
                                            
                                            //Profile
                                            var profPic : String = String()
                                            if(fid != ""){
                                                profPic = "https://graph.facebook.com/\(fid)/picture?type=large"
                                            }
                                            self.delObj.facebookFriendImageArray.append(profPic)
                                            
                                        }
                                    }
                                }
                                
                                //Store into defaults
                                self.defaults.setValue(self.delObj.facebookFriendNameArray, forKey: "facebookFriendNameArray")
                                self.defaults.setValue(self.delObj.facebookFriendTypeArray, forKey: "facebookFriendTypeArray")
                                self.defaults.setValue(self.delObj.facebookFriendImageArray, forKey: "facebookFriendImageArray")
                                self.defaults.setValue(self.delObj.facebookFriendIDArray, forKey: "facebookFriendIDArray")
                                
                                
                            }
                            else {
                                
                                print("Error Getting Friends \(error)");
                                
                            }
                            
                        }

                        
                        //Other Facebook taggable_friends
                        let OtherFBRequest = FBSDKGraphRequest(graphPath:"me/taggable_friends", parameters: params);
                        OtherFBRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                            
                            if error == nil {
                                print("result:\(result)")
                                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                                {
                                    if userNameArray.count>0{
                                        for i in 0...userNameArray.count-1{
                                            print("*\(i)*\(userNameArray[i].valueForKey("id"))")
                                            //Name
                                            let name = userNameArray[i].valueForKey("name") as! String
                                            self.delObj.facebookFriendNameArray.append(name)
                                            self.delObj.facebookFriendTypeArray.append("1")
                                            
                                            //ID
                                            self.delObj.facebookFriendIDArray.append("")
                                            self.delObj.facebookFriendImageArray.append("")
                                            
                                        }
                                    }
                                }
                                
                                //Store into defaults
                                self.defaults.setValue(self.delObj.facebookFriendNameArray, forKey: "facebookFriendNameArray")
                                self.defaults.setValue(self.delObj.facebookFriendTypeArray, forKey: "facebookFriendTypeArray")
                                self.defaults.setValue(self.delObj.facebookFriendImageArray, forKey: "facebookFriendImageArray")
                                self.defaults.setValue(self.delObj.facebookFriendIDArray, forKey: "facebookFriendIDArray")
                                
                                completion(true)
                            }
                            else {
                                
                                print("Error Getting Friends \(error)");
                                
                            }
                            
                        }
                        //Other Facebook friend ends
                        
                    }else{
                        completion(false)
                    }
                }
            }
        }
        
    }
    
    func countOfValue() -> Int{
        var checkCounter : Int = 0
        print("self.checkArray.count:\(self.checkArray.count)")
        if self.checkArray.count>0{
            for ind in 0...self.checkArray.count-1{
            if(self.checkArray[ind]=="1" && self.emailArray[ind] != ""){
                checkCounter = checkCounter + 1
            }
         }
        }
        return checkCounter
    }

    func FacebookInvite(){
        let content : FBSDKAppInviteContent = FBSDKAppInviteContent()
        
        content.appLinkURL = NSURL(string: "https://fb.me/1904889709740277")
        content.appInvitePreviewImageURL = NSURL(string:  self.delObj.baseUrl + "fbLogo.png")
        //FBSDKAppInviteDialog.showWithContent(content, delegate: self)
        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
    }

    
//TODO: - WebService / API implementation
    
    /**
     Fetch User ID from FBID
     
     - parameter fbID: passFB ID recieved from Facebook
     */
    func fetchMyID(fbID:String, completion : (Bool) -> ()){
        print("fbID:\(fbID)")
        
        SVProgressHUD.showWithStatus("Loading...")
        Alamofire.request(.POST, self.delObj.baseUrl + "getfbuser", parameters: ["fid":fbID]).responseJSON {
            response in
            print(response.result.value)
            print(response.request)
            if(response.result.isSuccess){
                
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] == "1"){
                    
                    self.OtherUserID = outJSON["userid"].stringValue
                    self.OtherUserProfile = outJSON["profile"].stringValue
                    self.OtherUserProfileType = outJSON["profile_type"].stringValue
                    
                    print("self.OtherUserID:\(self.OtherUserID)")
                    completion(true)
                }else{
                    SVProgressHUD.dismiss()
                    completion(false)
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }
                
            }else{
                completion(false)
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
            }
            
        }
    }
    
    
    func sendInvitation(){
       
        print("self.emailArray:\(self.emailArray)")
        let checkCount = self.countOfValue()
        self.lblCountOf.text = "\(checkCount) friend(s) added."
        if(checkCount > 0){
             SVProgressHUD.showWithStatus("Loading...")
            var sendList :[String] = []
            for ind in 0...self.checkArray.count-1{
                if(self.checkArray[ind] == "1"){
                    sendList.append(self.emailArray[ind])
                }
            }
            //let countEmail = sendList.count
            let params = ["user_id":self.delObj.loginUserID,"email_list":sendList]
            print("params:\(params)")
            Alamofire.request(.POST, delObj.baseUrl + "invitefriends", parameters:params as? [String : AnyObject] ).responseJSON{
                response in
                
                print("output\(response.result.value)")
                
                if(response.result.isSuccess){
                    SVProgressHUD.dismiss()
                    let outJSON = JSON(response.result.value!)
                    if(outJSON["status"] != "1"){
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                    }else{
                        
                        self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                        
                    }
                }else{
                    SVProgressHUD.dismiss()
                    self.delObj.displayMessage("examen", messageText: "please check internet connection")
                    
                }
            }
        }else{
            self.delObj.displayMessage("examen", messageText: "No email address is selected")
            
        }
    }
    
    
//TODO: - UIButton Action
    
    @IBAction func btnAddClick(sender:AnyObject){
        print("tag:\(sender.tag)")
        let index = sender.tag
        print("add index :\(index)")
        
        if(self.checkArray[sender.tag] != "1"){
            //MARK: Check
             self.checkArray[sender.tag] = "1"
            
        }else{
            //MARK: Uncheck
             self.checkArray[sender.tag] = "0"
            
        }
        
        let count = self.countOfValue()
        self.lblCountOf.text = "\(count) friend(s) added."
        self.tblMain.reloadData()
        
    }
   
    
   
    @IBAction func segmentValueChange(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            print("First selected");
            self.lblCountOf.hidden = false
            self.tblMain.reloadData()
        case 1:
            print("Second Segment selected");
             self.FacebookSetup()
             self.lblCountOf.hidden = true
             self.tblMain.reloadData()
        case 2:
            print("Second Segment selected");
          //  serviceWrapper.delegate = self
          //  serviceWrapper.getResponseForRequest("https://api.twitter.com/1.1/followers/list.json?screen_name=rshankra&skip_status=true&include_user_entities=false")
  
            
            
             self.tblMain.reloadData()
        default:
            break; 
        }
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    
    @IBAction func btnInviteFriendClick(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            print("First selected");
            //Invite Friends with Email ID
            self.sendInvitation()
        case 1:
            print("Second Segment selected");
            //Invite Friends with Facebook Invitation
            self.FacebookInvite()
        case 2:
            print("Second Segment selected");
            //Invite Friends with any other medium
            
        default:
            break;
        }
        
    }
    
    
//TODO: FacebookInviteDialogue Delegate Method Implementation
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!){
        print("-*****\(results)")
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!){
        print("-*****-\(error)")
    }

}
