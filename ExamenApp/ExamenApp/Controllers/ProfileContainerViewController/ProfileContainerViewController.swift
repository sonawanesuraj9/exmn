//
//  ProfileContainerViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 6/28/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit

class ProfileContainerViewController: UIViewController {

//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()    
    @IBOutlet weak var mainContainerView: UIView!
    
//TODO: - Controls
    
    
//TODO: - Let's Play
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if(self.delObj.is_loginUserBusiness){
            let newController = self.storyboard!.instantiateViewControllerWithIdentifier("idBusinessProfileViewController") as! BusinessProfileViewController
             
             let oldController = childViewControllers.last!
             newController.view.frame = oldController.view.frame
             oldController.willMoveToParentViewController(nil)
             addChildViewController(newController)
             
             transitionFromViewController(oldController, toViewController: newController, duration: 0.05, options: .TransitionCrossDissolve, animations:{ () -> Void in
             // nothing needed here
             }, completion: { (finished) -> Void in
             oldController.removeFromParentViewController()
             newController.didMoveToParentViewController(self)
             })
        }else{
            let newController = self.storyboard!.instantiateViewControllerWithIdentifier("idProfilepageViewController") as! ProfilepageViewController
             
             let oldController = childViewControllers.last!
             newController.view.frame = oldController.view.frame
             oldController.willMoveToParentViewController(nil)
             addChildViewController(newController)
             
             transitionFromViewController(oldController, toViewController: newController, duration: 0.05, options: .TransitionCrossDissolve, animations:{ () -> Void in
             // nothing needed here
             }, completion: { (finished) -> Void in
             oldController.removeFromParentViewController()
             newController.didMoveToParentViewController(self)
             })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
