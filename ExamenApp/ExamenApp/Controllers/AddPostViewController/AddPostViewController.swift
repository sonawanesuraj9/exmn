//
//  AddPostViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/4/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire

import Fabric
import TwitterKit



class AddPostViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,FBSDKSharingDelegate {

    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    let imgPicker : UIImagePickerController = UIImagePickerController()
    let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    var base64String : NSString = NSString()
    var is_imageUpload : Bool = Bool()
    var is_textEdited : Bool = Bool()
    var is_postPublic : Bool = Bool()
    var postImage : UIImage = UIImage()
    let textColor = UIColor(red: 66/255, green: 110/255, blue: 216/255, alpha: 1.0)
    
    var saveImageToGallary : Bool = Bool()
//TODO: - Controls
    
    @IBOutlet weak var txtPostDescription: UITextView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var btnPostOutlet: UIButton!
    @IBOutlet weak var btnPostToFoursquarOutlet: UIButton!
    @IBOutlet weak var btnPostToTwitterOutlet: UIButton!
    @IBOutlet weak var btnPostToFacebookOutlet: UIButton!
    @IBOutlet weak var postSwitch: UISwitch!
    @IBOutlet weak var lblImgTitle: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    
    @IBOutlet weak var viewOuterImage: UIView!
    
//TODO: - Let's Play
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let accessToken = FBSDKAccessToken.currentAccessToken()
        print("accessToken:\(accessToken)")
       // NSString *accessToken = [FBSDKAccessToken currentAccessToken];
        
        // Do any additional setup after loading the view.
        is_postPublic = true
        
        initPlaceholderForTextView()
        self.btnPostOutlet.addTarget(self, action: #selector(AddPostViewController.btnPostClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //Initialization
        self.postSwitch.tintColor = UIColor(red: 255/255, green: 145/255, blue: 131/255, alpha: 1.0)
        //ImageTap
        self.imgPost.userInteractionEnabled = true
        tapGesture.addTarget(self, action: #selector(AddPostViewController.postImageHasBeenTapped))
        self.imgPost.addGestureRecognizer(tapGesture)

        self.lblImgTitle.text = "post a positive image \u{1F4F7} "
        self.lblImgTitle.textColor = self.cust.placeholderTextColor
        
        self.viewOuterImage.layer.borderWidth = 1.0
        self.viewOuterImage.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).CGColor
        self.viewOuterImage.tintColor = cust.textTintColor
        self.viewOuterImage.layer.cornerRadius = cust.RounderCornerRadious
        self.viewOuterImage.clipsToBounds = true
        
        self.txtPostDescription.layer.borderWidth = 1.0
        self.txtPostDescription.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).CGColor
        self.txtPostDescription.tintColor = cust.textTintColor
        self.txtPostDescription.layer.cornerRadius = cust.RounderCornerRadious
        self.btnPostOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnPostToFacebookOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnPostToFoursquarOutlet.layer.cornerRadius = cust.RounderCornerRadious
        self.btnPostToTwitterOutlet.layer.cornerRadius = cust.RounderCornerRadious
        
       self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.frame.width, height: self.postSwitch.frame.origin.y + self.postSwitch.frame.size.height + 20)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func mandatoryCheck() -> Bool{
        var outFlag : Bool = Bool()
        print("cgt: \(self.txtPostDescription.text.characters.count)")
        print("is_textEdited:\(is_textEdited)")
        print("is_imageUpload:\(is_imageUpload)")
        if(!is_textEdited && !is_imageUpload){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter post or select image")
        }else if((self.txtPostDescription.text.characters.count == 0)){
            outFlag = false
            self.delObj.displayMessage("examen", messageText: "please enter post or select image")
        }else{
            outFlag = true
        }
        return outFlag
    }
    
    
    
//TODO: - Web service / API call
    func InsertUserPost(){
        
        if(mandatoryCheck()){
        
            SVProgressHUD.showWithStatus("Posting..")
            var postType : String = String()
            if(is_postPublic){
                postType = "Public"
            }else{
                postType = "Private"
            }
            var postText : String = String()
            if(is_textEdited){
                postText = cust.trimString(self.txtPostDescription.text!)
            }else{
                postText = ""
            }
            let parameters = ["user_id":delObj.loginUserID,
                              "image":base64String,
                              "post_type":postType,
                              "post":postText]
            
            print(parameters)
            Alamofire.request(.POST, delObj.baseUrl + "InsertUserPost", parameters: parameters).responseJSON{
            response in
            print("output\(response.request)")
                print("output\(response.response)")
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                      self.delObj.isNewPostAdded = true
                    self.navigationController?.popViewControllerAnimated(true)
                   
                }else{
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                    
                }
            }else{
                SVProgressHUD.dismiss()
                self.delObj.displayMessage("examen", messageText: "please check internet connection")
                
            }
        }
      }
    }
    
    
//TODOL - Function
    
    func initPlaceholderForTextView(){
       /* let emojiEscaped: String = "\u{1F44d}"
        let emojiData: NSData = emojiEscaped.dataUsingEncoding(NSUTF8StringEncoding)!
        let emojiString: String = String(data: emojiData, encoding: NSNonLossyASCIIStringEncoding)!
        NSLog("emojiString: %@", emojiString)*/
        
        txtPostDescription.text = "post a positive message or link \u{1F44d} "
        txtPostDescription.textColor = self.cust.placeholderTextColor
        is_textEdited = false
        
    }
    

    func postImageHasBeenTapped(){
        print("image tapped")
        self.askToChangeImage()
    }
    
    func askToChangeImage(){
        let alert = UIAlertController(title: "Let's get a picture", message: "Choose a Picture Method", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        self.imgPicker.delegate = self
        
        if(is_imageUpload){
            let removeImageButton = UIAlertAction(title: "Remove picture", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
                self.is_imageUpload = false
                
                self.imgPost.image = UIImage(named: "camera-outline")
            }
            alert.addAction(removeImageButton)
        }else{
            print("No image is selected")
        }
        
        //Add AlertAction to select image from library
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.imgPicker.delegate = self
            self.imgPicker.allowsEditing = true
            self.presentViewController(self.imgPicker, animated: true, completion: nil)
        }
        
        //Check if Camera is available, if YES then provide option to camera
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.imgPicker.allowsEditing = true
                self.presentViewController(self.imgPicker, animated: true, completion: nil)
            }
            alert.addAction(cameraButton)
        } else {
            print("Camera not available")
            
        }
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            print("Cancel Pressed")
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Save Image to Photo Library Additionla approved point #3
     */
    func saveImageToPhotoLibrary(){
        UIImageWriteToSavedPhotosAlbum(self.imgPost.image!, self, #selector(AddPostViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /**
     Helping method
     
     - parameter image:       image to save
     - parameter error:       error value
     - parameter contextInfo: contextInfo description
     */
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            print("Your image has been saved to your photos")
        } else {
            print("Save error")
        }
    }
    
    
    
//TODO: - POST to Facebook
    func postImageOnFacebook(){
    
        let photoshare : FBSDKSharePhoto = FBSDKSharePhoto()
        photoshare.image = postImage
        photoshare.userGenerated = true
        let content1 : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        content1.photos = [photoshare]
        content1.contentURL = NSURL(string:"http://examen.us/")
        
        let dialog : FBSDKShareDialog = FBSDKShareDialog()
        dialog.shareContent = content1
        dialog.fromViewController = self
        dialog.mode = FBSDKShareDialogMode.Automatic
        dialog.delegate = self
        dialog.show()

        //Save image to local
        self.saveImageToPhotoLibrary()
        
    }
    
    func PostonFacebook(fbMessage : String){
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentTitle =  "examen"
        content.contentDescription = fbMessage
        content.imageURL = NSURL(string:  self.delObj.baseUrl + "fbLogo.png")
        content.contentURL = NSURL(string:"http://examen.us/")
    
        let dialog : FBSDKShareDialog = FBSDKShareDialog()
        dialog.shareContent = content
        dialog.fromViewController = self
        dialog.mode = FBSDKShareDialogMode.Automatic
        dialog.delegate = self
        dialog.show()
        //FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self)
        
        // Facebook post ends here
    }

    
    
//TODO: - Facebook SDK ShareKit delegate methods
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("Facebook Post Completed")
        self.InsertUserPost()
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print("Facebook Post fail with error \(error)")
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        print("Facebook Post cancel")
    }
    

//TODO: - UIImagePickerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let pickedImage : UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        if picker.sourceType == .Camera{
            self.saveImageToGallary = true
        }
        self.imgPost.autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin , UIViewAutoresizing.FlexibleHeight , UIViewAutoresizing.FlexibleRightMargin , UIViewAutoresizing.FlexibleLeftMargin , UIViewAutoresizing.FlexibleTopMargin , UIViewAutoresizing.FlexibleWidth]
        self.imgPost.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.imgPost.image = cust.rotateCameraImageToProperOrientation(pickedImage, maxResolution: 460)// pickedImage
        postImage = self.imgPost.image!
       // self.lblImgTitle.hidden = true
        //let imageData = UIImageJPEGRepresentation(pickedImage, 0.8)
        let imageData : NSData = UIImageJPEGRepresentation(self.imgPost.image!,0.8)!
        base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        is_imageUpload = true
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        //is_imageUpload = false
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
//TODO: UITextViewDelegate Methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == self.cust.placeholderTextColor{
            textView.text = nil
            textView.textColor = textColor
            is_textEdited = true
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == txtPostDescription{
            
            if textView.text.isEmpty{
                
                
                txtPostDescription.text = "post a positive message or link \u{1F44d}"
                txtPostDescription.textColor = self.cust.placeholderTextColor
                is_textEdited = false
            }
            
        }
    }
    
//TODO: - UIButton Action
    
   
    @IBAction func postSwitchValueChanged(sender: AnyObject) {
        if(postSwitch.on){
            is_postPublic = true
        }else{
            is_postPublic = false
        }
        
    }
    
    @IBAction func btnPostClick(sender: AnyObject) {
        InsertUserPost()
        if self.saveImageToGallary{
            self.saveImageToPhotoLibrary()
        }
    }
    
    @IBAction func btnPostToFoursquareClick(sender: AnyObject) {
        if(self.txtPostDescription.text == ""){
            self.delObj.displayMessage("examen", messageText: "please enter text to share")
        }else{
        
    let url: String = String("https://api.linkedin.com/v1/people/~/shares?format=json")
        
       /* var o1: [NSObject : AnyObject] = [
            "key1" : "ABCD",
            "key2" : "EFG"
        ]
        
        var o2: [NSObject : AnyObject] = [
            "key1" : "XYZ",
            "key2" : "POI"
        ]
        
        var array = [o1, o2] as NSArray
        var jsonString: String = array.JSONRepresentation()

        
        let payload  =  {
            "comment": "Check out developer.linkedin.com! http://linkd.in/1FC2PyG",
            "visibility": {
                "code": "anyone"
            }
        }
        let pay = NSJSONSerialization.dataWithJSONObject(payload, options: NSJSONWritingOptions.PrettyPrinted)
        
       */
        /*    let payload  =  [
         "comment": shareText,
         "content": [
         "title": "LinkedIn Developers Resources",
         "description": "Leverage LinkedIn's APIs to maximize engagement",
         "submitted-url": "https://developer.linkedin.com",
         "submitted-image-url": "https://example.com/logo.png"
         ],
         "visibility": [
         "code": "anyone"
         ]
         ]
         */
        let shareText = self.txtPostDescription.text!
        let payload  =  [
            "comment": shareText,
            "visibility": [
                "code": "anyone"
            ]
        ]
    
        /*let setUser: [NSObject : AnyObject] = [
            "comment": "Check out developer.linkedin.com! http://linkd.in/1FC2PyG",
            "code": "anyone",
            "value" : ""
        ]*/
        var jsonData: NSData = NSData()
        
        do{
            jsonData = try NSJSONSerialization.dataWithJSONObject(payload, options: NSJSONWritingOptions.PrettyPrinted)
        }catch let error as NSError{
            print(error)
        }
        
       
        
        if LISDKSessionManager.hasValidSession() {
            LISDKAPIHelper.sharedInstance().postRequest(url, body: jsonData, success: { (response:LISDKAPIResponse!) in
                //success Block
                    print("Successful")
                self.InsertUserPost()
                self.delObj.displayMessage("examen", messageText: "LinkedIn post successful")
                }, error: { (apiError:LISDKAPIError!) in
                    //Error Block
                    print("error:\(apiError)")
            })
            /*LISDKAPIHelper.sharedInstance().postRequest(url, stringBody: payload, success: {(response: LISDKAPIResponse) -> Void in
                // do something with response
                }, error: {(apiError: LISDKAPIError) -> Void in
                    // do something with error
            })*/
        }else{
            LISDKSessionManager.createSessionWithAuth([LISDK_BASIC_PROFILE_PERMISSION,LISDK_W_SHARE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnString:String!) in
                //Success
                print("returnString :\(returnString)")
            }) { (erro:NSError!) in
                //error
                print("error:\(erro)")
            }
        }
     }
        
    }
    
    @IBAction func btnPostToTwitterClick(sender: AnyObject) {
        
        // Use the TwitterKit to create a Tweet composer.
        let composer = TWTRComposer()
        
        // Prepare the Tweet with the poem and image.
        if(!is_textEdited){
            composer.setText("")
        }else{
           composer.setText(self.txtPostDescription.text)
        }
        
        composer.setImage(postImage)
        
        // Present the composer to the user.
        composer.showFromViewController(self) { result in
            if result == .Done {
                print("Tweet composition completed.")
                self.InsertUserPost()
            } else if result == .Cancelled {
                print("Tweet composition cancelled.")
            }
        }
        
    }
    
    @IBAction func btnPostToFacebookClick(sender: AnyObject) {
        if is_imageUpload{
            postImageOnFacebook()
        }else{
            if(!is_textEdited){
                self.delObj.displayMessage("examen", messageText: "please enter text to post")
            }else{
               PostonFacebook(self.txtPostDescription.text)
            }
            
        }
        
    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*@IBAction func btnAddImage(sender: AnyObject) {
        print("image tapped")
        self.askToChangeImage()
    }*/

   /* func tempFacebook(){
        let message = "You are simpy Awesome.."
        if FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions") {
           
            FBSDKGraphRequest(graphPath: "me/feed", parameters: ["message":message], tokenString: "token", version: "1.0", HTTPMethod: "POST").startWithCompletionHandler({ (FBSDKGraphRequestConnection, obj:AnyObject!, error:NSError!) in
                //
                 print("Post id:\(obj["id"])")
            })
        }

    }*/

}
