//
//  UIColor+Extension.swift
//  Demo_LRF+Setting
//
//  Created by i-Phone on 7/6/19.
//  Copyright © 2019 i-Phone. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
   class func hexStringToUIColor (_ hex:String) -> UIColor{
        var cString:String = hex.trim.uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = String(cString.suffix(from: cString.index(cString.startIndex, offsetBy: 1)))
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
//    var hexString: String {
//        let components = cgColor.components
//        let r: CGFloat = components?[0] ?? 0.0
//        let g: CGFloat = components?[1] ?? 0.0
//        let b: CGFloat = components?[2] ?? 0.0
//
//        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)),
//                               lroundf(Float(b * 255)))
//        return hexString
//    }
    
    class func setColor(str: String) -> UIColor {
        return UIColor.hexStringToUIColor(str)
    }
    
    class func kAppThemeColor() -> UIColor {
        return UIColor.hexStringToUIColor("#8898e6")  // 136 152 230
    }
    
    class func kPlaceholderColor() -> UIColor {
        return UIColor.hexStringToUIColor("#d9d9d9")  // 150 150 150
    }
    
    class func kTextFieldColorColor() -> UIColor {
        return UIColor.hexStringToUIColor("#737373")  // 115 115 115
    }
    
    class func kbtnAgeSetup() -> UIColor {
        return UIColor.hexStringToUIColor("#63BCD5")  // 171 219 36
    }
    
    class func kApp_Sky_Color() -> UIColor {
        return UIColor.hexStringToUIColor("#5fbcd6")
    }

    class func kApp_viewLight_Color() -> UIColor {
        return UIColor.hexStringToUIColor("#8CCFD1")
    }
}
