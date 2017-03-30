//
//  PrivacyPolicyViewController.swift
//  ExamenApp
//
//  Created by Suraj MAC2 on 5/7/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController,UIWebViewDelegate {

    
    
//TODO: - General
    
    let delObj = UIApplication.sharedApplication().delegate as! AppDelegate
    let cust : CustomClass_Dev = CustomClass_Dev()
    
    var url : String =  String()
    var urlToLoad : NSURL = NSURL()
    
    
//TODO: - Controls
    @IBOutlet weak var webView: UIWebView!
    
    
//TODO: - Let's Play
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        url = self.delObj.baseUrl_static + "privacy.html"
        urlToLoad = NSURL(string: url)!
        let theRequestUrl = NSURLRequest(URL: urlToLoad)
        webView.loadRequest(theRequestUrl)

        self.webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    
    
//TODO: - UIWebViewDelegate Method Implementation
    func webViewDidStartLoad(webView: UIWebView){
        SVProgressHUD.showWithStatus("Loading...")
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        SVProgressHUD.dismiss()
    }
    

//TODO: - UIButton Action
    
    @IBAction func btnBackClick(sender: AnyObject) {
        SVProgressHUD.dismiss()
        self.navigationController?.popViewControllerAnimated(true)
    }
}
