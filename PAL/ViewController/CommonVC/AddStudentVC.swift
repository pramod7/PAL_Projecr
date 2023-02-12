//
//  AddStudentVC.swift
//  
//
//  Created by i-Verve on 28/10/20.
//

import UIKit

protocol DisplayViewControllerDelegate : NSObjectProtocol{
    func doSomethingWith(data: String,Id :Int)
    
}

class AddStudentVC: UIViewController, UITextViewDelegate, UITextFieldDelegate,  UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Outlet variable
    @IBOutlet weak var tblChild: UITableView!
    @IBOutlet weak var viewCard: UIView!
    
    @IBOutlet var cellStudentContainer: UITableViewCell!
    @IBOutlet var cellFullNameContainer: UITableViewCell!
    @IBOutlet var cellDOBContainer: UITableViewCell!
    @IBOutlet var cellbtnContainer: UITableViewCell!
    @IBOutlet var cellToolTipContainer: UITableViewCell!
    @IBOutlet var cellChildStrugleArea: UITableViewCell!
    @IBOutlet var celltxtView: UITableViewCell!
    
    @IBOutlet weak var lblStudentID: UILabel!
    @IBOutlet weak var txtStudentID: PALTextField!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var txtFirstName: PALTextField!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var txtLastName: PALTextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtDate: PALTextField!{
        didSet{
            txtDate.setRightPaddingWithImage(placeholderTxt: "Date of Birth", img: UIImage(named: "icon_calendar (1)")!, fontSize: 17, isLeftPadding: false)
        }
    }
    @IBOutlet weak var lblGendar: UILabel!
    @IBOutlet weak var btnBoy: UIButton!{
        didSet{
            btnBoy.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnGirl: UIButton!{
        didSet{
            btnGirl.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var lblHowOLd: UILabel!
    @IBOutlet weak var lblWhatArea: UILabel!
    @IBOutlet weak var btnReading: UIButton!
    @IBOutlet weak var btnWriting: UIButton!
    @IBOutlet weak var btnMaths: UIButton!
    @IBOutlet weak var btnOrganistion: UIButton!
    @IBOutlet weak var btnOthers: UIButton!
    @IBOutlet weak var btnAgeOne: UIButton!
    @IBOutlet weak var btnAgeTwo: UIButton!
    @IBOutlet weak var btnAgeThree: UIButton!
    @IBOutlet weak var btnAgeForth: UIButton!
    @IBOutlet weak var txtViewData: UITextView!{
        didSet{
            txtViewData.layer.cornerRadius = 5
            txtViewData.layer.borderWidth = 0.5
            txtViewData.layer.borderColor = UIColor(named: "Color_lightGrey_112")?.cgColor
            txtViewData.textColor = UIColor.kTextFieldColorColor()
        }
    }
    @IBOutlet var btnAddChild: UIButton!{
        didSet{
            btnAddChild.layer.cornerRadius = 5
            self.btnAddChild.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var nslcViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnSignUpHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnSignUpWidth: NSLayoutConstraint!
    
    //MARK:- local variable
    var studentId = String()
    var isFromSignUp = Bool()
    var isEdit = Bool()
    var childIndex = Int()
    var childInfoModel = ChildInfoModel()
    var howOldChild : String = ""
    var childStruggleArea : String = ""
    var datePickerChild = UIDatePicker(){
        didSet{
            self.datePickerChild.datePickerMode = .date
            self.datePickerChild.maximumDate = Date().maximumUserDate
            self.datePickerChild.minimumDate = Date().minimumUserDate
        }
    }
    var dismissAddStudent : ((Bool) -> Void)?
    weak var delegate : DisplayViewControllerDelegate?
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFirstName.delegate = CustomTextFieldDelegate.sharedInstance
        txtLastName.delegate = CustomTextFieldDelegate.sharedInstance
        self.setupChildSign()
        
        self.dataSetUp()
        if let strId = self.txtStudentID.text?.trim, strId.count > 0{
            self.enableDesabaleControl(enable: true)
        }
        else{
            self.enableDesabaleControl(enable: false)
        }
    }
    
    
    //MARK:- support method
    func dataSetUp(){
        if isFromSignUp {
            self.nslcViewTopSpace.constant = 0
            let param = arrChild[self.childIndex]
            
            var strGender = ""
            var strStrugle = ""
            var strOldChild = ""
            
            if let temp = param["gender"] as? String{
                strGender = temp
            }
            if let temp = param["childStrugleArea"] as? String{
                strStrugle = temp
            }
            if let temp = param["yearOldChild"] as? String{
                strOldChild = temp
            }
            self.childMetaData(gender:strGender, strText:strStrugle, strOldChild: strOldChild)
            if let tempID = param["student_Id"] as? String{
                self.txtStudentID.text = tempID
                self.studentId = tempID
            }
            if let tempFN = param["firstName"] as? String{
                self.txtFirstName.text = tempFN
            }
            if let tempLN = param["lastName"] as? String{
                self.txtLastName.text = tempLN
            }
            if let tempDOB = param["dob"] as? String{
                self.txtDate.text = tempDOB
            }
            if let tempView = param["otherDescription"] as? String{
                self.txtViewData.text = tempView
            }
            
            var isGender = "0"
            var isChildStrugle = String()
            var isOldChild = String()
            
            if let tempGender = param["gender"] as? String{
                isGender = tempGender
            }
            if let tempStrugle = param["childStrugleArea"] as? String{
                isChildStrugle = tempStrugle
            }
            if let tempOld = param["yearOldChild"] as? String{
                isOldChild = tempOld
            }
            
            self.childMetaData(gender: isGender, strText:isChildStrugle, strOldChild: isOldChild)
        }
        else{
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.nslcViewTopSpace.constant = 150
            self.viewCard.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 25)
            
            if self.isEdit {
                self.txtStudentID.text = self.childInfoModel?.student_Id?.trim
                self.txtFirstName.text = self.childInfoModel?.firstName?.trim
                self.txtLastName.text = self.childInfoModel?.lastName?.trim
                self.txtViewData.text = self.childInfoModel?.otherDescription?.trim
                
                if let dob = self.childInfoModel?.dob?.trim{
                    self.txtDate.text = dob
                }
                
                self.childMetaData(gender: (self.childInfoModel?.gender)!, strText: (self.childInfoModel?.childStrugleArea) ?? "", strOldChild: (self.childInfoModel?.yearOldChild)!)
            }
            else{
                btnGirl.btnUnSelectBorder()
                btnBoy.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
            }
            if self.txtViewData.text.trim.count > 0{
                self.btnOthers.isSelected = true
                self.tblChild.reloadRows(at: [IndexPath(row: 13, section: 0)], with: .none)
            }
        }
    }
    
    func childMetaData(gender: String, strText: String, strOldChild: String){
        if gender == "0" {
            btnGirl.btnUnSelectBorder()
            btnBoy.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
        }
        else {
            btnBoy.btnUnSelectBorder()
            btnGirl.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
        }
        
        if strText == "Reading" {
            self.btnChallengeAreaClick(self.btnReading)
        }
        else if strText == "Writing" {
            self.btnChallengeAreaClick(self.btnWriting)
        }
        else if strText == "Maths" {
            self.btnChallengeAreaClick(self.btnMaths)
        }
        else if strText == "Organisiton & Planing" {
            self.btnChallengeAreaClick(self.btnOrganistion)
        }
        else if strText == "Others" {
            btnSetup(btn: btnMaths)
            btnSetup(btn: btnReading)
            btnSetup(btn: btnWriting)
            btnSetup(btn: btnOrganistion)
            btnOthers.btnSelectedSetup(color: UIColor.kAppThemeColor())
            self.tblChild.reloadRows(at: [IndexPath(row: 13, section: 0)], with: .none)
        }
        self.childStruggleArea = strText
        
        if strOldChild == "3-5" {
            self.btnAgeClick(self.btnAgeOne)
        }
        else if strOldChild == "5-8" {
            self.btnAgeClick(self.btnAgeTwo)
        }
        else if strOldChild == "8-11" {
            self.btnAgeClick(self.btnAgeThree)
        }
        else if strOldChild == "11-13" {
            self.btnAgeClick(self.btnAgeForth)
        }
        self.howOldChild = strOldChild
    }
    
    func setupChildSign(){
        self.navigationController?.isNavigationBarHidden = false
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Add Child", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(BackClicked), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        
        btnSetup(btn: btnMaths)
        btnSetup(btn: btnReading)
        btnSetup(btn: btnWriting)
        btnSetup(btn: btnOrganistion)
        btnSetup(btn: btnOthers)
        btnAgeOne.btnUnSelectBorder()
        btnAgeTwo.btnUnSelectBorder()
        btnAgeThree.btnUnSelectBorder()
        btnAgeForth.btnUnSelectBorder()
        
        lblStudentID.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtStudentID.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblFirstName.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtFirstName.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblLastName.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtLastName.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblDate.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtDate.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtViewData.font = UIFont.Font_ProductSans_Regular(fontsize: 12)
        lblGendar.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblHowOLd.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblWhatArea.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        
        self.btnBoy.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnGirl.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnWriting.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnReading.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnMaths.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnOrganistion.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnOthers.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnAgeOne.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnAgeTwo.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnAgeThree.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnAgeForth.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        
        if DeviceType.IS_IPHONE{
            self.txtDate.inputView = self.datePickerChild
            let toolbar = UIToolbar();
            toolbar.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            toolbar.sizeToFit()
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonDatePicker));
            toolbar.setItems([spaceButton,doneButton], animated: false)
            txtDate.inputAccessoryView = toolbar
        }
        if #available(iOS 13.4, *) {
            self.datePickerChild.preferredDatePickerStyle = .wheels
        }
        
        if DeviceType.IS_IPHONE {
            self.nslcbtnSignUpWidth.isActive = true
            self.nslcbtnSignUpHeight.isActive = true
        }
        else {
            self.nslcbtnSignUpWidth.isActive = false
            self.nslcbtnSignUpHeight.isActive = false
        }
    }
   
    func childAddValidation() {
        if self.txtStudentID.text?.trim.count == 0 {
            self.txtStudentID.text = "";
            showAlertWithFocus(message: "Please enter Student Id.", txtFeilds: self.txtStudentID, inView: self)
        }
        else if self.txtFirstName.text?.trim.count == 0 {
            self.txtFirstName.text = "";
            showAlertWithFocus(message: Validation.enterFirstname, txtFeilds: self.txtFirstName, inView: self)
        }
        //        else if (self.txtFirstName.text!.trim.count < 2) {
        //            showAlertWithFocus(message: Validation.enterMoreCharacterFirstName, txtFeilds: self.txtFirstName, inView: self)
        //        }
        else if self.txtLastName.text?.trim.count == 0{
            self.txtLastName.text = "";
            showAlertWithFocus(message: Validation.enterLastName, txtFeilds: self.txtLastName, inView: self)
        }
        //        else if (self.txtLastName.text!.trim.count < 2) {
        //            showAlertWithFocus(message: Validation.enterMoreCharacterLastName, txtFeilds: self.txtLastName, inView: self)
        //        }
        else if self.txtDate.text?.trim.count == 0{
            showAlertWithFocus(message: "Please select Date of Birth.", txtFeilds: self.txtDate, inView: self)
        }
        else if self.howOldChild == "" {
            showAlert(title: APP_NAME, message: "Please select How old is your child.")
        }
        else if self.childStruggleArea == "" {
            showAlert(title: APP_NAME, message: "Please select your child struggle area.")
        }
        else if self.childStruggleArea == "Others" && self.txtViewData.text.trim.count == 0{
            ViewshowAlertWithFocus(message: "Please enter struggle area of your child.", txtFeilds: self.txtViewData, inView: self)
        }
        else{
            self.view.endEditing(true)
            
            if self.isFromSignUp {
                
                arrChild[childIndex]["childId"] = self.childInfoModel?.childId
                arrChild[childIndex]["firstName"] = self.txtFirstName.text?.trim
                arrChild[childIndex]["lastName"] = self.txtLastName.text?.trim
                arrChild[childIndex]["student_Id"] = self.txtStudentID.text?.trim
                arrChild[childIndex]["gender"] = self.btnBoy.isSelected ? 0:1
                arrChild[childIndex]["yearOldChild"] = self.howOldChild
                arrChild[childIndex]["dob"] = self.txtDate.text
                arrChild[childIndex]["childStrugleArea"] = self.childStruggleArea
                arrChild[childIndex]["teacherLinkId"] = Preferance.user.teacher_Id
                arrChild[childIndex]["otherDescription"] = self.txtViewData.text.trim
                if let delegate = delegate{
                    delegate.doSomethingWith(data: "\(self.txtFirstName.text ?? "") \(self.txtLastName.text ?? "")", Id: self.childIndex)
                    
                }
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.APICallAddStudent()
            }
        }
    }
   
    func enableDesabaleControl(enable: Bool){
        self.txtFirstName.isUserInteractionEnabled = enable
        self.txtLastName.isUserInteractionEnabled = enable
        self.txtDate.isUserInteractionEnabled = enable
        
        self.btnGirl.isUserInteractionEnabled = enable
        self.btnBoy.isUserInteractionEnabled = enable
        
        self.btnAgeOne.isUserInteractionEnabled = enable
        self.btnAgeTwo.isUserInteractionEnabled = enable
        self.btnAgeThree.isUserInteractionEnabled = enable
        self.btnAgeForth.isUserInteractionEnabled = enable
        
        self.btnReading.isUserInteractionEnabled = enable
        self.btnWriting.isUserInteractionEnabled = enable
        self.btnMaths.isUserInteractionEnabled = enable
        self.btnOrganistion.isUserInteractionEnabled = enable
        self.btnOthers.isUserInteractionEnabled = enable
    }
    
    //MARK:- btn click
    @objc func doneButtonDatePicker() {
        self.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        self.txtDate.text = formatter.string(from: datePickerChild.date)
        self.txtDate.resignFirstResponder()
    }
    
    @objc func BackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnSetup(btn:UIButton){
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.kAppThemeColor().cgColor
        btn.layer.cornerRadius = 5
        btn.setTitleColor(.black, for: .normal)
        btn.isSelected = false
    }
    
    @IBAction func btnDismissClick(_ sender: UIButton) {
        if let _ = self.dismissAddStudent{
            self.dismissAddStudent!(false)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnGenderClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            btnGirl.btnUnSelectBorder()
            btnBoy.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
        default:
            btnBoy.btnUnSelectBorder()
            btnGirl.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
        }
    }
    
    @IBAction func btnAgeClick(_ sender: UIButton) {
        self.howOldChild = (sender.titleLabel?.text)!
        switch sender.tag {
        case 0:
            btnAgeOne.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
            btnAgeTwo.btnUnSelectBorder()
            btnAgeThree.btnUnSelectBorder()
            btnAgeForth.btnUnSelectBorder()
        case 1:
            btnAgeTwo.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
            btnAgeOne.btnUnSelectBorder()
            btnAgeThree.btnUnSelectBorder()
            btnAgeForth.btnUnSelectBorder()
        case 2:
            btnAgeOne.btnUnSelectBorder()
            btnAgeTwo.btnUnSelectBorder()
            btnAgeThree.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
            btnAgeForth.btnUnSelectBorder()
        case 3:
            btnAgeOne.btnUnSelectBorder()
            btnAgeTwo.btnUnSelectBorder()
            btnAgeThree.btnUnSelectBorder()
            btnAgeForth.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
        default:
            btnAgeOne.btnUnSelectBorder()
            btnAgeTwo.btnUnSelectBorder()
            btnAgeThree.btnUnSelectBorder()
            btnAgeForth.btnUnSelectBorder()
        }
    }
    
    @IBAction func btnChallengeAreaClick(_ sender: UIButton) {
        self.childStruggleArea = (sender.titleLabel?.text)!
        
        switch sender.tag {
        case 0:
            btnReading.btnSelectedSetup(color: UIColor.kAppThemeColor())
            btnSetup(btn: btnWriting)
            btnSetup(btn: btnOrganistion)
            btnSetup(btn: btnOthers)
            break
        case 1:
            btnSetup(btn: btnMaths)
            btnSetup(btn: btnReading)
            btnWriting.btnSelectedSetup(color: UIColor.kAppThemeColor())
            btnSetup(btn: btnOrganistion)
            btnSetup(btn: btnOthers)
            break
        case 2:
            btnMaths.btnSelectedSetup(color: UIColor.kAppThemeColor())
            btnSetup(btn: btnReading)
            btnSetup(btn: btnWriting)
            btnSetup(btn: btnOrganistion)
            btnSetup(btn: btnOthers)
            break
        case 3:
            btnSetup(btn: btnMaths)
            btnSetup(btn: btnReading)
            btnSetup(btn: btnWriting)
            btnOrganistion.btnSelectedSetup(color: UIColor.kAppThemeColor())
            btnSetup(btn: btnOthers)
            break
        case 4:
            btnSetup(btn: btnMaths)
            btnSetup(btn: btnReading)
            btnSetup(btn: btnWriting)
            btnSetup(btn: btnOrganistion)
            btnOthers.btnSelectedSetup(color: UIColor.kAppThemeColor())
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let indexPath = NSIndexPath(row: 13, section: 0) as IndexPath
                self.tblChild.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            break
        default:
            btnSetup(btn: btnMaths)
            btnSetup(btn: btnReading)
            btnSetup(btn: btnWriting)
            btnSetup(btn: btnOrganistion)
            btnSetup(btn: btnOthers)
            break
        }
        self.tblChild.reloadRows(at: [IndexPath(row: 13, section: 0)], with: .none)

    }
    
    @IBAction func btnAddChildClick(_ sender: Any) {
        self.childAddValidation()
    }
                
    @IBAction func btnToolTipClick(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME, message: ScreenText.childToolTip, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- API Call
    func APICallGetStudent() {
        
        var params: [String: Any] = [ : ]
        params["childId"] = self.txtStudentID.text?.trim
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getStudentInfoById, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let childTemp = userData.childInfo {
                            if let temp_ID = childTemp.student_Id{
                                self.studentId = temp_ID
                            }
                            self.childInfoModel = childTemp
                            self.enableDesabaleControl(enable: true)
                        
                            self.txtFirstName.text = childTemp.firstName
                            self.txtLastName.text = childTemp.lastName
                            if  childTemp.gender == "0" {
                                self.btnGirl.btnUnSelectBorder()
                                self.btnBoy.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
                            }
                            else {
                                self.btnBoy.btnUnSelectBorder()
                                self.btnGirl.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
                            }
                            
                            if let dob = childTemp.dob{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy"
                                if let dateTemp = formatter.date(from: dob){
                                    formatter.dateFormat = "d MMM yyyy"
                                    self.txtDate.text = formatter.string(from: dateTemp)
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
                            
                            self.txtFirstName.text = ""
                            self.txtLastName.text = ""
                            self.txtDate.text = ""
                            self.txtDate.text = ""
                            self.txtViewData.text = ""
                            
                            self.btnAgeOne.btnUnSelectBorder()
                            self.btnAgeTwo.btnUnSelectBorder()
                            self.btnAgeThree.btnUnSelectBorder()
                            self.btnAgeForth.btnUnSelectBorder()
                            
                            self.btnSetup(btn: self.btnMaths)
                            self.btnSetup(btn: self.btnReading)
                            self.btnSetup(btn: self.btnWriting)
                            self.btnSetup(btn: self.btnOrganistion)
                            self.btnSetup(btn: self.btnOthers)
                            self.tblChild.reloadRows(at: [IndexPath(row: 13, section: 0)], with: .none)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                let indexPath = NSIndexPath(row: 13, section: 0) as IndexPath
                                self.tblChild.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func APICallAddStudent() {
        var params: [String: Any] = [ : ]
        
        params["childId"] = self.childInfoModel?.childId
        params["firstName"] = self.txtFirstName.text?.trim
        params["lastName"] = self.txtLastName.text?.trim
        params["student_Id"] = self.txtStudentID.text?.trim
        params["gender"] = self.btnBoy.isSelected ? 0:1
        params["yearOldChild"] = self.howOldChild
        params["dob"] = self.txtDate.text!.trim
        params["childStrugleArea"] = self.childStruggleArea
        params["otherDescription"] = (self.childStruggleArea.trim == "Others") ?self.txtViewData.text?.trim:""
        
        var arrPayment = [[String:Any]]()
        arrPayment.append(params)
        
        var paramTemp: [String: Any] = [ : ]
        paramTemp["data"] = arrPayment
        
        APIManager.shared.callPostAPI(url: URLs.APIURL + getUserTye() + addEditChild, parameters: paramTemp, showLoader: true) { (status, dictResponse, errorMessage) in
            DispatchQueue.main.async(execute: {
                if (status){
                    if let _ = self.dismissAddStudent{
                        self.dismissAddStudent!(true)
                    }
                   
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    if let msg = errorMessage {
                        showAlert(title: APP_NAME, message: msg)
                    }
                }
            })
        }
    }
    
    //MARK:- txtField delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtStudentID {
            if let tempID = textField.text?.trim, tempID.count > 0{
                if self.studentId != tempID{
                    self.APICallGetStudent()
                }
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtDate && DeviceType.IS_IPAD{

            self.view.endEditing(true)
            let alertView = UIAlertController(title:" ", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet);
            alertView.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            if !DeviceType.IS_IPAD{
                self.datePickerChild.center.x = self.view.center.x
            }
            alertView.view.addSubview(datePickerChild)
            if let popover = alertView.popoverPresentationController {
                popover.permittedArrowDirections = .up
                alertView.popoverPresentationController?.sourceView = self.txtDate
                alertView.popoverPresentationController?.sourceRect = self.txtDate.bounds
            }
            let action = UIAlertAction(title: Messages.OK, style: .default, handler: { (alert) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM yyyy"
                self.txtDate.text = dateFormatter.string(from: self.datePickerChild.date)
            })
            action.setValue(UIColor(named: "Color_appTheme")!, forKey: "titleTextColor")
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1:
            return cellStudentContainer
        case 3:
            return cellFullNameContainer
        case 5:
            return cellDOBContainer
        case 7:
            //cellbtnContainer.backgroundColor = .red
            return cellbtnContainer
        case 9:
            //cellToolTipContainer.backgroundColor = .red
            return cellToolTipContainer
        case 11:
            //cellChildStrugleArea.backgroundColor = .red
            return cellChildStrugleArea
        case 13:
            //celltxtView.backgroundColor = .red
            return celltxtView
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return ScreenSize.SCREEN_HEIGHT*0.09
        case 3:
            return ScreenSize.SCREEN_HEIGHT*0.09
        case 5:
            return ScreenSize.SCREEN_HEIGHT*0.09
        case 7:
            return DeviceType.IS_IPHONE ?170:220
        case 9:
            return DeviceType.IS_IPHONE ? 50:50
        case 11:
            return DeviceType.IS_IPHONE ?280:340
        case 13:
            return (self.btnOthers.isSelected) ?100:0
        default:
            return  DeviceType.IS_IPHONE ? 20:20
        }
    }
}
