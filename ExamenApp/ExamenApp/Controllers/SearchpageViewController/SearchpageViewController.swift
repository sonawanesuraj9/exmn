 //
//  SearchpageViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/2/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
 
 class searchByTableViewCell : UITableViewCell{
    
    @IBOutlet weak var lblTitleSearchBy: UILabel!
 }
 class SuggestionTableViewCell : UITableViewCell{    
    
    @IBOutlet weak var lblHint: UILabel!
    
 }

class SearchpageViewController: UIViewController, UITextFieldDelegate,FSCalendarDataSource,FSCalendarDelegate, UITableViewDataSource,UITableViewDelegate {

//TODO: - General
    
    @IBOutlet weak var containerView: UIView!
    let cust : CustomClass_Dev = CustomClass_Dev()
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    var returnKeyHandler : IQKeyboardReturnKeyHandler = IQKeyboardReturnKeyHandler()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var searchByArray : [String] = ["name","volunteer activity","nonprofit","examen post date"]
    
    var suggestionArray : [String] = []
    
    //Data for Calender
    var calenderView : UIView = UIView()
    var fcalendar : FSCalendar = FSCalendar()
    var isDateTypeSelected : Bool = Bool()
    var calenderDisplay : Bool = Bool()
    var searchType : String = String()
    // searchType >> 1 = Name; 2 = Volunteer; 3 = Charity
    
//TODO: - Controls
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var searchByView: UIView!
    @IBOutlet weak var tblSearchBy: UITableView!
    @IBOutlet weak var tblSuggestion: UITableView!
    @IBOutlet weak var searchSuggestion: UIView!
    @IBOutlet weak var contView: UIView!
   
    @IBOutlet weak var btnSearchOutlet: UIButton!
    @IBOutlet weak var txtSearchText: UITextField!
   // @IBOutlet weak var txtSearchBy: UITextField!
    @IBOutlet weak var btnSearchByOutlet: UIButton!
    
    
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //IQKeyboardReturnKeyHandler Method
        //returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        

        
        // Do any additional setup after loading the view.
        self.txtSearchText.delegate = self
        
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
         /*self.txtSearchBy.attributedPlaceholder = NSAttributedString(string:"Search by",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])*/
        
        self.txtSearchText.attributedPlaceholder = NSAttributedString(string:"search",
            attributes:[NSForegroundColorAttributeName: cust.placeholderTextColor])
        
        self.btnSearchOutlet.layer.cornerRadius = cust.RounderCornerRadious
        
        
       
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.delObj.isNewTimeUser = false
        
        self.blurView.hidden = true
        self.searchByView.hidden = true
        self.tblSearchBy.tableFooterView = UIView()
        
        
        self.tblSearchBy.delegate = self
        self.tblSearchBy.dataSource = self
        self.tblSuggestion.delegate = self
        self.txtSearchText.delegate = self
        self.txtSearchText.tintColor = cust.textTintColor
        self.tblSuggestion.dataSource = self
        self.searchSuggestion.hidden = true
        //check suggestions
        if(self.defaults.valueForKey("suggestionArray") != nil){
            self.suggestionArray = self.defaults.valueForKey("suggestionArray") as! [String]
        }
        self.tblSuggestion.reloadData()
        
        
        print("Search page")
        if(delObj.detailSelected){
            //Navigate from next to back
            
            isDateTypeSelected = false
            self.txtSearchText.text = self.delObj.searchString
            self.searchType = self.delObj.searchType
            
            print("***:\(self.searchType)")
            // Display SearchType Name
            if(self.searchType == "1"){
                self.btnSearchByOutlet.setTitle("name", forState: UIControlState.Normal)
                
            }else if(self.searchType == "2"){
                self.btnSearchByOutlet.setTitle("volunteer activity", forState: UIControlState.Normal)
                
            }else if(self.searchType == "3"){
                self.btnSearchByOutlet.setTitle("nonprofit", forState: UIControlState.Normal)
                
            }else if(self.searchType == "4"){
                self.btnSearchByOutlet.setTitle("examen post date", forState: UIControlState.Normal)
                
            }
            self.selectViewController(delObj.lastSelection)
            print(self.delObj.searchType)
            
        }else{
            //Normal Flow
            isDateTypeSelected = false
            self.fcalendar.removeFromSuperview()
            self.calenderView.removeFromSuperview()
            
            
            self.txtSearchText.text = ""
            self.delObj.searchType = "1"
            self.searchType = "1"
            self.selectViewController(0)
            self.btnSearchByOutlet.setTitle("name", forState: UIControlState.Normal)
            
            //Clear all table
            self.delObj.keepIDArray.removeAll(keepCapacity: false)
            self.delObj.keepLogoArray.removeAll(keepCapacity: false)
            self.delObj.keepNameArray.removeAll(keepCapacity: false)
            
            self.delObj.keepPostIDArray.removeAll(keepCapacity: false)
            self.delObj.keepPostDateArray.removeAll(keepCapacity: false)
            self.delObj.keepPostTextArray.removeAll(keepCapacity: false)
            self.delObj.keepPostImageArray.removeAll(keepCapacity: false)
            self.delObj.keepPostByNameArray.removeAll(keepCapacity: false)
            self.delObj.keepPostUserPhotoArray.removeAll(keepCapacity: false)
            
            print(self.delObj.searchType)
            
        }
     
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//TODO: - UITableViewDatasource Method implementation
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var returnCnt : Int = Int()
        if(tableView == tblSearchBy){
            returnCnt = searchByArray.count
        }else{
            if suggestionArray.count>=5{
                returnCnt =  5
            }else{
                returnCnt =  suggestionArray.count
            }
        }
        return returnCnt
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView == tblSearchBy){
            let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! searchByTableViewCell
            cell.lblTitleSearchBy.text = self.searchByArray[indexPath.row]
            return cell
        }else{
        
            let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! SuggestionTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.lblHint.text = suggestionArray[indexPath.row]
        return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print(indexPath.row)
        if(tableView == tblSearchBy){
            print(indexPath.row)
            print("searchBy:\(self.searchByArray[indexPath.row])")
            if(indexPath.row == 0){
                print("name selected")
                self.searchType = "1"
                self.delObj.searchType = "1"
                self.isDateTypeSelected = false
                self.btnSearchByOutlet.setTitle("name", forState: UIControlState.Normal)
                self.txtSearchText.text = ""
                
                if(self.calenderDisplay){
                    self.fcalendar.removeFromSuperview()
                    self.calenderView.removeFromSuperview()
                }
                
            }else if(indexPath.row == 1){
                print("Volunteer Activity selected")
                self.isDateTypeSelected = false
                self.searchType = "2"
                self.delObj.searchType = "2"
                self.btnSearchByOutlet.setTitle("volunteer activity", forState: UIControlState.Normal)
                self.txtSearchText.text = ""
                
                if(self.calenderDisplay){
                    self.fcalendar.removeFromSuperview()
                    self.calenderView.removeFromSuperview()
                }
            }else if(indexPath.row == 2){
                print("Charity selected")
                
                self.isDateTypeSelected = false
                self.searchType = "3"
                self.delObj.searchType = "3"
                self.btnSearchByOutlet.setTitle("nonprofit", forState: UIControlState.Normal)
                
                self.txtSearchText.text = ""
                
                if(self.calenderDisplay){
                    self.fcalendar.removeFromSuperview()
                    self.calenderView.removeFromSuperview()
                }
            }else if(indexPath.row == 3){
                print("Examen date selected")
                self.txtSearchText.text = ""
                self.searchType = "4"
                self.txtSearchText.resignFirstResponder()
                self.btnSearchByOutlet.setTitle("examen post date", forState: UIControlState.Normal)
                
                self.isDateTypeSelected = true
            }
            self.searchByView.hidden = true
            self.blurView.hidden = true
        }else{
            self.txtSearchText.text = self.suggestionArray[indexPath.row]
            self.searchSuggestion.hidden = true
        }
    }
    
    
    
//TODO: - UITextField Delegate Method
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        self.txtSearchText.resignFirstResponder()
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        var vals : Bool = Bool()
        
        if(textField == txtSearchText){
           self.tblSuggestion.reloadData()
            vals = false
            if(self.searchType == "1"){
                //Check if search suggestion has value, then display it
                if(self.suggestionArray.count>0){
                    self.searchSuggestion.hidden = false
                }else{
                    self.searchSuggestion.hidden = true
                }
            }else{
                self.searchSuggestion.hidden = true
                
            }
           // print("searchType:\(searchType)")
        }else{
            self.searchSuggestion.hidden = true
        }
       /* if(textField == txtSearchBy){
            
            let searchbyAlert = UIAlertController(title: "Select search method", message: "Search type", preferredStyle: UIAlertControllerStyle.Alert)
            
            searchbyAlert.addAction(UIAlertAction(title: "Name", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
                print("name selected")
                self.searchType = "Name"
                 self.isDateTypeSelected = false
                self.txtSearchBy.text = "Name"
                self.txtSearchText.text = ""
               
                if(self.calenderDisplay){
                    self.fcalendar.removeFromSuperview()
                    self.calenderView.removeFromSuperview()
                }
                
            }))
            
            
            searchbyAlert.addAction(UIAlertAction(title: "Volunteer Activity", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
                print("Volunteer Activity selected")
                 self.isDateTypeSelected = false
                 self.searchType = "Volunteer"
                self.txtSearchBy.text = "Volunteer Activity"
                self.txtSearchText.text = ""
                
                if(self.calenderDisplay){
                    self.fcalendar.removeFromSuperview()
                    self.calenderView.removeFromSuperview()
                }
                
            }))
            
            
            searchbyAlert.addAction(UIAlertAction(title: "Charity", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
                print("Charity selected")
               
                self.isDateTypeSelected = false
                 self.searchType = "Charity"
                self.txtSearchBy.text = "Charity"
                self.txtSearchText.text = ""
               
                if(self.calenderDisplay){
                    self.fcalendar.removeFromSuperview()
                    self.calenderView.removeFromSuperview()
                }
                
            }))
            
            
            searchbyAlert.addAction(UIAlertAction(title: "Examen date", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
                print("Examen date selected")
                self.txtSearchText.text = ""
                self.txtSearchText.resignFirstResponder()
                self.txtSearchBy.text = "Examen date"
                self.isDateTypeSelected = true
              // self.createDynamicCalender()
                
            }))
            
            searchbyAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(searchbyAlert, animated: true, completion: nil)
            
            vals = false
           
        }else*/
        if(textField == txtSearchText){
            if(self.isDateTypeSelected){
                if(!self.calenderDisplay){
                    
                   createDynamicCalender()
                    vals = false
                }else{
                    self.fcalendar.removeFromSuperview()
                    self.calenderView.removeFromSuperview()
                    createDynamicCalender()
                    vals = false
                }
             
                
            }else{
                vals = true
            }
        }
        
        
        return vals
    }
    
//TODO: - FSCalendarDataSource Methods
    
    func createDynamicCalender(){
        self.calenderView.frame = self.contView.frame
        self.calenderView.backgroundColor = UIColor.whiteColor()
        self.containerView.addSubview(self.calenderView)
        calenderDisplay = true
        fcalendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.contView.frame.size.width, height: self.contView.frame.size.height))
        fcalendar.dataSource = self
        fcalendar.delegate = self
        fcalendar.reloadData()
        self.calenderView.addSubview(fcalendar)
    }
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        NSLog("change page to \(calendar.stringFromDate(calendar.currentPage))")
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        let dateFromString = calendar.stringFromDate(date)
        print("Date from String: \(dateFromString)")
        self.txtSearchText.text = dateFromString
        self.fcalendar.removeFromSuperview()
        self.calenderView.removeFromSuperview()
        
    }
    
    
//TODO: - UIButton Action
    func selectViewController(segVal : Int){
        
        var viewControllerIdentifier = ["idSearchByNameViewController","idSearchByDateViewController"]
        var seg = segVal
        if(seg == 0){
            //seg = 0
            // println(seg2.selectedIndex)
            
           // if(self.txtSearchText.text != ""){
                
                let searchByNm : SearchByNameViewController = SearchByNameViewController()
                searchByNm.searchType =  self.searchType
            print("---\(self.searchType)")
                // self.delObj.searchType  = self.searchType
                searchByNm.searchString = self.txtSearchText.text!
                self.delObj.searchString = self.txtSearchText.text!
                self.delObj.lastSelection = 0
                print(self.txtSearchText.text)
                
                let newController = self.storyboard!.instantiateViewControllerWithIdentifier(viewControllerIdentifier[seg])
                
                let oldController = childViewControllers.last!
                newController.view.frame = oldController.view.frame
                oldController.willMoveToParentViewController(nil)
                addChildViewController(newController)
                
                transitionFromViewController(oldController, toViewController: newController, duration: 0.25, options: .TransitionCrossDissolve, animations:{ () -> Void in
                    // nothing needed here
                    }, completion: { (finished) -> Void in
                        oldController.removeFromParentViewController()
                        newController.didMoveToParentViewController(self)
                })
                
            //}else{
            //    self.delObj.displayMessage("Examen", messageText: "Enter search text")
           // }
            
        }else{
            seg = 1
            // println(seg2.selectedIndex)
            if(self.txtSearchText.text != ""){
                
                let newController = self.storyboard!.instantiateViewControllerWithIdentifier(viewControllerIdentifier[seg])
                
                self.delObj.searchString = self.txtSearchText.text!
                self.delObj.lastSelection = 1
                self.delObj.searchType = "4"
                let oldController = childViewControllers.last!
                newController.view.frame = oldController.view.frame
                oldController.willMoveToParentViewController(nil)
                addChildViewController(newController)
                
                transitionFromViewController(oldController, toViewController: newController, duration: 0.25, options: .TransitionCrossDissolve, animations:{ () -> Void in
                    // nothing needed here
                    }, completion: { (finished) -> Void in
                        oldController.removeFromParentViewController()
                        newController.didMoveToParentViewController(self)
                })
                self.txtSearchText.resignFirstResponder()
                
            }else{
                self.delObj.displayMessage("Examen", messageText: "select date")
            }
        }
    }
    
    @IBAction func btnSearchClick(sender: AnyObject) {
        print(self.searchType)
        self.txtSearchText.resignFirstResponder()
        if(self.searchType == "1" || self.searchType == "2" || self.searchType == "3"){
            print("suggestionArray.count:\(suggestionArray.count)")
            if(suggestionArray.count>0){
            for i in 0...suggestionArray.count-1{
                if(self.suggestionArray[i] == self.txtSearchText.text){
                    //if(i != 0){
                        self.suggestionArray.removeAtIndex(i)
                        self.suggestionArray.insert(self.txtSearchText.text!, atIndex: 0)
                    //}
                    
                    break
                }else{
                    if(i == self.suggestionArray.count-1){
                        self.suggestionArray.insert(self.txtSearchText.text!, atIndex: 0)
                        break
                    }
                }
            }
            }else{
                self.suggestionArray.insert(self.txtSearchText.text!, atIndex: 0)
                
                
            }
           // self.suggestionArray.insert(self.txtSearchText.text!, atIndex: 0)
            print(self.suggestionArray)
            self.defaults.setValue(self.suggestionArray, forKey: "suggestionArray")
            self.searchSuggestion.hidden = true
            self.selectViewController(0)
        }else if(searchType == "4"){
             self.searchSuggestion.hidden = true
            self.selectViewController(1)
        }
        
    }
    
    @IBAction func btnAddPostClick(sender: AnyObject) {
        let addPostVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAddPostViewController") as! AddPostViewController
        self.navigationController?.pushViewController(addPostVC, animated: true)
    }
    
    @IBAction func btnSearchByCloseClick(sender: AnyObject) {
        self.searchByView.hidden = true
        self.blurView.hidden = true
    }
    @IBAction func btnSearchByClick(sender: AnyObject) {
        self.searchSuggestion.hidden = true
        self.searchByView.hidden = false
        self.blurView.hidden = false
        self.tblSearchBy.reloadData()
        /*let searchbyAlert = UIAlertController(title: "select search method", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        searchbyAlert.addAction(UIAlertAction(title: "name", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("name selected")
            self.searchType = "1"
            self.delObj.searchType = "1"
            self.isDateTypeSelected = false
            self.btnSearchByOutlet.setTitle("name", forState: UIControlState.Normal)
            self.txtSearchText.text = ""
            
            if(self.calenderDisplay){
                self.fcalendar.removeFromSuperview()
                self.calenderView.removeFromSuperview()
            }
            
        }))
        
        
        searchbyAlert.addAction(UIAlertAction(title: "volunteer activity", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("Volunteer Activity selected")
            self.isDateTypeSelected = false
            self.searchType = "2"
            self.delObj.searchType = "2"
            self.btnSearchByOutlet.setTitle("volunteer activity", forState: UIControlState.Normal)
            self.txtSearchText.text = ""
            
            if(self.calenderDisplay){
                self.fcalendar.removeFromSuperview()
                self.calenderView.removeFromSuperview()
            }
            
        }))
        
        
        searchbyAlert.addAction(UIAlertAction(title: "charity", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("Charity selected")
            
            self.isDateTypeSelected = false
            self.searchType = "3"
            self.delObj.searchType = "3"
             self.btnSearchByOutlet.setTitle("charity", forState: UIControlState.Normal)
            
            self.txtSearchText.text = ""
            
            if(self.calenderDisplay){
                self.fcalendar.removeFromSuperview()
                self.calenderView.removeFromSuperview()
            }
            
        }))
        
        
        searchbyAlert.addAction(UIAlertAction(title: "examen date", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            print("Examen date selected")
            self.txtSearchText.text = ""
             self.searchType = "4"
            self.txtSearchText.resignFirstResponder()
           self.btnSearchByOutlet.setTitle("examen date", forState: UIControlState.Normal)
            
            self.isDateTypeSelected = true
            // self.createDynamicCalender()
            
        }))
        
        searchbyAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(searchbyAlert, animated: true, completion: nil)*/
        
    }
    func DisplayNameClick(sender:UIButton){
        print(sender.tag)
    }
}
