//
//  TwitterFollower.swift
//  ExamenApp
//
//  Created by Suraj MAC3 on 22/03/17.
//  Copyright © 2017 supaint. All rights reserved.
//

import Foundation


struct TwitterFollower {
    var name: String?
    var description: String?
    var profileURL: String?
    
    init (name: String, url: String) {
        
        self.name = name
        let pictureURL = NSURL(string: url)
        profileURL = url //NSData(contentsOfURL: pictureURL!)
        
    }
}