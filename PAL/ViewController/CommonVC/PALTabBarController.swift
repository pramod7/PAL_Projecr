//
//  PALTabBarController.swift
//  PAL
//
//  Created by i-Phone on 21/10/20.
//  Copyright © 2020 i-Verve. All rights reserved.


import UIKit

class PALTabBarController: UITabBarController {
    
//    var kiPhoneBarHeight : CGFloat = (isXIPhone()!) ? 85 : 60
    let tabBarCornerRadius: CGFloat = 15
    let tabBarTitleOffSet = UIOffset(horizontal: 0, vertical: -4)
    let tabBarBadgeColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
    
    var arrUnSelectedIcon:[String] = []
    var arrSelectedIcon:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Preferance.user.userType == 1 {
            self.arrUnSelectedIcon = ["Icon_HomeUnSelect","Icon_UserUnSelect","Icon_NotificationUnSelect",  "Icon_SettingUnSelect"]
            self.arrSelectedIcon = ["Icon_HomeSelect","Icon_UserSelect","Icon_NotificationSelect", "Icon_SettingSelect"]
        }
        else {
            self.arrUnSelectedIcon = ["Icon_HomeUnSelect","Icon_UserUnSelect","Icon_NotificationUnSelect", "Icon_FavUnSelect", "Icon_SettingUnSelect"]
            self.arrSelectedIcon = ["Icon_HomeSelect","Icon_UserSelect","Icon_NotificationSelect","Icon_FavSelect", "Icon_SettingSelect"]
        }
        
        self.settingUpViewControllers()
        self.setTabBarItems()
        self.makeRoundTabbar()
    }
    
    //MARK:- support method
    private func makeRoundTabbar() -> Void {
        
        self.tabBar.isTranslucent = true
        self.tabBar.clipsToBounds = true
        self.tabBar.layer.cornerRadius = 15
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.layer.borderWidth = 0.1
        self.delegate = self
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.barTintColor = UIColor.white
        if #available(iOS 11.0, *) {
            self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setTabBarItems(){
        for i in 0..<arrSelectedIcon.count {
            let myTabBarItem = (self.tabBar.items?[i])! as UITabBarItem
            myTabBarItem.image = UIImage(named: arrUnSelectedIcon[i])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem.selectedImage = UIImage(named: arrSelectedIcon[i])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem.title = ""
            myTabBarItem.badgeColor = tabBarBadgeColor
            myTabBarItem.titlePositionAdjustment = tabBarTitleOffSet
            myTabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        }
    }
    
    private func settingUpViewControllers(){
        
        let patentDashboard = storyboard?.instantiateViewController(withIdentifier: "ParentDashbaordVC") as! ParentDashbaordVC
        let teacherDashboard = storyboard?.instantiateViewController(withIdentifier: "TeacherDashboardVC") as! TeacherDashboardVC
        
        let parentProfileVC = storyboard?.instantiateViewController(withIdentifier: "ParentViewProfileVC") as! ParentViewProfileVC
        let teacherProfileVC = storyboard?.instantiateViewController(withIdentifier: "TeacherViewProfileVC") as! TeacherViewProfileVC
        
        let notificationVC = storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        let favouriteVC = storyboard?.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
        let settingVC = storyboard?.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        
        // Adding navigation controllers
        let navParentDashboard = UINavigationController.init(rootViewController: patentDashboard)
//        if #available(iOS 15, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            navParentDashboard.navigationBar.standardAppearance = appearance
//            navParentDashboard.navigationBar.compactAppearance = appearance
//            navParentDashboard.navigationBar.scrollEdgeAppearance = navParentDashboard.navigationBar.standardAppearance
//        }
        
        let navTeacherDashboard = UINavigationController.init(rootViewController: teacherDashboard)
        
        let navParentProfileVC = UINavigationController.init(rootViewController: parentProfileVC)
        let navTeacherProfileVC = UINavigationController.init(rootViewController: teacherProfileVC)
        
        let navnotificationVC = UINavigationController.init(rootViewController: notificationVC)
        let navfavouriteVC = UINavigationController.init(rootViewController: favouriteVC)
        let navsettingVC = UINavigationController.init(rootViewController: settingVC)
        
        navParentDashboard.navigationBar.awakeFromNib()
        navTeacherDashboard.navigationBar.awakeFromNib()
        
        navParentProfileVC.navigationBar.awakeFromNib()
        navTeacherProfileVC.navigationBar.awakeFromNib()
        
        navnotificationVC.navigationBar.awakeFromNib()
        navfavouriteVC.navigationBar.awakeFromNib()
        navsettingVC.navigationBar.awakeFromNib()
        
        navParentDashboard.isNavigationBarHidden = false
        navParentDashboard.navigationItem.setHidesBackButton(true, animated: true)
        navTeacherDashboard.isNavigationBarHidden = false
        navTeacherDashboard.navigationItem.setHidesBackButton(true, animated: true)
        
        navParentProfileVC.isNavigationBarHidden = false
        navParentProfileVC.navigationItem.setHidesBackButton(true, animated: true)
        navTeacherProfileVC.isNavigationBarHidden = false
        navTeacherProfileVC.navigationItem.setHidesBackButton(true, animated: true)
        
        navnotificationVC.isNavigationBarHidden = false
        navnotificationVC.navigationItem.setHidesBackButton(true, animated: true)
        navfavouriteVC.isNavigationBarHidden = false
        navfavouriteVC.navigationItem.setHidesBackButton(true, animated: true)
        navsettingVC.isNavigationBarHidden = false
        navsettingVC.navigationItem.setHidesBackButton(true, animated: true)
        
        if Preferance.user.userType == 1 {
            self.viewControllers = [navParentDashboard, navParentProfileVC, navnotificationVC, navsettingVC]
        }
        else {
            self.viewControllers = [navTeacherDashboard, navTeacherProfileVC, navnotificationVC, navfavouriteVC,  navsettingVC]
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension PALTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Clicked : \(tabBarController.selectedIndex)")
    }
}

extension UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 60
        return sizeThatFits
    }
}
