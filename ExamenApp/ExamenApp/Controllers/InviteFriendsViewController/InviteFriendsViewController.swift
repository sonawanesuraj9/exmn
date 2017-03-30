//
//  InviteFriendsViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/7/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Contacts
import Alamofire

class InviteFriendsTableViewCell: UITableViewCell{
    
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtEmailID: UITextField!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
}

class InviteFriendsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate {

    
//TODO: - General
    let cust: CustomClass_Dev = CustomClass_Dev()
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var emailArray : [String] = [""]
    //0 >> select all active , 1 >> deleselct all active
    var selectButtonValue : Int = Int()
    //0 for uncheck, 1 for check
    var nameArray : [String] = [""]
    var checkArray : [String] = [""]
    var is_emailEnter : Bool = Bool()
    var tmpEmail : String = String()
//TODO: - Controls
    
    @IBOutlet weak var btnSelectAllOutlet: UIButton!
    @IBOutlet weak var lblEmailCounter: UILabel!
    @IBOutlet weak var tblEmailID: UITableView!
    @IBOutlet weak var btnInviteFriend: UIButton!
    //@IBOutlet weak var txtEmailID: UITextField!
    
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblEmailID.delegate = self
        self.tblEmailID.dataSource = self
        
        // Do any additional setup after loading the view.
        
        
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
        tblEmailID.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //self.emailArray.removeAll(keepCapacity: false)
        let count = self.countOfValue()
        self.btnSelectAllOutlet.hidden = true
        self.btnSelectAllOutlet.setTitle("", forState: .Normal)
        self.lblEmailCounter.text = "\(count) friend(s) added."
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
     
        self.btnInviteFriend.layer.cornerRadius = cust.RounderCornerRadious
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - UITableViewDatasource Method Implementation
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("emailArray.count:\(emailArray.count)")
        print("checkArray:\(checkArray.count)")
        return emailArray.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! InviteFriendsTableViewCell
        print(indexPath.row)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.txtEmailID.delegate = self
        cell.txtEmailID.tintColor = self.cust.textTintColor
        cell.txtEmailID.text = self.nameArray[indexPath.row]//self.emailArray[indexPath.row]
        
        
        
        
        
        cell.btnAdd.tag = indexPath.row
         if(self.emailArray[indexPath.row] == ""){
            cell.txtEmailID.attributedPlaceholder = NSAttributedString(string:"email address",
                                                                       attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
            cell.btnRemove.hidden = true
         }else{
            cell.btnRemove.hidden = false
         }
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(InviteFriendsViewController.btnAddClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        if(self.checkArray[indexPath.row] == "1"){
            cell.btnRemove.setImage(UIImage(named: "check_icon"), forState: .Normal)

        }else{
            cell.btnRemove.setImage(UIImage(named: "uncheck_icon"), forState: .Normal)

        }
        
        
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(InviteFriendsViewController.btnRemoveClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        if(indexPath.row == (emailArray.count-1)){
             cell.btnAdd.hidden = false
        }else{
            cell.btnAdd.hidden = true
        }
       print("indexPath.row:\(indexPath.row)")
        return cell
    }
    
//TODO: - UITextField Delegate method
    

    
//TODO: - Function
    /**
     Change select all / deselect all button title
     
     - parameter value: value: if 0 >> select All, if 1 >> Deselect all
     */
    func updateButtonTitle(){
        
        let val = self.countOfValue()
        print("val:\(val)")
            if val > 0{
                self.btnSelectAllOutlet.setTitle("Deselect All", forState: .Normal)
                selectButtonValue = 1
            }else{
                self.btnSelectAllOutlet.setTitle("Select All", forState: .Normal)
                selectButtonValue = 0
            }
        
    }
    
    @IBAction func btnRemoveClick(sender:AnyObject){
        print("tag:\(sender.tag)")
        let index = sender.tag
        if(self.emailArray[index] != ""){
            if(self.checkArray[index] == "0"){
                self.checkArray[index] = "1"
            }else{
                self.checkArray[index] = "0"
            }
            
            //self.emailArray.removeAtIndex(index)
        }
            print("emailArray after :\(emailArray)")
        let count = self.countOfValue()
        if(self.emailArray.count == 0){
            self.btnSelectAllOutlet.hidden = true
          //  self.btnSelectAllOutlet.setTitle("Select All", forState: .Normal)
        }else{
            self.btnSelectAllOutlet.hidden = false
          //  self.btnSelectAllOutlet.setTitle("Deselect All", forState: .Normal)
        }
        self.updateButtonTitle()
        self.lblEmailCounter.text = "\(count) friend(s) added."
        self.tblEmailID.reloadData()
        
    }
    
    @IBAction func btnAddClick(sender:AnyObject){
        print("tag:\(sender.tag)")
        let index = sender.tag
        print("add index :\(index)")
        
        let tmpIndex : NSIndexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let cell = self.tblEmailID.cellForRowAtIndexPath(tmpIndex) as! InviteFriendsTableViewCell
        let emailString = cell.txtEmailID.text
        
        if(emailString != ""){
            if(self.cust.isValidEmail(emailString!)){
                self.emailArray.insert(emailString!, atIndex: index)
                self.nameArray.insert(emailString!, atIndex: index)
                self.checkArray.insert("1", atIndex: index)
            }
           // self.emailArray.append("")
           
        }else{
           /* if(index != 0){
                self.emailArray.removeAtIndex(index)
                self.emailArray.append("")
               
            }*/
        }
        let count = self.countOfValue()
        if(self.emailArray.count == 0){
            self.btnSelectAllOutlet.hidden = true
           // self.btnSelectAllOutlet.setTitle("Select All", forState: .Normal)
        }else{
            self.btnSelectAllOutlet.hidden = false
            //self.btnSelectAllOutlet.setTitle("Deselect All", forState: .Normal)
        }
        self.updateButtonTitle()
        self.lblEmailCounter.text = "\(count) friend(s) added."
         self.tblEmailID.reloadData()
        
    }
    
    
    func countOfValue() -> Int{
        var checkCounter : Int = 0
        for ind in 0...self.checkArray.count-1{
            if(self.checkArray[ind]=="1" && self.emailArray[ind] != ""){
                checkCounter = checkCounter + 1
            }
        }
        return checkCounter
    }
    
//TODO: - Contact fetch from device
    
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
            let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactMiddleNameKey, CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNSocialProfileServiceGameCenter, CNContactFormatter.descriptorForRequiredKeysForStyle(.PhoneticFullName)])
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
            for contact in contacts {
                 if(contact.emailAddresses.first?.value as? String != nil){
                    
                   // let emailVal = contact.emailAddresses.first!.value as? String
                   // print(emailVal)
                    let emailVal1 = contact.emailAddresses.count
                    
                    for em in 0...emailVal1-1{
                        print("\(em): \(contact.emailAddresses[em].value as? String)")
                        let finalEmail = contact.emailAddresses[em].value as? String
                        self.emailArray.append(finalEmail!)
                        self.nameArray.append(contact.givenName + " " + contact.familyName)
                        self.checkArray.append("1")
                    }
                    print("**\(emailVal1)")
                    //self.emailArray.append(emailVal!)
                     print("emailArray-inner:\(self.emailArray)")
                }
            }
           dispatch_async(dispatch_get_main_queue(), {
                // code here
            self.checkArray.append("0")
            self.emailArray.append("")
            self.nameArray.append("")
            print("emailArray:\(self.nameArray)")
            print("emailArray:\(self.emailArray)")
            let checkCount = self.countOfValue()
            if(self.emailArray.count == 0){
                self.btnSelectAllOutlet.hidden = true
               // self.btnSelectAllOutlet.setTitle("Select All", forState: .Normal)
            }else{
                self.btnSelectAllOutlet.hidden = false
                //self.btnSelectAllOutlet.setTitle("Deselect All", forState: .Normal)
            }
            self.updateButtonTitle()
            self.lblEmailCounter.text = "\(checkCount) friend(s) added."
                self.tblEmailID.reloadData()
            })
            
        }
       
    }
    
//TODO: - Web service / API implementation
    
    func sendInvitation(){
        print("self.emailArray:\(self.emailArray)")
        let checkCount = self.countOfValue()
           self.lblEmailCounter.text = "\(checkCount) friend(s) added."
        if(checkCount > 0){
             SVProgressHUD.showWithStatus("Loading...")
        var sendList :[String] = []
        for ind in 0...self.checkArray.count-1{
            if(self.checkArray[ind] == "1"){
                sendList.append(self.emailArray[ind])
            }
        }
        
        
        /*for ind in 0...self.emailArray.count-1{
            if(self.emailArray[ind] != ""){
                sendList.append(self.emailArray[ind])
            }
        }*/
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
    
    @IBAction func btnSelectAllClick(sender: AnyObject) {
        var count : Int = Int()
        if selectButtonValue == 0{
            if(self.checkArray.count == self.emailArray.count){
                for ind in 0...self.checkArray.count-1{
                    self.checkArray[ind] = "1"
                }
                count = self.countOfValue()
                if(self.emailArray.count == 0){
                    self.btnSelectAllOutlet.hidden = true
                }else{
                    self.btnSelectAllOutlet.hidden = false
                }
             }
        }else if selectButtonValue == 1{
            if(self.checkArray.count == self.emailArray.count){
                for ind in 0...self.checkArray.count-1{
                    self.checkArray[ind] = "0"
                }
                count = self.countOfValue()
                if(self.emailArray.count == 0){
                    self.btnSelectAllOutlet.hidden = true
                }else{
                    self.btnSelectAllOutlet.hidden = false
                }
            }
        }
       
            
            
            
        self.updateButtonTitle()
        self.lblEmailCounter.text = "\(count) friend(s) added."
        self.tblEmailID.reloadData()
        
    }
    
    
    
    @IBAction func btnInviteFriendClick(sender: AnyObject) {
        self.sendInvitation()
        
    }
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
