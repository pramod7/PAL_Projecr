//
//  ParentEditProfile.swift
//
//
//  Created by i-Verve on 23/12/20.
//

import UIKit

class ParentEditProfile: UIViewController,UITextFieldDelegate,SchoolListDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets variable
    @IBOutlet weak var tblParentEditProfile: UITableView!
    @IBOutlet weak var txtFirstName: PALTextField!{
        didSet{
            self.txtFirstName.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var txtLastName: PALTextField!{
        didSet{
            self.txtLastName.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var txtChildrenAccount: PALTextField!{
        didSet{
            txtChildrenAccount.setRightPaddingWithImage(placeholderTxt: "Select Children Count", img: UIImage(named: "Icon_downArrow")!, fontSize: 15, isLeftPadding: false)
        }
    }
    @IBOutlet weak var txtEmail: PALTextField!{
        didSet{
            self.txtEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var txtSubrub: PALTextField!{
        didSet{
            self.txtSubrub.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var btnEditProfile: UIButton!{
        didSet{
            self.btnEditProfile.layer.cornerRadius = 5
            self.btnEditProfile.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        }
    }
    @IBOutlet weak var lblfirst: UILabel!{
        didSet{
            self.lblfirst.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var lblLast: UILabel!{
        didSet{
            self.lblLast.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var lblSubrub: UILabel!{
        didSet{
            self.lblSubrub.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var lblChildernLinked: UILabel!{
        didSet{
            self.lblChildernLinked.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var lblEmail: UILabel!{
        didSet{
            self.lblEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet var cellFullName: UITableViewCell!
    @IBOutlet var cellSuburb: UITableViewCell!
    @IBOutlet var cellChildren: UITableViewCell!
    @IBOutlet var cellEmail: UITableViewCell!
    @IBOutlet var cellEditButton: UITableViewCell!
    
    @IBOutlet weak var nslcbtnEditHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnEditWidth: NSLayoutConstraint!
    
    //MARK: - btn Click
    @IBAction func btnEditClick(_ sender: Any) {
        self.editProfileValidation()
    }
    
    //MARK: - Local variable
    var pickerView = UIPickerView()
    var arrChildrenCount = [String]()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        txtFirstName.delegate = CustomTextFieldDelegate.sharedInstance
        txtLastName.delegate = CustomTextFieldDelegate.sharedInstance
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        if DeviceType.IS_IPHONE {
            self.pickerViewSetUp()
        }
        
        if DeviceType.IS_IPHONE{
            self.nslcbtnEditHeight.isActive = true
            self.nslcbtnEditWidth.isActive = true
        }
        else{
            self.nslcbtnEditHeight.isActive = false
            self.nslcbtnEditWidth.isActive = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.EditProfile, titleColor: .white)
            self.navigationItem.titleView = titleLabel
        }
        self.SetupProfile()
    }
    
    //MARK: - Support Method
    func SetupProfile(){
        
        if let fName = Preferance.user.firstName{
            self.txtFirstName.text = fName
        }
        if let lName = Preferance.user.lastName{
            self.txtLastName.text = lName
        }
        if let email = Preferance.user.email{
            self.txtEmail.text = email
        }
        if let suburb = Preferance.user.suburb{
            self.txtSubrub.text = suburb
        }
        if let childInfo = Preferance.user.childInfo{
            self.txtChildrenAccount.text = "\(childInfo.count)"
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
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.txtChildrenAccount.inputAccessoryView = toolBar
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
        else if (self.txtSubrub.text!.isBlank && Preferance.user.userType == 1){
            showAlertWithFocus(message: Validation.enterSuburb, txtFeilds: self.txtSubrub, inView: self)
        }
        else if (self.txtChildrenAccount.text!.isBlank && Preferance.user.userType == 1){
            showAlertWithFocus(message: Validation.enterChildrenCount, txtFeilds: self.txtChildrenAccount, inView: self)
        }
//        else if (self.txtEmail.text?.isBlank)!{
//            showAlertWithFocus(message: Validation.enterEmail, txtFeilds: self.txtEmail, inView: self)
//        }
//        else if (!isValidEmail(str: self.txtEmail.text!.trim)){
//            showAlertWithFocus(message: Validation.enterValidEmail, txtFeilds: self.txtEmail, inView: self)
//        }
        else{
            self.view.endEditing(true)
            self.APICallGetProfile()
        }
    }
    
    //MARK: - txt delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtChildrenAccount{
//            if DeviceType.IS_IPAD{
//                let nextVC = SchoolListVC.instantiate(fromAppStoryboard: .PopOverStoryboard)
//                nextVC.delegate = self
//                nextVC.isChildCount = true
//                let nav = UINavigationController(rootViewController: nextVC)
//                nav.modalPresentationStyle = .popover
//                if let popover = nav.popoverPresentationController {
//                    nextVC.preferredContentSize = CGSize(width: 300,height: 200)
//                    popover.permittedArrowDirections = .unknown
//                    popover.sourceView = self.txtChildrenAccount
//                    popover.sourceRect = self.txtChildrenAccount.bounds
//                }
//                self.present(nav, animated: true, completion: nil)
//                self.view.endEditing(true)
//                return false
//            }
            return false
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
        else if self.txtEmail == textField{
            return false
        }
        return true
    }
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
            return cellFullName
        case 3:
            return cellSuburb
        case 5:
            return cellChildren
        case 7:
            return cellEmail
        case 9:
            return cellEditButton
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE{
            return (indexPath.row % 2 == 0) ? 10 : (indexPath.row == 9) ? 100 : 80
        }
        else{
            return (indexPath.row % 2 == 0) ? ScreenSize.SCREEN_HEIGHT*0.02 : (indexPath.row == 9) ? ScreenSize.SCREEN_HEIGHT*0.11 :ScreenSize.SCREEN_HEIGHT*0.09
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
        print("No Use")
    }
    
    func saveCount(strText : String){
        self.txtChildrenAccount.text = strText as String
    }
    
    func saveFont(SelectedFont: Int) {
        
    }
    
    //MARK: - btn click event
    @objc func action() {
        self.view.endEditing(true)
    }
    
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - API Call
    func APICallGetProfile() {
        
        var params: [String: Any] = [ : ]
        params["firstName"] = self.txtFirstName.text?.trim
        params["lastName"] = self.txtLastName.text?.trim
        params["suburb"] = self.txtSubrub.text?.trim
        params["childCount"] = self.txtChildrenAccount.text?.trim
                
        APIManager.showLoader()
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + updateProfile, showLoader: true, vc:self) { (jsonData, error) in
            APIManager.hideLoader()
            
            if jsonData != nil {
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        Preferance.user.firstName = self.txtFirstName.text?.trim
                        Preferance.user.lastName = self.txtLastName.text?.trim
                        Preferance.user.suburb = self.txtSubrub.text?.trim
                        
                        Singleton.shared.save(object: Preferance.user.toJSON(), key: UserDefaultsKeys.userData)
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                            self.navigationController?.popViewController(animated: true)
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

//MARK: - GMSSearchDelegate
extension ParentEditProfile: SearchViewControllerDelegate{
    func searched(viewController: UIViewController, text: String, latitude: Double?, longitude: Double?, venueId: Int?) {
        print(text)
        self.txtSubrub.text = text
        viewController.dismiss(animated: true, completion: nil)
    }
}

