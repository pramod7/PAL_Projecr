//
//  TeacherEditProfileVC.swift
//  PAL
//
//  Created by i-Phone7 on 05/12/20.
//

import UIKit

class TeacherEditProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,SchoolListDelegate {

    //MARK: Outlets variable
    @IBOutlet weak var txtFirstName: PALTextField!
    @IBOutlet weak var txtLastName: PALTextField!
    @IBOutlet weak var txtEmail: PALTextField!{
        didSet{
            txtEmail.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var txtPassCode: PALTextField!{
        didSet{
            txtPassCode.setRightPaddingWithImage(placeholderTxt: "Select Suburb", img: UIImage(named: "Icon_downArrow")!, fontSize: 15, isLeftPadding: false)
        }
    }
    @IBOutlet weak var txtSchool: PALTextField!{
        didSet{
            txtSchool.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var btnSave: UIButton!{
        didSet{
            self.btnSave.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var lblfirst: UILabel!
    @IBOutlet weak var lblLast: UILabel!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var lblPassCode: UILabel!{
        didSet{
            lblPassCode.text = "Suburb"
        }
    }
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgtxtDown: UIImageView!
    
    @IBOutlet weak var tblEditProfile: UITableView!
    
    @IBOutlet var cellFullName: UITableViewCell!
    @IBOutlet var cellEmail: UITableViewCell!
    @IBOutlet var cellPassCode: UITableViewCell!
    @IBOutlet var cellSchool: UITableViewCell!
    @IBOutlet var cellSaveButton: UITableViewCell!
    
    @IBOutlet weak var nslcSignUpWidth: NSLayoutConstraint!
    @IBOutlet weak var nslcSignUpHeight: NSLayoutConstraint!

    
    //MARK:- btn Click
    @IBAction func btnSaveClick(_ sender: Any) {
        self.editProfileValidation()
    }
    
    //MARK:- local variable
    var isSchoolId = Int()
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        txtFirstName.delegate = CustomTextFieldDelegate.sharedInstance
        txtLastName.delegate = CustomTextFieldDelegate.sharedInstance
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: ScreenTitle.EditProfile, titleColor: .white)
        self.navigationItem.titleView = titleLabel
                
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        self.SetupSignup()
        
        self.txtSchool.text = Preferance.user.schoolName
        self.txtEmail.text = Preferance.user.email
        self.txtFirstName.text = Preferance.user.firstName!
        self.txtLastName.text = Preferance.user.lastName!
        self.txtPassCode.text = Preferance.user.suburb
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
        }
    }
    
    //MARK:- support method
    func SetupSignup(){
        self.lblfirst.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblLast.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblSchool.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblPassCode.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtFirstName.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtLastName.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtPassCode.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtSchool.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnSave.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        
        if DeviceType.IS_IPHONE{
            self.nslcSignUpWidth.isActive = true
            self.nslcSignUpHeight.isActive = true
        }
        else{
            self.nslcSignUpWidth.isActive = false
            self.nslcSignUpHeight.isActive = false
        }        
    }

    func editProfileValidation() {
        if (self.txtFirstName.text!.isBlank) {
            self.txtFirstName.text = "";
            showAlertWithFocus(message: Validation.enterFirstname, txtFeilds: self.txtFirstName, inView: self)
        }
        else if (self.txtFirstName.text?.containsEmoji)!{
            showAlertWithFocus(message: Validation.firstnameEmoji, txtFeilds: self.txtFirstName, inView: self)
        }
        else if (self.txtFirstName.text!.trim.count < 2) {
            showAlertWithFocus(message: Validation.enterMoreCharacterFirstName, txtFeilds: self.txtFirstName, inView: self)
        }
        else if (self.txtLastName.text!.isBlank) {
            self.txtLastName.text = "";
            showAlertWithFocus(message: Validation.enterLastName, txtFeilds: self.txtLastName, inView: self)
        }
        else if (self.txtLastName.text?.containsEmoji)!{
            showAlertWithFocus(message: Validation.lastnameEmoji, txtFeilds: self.txtLastName, inView: self)
        }
        else if (self.txtLastName.text!.trim.count < 2) {
            showAlertWithFocus(message: Validation.enterMoreCharacterLastName, txtFeilds: self.txtLastName, inView: self)
        }
        else if (self.txtPassCode.text!.isBlank && Preferance.user.userType == 2){
            showAlertWithFocus(message: Validation.enterSuburb, txtFeilds: self.txtPassCode, inView: self)
        }
        else if (self.txtSchool.text!.isBlank && Preferance.user.userType == 2){
            showAlertWithFocus(message: Validation.selectSchool, txtFeilds: self.txtSchool, inView: self)
        }
        else if (self.txtEmail.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterEmail, txtFeilds: self.txtEmail, inView: self)
        }
        else if (!isValidEmail(str: self.txtEmail.text!.trim)){
            showAlertWithFocus(message: Validation.enterValidEmail, txtFeilds: self.txtEmail, inView: self)
        }
        else{
            self.APICallGetProfile()
        }
    }
    
    //MARK:- txt delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
                nextVC.preferredContentSize = CGSize(width: 400,height: 200)
                popover.permittedArrowDirections = .unknown
                popover.sourceView = self.txtSchool
                popover.sourceRect = self.txtSchool.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
            return false
        }else if textField == self.txtPassCode{
            self.view.endEditing(true)
            let nextVC = SearchViewController.instantiate(fromAppStoryboard: .Main)
            nextVC.delegate = self
            nextVC.needSuburb = true
            nextVC.modalPresentationStyle = .overCurrentContext
            self.present(nextVC, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    //MARK:- schoolList delegate
    func saveText(objSchool : SchoolListModel){
        if Preferance.user.userType == 2{
            self.txtSchool.text = objSchool.schoolName
            self.isSchoolId = objSchool.schoolId!
        }
    }
    
    func saveFont(SelectedFont: Int) {
        
    }
    
    func saveCount(strText : String){
        print("No Use")
    }
        
    //MARK:- btn click event
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        let nextVC = AddStudentVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK:- tbl delegate/datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
            return cellFullName
        case 3:
            return  cellPassCode
        case 5:
            return  cellSchool
        case 7:
            return cellEmail
        case 9:
            return cellSaveButton
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE{
            return (indexPath.row % 2 == 0) ? 10 : (indexPath.row == 9) ? 40 : 80
        }
        else{
            return (indexPath.row % 2 == 0) ? ScreenSize.SCREEN_HEIGHT*0.02 : (indexPath.row == 9) ? ScreenSize.SCREEN_HEIGHT*0.11 :ScreenSize.SCREEN_HEIGHT*0.09            
        }
    }
    
    //MARK:- API Call
    func APICallGetProfile() {

        var params: [String: Any] = [ : ]
        params["firstName"] = self.txtFirstName.text?.trim
        params["lastName"] = self.txtLastName.text?.trim
        params["suburb"] = self.txtPassCode.text?.trim
        params["schoolId"] = Preferance.user.schoolId
        params["email"] = self.txtEmail.text?.trim

        APIManager.showLoader()
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + updateProfile, showLoader: true, vc:self) { (jsonData, error) in
            APIManager.hideLoader()

            if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                if let status = userData.status, status == 1{
                    if let user = userData.user {
                        let tempId = Preferance.user.schoolId
                        Preferance.user.firstName = user.firstName
                        Preferance.user.lastName = user.lastName
                        Preferance.user.schoolId = tempId
                        Preferance.user.schoolName = user.schoolName
                        Preferance.user.suburb = user.suburb
                        Preferance.user.teacher_Id = user.teacher_Id
                        Singleton.shared.save(object: Preferance.user.toJSON(), key: UserDefaultsKeys.userData)
                        self.navigationController?.popViewController(animated: true)
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
//MARK:- GMSSearchDelegate
extension TeacherEditProfileVC: SearchViewControllerDelegate{
    func searched(viewController: UIViewController, text: String, latitude: Double?, longitude: Double?, venueId: Int?) {
        print(text)
        self.txtPassCode.text = text
        viewController.dismiss(animated: true, completion: nil)
    }
}

