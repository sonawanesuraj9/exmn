//
//  TwitterServiceWrapper.swift
//  ExamenApp
//
//  Created by Suraj MAC3 on 22/03/17.
//  Copyright © 2017 supaint. All rights reserved.
//

import UIKit

protocol TwitterFollowerDelegate{
    func finishedDownloading(follower:TwitterFollower)
}


/// Taking Help from following lInks:
//http://rshankar.com/retrieve-list-of-twitter-followers-using-swift/
//https://github.com/rshankras/SwiftDemo/tree/master/SwiftDemo

/*
public class TwitterServiceWrapper: NSObject {
    let consumerKey = ""
    let consumerSecret = ""
    let authURL = "https://api.twitter.com/oauth2/token"
    
    
    var delegate:TwitterFollowerDelegate?
   
    
    // MARK:- Bearer Token
    
    func getBearerToken(completion:(bearerToken: String) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: authURL)!)
        request.HTTPMethod = "POST"
        request.addValue("Basic " + getBase64EncodeString(), forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField:     "Content-Type")
        var grantType = "grant_type=client_credentials"
        request.HTTPBody = grantType.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:  true)
        
            
        NSURLSession.sharedSession() .dataTaskWithRequest(request, completionHandler: { (data: NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            
            var errorPointer : NSErrorPointer = nil
            
            if let results: NSDictionary = NSJSONSerialization .JSONObjectWithData(data!, options:   NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                
                if let token = results["access_token"] as? String {
                    completion(bearerToken: token)
                } else {
                    print(results["errors"])
                }
            }
            
        }).resume()
    }
    
    // MARK:- base64Encode String
    
    func getBase64EncodeString() -> String {
    
        let consumerKeyRFC1738 =   consumerKey.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
    
        let consumerSecretRFC1738 = consumerSecret.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
    
        let concatenateKeyAndSecret = consumerKeyRFC1738! + ":" + consumerSecretRFC1738!
    
        let secretAndKeyData = concatenateKeyAndSecret.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
    
        let base64EncodeKeyAndSecret =  secretAndKeyData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
    
        return base64EncodeKeyAndSecret!
    }

    
    
    // MARK:- Service Call
    
    func getResponseForRequest(url:String) {
        var results:NSDictionary
        getBearerToken({ (bearerToken) ->  Void in
            var request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "GET"
            let token = "Bearer " + bearerToken
            request.addValue(token, forHTTPHeaderField: "Authorization")
            
            NSURLSession.sharedSession() .dataTaskWithRequest(request, completionHandler: { (data:  NSData?, response:NSURLResponse?, error: NSError?) -> Void in
                
                self.processResult(data, response: response, error: error)
            }).resume()
        })
    }
    
    // MARK:- Process results
    func processResult(data: NSData, response:NSURLResponse, error: NSError?) {
        
        var errorPointer : NSErrorPointer = nil
        
        if let results: NSDictionary = NSJSONSerialization .JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments  , error: errorPointer) as? NSDictionary {
            
            if var users = results["users"] as? NSMutableArray {
                for user in users {
                    let follower = TwitterFollower(name: user["name"] as! String, url: user["profile_image_url"] as! String)
                    self.delegate?.finishedDownloading(follower)
                }
                
            } else {
                println(results["errors"])
            }
        }
    }


}
*/