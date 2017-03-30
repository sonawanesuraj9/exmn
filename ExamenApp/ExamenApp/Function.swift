//
//  Function.swift
//  ExamenApp
//
//  Created by Suraj MAC3 on 24/11/16.
//  Copyright © 2016 supaint. All rights reserved.
//

import Foundation
import UIKit


class randomString{
    class func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
}


class randValue{
    class func randomAlphanumericString(length: Int) -> String {
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters
        let lettersLength = UInt32(letters.count)
        
        let randomCharacters = (0..<length).map { i -> String in
            let offset = Int(arc4random_uniform(lettersLength))
            let c = letters[letters.startIndex.advancedBy(offset)]
            return String(c)
        }
        
        return randomCharacters.joinWithSeparator("")
    }
}