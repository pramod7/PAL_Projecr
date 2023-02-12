//
//  ChangePasswordVC.swift
//  PAL
//
//  Created by i-Verve on 05/11/20.
//

import UIKit

class ChangePasswordVC: UIViewController,UITextFieldDelegate {
    
    //MARK: - Outlet variable
    @IBOutlet weak var lblOldPass: UILabel!
    @IBOutlet weak var txtOldPass: PALTextField!
    @IBOutlet weak var lblNewPass: UILabel!
    @IBOutlet weak var txtNewPass: PALTextField!
    @IBOutlet weak var lblConfirmPass: UILabel!
    @IBOutlet weak var txtConfirmPass: PALTextField!
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var nslcOldPassTopSpace: NSLayoutConstraint!
    @IBOutlet weak var btnChangeActive: NSLayoutConstraint!
    @IBOutlet weak var btnChangeHieghtActive: NSLayoutConstraint!

    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: ScreenTitle.ChangePass, titleColor: .white)
        self.navigationItem.titleView = titleLabel
                
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        let currentPass = Singleton.shared.get(key: LocalKeys.password) as! String
        self.SetupChangePass()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    //MARK: - support method
    
    func SetupChangePass(){
        self.lblOldPass.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblNewPass.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtOldPass.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtNewPass.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtConfirmPass.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.btnChangePass.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        self.lblConfirmPass.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        
        if DeviceType.IS_IPHONE{
            self.btnChangePass.layer.cornerRadius = 5
            self.btnChangeActive.isActive = true
            self.btnChangeHieghtActive.isActive = true
            self.nslcOldPassTopSpace.isActive = true
        }
        else{
            self.btnChangePass.layer.cornerRadius = 10
            self.btnChangeActive.isActive = false
            self.btnChangeHieghtActive.isActive = false
            self.nslcOldPassTopSpace.isActive = false
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
    func ChangePassValidation() {
        let currentPass = Singleton.shared.get(key: LocalKeys.password) as! String
        if (self.txtOldPass.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterOldPassword, txtFeilds: self.txtOldPass, inView: self)
        }
        else if (self.txtOldPass.text?.trim != currentPass) {
            showAlertWithFocus(message: Validation.oldPassIncorrect, txtFeilds: self.txtOldPass, inView: self)
        }
        else if (self.txtNewPass.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterNewPassword, txtFeilds: self.txtNewPass, inView: self)
        }
        else if let pass = self.txtNewPass.text?.trim, pass.count < 6{
            showAlertWithFocus(message: Validation.enterMinNewPassword, txtFeilds: self.txtNewPass, inView: self)
        }
//        else if (!(self.txtNewPass.text?.trim.isValidPassword)!){
//            showAlertWithFocus(message: Validation.validPassword, txtFeilds: self.txtNewPass, inView: self)
//        }
        else if (self.txtNewPass.text == self.txtOldPass.text){
            showAlertWithFocus(message: Validation.oldConfirmPasswordnosameMatch, txtFeilds: self.txtNewPass, inView: self)
        }
        else if (self.txtConfirmPass.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterConfirmPassword, txtFeilds: self.txtConfirmPass, inView: self)
        }
//        else if let pass = self.txtConfirmPass.text?.trim, pass.count < 8{
//            showAlertWithFocus(message: Validation.enterMinCnfPassword, txtFeilds: self.txtConfirmPass, inView: self)
//        }
        else if (self.txtNewPass.text != self.txtConfirmPass.text){
            showAlertWithFocus(message: Validation.NewConfirmPasswordNotMatch, txtFeilds: self.txtNewPass, inView: self)
        }
        else{
            self.APICallChangePassword()
        }
    }

    //MARK: - btn click event
    @objc func btnBackClick() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnChangePassClick(_ sender: Any) {
        self.ChangePassValidation()
    }
    
    //MARK: - TextField Copy Paste func
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            DispatchQueue.main.async(execute: {
                (sender as? UIMenuController)?.setMenuVisible(false, animated: false)
            })
            return false
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - API Call
    func APICallChangePassword() {
        self.view.endEditing(true)
        var params: [String: Any] = [ : ]
        params["userType"] = Preferance.user.userType
        params["userId"] = Preferance.user.userId
        params["newPassword"] = self.txtNewPass.text?.trim
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + changePassword, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        Singleton.shared.save(object: self.txtNewPass.text!.trim as String, key: LocalKeys.password)
                        let alert = UIAlertController(title: APP_NAME, message: userData.message, preferredStyle: .alert)
                        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
                        let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: {action in
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
