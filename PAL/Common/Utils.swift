//
//  BikeCheckUtils.swift
//  Bike Check
//
//  Created by i-Verve on 20/03/20.
//  Copyright © 2020 i-Phone7. All rights reserved.
//

import Foundation
import UIKit

func isValidEmail(str: String) -> Bool {
    let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: str)
}

func isXIPhone() -> Bool?{
    var iPhoneX = Bool()
    if #available(iOS 11.0, *) {
        if ((UIApplication.shared.keyWindow?.safeAreaInsets.top)! > CGFloat(0.0)) {
            iPhoneX = true
        }
    }
    return iPhoneX
}

func getUserTye() -> String{
    return (Preferance.user.userType == 1) ?"parent/": (Preferance.user.userType == 2) ?"teacher/":"student/"
}

func transparentNav(nav: UINavigationController) {
    
    if #available(iOS 15, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
    }
    else {
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = true
    }
}

func nonTransparentNav(nav: UINavigationController) {
    if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
       , colorName.trim.count > 0{
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: colorName)
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        }
        else {
            // Fallback on earlier versions
            nav.navigationBar.isTranslucent = false
            nav.navigationBar.barTintColor = UIColor(named: colorName)
        }
    }
}

func StudentnonTransparentNav(nav: UINavigationController){
    if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
       , colorName.trim.count > 0{
        if #available(iOS 13.0, *) {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.hexStringToUIColor(colorName)
    nav.navigationBar.standardAppearance = appearance;
    nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
    }
    else {
        // Fallback on earlier versions
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.barTintColor = UIColor.hexStringToUIColor(colorName)
    }
}
}

func setLeftButtonWithTarget(_ target: AnyObject, action:Selector, imageName:String) -> [UIBarButtonItem] {
    
    let leftBtn = UIButton(type: UIButton.ButtonType.custom)
    leftBtn.backgroundColor = UIColor.clear
    leftBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    leftBtn.setImage(UIImage(named:imageName), for:UIControl.State())

    leftBtn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    let negativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
    negativeSpace.width = -5
    let barButton = UIBarButtonItem(customView:leftBtn)
    let arrBarItems = [negativeSpace, barButton]
    return arrBarItems
}

func setRightButtonWithTarget(_ target: AnyObject, action:Selector, imageName:String) -> [UIBarButtonItem]
{
    let rightBtn = UIButton(type: UIButton.ButtonType.custom)
    rightBtn.backgroundColor = UIColor.clear
    rightBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    rightBtn.setImage(UIImage(named:imageName), for:UIControl.State())
    
    rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:0 , bottom: 0, right: rightBtn.frame.size.width - (rightBtn.frame.size.width + 15))
    rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightBtn.frame.size.width)
    
    rightBtn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    let negativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
    negativeSpace.width = -5
    let barButton = UIBarButtonItem(customView:rightBtn)
    let arrBarItems = [negativeSpace, barButton]
    return arrBarItems
}

func clearStudentTempDir(){
    let fileManager = FileManager.default
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let tempDirPath = dirPath.appending("/WorkSheetMetaData")
    
    do {
        let folderPath = tempDirPath
        let paths = try fileManager.contentsOfDirectory(atPath: tempDirPath)
        for path in paths
        {
            try fileManager.removeItem(atPath: "\(folderPath)")///\(path)
        }
    }
    catch let error as NSError{
        print(error.localizedDescription)
    }
}

func clearTeacherTempDir(){
    let fileManager = FileManager.default
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let tempDirPath = dirPath.appending("/TeacherWorkSheetMetaData")
    
    do {
        let folderPath = tempDirPath
        let paths = try fileManager.contentsOfDirectory(atPath: tempDirPath)
        for path in paths
        {
            try fileManager.removeItem(atPath: "\(folderPath)")///\(path)
        }
    }
    catch let error as NSError{
        print(error.localizedDescription)
    }
}

//MARK:- Fonts
func getPropostionalFontSize(_ size:CGFloat) -> CGFloat{
    var sizeToCheckAgainst = size
    if(DeviceType.IS_IPAD) {
        sizeToCheckAgainst = size * (ScreenSize.SCREEN_HEIGHT/736)
    }
    else {
        if(DeviceType.IS_IPHONE_XR){
            sizeToCheckAgainst += 1.4
        }
        else if(DeviceType.IS_IPHONE_6P_7P_8P){
            sizeToCheckAgainst += 1
        }
        else if(DeviceType.IS_IPHONE_X_Xs){
            sizeToCheckAgainst += 0
        }
        else if(DeviceType.IS_IPHONE_6_7_8){
            sizeToCheckAgainst -= 0
        }
        else if(DeviceType.IS_IPHONE_5){
            sizeToCheckAgainst -= 1
        }
        else if(DeviceType.IS_IPHONE_4_OR_LESS){
            sizeToCheckAgainst -= 2
        }
    }
    return sizeToCheckAgainst
}

//MARK:- First latter of String
func getNthCharacter(strText: String) -> String {
    if strText.count > 0 {
        return String(strText.prefix(1))
    }
    return ""
}

//MARK:- ResetSession Data
func resetSessionData() {
    Preferance.user = User()
    Singleton.shared.save(object: Preferance.user.toJSON(), key: UserDefaultsKeys.userData)
    Singleton.shared.save(object: "0", key: LocalKeys.isLogin)
    Singleton.shared.save(object: "", key: LocalKeys.password)
}

//NSAttributedString
func certificateType(str: String) -> NSMutableAttributedString{
    let attributesOfTerms = [NSAttributedString.Key.font: UIFont.Font_ProductSans_Bold(fontsize: 15), NSAttributedString.Key.foregroundColor: UIColor(named: "Color_lightSky")]
    let regularFontAttribute = [NSAttributedString.Key.font:UIFont.Font_ProductSans_Regular(fontsize: 14)]
    
    let attributedString = NSMutableAttributedString.init(string: "Certificate: \(str)", attributes: attributesOfTerms as [NSAttributedString.Key : Any])
    var foundRange = attributedString.mutableString.range(of: "\(str)")
    foundRange = attributedString.mutableString.range(of: "Certificate:")
    attributedString.addAttributes(regularFontAttribute, range: foundRange)
    return attributedString
}
