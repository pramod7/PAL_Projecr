//  PALDictionary.swift
//  PAL
//
//  Created by i-Phone on 23/04/21.
//  Copyright © 2021 i-Phone. All rights reserved.
//

import Foundation
import CoreGraphics

extension Dictionary where Key == String{
    
    func getDoubleValue(key: String) -> Double{
        
        if let any: Any = self[key] as Any?{
            if let number = any as? NSNumber{
                return number.doubleValue
            }else if let str = any as? NSString{
                return str.doubleValue
            }
        }
        return -1
    }
    
    func getIntValue(key: String) -> Int{
        
        if let any: Any = self[key] as Any?{
            if let number = any as? NSNumber{
                return number.intValue
            }else if let str = any as? NSString{
                return str.integerValue
            }
        }
        return -1
    }
    
    
    func getStringValue(key: String) -> String{
        
        if let any: Any = self[key] as Any?{
            if let number = any as? NSNumber{
                return number.stringValue
            }else if let str = any as? String{
                return str
            }
        }
        return ""
    }
    
    func getBooleanValue(key: String) -> Bool {
        
        if let any: Any = self[key] as Any?{
            if let num = any as? NSNumber {
                return num.boolValue
            } else if let str = any as? NSString {
                return str.boolValue
            }
        }
        return false
    }
    
    func getStringArrayValue(key: String) -> [String]{
        
        if let any: Any = self[key] as Any?{
            if let ary = any as? [String] {
                return ary
            }
        }
        return []
    }
    
    func getStringDictionaryValue(key : String) -> NSDictionary {
        if let any: Any = self[key] as Any?{
            if let ary = any as? NSDictionary {
                return ary
            }
        }
        return [:]
    }
    
    func getArrayValue(key : String) -> NSMutableArray {
        if let any: Any = self[key] as Any?{
            if let ary = any as? NSMutableArray {
                return ary
            }
        }
        return []
    }
    
}
//MARK:- -------- NSDictionary
extension NSDictionary {
    
    func convertToString() -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        //        if jsonData  == nil{
        //            return "{}"
        //        }else {
        return String(data: jsonData as Data, encoding: String.Encoding.utf8)!
        //        }
    }
    
    func object_forKeyWithValidationForClass_Int(aKey: String) -> Int {
        
        // CHECK FOR EMPTY
        if(self.allKeys.count == 0) {
            return Int()
        }
        
        // CHECK IF KEY EXIST
        if let val = self.object(forKey: aKey) {
            if((val as AnyObject).isEqual(NSNull())) {
                return Int()
            }
        } else {
            // KEY NOT FOUND
            return Int()
        }
        
        // CHECK FOR NIL VALUE
        let aValue : AnyObject = self.object(forKey: aKey)! as AnyObject
        if aValue.isEqual(NSNull()) {
            return Int()
        }
        else if(aValue.isKind(of: NSString.self)){
            return Int((aValue as! NSString).intValue)
        }
        else {
            
            if aValue is Int {
                return self.object(forKey: aKey) as! Int
            }
            else{
                return Int()
            }
        }
    }
    
    func object_forKeyWithValidationForClass_CGFloat(aKey: String) -> CGFloat {
        
        // CHECK FOR EMPTY
        if(self.allKeys.count == 0) {
            return CGFloat()
        }
        
        // CHECK IF KEY EXIST
        if let val = self.object(forKey: aKey) {
            if((val as AnyObject).isEqual(NSNull())) {
                return CGFloat()
            }
        } else {
            // KEY NOT FOUND
            return CGFloat()
        }
        
        // CHECK FOR NIL VALUE
        let aValue : AnyObject = self.object(forKey: aKey)! as AnyObject
        if aValue.isEqual(NSNull()) {
            return CGFloat()
        }
        else if(aValue.isKind(of: NSString.self)){
            return CGFloat((aValue as! NSString).floatValue)
        }
        else {
            
            if aValue is CGFloat {
                return self.object(forKey: aKey) as! CGFloat
            }
            else{
                return CGFloat()
            }
        }
    }
    
    func object_forKeyWithValidationForClass_Float(aKey: String) -> Float {
        
        // CHECK FOR EMPTY
        if(self.allKeys.count == 0) {
            return Float()
        }
        
        // CHECK IF KEY EXIST
        if let val = self.object(forKey: aKey) {
            if((val as AnyObject).isEqual(NSNull())) {
                return Float()
            }
        } else {
            // KEY NOT FOUND
            return Float()
        }
        
        // CHECK FOR NIL VALUE
        let aValue : AnyObject = self.object(forKey: aKey)! as AnyObject
        if aValue.isEqual(NSNull()) {
            return Float()
        }
        else if(aValue.isKind(of: NSString.self)){
            return Float((aValue as! NSString).floatValue)
        }
        else {
            
            if aValue is Float {
                return self.object(forKey: aKey) as! Float
            }
            else{
                return Float()
            }
        }
    }
    
    func object_forKeyWithValidationForClass_String(aKey: String) -> String {
        
        // CHECK FOR EMPTY
        if(self.allKeys.count == 0) {
            return String()
        }
        
        // CHECK IF KEY EXIST
        if let val = self.object(forKey: aKey) {
            if((val as AnyObject).isEqual(NSNull())) {
                return String()
            }
        } else {
            // KEY NOT FOUND
            return String()
        }
        
        // CHECK FOR NIL VALUE
        let aValue : AnyObject = self.object(forKey: aKey)! as AnyObject
        if aValue.isEqual(NSNull()) {
            return String()
        }
        else if(aValue.isKind(of: NSNumber.self)){
            return String(format:"%f", (aValue as! NSNumber).doubleValue)
        }
        else {
            
            if aValue is String {
                return self.object(forKey: aKey) as! String
            }
            else{
                return String()
            }
        }
    }
    
    func object_forKeyWithValidationForClass_Bool(aKey: String) -> Bool {
        // CHECK FOR EMPTY
        if(self.allKeys.count == 0) {
            return Bool()
        }
        
        // CHECK IF KEY EXIST
        if let val = self.object(forKey: aKey) {
            if((val as AnyObject).isEqual(NSNull())) {
                return Bool()
            }
        } else {
            // KEY NOT FOUND
            return Bool()
        }
        
        // CHECK FOR NIL VALUE
        let aValue : AnyObject = self.object(forKey: aKey)! as AnyObject
        if aValue.isEqual(NSNull()) {
            return Bool()
        }
        else {
            
            if aValue is Bool {
                return self.object(forKey: aKey) as! Bool
            }
            else{
                return Bool()
            }
        }
    }
    
    func object_forKeyWithValidationForClass_NSArray(aKey: String) -> NSArray {
        // CHECK FOR EMPTY
        if(self.allKeys.count == 0) {
            return NSArray()
        }
        
        // CHECK IF KEY EXIST
        if let val = self.object(forKey: aKey) {
            if((val as AnyObject).isEqual(NSNull())) {
                return NSArray()
            }
        } else {
            // KEY NOT FOUND
            return NSArray()
        }
        
        // CHECK FOR NIL VALUE
        let aValue : AnyObject = self.object(forKey: aKey)! as AnyObject
        if aValue.isEqual(NSNull())
        {
            return NSArray()
        }
        else {
            if aValue is NSArray
            {
                return self.object(forKey: aKey) as! NSArray
            }
            else{
                return NSArray()
            }
        }
    }
    
    func object_forKeyWithValidationForClass_NSMutableArray(aKey: String) -> NSMutableArray {
        // CHECK FOR EMPTY
        if(self.allKeys.count == 0) {
            return NSMutableArray()
        }
        
        // CHECK IF KEY EXIST
        if let val = self.object(forKey: aKey) {
            if((val as AnyObject).isEqual(NSNull())) {
                return NSMutableArray()
            }
        } else {
            // KEY NOT FOUND
            return NSMutableArray()
        }
        
        // CHECK FOR NIL VALUE
        let aValue : AnyObject = self.object(forKey: aKey)! as AnyObject
        if aValue.isEqual(NSNull()) {
            return NSMutableArray()
        }
        else {
            
            if aValue is NSMutableArray {
                return self.object(forKey: aKey) as! NSMutableArray
            }
            else{
                return NSMutableArray()
            }
        }
    }
    
    func object_forKeyWithValidationForClass_NSDictionary(aKey: String) -> NSDictionary {
        // CHECK FOR EMPTY
        if(self.allKeys.count == 0) {
            return NSDictionary()
        }
        
        // CHECK IF KEY EXIST
        if let val = self.object(forKey: aKey) {
            if((val as AnyObject).isEqual(NSNull())) {
                return NSDictionary()
            }
        } else {
            // KEY NOT FOUND
            return NSDictionary()
        }
        
        // CHECK FOR NIL VALUE
        let aValue : AnyObject = self.object(forKey: aKey)! as AnyObject
        if aValue.isEqual(NSNull()) {
            return NSDictionary()
        }
        else {
            
            if aValue is NSDictionary {
                return self.object(forKey: aKey) as! NSDictionary
            }
            else{
                return NSDictionary()
            }
        }
    }
    
    func object_forKeyWithValidationForClass_NSMutableDictionary(aKey: String) -> NSMutableDictionary {
        // CHECK FOR EMPTY
        if(self.allKeys.count == 0) {
            return NSMutableDictionary()
        }
        
        // CHECK IF KEY EXIST
        if let val = self.object(forKey: aKey) {
            if((val as AnyObject).isEqual(NSNull())) {
                return NSMutableDictionary()
            }
        } else {
            // KEY NOT FOUND
            return NSMutableDictionary()
        }
        
        // CHECK FOR NIL VALUE
        let aValue : AnyObject = self.object(forKey: aKey)! as AnyObject
        if aValue.isEqual(NSNull()) {
            return NSMutableDictionary()
        }
        else {
            if aValue is NSMutableDictionary {
                return self.object(forKey: aKey) as! NSMutableDictionary
            }
            else{
                return NSMutableDictionary()
            }
        }
    }
    
//    func dictionaryByReplacingNullsWithBlanks() -> NSMutableDictionary {
//        let dictReplaced : NSMutableDictionary = self.mutableCopy() as! NSMutableDictionary
//        let null : AnyObject = NSNull()
//        let blank : NSString = ""
//        for key : Any in self.allKeys {
//            let strKey : NSString  = key as! NSString
//            let object : AnyObject = self.object(forKey: strKey)! as AnyObject
//            if object.isEqual(null) {
//                dictReplaced.setObject(blank, forKey: strKey)
//            } else if object is NSDictionary {
//                dictReplaced.setObject((object as! NSDictionary).dictionaryByReplacingNullsWithBlanks(), forKey: strKey)
//            } else if object is NSArray {
//                dictReplaced.setObject((object as! NSArray).arrayByReplacingNullsWithBlanks(), forKey: strKey)
//            }
//        }
//        return dictReplaced
//    }
}
