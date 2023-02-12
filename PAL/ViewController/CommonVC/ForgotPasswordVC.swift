//
//  ForgotPasswordVC.swift
//  
//
//  Created by i-Verve on 22/10/20.
//

import UIKit

class ForgotPasswordVC: UIViewController,UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var imgForgot: UIImageView!
    @IBOutlet weak var txtEmail: PALTextField!
    @IBOutlet weak var btnSubmit: UIButton!{
        didSet{
            btnSubmit.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var nslcTopViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnLoginWidth: NSLayoutConstraint!{
        didSet {
            if DeviceType.IS_IPHONE{
                nslcbtnLoginWidth.isActive = true
            }
            else{
                nslcbtnLoginWidth.isActive = false
            }
        }
    }
    @IBOutlet weak var nslcbtnLoginHeight: NSLayoutConstraint!{
        didSet {
            if DeviceType.IS_IPHONE{
                nslcbtnLoginHeight.isActive = true
            }
            else{
                nslcbtnLoginHeight.isActive = false
            }
        }
    }
    
    //MARK: - Button Click
    
    @IBAction func btnSubmitClick(_ sender: Any) {
        if ((self.txtEmail.text?.isBlank)!) {
            showAlertWithFocus(message: Validation.enterEmail, txtFeilds: txtEmail!, inView: self)
        }
        else if(!isValidEmail(str: txtEmail.text!)){
            showAlertWithFocus(message: Validation.EmailValidation, txtFeilds: txtEmail!, inView: self)
        }
        else {
            self.txtEmail.resignFirstResponder()
            self.APICallForgotPassword()
        }
    }
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Forgot Password", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            self.navigationItem.setHidesBackButton(true, animated: true)
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        
        self.SetupForgotPassword()
    }
    
    //MARK: - support method
    func SetupForgotPassword(){
        
        self.lblEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtEmail.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.btnSubmit.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        if DeviceType.IS_IPHONE{
            self.nslcTopViewHeight.isActive = true
        }
        else{
            self.nslcTopViewHeight.isActive = false
        }
    }
    
    //MARK: - btn Click
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - API Call
    func APICallForgotPassword() {
        
        var params: [String: Any] = [ : ]
        params["email"] = self.txtEmail.text?.trim
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + forgotPassword, showLoader: true, vc:self) { (jsonData, error) in
            if let tempJson = jsonData{
                if let json = tempJson.dictionaryObject {
                    if let userData = ObjectResponse(JSON: json){
                        if let status = userData.status, status == 1{
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
}
