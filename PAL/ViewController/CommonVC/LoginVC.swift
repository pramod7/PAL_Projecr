//
//  ViewController.swift
//  PAL
//
//  Created by i-Verve on 21/10/20.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var imgLogo: UIImageView!{
        didSet{
            self.imgLogo.layer.cornerRadius = (DeviceType.IS_IPHONE) ? ((ScreenSize.SCREEN_HEIGHT * 0.35) * 0.5)/2 : ((ScreenSize.SCREEN_HEIGHT * 0.3) * 0.5)/2
        }
    }
    @IBOutlet weak var btnLogin: UIButton!{
        didSet{
            self.btnLogin.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var lblDont: UILabel!
    @IBOutlet weak var btnsignup: UIButton!
    @IBOutlet weak var txtEmail: PALTextField!
    @IBOutlet weak var txtPassword: PALTextField!
    @IBOutlet weak var nslcTopViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnLoginWidth: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnLoginHeight: NSLayoutConstraint!
    
    //MARK: - Button Click
    @IBAction func btnLoginClick(_ sender: Any) {
        self.signInValidation()
    }
    
    @IBAction func btnSignupClick(_ sender: Any) {
        let nextVC = SelectCategoryVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnForgotPass(_ sender: Any) {
        let nextVC = ForgotPasswordVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: - local variable
    var strAlertMssg = String()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.SetupLogin()
        //        if self.strAlertMssg.count > 0{
        //            self.sessionResetReason()
        //        }
//        
//        self.txtEmail.text = "GB4983"//"teacher21@yopmail.com"
//        self.txtPassword.text = "123456"
    }    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nav = self.navigationController{
            transparentNav(nav: nav)
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Login", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
        
        if Preferance.user.userType == 0{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    //MARK: - support method
    func sessionResetReason() {
        if strAlertMssg.count > 0 {
            let alert = UIAlertController(title: APP_NAME, message: strAlertMssg, preferredStyle: .alert)
            alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func SetupLogin(){
        self.lblEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblPassword.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtEmail.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtPassword.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.btnForgotPassword.titleLabel?.font = UIFont.Font_WorkSans_Meduim(fontsize: 14)
        self.btnLogin.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        self.btnsignup.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.lblDont.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        if DeviceType.IS_IPHONE{
            self.nslcTopViewHeight.isActive = true
            self.nslcbtnLoginWidth.isActive = true
            self.nslcbtnLoginHeight.isActive = true
        }
        else{
            self.nslcTopViewHeight.isActive = false
            self.nslcbtnLoginWidth.isActive = false
            self.nslcbtnLoginHeight.isActive = false
        }
    }
    
    func signInValidation() {
        
        if (self.txtEmail.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterEmail, txtFeilds: self.txtEmail, inView: self)
        }
        else if (!isValidEmail(str: self.txtEmail.text!.trim) && self.txtEmail.text!.contains("@")){
            showAlertWithFocus(message: Validation.enterValidEmail, txtFeilds: self.txtEmail, inView: self)
        }
        else if (self.txtPassword.text?.isBlank)! {
           
            showAlertWithFocus(message: Validation.enterPassword, txtFeilds: self.txtPassword, inView: self)
        }
        else if let pass = self.txtPassword.text?.trim, pass.count < 6{
            showAlertWithFocus(message: Validation.enterMinPassword, txtFeilds: self.txtPassword, inView: self)
        }
        //        else if (!(self.txtPassword.text?.trim.isValidPassword)!){
        //            showAlertWithFocus(message: Validation.validPassword, txtFeilds: self.txtPassword, inView: self)
        //        }
        else if (self.txtPassword.text?.trim.containsEmoji)!{
            showAlertWithFocus(message: Validation.passwordEmoji, txtFeilds: self.txtPassword, inView: self)
        }
        else{
            self.view.endEditing(true)
            if txtEmail.text!.contains("@"){
                self.APICallSignIn(showLoader: true)
            }
            else{
                self.APICallPrelogin()
            }
        }
    }
    
    //MARK: - TextField Copy Paste func
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        if txtPassword.isFirstResponder {
            DispatchQueue.main.async(execute: {
                (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
            })
            return false
        }

        return super.canPerformAction(action, withSender: sender)
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - btn click event
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
   
    //MARK: - API Call
    func APICallPrelogin() {
        var params: [String: Any] = [ : ]
        params["email"] = self.txtEmail.text?.trim
        params["password"] = self.txtPassword.text?.trim
        params["deviceType"] = MyApp.device_type
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + preLogin, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if jsonData?[APIKey.data]["isAlreadyLogin"].int == 1
                        {
                            let alert = UIAlertController(title: APP_NAME, message: jsonData?[APIKey.message].string, preferredStyle: .alert)
                            alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
                            let Ok = UIAlertAction(title: "OK", style: .default) {(action) in
                                self.APICallSignIn(showLoader: true)
                            }
                            let Cancel = UIAlertAction(title: Messages.CANCEL, style: .cancel, handler: nil)
                            Ok.setValue(UIColor.darkGray, forKey: "titleTextColor")
                            alert.addAction(Ok)
                            alert.addAction(Cancel)
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            self.APICallSignIn(showLoader: false)
                        }
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
    
    func APICallSignIn(showLoader:Bool) {
        
        var params: [String: Any] = [ : ]
        params["email"] = self.txtEmail.text?.trim
        params["password"] = self.txtPassword.text?.trim
        params["deviceType"] = MyApp.device_type
        params["deviceToken"] = Singleton.shared.get(key: UserDefaultsKeys.FCMToken) as! String
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + login, showLoader: showLoader, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let user = userData.user {
                            Preferance.user = user
                            
                            if Preferance.user.userType == 0 && DeviceType.IS_IPHONE{
                                self.showAlertWithBackAction(title: APP_NAME, message: Validation.iPadSCompatible)
                            }
                            else if Preferance.user.userType == 2 && DeviceType.IS_IPHONE{
                                self.showAlertWithBackAction(title: APP_NAME, message: Validation.iPadTCompatible)
                            }
                            else  {
                                self.txtEmail.text = ""
                                // self.txtPassword.text = ""
                                
                                Singleton.shared.save(object: "1", key: LocalKeys.isLogin)
                                Singleton.shared.save(object: self.txtPassword.text!.trim as String, key: LocalKeys.password)
                                Singleton.shared.save(object: user.toJSON(), key: UserDefaultsKeys.userData)
                                
                                Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)//Color_English
                                
                                self.txtEmail.text = ""
                                self.txtPassword.text = ""
                                if Preferance.user.userType == 1 || Preferance.user.userType == 2{
                                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                                    let nextVC = PALTabBarController.instantiate(fromAppStoryboard: .TabBar)
                                    self.navigationController?.pushViewController(nextVC, animated: true)
                                }
                                else {
                                    if #available(iOS 13.0, *) {
                                        let objNext = WelcomeStudentVC.instantiate(fromAppStoryboard: .Student)
                                        self.navigationController?.pushViewController(objNext, animated: true)
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                    
                                }
                            }
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
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

