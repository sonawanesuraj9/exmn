//
//  ContainerViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/2/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit

class ContainerViewController: UITabBarController {

    @IBOutlet weak var TabBarOutlet: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Uncomment Below for more formatting
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))], forState: UIControlState.Normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: CGFloat(0.54), green: CGFloat(0.24), blue: CGFloat(0), alpha: CGFloat(1))], forState: UIControlState.Selected)
        
      //  let selecteditem = TabBarOutlet!.selectedItem
        
        if(TabBarOutlet!.selectedItem == "More page" ){
            displayActionSheet()
        }
        print(selectedIndex)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if(TabBarOutlet!.selectedItem == "More page" ){
        displayActionSheet()
        
        }
        
    }

    
    func displayActionSheet(){
        //Let's Open Action Sheet
        
        let alert = UIAlertController(title: "Let's Choose Option", message: "Here are more options for you", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Share with friends", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            //share with friends
        }))
        alert.addAction(UIAlertAction(title: "Privacy Policy", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            //Privacy Policy
        }))
        alert.addAction(UIAlertAction(title: "Terms of Service", style: UIAlertActionStyle.Default, handler: { (value:UIAlertAction) -> Void in
            //Terms of service
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
