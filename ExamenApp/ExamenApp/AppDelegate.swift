//
//  AppDelegate.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 4/28/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import CoreLocation
import Fabric
import TwitterKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?

    var userPlaceHolderImage  : UIImage = UIImage(named: "addphoto_placeholder.png")!
    var profilePlaceholder  : UIImage = UIImage(named: "profile-placeholder")!
    var coverPlaceholder : UIImage = UIImage(named: "cover_placeholder")!
   
    var isNewTimeUser : Bool = Bool()
/*******************************************************/
    var devHeight : CGFloat = CGFloat()
    var baseUrl : String = String()
    var baseUrl_static : String = String()
    let imageCache : NSCache = NSCache()
    var loginUserID : String = String()
    var loginUserEmail : String = String()
    var is_loginUserBusiness : Bool = Bool()
    var screenWidth : CGFloat = CGFloat()
    var screenHeight : CGFloat = CGFloat()
    var deviceName : String = String()
    var deviceTokenToSend : String = String()
    var deviceUDID : String = String()
    var splashSec : Double = Double()
    
    //var userCoverPhoto : String = String()
    //var userProfilePhoto : String = String()
    
    var created_date : String = String()
    var admin_photo_URL : String = String()
/*******************************************************/
    //For normalSignup screen
    var tmp_next : Bool = Bool()
    
    var is_updateCharity : Bool = Bool()
    var is_normal_aboutmechange : Bool = Bool()
    var is_normal_CharitySelected : Bool = Bool()
    var is_normal_profileType : Bool = Bool()
    var normal_supportedCharityID : String = String()
    var normal_charityName : String = String()
    
    //Non-profit Resume Array
    var selectedIDArray_nonprofit : [String] = []
    var selectedTitleArray_nonprofit : [String] = []
    var selectedWebsiteArray_nonprofit : [String] = []
    //var selectedLogoArray_nonprofit : [NSString] = []
   // var selectedLogoURL_nonprofit : [String] = []
    var selectedCompanyArray_nonprofit : [String] = []
    var selectedStartDateArray_nonprofit : [String] = []
    var selectedEndDateArray_nonprofit : [String] = []
    var selectedIsPresentArray_nonprofit : [String] = []
   // var selectedLogoImageTmp_nonprofit : [UIImage] = []
    var is_editResume : Bool = Bool()
    
/*******************************************************/
    //For business profile normal signup
    var is_business_normal_introChanged : Bool = Bool()
    var is_business_ouline_changed : Bool = Bool()
    
    
/*******************************************************/
    //For Home Screen
    
    var isNewPostAdded : Bool = Bool()
    
/*******************************************************/
    //For Search Page 
    var searchString : String = String()
    var searchType : String = String()
    var detailSelected : Bool = Bool()
    var lastSelection : Int = Int()
            /* Response array for searchbyName*/
        var keepIDArray : [String] = []
        var keepNameArray : [String] = []
        var keepProfileArray : [String] = []
        var keepLogoArray : [String] = []
        var keepFollowstatusArray : [String] = []
        var keepProfile_type : [String] = []
    
              /*Response array for search by date */
        var keepPostDateArray : [String] = []
        var keepPostImageArray : [String] = []
        var keepPostTextArray : [String] = []
        var keepPostIDArray : [String] = []
        var keepPostByNameArray : [String] = []
        var keepPostUserPhotoArray : [String] = []
        var keepImageAvailableArray : [String] = []
        var keepPostByArray : [String] = []
        var keepPostByIDArray : [String] = []
        var keepPostbyProfile_type : [String] = []
    
/*******************************************************/
    
    //Locaiton Variables
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var currentLat : Double = Double()
    var currentLong : Double = Double()
    var locFlag : Bool!
    var userZipcode : String = String()
    
    
/*******************************************************/
    //Fetch friends from Facebook
    var facebookFriendNameArray : [String] = []
    var facebookFriendTypeArray : [String] = []
    var facebookFriendImageArray : [String] = []
    var facebookFriendIDArray : [String] = []
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        splashSec = 4.0
        screenHeight = UIScreen.mainScreen().bounds.height
        
        if(screenHeight == 568){
            deviceName = "_i5"
        }else if(screenHeight == 667){
            deviceName = "_i6"
        }else if(screenHeight == 736){
            deviceName = "_i6p"
        }else{
            deviceName = "_i5"
        }
        
        Fabric.with([Twitter.self])

        isNewPostAdded = false
        tmp_next = false
        is_editResume = false
        deviceUDID  = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        //baseUrl = "http://www.supraint.com/works/examen/mobwebservices/ios/"
        baseUrl = "http://examen.us/mobile/ios/ws_examen_ios.php/"
        
        baseUrl_static = "http://examen.us/mobile/ios/"
                
        //Mannually override IQKeyboardManager
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

        devHeight = UIScreen.mainScreen().bounds.height

        //Remote Notification Code
       // self.initializeNotificationSetting()
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //return true
    }

//TODO: - Facebook
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if (LISDKCallbackHandler.shouldHandleUrl(url)){
            return LISDKCallbackHandler.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }else{
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    func clearFacebookArray(){
        facebookFriendImageArray.removeAll(keepCapacity: false)
        facebookFriendIDArray.removeAll(keepCapacity: false)
        facebookFriendTypeArray.removeAll(keepCapacity: false)
        facebookFriendNameArray.removeAll(keepCapacity: false)
    }
    
    
//TODO: - Common Functions
    
    func displayMessage(titleString : String, messageText : String){
        let alert = UIAlertController(title: "examen", message: messageText, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
   
//TODO: - Remote Notification Initialization
    
   /* func initializeNotificationSetting(){
        //Remote Notification Code
        let setting = UIUserNotificationSettings(forTypes: [.Sound,.Badge,.Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }*/
    
//TODO: - Remote Notification Delegate Method
   /* func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        print(" deviceTokenString : \(deviceTokenString)" )
        deviceTokenToSend = deviceTokenString
        NSNotificationCenter.defaultCenter().postNotificationName("GotDeviceToken", object: nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error.localizedDescription)
    }
    */
//TODO: Location function
    
    func CurrentLocationIdentifier(){
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        locFlag = false
        let status = CLLocationManager.authorizationStatus()
        if(status == .Denied || status == .AuthorizedWhenInUse){
            
            var title: String
            title =  "Location services are off Background location is not enabled"
            let message: String = "To use background location you must turn on 'Always' in the Location Services Settings"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "Setting", style: .Default, handler: { (value:UIAlertAction) in
                let settingsURL: NSURL = NSURL(string: UIApplicationOpenSettingsURLString)!
                if(UIApplication.sharedApplication().canOpenURL(settingsURL)){
                    UIApplication.sharedApplication().openURL(settingsURL)
                }else{
                    print("Unable to open URL")
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            alertController.addAction(cancelAction)
            self.window?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            
        }
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            
            //locationManager.requestAlwaysAuthorization()
             locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(!locFlag){
            locFlag = true
            
            let locationArray = locations as NSArray
            currentLocation = locationArray.lastObject as! CLLocation
            let coord = currentLocation.coordinate
            //locationManager.stopUpdatingLocation()
            NSNotificationCenter.defaultCenter().postNotificationName("postLocationUpdate", object: nil)
            currentLat = coord.latitude
            currentLong = coord.longitude
            
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)-> Void in
                if error != nil {
                    print("Reverse geocoder failed with error: \(error!.localizedDescription)")
                    return
                }
                
                if placemarks!.count > 0 {
                    let placemark = placemarks![0] 
                    self.locationManager.stopUpdatingLocation()
                    let postalCode = (placemark.postalCode != nil) ? placemark.postalCode : ""
                    print("Postal code updated to: \(postalCode)")
                    self.userZipcode = postalCode!
                }else{
                    print("No placemarks found.")
                }
            })
            
            print(coord.latitude)
            print(coord.longitude)
        }
    }
    
   
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

