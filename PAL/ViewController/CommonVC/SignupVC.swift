//
//  SignupVC.swift
//
//
//  Created by i-Verve on 22/10/20.
//

import UIKit

class SignupVC: UIViewController,UITextFieldDelegate,SchoolListDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate {
    
    func saveFont(SelectedFont: Int) {
    }
    
    
    //MARK: Outlets variable
    @IBOutlet weak var imgSignup: UIImageView!
    @IBOutlet weak var txtFirstName: PALTextField!
    @IBOutlet weak var txtLastName: PALTextField!
    @IBOutlet weak var txtSubrub: PALTextField!{
        didSet{
            txtSubrub.setRightPaddingWithImage(placeholderTxt: "Select Suburb", img: UIImage(named: "Icon_downArrow")!, fontSize: 17, isLeftPadding: false)
        }
    }
    @IBOutlet weak var txtChildrenAccount: PALTextField!{
        didSet{
            txtChildrenAccount.setRightPaddingWithImage(placeholderTxt: "Select Children Count", img: UIImage(named: "Icon_downArrow")!, fontSize: 17, isLeftPadding: false)
        }
    }
    @IBOutlet weak var txtEmail: PALTextField!
    @IBOutlet weak var txtPassword: PALTextField!
    @IBOutlet weak var txtConfPassword: PALTextField!
    @IBOutlet weak var txtPassCode: PALTextField!
    @IBOutlet weak var txtSchool: PALTextField!{
        didSet{
            txtSchool.setRightPaddingWithImage(placeholderTxt: "Select School", img: UIImage(named: "Icon_downArrow")!, fontSize: 17, isLeftPadding: false)
            
        }
    }
    @IBOutlet weak var txtRefferalCode: PALTextField!
    @IBOutlet weak var lblDont: UILabel!
    @IBOutlet weak var btnsignup: UIButton!{
        didSet{
            self.btnsignup.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnTeacherSignup: UIButton!{
        didSet{
            self.btnTeacherSignup.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblfirst: UILabel!
    @IBOutlet weak var lblLast: UILabel!
    @IBOutlet weak var lblSubrub: UILabel!
    @IBOutlet weak var lblChildernLinked: UILabel!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var lblPassCode: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblReferral: UILabel!
    @IBOutlet weak var lblConfPassword: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewTopBAckground: UIView!
    
    @IBOutlet weak var imgtxtDown: UIImageView!{
        didSet{
            //imgtxtDown.transform = imgtxtDown.transform.rotated(by: .pi/2)
        }
    }
    @IBOutlet weak var tblSignUP: UITableView!
    @IBOutlet var cellFullName: UITableViewCell!
    @IBOutlet var cellSuburb: UITableViewCell!
    @IBOutlet var cellChildren: UITableViewCell!
    @IBOutlet var cellEmail: UITableViewCell!
    @IBOutlet var cellPassWord: UITableViewCell!
    @IBOutlet var cellNext: UITableViewCell!
    @IBOutlet var cellPassCode: UITableViewCell!
    @IBOutlet var cellConfPassCode: UITableViewCell!
    @IBOutlet var cellSchool: UITableViewCell!
    @IBOutlet var cellSignUpButton: UITableViewCell!
    @IBOutlet var cellReferralCode: UITableViewCell!
    
    @IBOutlet weak var nslcTopViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nslcbtnParentSignUpWidth: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnParentSignUpHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nslcbtnTeacherSignUpWidth: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnTeacherSignUpHeight: NSLayoutConstraint!
    
    @IBOutlet var txtTermsText: UITextView!
    @IBOutlet var btnTerms: UIButton!
    
    //MARK: - btn Click
    @IBAction func btnSignupClick(_ sender: Any) {
        self.signUpValidation()
    }
    
    @IBAction func btnTermsClick(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.btnTerms.isSelected {
            self.btnTerms.isSelected = false
        }
        else {
            self.btnTerms.isSelected = true
        }
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        if let viewControllers = self.navigationController?.viewControllers{
            for controller in viewControllers{
                if controller is LoginVC{
                    self.navigationController?.popToRootViewController(animated: true)
                    return
                }
            }
        }
        let loginVC = LoginVC.instantiate(fromAppStoryboard: .Main)
        let nav = UINavigationController(rootViewController: loginVC)
        UIApplication.shared.keyWindow?.rootViewController = nav
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    //MARK: - Local variable
    var isUserType = Int()
    var isSchoolId = Int()
    var pickerView = UIPickerView()
    var arrChildrenCount = [String]()
    var imgDownArrow = UIImageView()
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFirstName.delegate = CustomTextFieldDelegate.sharedInstance
        txtLastName.delegate = CustomTextFieldDelegate.sharedInstance
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        if DeviceType.IS_IPHONE {
            self.pickerViewSetUp()
        }
        self.SetupSignup()
        self.provisionAttribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - support method
    func SetupSignup(){
        self.imgSignup.layer.cornerRadius = (DeviceType.IS_IPHONE) ? ((ScreenSize.SCREEN_HEIGHT * 0.35) * 0.5)/2 : ((ScreenSize.SCREEN_HEIGHT * 0.3) * 0.5)/2
        
        self.lblfirst.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblSubrub.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblPassword.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblReferral.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblConfPassword.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblChildernLinked.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblLast.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblSchool.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblPassCode.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtFirstName.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtLastName.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtSubrub.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtPassCode.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtSchool.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtPassword.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtConfPassword.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtChildrenAccount.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnLogin.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.btnsignup.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        self.btnTeacherSignup.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        self.lblDont.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        self.btnNext.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: (DeviceType.IS_IPHONE) ? -10:-30, bottom: 0, right: 0)
        
        if DeviceType.IS_IPHONE{
            self.nslcTopViewHeight.isActive = true
            self.nslcbtnParentSignUpWidth.isActive = true
            self.nslcbtnParentSignUpHeight.isActive = true
            self.nslcbtnTeacherSignUpWidth.isActive = true
            self.nslcbtnTeacherSignUpHeight.isActive = true
        }
        else{
            self.nslcTopViewHeight.isActive = false
            self.nslcbtnParentSignUpWidth.isActive = false
            self.nslcbtnParentSignUpHeight.isActive = false
            self.nslcbtnTeacherSignUpWidth.isActive = false
            self.nslcbtnTeacherSignUpHeight.isActive = false
        }
        
        if let nsv = self.navigationController{
            transparentNav(nav: nsv)
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.SignUp, titleColor: .white)
            self.navigationItem.titleView = titleLabel
        }
        
        if Preferance.user.userType == 2 {
            self.imgSignup.isHidden = true
            self.viewTopBAckground.heightAnchor.constraint(equalTo: self.viewTopBAckground.widthAnchor, multiplier: 1.0/12.0).isActive = true//14
            self.lblDont.text = ScreenText.alreadyAccount
        }
        else {
            self.imgSignup.isHidden = false
            self.lblDont.text = ScreenText.alreadyAccount
            //            self.viewTopBAckground.heightAnchor.constraint(equalTo: self.viewTopBAckground.widthAnchor, multiplier: 1.0/1.0).isActive = true
        }
    }
    
    func pickerViewSetUp() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.txtChildrenAccount.inputView = self.pickerView
        self.arrChildrenCount = ["1", "2", "3", "4", "5"]
        
        let toolBar = UIToolbar()
        toolBar.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.pickerDone))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.txtChildrenAccount.inputAccessoryView = toolBar
    }
    
    func scrollSpecificIndex(index: Int)  {
        self.tblSignUP.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
    }
    
    func signUpValidation() {
        if (self.txtFirstName.text!.isBlank) {
            if self.isUserType == 1{
                self.scrollSpecificIndex(index: 1)
            }
            DispatchQueue.main.async {
                self.txtFirstName.text = ""
                showAlertWithFocus(message: Validation.enterFirstname, txtFeilds: self.txtFirstName, inView: self)
            }
        }
        else if (self.txtFirstName.text?.containsEmoji)!{
            showAlertWithFocus(message: Validation.firstnameEmoji, txtFeilds: self.txtFirstName, inView: self)
        }
        else if (self.txtFirstName.text!.trim.count < 2) {
            showAlertWithFocus(message: Validation.enterMoreCharacterFirstName, txtFeilds: self.txtFirstName, inView: self)
        }
        
        else if (self.txtLastName.text!.isBlank) {
            if self.isUserType == 1{
                self.scrollSpecificIndex(index: 1)
            }
            DispatchQueue.main.async {
                self.txtLastName.text = "";
                showAlertWithFocus(message: Validation.enterLastName, txtFeilds: self.txtLastName, inView: self)
            }
        }
        else if (self.txtLastName.text?.containsEmoji)!{
            showAlertWithFocus(message: Validation.lastnameEmoji, txtFeilds: self.txtLastName, inView: self)
        }
        else if (self.txtLastName.text!.trim.count < 2) {
            showAlertWithFocus(message: Validation.enterMoreCharacterLastName, txtFeilds: self.txtLastName, inView: self)
        }
        
        else if (self.txtSubrub.text?.trim.count == 0){
            if self.isUserType == 1{
                self.scrollSpecificIndex(index: 3)
            }
            DispatchQueue.main.async {
                showAlertWithFocus(message: Validation.enterSuburb, txtFeilds: self.txtSubrub, inView: self)
            }
        }
        else if (self.txtChildrenAccount.text!.isBlank && Preferance.user.userType == 1){
            if self.isUserType == 1{
                self.scrollSpecificIndex(index: 5)
            }
            DispatchQueue.main.async {
                showAlertWithFocus(message: Validation.enterChildrenCount, txtFeilds: self.txtChildrenAccount, inView: self)
            }
        }
        //        else if (self.txtPassCode.text!.isBlank && Preferance.user.userType == 2){
        //            showAlertWithFocus(message: Validation.enterPassCode, txtFeilds: self.txtPassCode, inView: self)
        //        }
        else if (self.txtSchool.text!.isBlank && Preferance.user.userType == 2){
            
            DispatchQueue.main.async {
                showAlertWithFocus(message: Validation.selectSchool, txtFeilds: self.txtSchool, inView: self)
            }
        }
        else if (self.txtEmail.text?.isBlank)!{
            if self.isUserType == 1{
                self.scrollSpecificIndex(index: 7)
            }
            DispatchQueue.main.async {
                showAlertWithFocus(message: Validation.enterEmail, txtFeilds: self.txtEmail, inView: self)
            }
        }
        else if (!isValidEmail(str: self.txtEmail.text!.trim)){
            if self.isUserType == 1{
                self.scrollSpecificIndex(index: 7)
            }
            DispatchQueue.main.async {
                showAlertWithFocus(message: Validation.enterValidEmail, txtFeilds: self.txtEmail, inView: self)
            }
        }
        else if (self.txtPassword.text?.isBlank)!{
            DispatchQueue.main.async {
                showAlertWithFocus(message: Validation.enterPassword, txtFeilds: self.txtPassword, inView: self)
            }
        }
        else if let pass = self.txtPassword.text?.trim, pass.count < 6{
            showAlertWithFocus(message: Validation.enterMinPassword, txtFeilds: self.txtPassword, inView: self)
        }
        //        else if (!(self.txtPassword.text?.trim.isValidPassword)!){
        //            showAlertWithFocus(message: Validation.validPassword, txtFeilds: self.txtPassword, inView: self)
        //        }
        else if (self.txtPassword.text?.containsEmoji)!{
            showAlertWithFocus(message: Validation.passwordEmoji, txtFeilds: self.txtPassword, inView: self)
        }
        else if (self.txtConfPassword.text?.isBlank)!{
            showAlertWithFocus(message: Validation.ConfirmPassword, txtFeilds: self.txtConfPassword, inView: self)
        }
        else if (self.txtConfPassword.text?.containsEmoji)!{
            showAlertWithFocus(message: Validation.passwordEmoji, txtFeilds: self.txtConfPassword, inView: self)
        }
        else if (self.txtPassword.text != self.txtConfPassword.text){
            showAlertWithFocus(message: Validation.PasswordConfirmPswNotMatch, txtFeilds: self.txtConfPassword, inView: self)
        }
        else if (!self.btnTerms.isSelected){
            showAlert(title: APP_NAME, message: Validation.TermsMssg)
        }
        else{
            self.view.endEditing(true)
            self.APICallSignUp()
        }
    }
    
    @IBAction func GoogleButton(sender: AnyObject) {
        if let url = NSURL(string: "https://pal.clouddownunder.com.au/school/signup"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func provisionAttribute(){
        let attributesOfTerms = [NSAttributedString.Key.font: UIFont.Font_ProductSans_Regular(fontsize: 15), NSAttributedString.Key.foregroundColor: UIColor.kPlaceholderColor()]
        let regularFontAttribute = [NSAttributedString.Key.font:UIFont.Font_ProductSans_Regular(fontsize: 14)]
        
        let attributedString = NSMutableAttributedString.init(string: "By tapping sign up, you agree to the Terms & conditions and Privacy policy.", attributes: attributesOfTerms)
        var foundRange = attributedString.mutableString.range(of: "Terms & conditions ")
        attributedString.addAttribute(NSAttributedString.Key.link, value: "1", range: foundRange)
        foundRange = attributedString.mutableString.range(of: "Privacy policy.")
        attributedString.addAttribute(NSAttributedString.Key.link, value: "2", range: foundRange)
        foundRange = attributedString.mutableString.range(of: "By tapping sign up, you agree to the")
        attributedString.addAttributes(regularFontAttribute, range: foundRange)
        foundRange = attributedString.mutableString.range(of: " and")
        attributedString.addAttributes(regularFontAttribute, range: foundRange)
        txtTermsText.linkTextAttributes = [.foregroundColor: UIColor(named: "Color_lightSky")!, .underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.Font_ProductSans_Bold(fontsize: 16)]
        txtTermsText.delegate = self
        txtTermsText.attributedText = attributedString
        txtTermsText.layoutIfNeeded()
    }
    
    func presetTermsVC(isPrivacy: Bool) {
        if DeviceType.IS_IPHONE {
            let nextVC = Terms_ConditionVC.instantiate(fromAppStoryboard: .Settings)
            nextVC.isFromSignUp = true
            nextVC.isPrivacyPolicy = isPrivacy
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else {
            let nextVC = Terms_ConditionVC.instantiate(fromAppStoryboard: .Settings)
            nextVC.isFromSignUp = true
            nextVC.isPrivacyPolicy = isPrivacy
            //            if #available(iOS 13.0, *) {
            //                nextVC.isModalInPresentation = false
            //            }
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    //MARK: - API Call
    func TeacherConfirmationPopUp(strMssg: String)  {//ScreenText.TeacherSignUpWarMssg
        let alert = UIAlertController(title: APP_NAME, message: strMssg, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: {action in
            if let viewControllers = self.navigationController?.viewControllers{
                for controller in viewControllers{
                    if controller is LoginVC{
                        self.navigationController?.popToRootViewController(animated: true)
                        return
                    }
                }
            }
        })
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - txt delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFirstName {
            self.txtLastName.becomeFirstResponder()
        }
        else if textField == self.txtLastName {
            self.txtSubrub.becomeFirstResponder()
        }
        else if textField == self.txtSubrub {
            self.txtChildrenAccount.becomeFirstResponder()
        }
        else if textField == self.txtChildrenAccount {
            self.txtEmail.becomeFirstResponder()
        }
        else if textField == self.txtEmail {
            self.txtPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtSchool{
            let nextVC = SchoolListVC.instantiate(fromAppStoryboard: .PopOverStoryboard)
            nextVC.delegate = self
            let nav = UINavigationController(rootViewController: nextVC)
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                nextVC.preferredContentSize = CGSize(width: 400,height: 300)
                popover.permittedArrowDirections = .unknown
                popover.sourceView = self.txtSchool
                popover.sourceRect = self.txtSchool.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
            return false
        }
        else if textField == self.txtChildrenAccount{
            if DeviceType.IS_IPAD{
                self.view.endEditing(true)
                let nextVC = SchoolListVC.instantiate(fromAppStoryboard: .PopOverStoryboard)
                nextVC.delegate = self
                nextVC.isChildCount = true
                nextVC.arrChildList = ["1", "2", "3", "4", "5"]
                let nav = UINavigationController(rootViewController: nextVC)
                nav.modalPresentationStyle = .popover
                if let popover = nav.popoverPresentationController {
                    nextVC.preferredContentSize = CGSize(width: 300,height: 300)
                    popover.permittedArrowDirections = .unknown
                    popover.sourceView = self.txtChildrenAccount
                    popover.sourceRect = self.txtChildrenAccount.bounds
                }
                self.present(nav, animated: true, completion: nil)
                return false
            }
        }
        else if self.txtSubrub == textField{
            self.view.endEditing(true)
            let nextVC = SearchViewController.instantiate(fromAppStoryboard: .Main)
            nextVC.delegate = self
            nextVC.needSuburb = true
            //            if DeviceType.IS_IPAD{
            //                let nav = UINavigationController(rootViewController: nextVC)
            //                nav.modalPresentationStyle = .popover
            //                if let popover = nav.popoverPresentationController {
            //                    nextVC.preferredContentSize = CGSize(width: 300,height: 200)
            //                    popover.permittedArrowDirections = .unknown
            //                    popover.sourceView = self.txtSubrub
            //                    popover.sourceRect = self.txtSubrub.bounds
            //                }
            //            }
            //            else {
            nextVC.modalPresentationStyle = .overCurrentContext
            //            }
            self.present(nextVC, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    //MARK: - txtView delegate
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if textView.tag == 1 {
            return true
        }
        if URL.absoluteString == "1" {
            self.presetTermsVC(isPrivacy: false)
            return false
        }
        else if URL.absoluteString == "2" {
            self.presetTermsVC(isPrivacy: true)
            return false
        }
        else {
            return true
        }
    }
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 1:
                return cellFullName
            case 3:
                return cellSuburb
            case 5:
                return (Preferance.user.userType == 1) ? cellChildren : cellSchool
            case 7:
                return cellEmail
            case 9:
                return cellPassWord
            case 11:
                //            cellConfPassCode.backgroundColor = .yellow
                return cellConfPassCode
            case 13:
                //            cellReferralCode.backgroundColor = .red
                return cellReferralCode
            case 15:
                //            cellSignUpButton.backgroundColor = .yellow
                return cellSignUpButton
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE{
            if indexPath.row == 5
            {
                return (Preferance.user.userType == 1) ? 80 : 120
            }else{
                return (indexPath.row % 2 == 0) ? 10 : (indexPath.row == 15 ) ? 190 : 80
            }
        }
        else{
            if indexPath.row % 2 == 0{
                return ScreenSize.SCREEN_HEIGHT*0.02
            }
            else{
                if indexPath.row == 13 {
                    return Preferance.user.userType == 2 ?0:ScreenSize.SCREEN_HEIGHT*0.1
                }
                else if indexPath.row == 15 {
                    return 230
                }else if indexPath.row == 5
                {
                    return (Preferance.user.userType == 1) ? ScreenSize.SCREEN_HEIGHT*0.1 : ScreenSize.SCREEN_HEIGHT*0.13
                }
                else{
                    return ScreenSize.SCREEN_HEIGHT*0.1
                }
            }
        }
    }
    
    //MARK: - pickerView delegate/datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrChildrenCount.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrChildrenCount[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtChildrenAccount.text = self.arrChildrenCount[row]
    }
    
    //MARK: - schoolList delegate
    func saveText(objSchool : SchoolListModel){
        if Preferance.user.userType == 2{
            self.txtSchool.text = objSchool.schoolName
            self.isSchoolId = objSchool.schoolId!
        }
    }
    
    func saveCount(strText : String){
        self.txtChildrenAccount.text = strText as String
    }
    
    //MARK: - API Call
    func APICallSignUp() {
        
        var params: [String: Any] = [ : ]
        params["firstName"] = self.txtFirstName.text?.trim
        params["lastName"] = self.txtLastName.text?.trim
        params["suburb"] = self.txtSubrub.text?.trim
        params["childCount"] = self.txtChildrenAccount.text?.trim
        params["schoolId"] = self.isSchoolId
        params["email"] = self.txtEmail.text?.trim
        params["password"] = self.txtPassword.text?.trim
        params["userType"] = self.isUserType
        params["referralCode"] = self.txtRefferalCode.text?.trim
        params["deviceType"] = MyApp.device_type
        params["deviceToken"] =  Singleton.shared.get(key: UserDefaultsKeys.FCMToken) as! String
        
        APIManager.shared.callPostApi(parameters: params, reqURL:  URLs.APIURL + signUp, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if self.isUserType == 1 {
                            if let user = userData.user {
                                Preferance.user = user
                                Preferance.user.userType = self.isUserType
                                Singleton.shared.save(object: Preferance.user.toJSON(), key: UserDefaultsKeys.userData)
                                Singleton.shared.save(object: "1", key: LocalKeys.isLogin)
                                Singleton.shared.save(object: self.txtPassword.text!.trim as String, key: LocalKeys.password)
                                
                                Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)
                                let nextVC = ChildAddCountVC.instantiate(fromAppStoryboard: .Main)
                                nextVC.childCount = self.txtChildrenAccount.text!.trim
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                        }
                        else {
                            self.TeacherConfirmationPopUp(strMssg: userData.message!)
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
    
    //MARK: - btn click event
    @objc func pickerDone() {
        self.view.endEditing(true)
        if self.txtChildrenAccount.text?.trim.count == 0{
            self.txtChildrenAccount.text = self.arrChildrenCount[0]
        }
    }
    
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        self.signUpValidation()
    }
}

extension SignupVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //self.navigationController?.popViewController(animated: true)
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            print("true")
            return true
        }
        print("false")
        return false
    }
}
//MARK: - GMSSearchDelegate
extension SignupVC: SearchViewControllerDelegate{
    func searched(viewController: UIViewController, text: String, latitude: Double?, longitude: Double?, venueId: Int?) {
        print(text)
        self.txtSubrub.text = text
        viewController.dismiss(animated: true, completion: nil)
    }
}
