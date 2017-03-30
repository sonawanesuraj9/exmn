//
//  LauchScreenViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC3 on 06/08/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit




class LauchScreenViewController: UIViewController {

    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    let imageNameArray : [String] = ["","","","","",""]
    
//TODO: - Controls
    
    @IBOutlet weak var imgLauch: UIImageView!
    
    
//TODO: - Let's Play
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
