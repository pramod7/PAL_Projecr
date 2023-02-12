//
//  UIFont+Extension.swift
//  Demo_LRF+Setting
//
//  Created by i-Phone on 27/10/20.
//  Copyright © 2019 i-Phone. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    //MARK:- -------- logAllFont
    class func logAllfont() {
        for family in UIFont.familyNames as [String]{
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family){
                print("\(name)")
            }
        }
    }
    
    class func Font_System(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "System", size: getPropostionalFontSize(size))!
    }

    class func Font_ProductSans_Regular(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "ProductSans-Regular", size: getPropostionalFontSize(size))!
    }
    
    class func Font_ProductSans_Bold(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "ProductSans-Bold", size: getPropostionalFontSize(size))!
    }
    
    class func Font_WorkSans_Regular(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "WorkSans-Regular", size: getPropostionalFontSize(size))!
    }
    
    class func Font_WorkSans_Meduim(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "WorkSans-Medium", size: getPropostionalFontSize(size))!
    }
    
    class func Font_WorkSans_Bold(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "WorkSans-Bold", size: getPropostionalFontSize(size))!
    }
    
    class func Font_EduNSWACTFoundation(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "EduNSWACTFoundation-Regular", size: getPropostionalFontSize(size))!
    }
    
    class func Font_EduQLDBeginner(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "EduQLDBeginner-Regular", size: getPropostionalFontSize(size))!
    }
    
    class func Font_EduSABeginner(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "EduSABeginner-Regular", size: getPropostionalFontSize(size))!
    }
    
    class func Font_EduTASBeginner(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "EduTASBeginner-Regular", size: getPropostionalFontSize(size))!
    }
    
    class func Font_EduVICWANTBeginner(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "EduVICWANTBeginner-Regular", size: getPropostionalFontSize(size))!
    }
    
    class func Font_kiwischoolhandwritingregular(fontsize size: CGFloat) -> UIFont {
        return UIFont(name: "KiwiSchoolHandwriting-Regular", size: getPropostionalFontSize(size))!
    }
}
