//
//  Terms&ConditionVC.swift
//  PAL
//
//  Created by i-Verve on 05/11/20.
//

import UIKit
import WebKit

class Terms_ConditionVC: UIViewController, WKNavigationDelegate {
    
    //MARK:- Outlet variable
    @IBOutlet weak var wkWebView: WKWebView!
    
    //MARK:- Local variable
    var isPrivacyPolicy = Bool()
    var isFromSignUp = Bool()
    var isFromSetting = Bool()
    var dimissTCVC : ((Bool) -> Void)?
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let btnBack: UIButton = UIButton()
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        btnBack.imageView?.contentMode = .scaleAspectFit
        if self.isFromSignUp{
            //            btnBack.setImage(UIImage(named:"Icon_Cross"), for: .normal)
            //            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnBack)
            Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)
        }
        btnBack.setImage(UIImage(named:"Icon_Back_white"), for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
        }
     
        let titleLabel = UILabel()
        if isPrivacyPolicy{
            titleLabel.navTitle(strText: "Privacy Policy", titleColor: .white)
        }
        else{
            titleLabel.navTitle(strText: "Terms & Conditions", titleColor: .white)
        }
        self.navigationItem.titleView = titleLabel
        
        if Preferance.user.userType == 0{
            if self.isPrivacyPolicy{
                let request = URLRequest(url: URL(string:URLs.APITermsPrivacyURL + APIEndpoint.getStudentPrivacy)!)
                self.wkWebView.load(request)
            }
            else{
                let request = URLRequest(url: URL(string:URLs.APITermsPrivacyURL + APIEndpoint.getStudentTerms)!)
                self.wkWebView.load(request)
            }
        }
        else if Preferance.user.userType == 1{
            if self.isPrivacyPolicy{
                let request = URLRequest(url: URL(string:URLs.APITermsPrivacyURL + APIEndpoint.getParentPrivacy)!)
                self.wkWebView.load(request)
            }
            else{
                let request = URLRequest(url: URL(string:URLs.APITermsPrivacyURL + APIEndpoint.getParentTerms)!)
                self.wkWebView.load(request)
            }
        }
        else if Preferance.user.userType == 2{
            if self.isPrivacyPolicy{
                let request = URLRequest(url: URL(string:URLs.APITermsPrivacyURL + APIEndpoint.getTeacherPrivacy)!)
                self.wkWebView.load(request)
            }
            else{
                let request = URLRequest(url: URL(string:URLs.APITermsPrivacyURL + APIEndpoint.getTeacherTerms)!)
                self.wkWebView.load(request)
            }
        }
        
        self.wkWebView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        APIManager.showPopOverLoader(view: self.view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:- support Method
    
    
    //MARK:- btn Click
    @objc func btnBackClick() {
        self.tabBarController?.tabBar.isHidden = false
        if self.isFromSignUp{
            Singleton.shared.save(object: "", key: UserDefaultsKeys.navColor)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        APIManager.hideLoader()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        APIManager.hideLoader()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
