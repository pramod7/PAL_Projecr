//
//  FeedbackVC.swift
//  Bike Check
//
//  Created by i-Phone7 on 26/11/19.
//  Copyright © 2019 i-Phone7. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController , UITextViewDelegate {
    
    //MARK: - Outlets variable
    @IBOutlet weak var txtViewFeature: UITextView!{
        didSet{
            txtViewFeature.addPlaceholder(strPlaceholder: "Which feature(s) would you like to see in the future?")
            txtViewFeature.textColor = .black
        }
    }
    @IBOutlet weak var txtVIewExp: UITextView!{
        didSet{
            txtVIewExp.addPlaceholder(strPlaceholder: "Share your experience with us. We would love to hear from you.")
            txtVIewExp.textColor = .black
        }
    }
    @IBOutlet weak var btnSend: UIButton!
       
    @IBOutlet weak var objViewOne: UIView!
    @IBOutlet weak var objViewTwo: UIView!
    
    @IBOutlet weak var btnSendWidth: NSLayoutConstraint!
    @IBOutlet weak var txtViewWidth: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnHeight: NSLayoutConstraint!
    
    //MARK: - local variable
    var appversion = ""
    var systemVersion = ""
    var DeviceName = ""
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Feedback", titleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        self.appversion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
        self.systemVersion = UIDevice.current.systemVersion
        self.DeviceName = UIDevice.current.name
        self.tabBarController?.tabBar.isHidden = true
        self.SetupFeedback()
    }
    
    //MARK: - Support Method
    func SetupFeedback(){
        self.txtViewFeature.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtVIewExp.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.btnSend.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        
        self.objViewOne.layer.cornerRadius = 5
        self.objViewTwo.layer.cornerRadius = 5
        self.btnSend.layer.cornerRadius = 5
        
        if DeviceType.IS_IPHONE{
            self.btnSendWidth.isActive = true
            self.nslcbtnHeight.isActive = true
            //self.txtViewWidth.isActive = true
        }
        else{
            self.btnSendWidth.isActive = false
            self.nslcbtnHeight.isActive = false
            //self.txtViewWidth.isActive = false
        }
    }
    
    //MARK: - Textview and Textfield Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView == self.txtViewFeature) {
            textView.becomeFirstResponder()
        }
        if (textView == self.txtVIewExp) {
            textView.becomeFirstResponder()
        }
    }
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView == self.txtViewFeature) || (textView == self.txtVIewExp){
            return textView.text.count + (text.count - range.length) <= 500
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
    }
    //MARK: - btn Click Actions
    @IBAction func btnSendClicked(_ sender: Any) {
        
        if self.txtViewFeature.text?.trim.count == 0{
            showAlertWith(message: Validation.feedTitle, inView: self)
        }
        else if (self.txtViewFeature.text?.trim.count)! < 20{
            showAlertWith(message: Validation.FeatureDesclength, inView: self)
        }
        else if self.txtVIewExp.text?.trim.count == 0{
            showAlertWith(message: Validation.feedDesc, inView: self)
        }
        else if (self.txtVIewExp.text?.trim.count)! < 20 {
            showAlertWith(message: Validation.ExperienceDesclength, inView: self)
        }
        else{
            self.APICallSendFeedBack()
        }
    }
    
    @objc func btnBackClick() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - API Call
    func APICallSendFeedBack() {
        self.view.endEditing(true)
        var reqParam: [String: Any] = [ : ]
        reqParam["userId"]          = Preferance.user.userId
        reqParam["feature"]         = self.txtViewFeature.text?.trim
        reqParam["experience"]      = self.txtVIewExp.text.trim
        reqParam["versionCode"]     = MyApp.versionCode
        reqParam["osVersion"]       = MyApp.osVersion
        reqParam["deviceType"]      = MyApp.device_type
        reqParam["mobileName"]      = MyApp.mobileName
        reqParam["userType"]        = Preferance.user.userType
        
        APIManager.shared.callPostApi(parameters: reqParam, reqURL: URLs.APIURL + getUserTye() + shareFeedback, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        let alert = UIAlertController(title: APP_NAME, message: userData.message, preferredStyle: .alert)
                        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
                        let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: {action in
                            self.tabBarController?.tabBar.isHidden = false
                            self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(btnOK)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                }
            }
        }
    }
}
