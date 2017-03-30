//
//  AddNonProfitTableViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/26/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit
import Alamofire

class AddNonProfitTableViewCell : UITableViewCell{

//TODO: - Controls
    
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCharityName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
     @IBOutlet weak var lblWebsite: UILabel!
    //@IBOutlet weak var imgProfile: UIImageView!
}



class AddNonProfitTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    
    
//TODO: - General
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    
//TODO: - Controls
    
    @IBOutlet weak var btnAddNewOutlet: UIButton!
    @IBOutlet weak var tblMain: UITableView!
    
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblMain.delegate = self
        self.tblMain.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       self.btnAddNewOutlet.layer.cornerRadius = self.cust.RounderCornerRadious
        self.tblMain.reloadData()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
//TODO: - UITableViewDatasource Method Implementation
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("self.delObj.selectedCompanyArray_nonprofit.count:\(self.delObj.selectedWebsiteArray_nonprofit.count)")
        return self.delObj.selectedCompanyArray_nonprofit.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! AddNonProfitTableViewCell
       
        
        cell.lblCharityName.text = self.delObj.selectedCompanyArray_nonprofit[indexPath.row]
        cell.lblTitle.text = self.delObj.selectedTitleArray_nonprofit[indexPath.row]
        cell.lblWebsite.text = self.delObj.selectedWebsiteArray_nonprofit[indexPath.row]
        if(self.delObj.selectedIsPresentArray_nonprofit[indexPath.row] == "Y"){
            cell.lblDate.text = self.delObj.selectedStartDateArray_nonprofit[indexPath.row] + " - " + "Present"
        }else{
             cell.lblDate.text = self.delObj.selectedStartDateArray_nonprofit[indexPath.row] + " - " + self.delObj.selectedEndDateArray_nonprofit[indexPath.row]
        
        }
        
        cell.btnRemove.tag = indexPath.row
        //cell.btnRemove.hidden = true
        cell.btnRemove.addTarget(self, action: #selector(AddNonProfitTableViewController.btnRemoveClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return cell
    }
    
    @IBAction func btnRemoveClick(sender:AnyObject){
        print(sender.tag)
        let tmpIndex = sender.tag
        
        if(self.delObj.is_editResume){
            
            //Add Confirmation alert before performing delete
            let confAlert = UIAlertController(title: "examen", message: "Do you want to remove?", preferredStyle: .Alert)
            confAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (value:UIAlertAction) in
                //
                self.removeNonProfit(tmpIndex)
            }))
            
            confAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            self.presentViewController(confAlert, animated: true, completion: nil)
            
            
        }else{
            //sgnup scenario
            //Add Confirmation alert before performing delete
            let confAlert = UIAlertController(title: "examen", message: "Do you want to remove?", preferredStyle: .Alert)
            confAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (value:UIAlertAction) in
                //
                self.delObj.selectedWebsiteArray_nonprofit.removeAtIndex(tmpIndex)
                self.delObj.selectedTitleArray_nonprofit.removeAtIndex(tmpIndex)
                self.delObj.selectedCompanyArray_nonprofit.removeAtIndex(tmpIndex)
                self.delObj.selectedStartDateArray_nonprofit.removeAtIndex(tmpIndex)
                self.delObj.selectedEndDateArray_nonprofit.removeAtIndex(tmpIndex)
                self.delObj.selectedIsPresentArray_nonprofit.removeAtIndex(tmpIndex)
                self.tblMain.reloadData()
            }))
            
            confAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            self.presentViewController(confAlert, animated: true, completion: nil)
            
            
            
            
        }
        
    }
    
    
//TODO: - Web service / API implememtation
    
    
    func clearNonProfitResumeArray(){
        self.delObj.selectedIsPresentArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedEndDateArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedStartDateArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedTitleArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedWebsiteArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedCompanyArray_nonprofit.removeAll(keepCapacity: false)
        self.delObj.selectedIDArray_nonprofit.removeAll(keepCapacity: false)
       
    }
    
    
    
    func removeNonProfit(indx : Int){
        
        let id = self.delObj.selectedIDArray_nonprofit[indx]
        let param : [String : AnyObject] = ["userid":self.delObj.loginUserID,
                                            "vol_id":id,
                                            ]
        SVProgressHUD.showWithStatus("loading...")
        
        
        
        Alamofire.request(.POST, self.delObj.baseUrl + "deletevolun", parameters: param).responseJSON{
            response in
            
            print("output\(response.result.value)")
            
            if(response.result.isSuccess){
                SVProgressHUD.dismiss()
                let outJSON = JSON(response.result.value!)
                if(outJSON["status"] != "1"){
                    let count = outJSON["data"]["volunteer_activity"].array?.count
                    self.clearNonProfitResumeArray()
                    if(count != 0){
                        
                        if let ct = count{
                            for index in 0...ct-1{
                                
                                self.delObj.selectedCompanyArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["company_name"].stringValue)
                                self.delObj.selectedIDArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["id"].stringValue)
                                self.delObj.selectedTitleArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["role"].stringValue)
                                self.delObj.selectedWebsiteArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["website"].stringValue)
                                self.delObj.selectedStartDateArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["start_date"].stringValue)
                                self.delObj.selectedEndDateArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["end_date"].stringValue)
                                self.delObj.selectedIsPresentArray_nonprofit.append(outJSON["data"]["volunteer_activity"][index]["is_present"].stringValue)
                             //   self.delObj.selectedLogoImageTmp_nonprofit.removeAtIndex(indx)
                            //self.delObj.selectedLogoImageTmp_nonprofit.insert(UIImage(named: "")!, atIndex: indx)
                                
                            }//end for loop
                            
                            print("vol_company_name: \(self.delObj.selectedCompanyArray_nonprofit)")
                           
                         
                        }
                    }
                    self.tblMain.reloadData()
                    
                }else{
                    self.delObj.displayMessage("examen", messageText: outJSON["msg"].stringValue)
                }
                
            }else{
                //Responce failure
                 self.delObj.displayMessage("examen", messageText: "Newtwork Error")
                SVProgressHUD.dismiss()
                print("Newtwork Error")
            }
        }
    }
    
    
//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnAddNewClick(sender: AnyObject) {
         let addVC = self.storyboard?.instantiateViewControllerWithIdentifier("idAddNonProfitResumeViewController") as! AddNonProfitResumeViewController
        self.presentViewController(addVC, animated: true, completion: nil)
       // self.navigationController?.pushViewController(addVC, animated: true)
    }

}
