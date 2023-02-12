//
//  AddNewStudentVC.swift
//  PAL
//
//  Created by i-Verve on 07/11/20.
//

import UIKit

protocol ParentProfileDelegate{
    func dimissEditVC()
}

class AddNewStudentVC: UIViewController,UITextFieldDelegate {
    
    //MARK:- Outlet variable
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblAddNewStudent: UILabel!
    @IBOutlet weak var lblfirst: UILabel!
    @IBOutlet weak var lblLast: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var lblTechaerID: UILabel!
    @IBOutlet weak var txtTeacherID: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var tblStudent: UITableView!
    @IBOutlet var cellOne: UITableViewCell!
    @IBOutlet var cellSecond: UITableViewCell!
    @IBOutlet var cellThird: UITableViewCell!
    @IBOutlet var cellForth: UITableViewCell!
    @IBOutlet var cellFifth: UITableViewCell!
    @IBOutlet var cellSix: UITableViewCell!
    @IBOutlet var cellSeven: UITableViewCell!
    @IBOutlet weak var btnLink: UIButton!
    @IBOutlet weak var btnBoy: UIButton!
    @IBOutlet weak var btnGirl: UIButton!
    @IBOutlet weak var btnAddnew: UIButton!
    @IBOutlet weak var objView: UIView!
    
    //@IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var btnAddIphone: NSLayoutConstraint!
    @IBOutlet weak var btnLinkIphone: NSLayoutConstraint!
    @IBOutlet weak var btnBoyIphone: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnGenderWidth: NSLayoutConstraint!
    //@IBOutlet weak var lblAddNewLeading: NSLayoutConstraint!
    //@IBOutlet weak var tblWidth: NSLayoutConstraint!
    
    //MARK:- Local variable
    var delegate: ParentProfileDelegate?
    var isFromAdd = true
    var datePicker = UIDatePicker(){
        didSet{
            self.datePicker.datePickerMode = UIDatePicker.Mode.date
            self.datePicker.datePickerMode = .date
            var components = DateComponents()
            components.year = -100
            self.datePicker.minimumDate = Calendar.current.date(byAdding: components, to: Date())
            
            components.year = -18
            self.datePicker.maximumDate = Calendar.current.date(byAdding: components, to: Date())
        }
    }
    
    //MARK:- life cyclt
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        txtFirstName.delegate = CustomTextFieldDelegate.sharedInstance
        txtLastName.delegate = CustomTextFieldDelegate.sharedInstance
        self.SetupAddStudent()
    }
    
    //MARK:- Support Method
    func SetupAddStudent(){
        objView.layer.cornerRadius = 20
        btnUnSelectedSetupNew(btn: btnGirl)
        btnBoy.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
        btnUnSelectedSetupNew(btn: btnLink)
        btnAddnew.layer.cornerRadius = 5
        
        if isFromAdd == true{
            self.lblAddNewStudent.text = "Add New Student"
            btnAddnew.setTitle("Add Now", for: .normal)
        }
        else{
            self.lblAddNewStudent.text = "Edit"
            btnAddnew.setTitle("Save Now", for: .normal)
        }
        self.lblAddNewStudent.font = UIFont.Font_ProductSans_Bold(fontsize: 18)
        self.lblfirst.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblLast.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblPassword.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.lblGender.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblusername.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblDate.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.lblTechaerID.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtFirstName.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtLastName.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtPassword.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtDate.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtUsername.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtTeacherID.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.btnGirl.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.btnBoy.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.btnLink.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.btnAddnew.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        
        if DeviceType.IS_IPHONE{
            //self.viewTop.constant = 100
            //self.lblAddNewLeading.constant = -10
            self.btnAddIphone.isActive = true
            self.btnLinkIphone.isActive = true
            self.btnBoyIphone.isActive = true
            self.nslcbtnGenderWidth.isActive = true
            //self.tblWidth.isActive = true
        }
        else{
            //self.viewTop.constant = 160
            //self.lblAddNewLeading.constant = -30
            self.btnAddIphone.isActive = false
            self.btnLinkIphone.isActive = false
            self.btnBoyIphone.isActive = false
            self.nslcbtnGenderWidth.isActive = false
            //self.tblWidth.isActive = false
        }
        
        if DeviceType.IS_IPHONE{
            self.txtDate.inputView = self.datePicker
            let toolbar = UIToolbar();
            toolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            toolbar.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            toolbar.sizeToFit()
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonDatePicker));
            toolbar.setItems([spaceButton,doneButton], animated: false)
            txtDate.inputAccessoryView = toolbar
        }
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    func btnUnSelectedSetupNew(btn:UIButton){
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.kbtnAgeSetup().cgColor
        btn.layer.cornerRadius = 5
        btn.setTitleColor(UIColor.black, for: .normal)
    }
    func AddStudentValidation() {
        if (self.txtFirstName.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterFirstname, txtFeilds: self.txtFirstName, inView: self)
        }
        else if (self.txtLastName.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterLastName, txtFeilds: self.txtLastName, inView: self)
        }
        else if (self.txtDate.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterBirthdate, txtFeilds: self.txtDate, inView: self)
        }
        else if (self.txtUsername.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterusername, txtFeilds: self.txtUsername, inView: self)
        }
        else if (self.txtPassword.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterPassword, txtFeilds: self.txtPassword, inView: self)
        }
        else if (!(self.txtPassword.text?.trim.isValidPassword)!){
            showAlertWithFocus(message: Validation.validPassword, txtFeilds: self.txtPassword, inView: self)
        }
        else if (self.txtTeacherID.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterTeacherID, txtFeilds: self.txtTeacherID, inView: self)
        }
        else{
            self.delegate?.dimissEditVC()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:- btn Click
    @IBAction func btndimissClick(_ sender: Any) {
        self.delegate?.dimissEditVC()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBoyClick(_ sender: Any) {
        btnUnSelectedSetupNew(btn: btnGirl)
        btnBoy.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
    }
    
    @IBAction func btnGirlClick(_ sender: Any) {
        btnUnSelectedSetupNew(btn: btnBoy)
        btnGirl.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
    }
    
    @IBAction func btnLinkClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            sender.setTitle("Unlink", for: .normal)
            btnLink.btnSelectedSetup(color: UIColor.kbtnAgeSetup())
        }
        else {
            sender.setTitle("Link", for: .normal)
            btnUnSelectedSetupNew(btn: btnLink)
        }
    }
    
    @IBAction func btnAddNow(_ sender: Any) {
         self.AddStudentValidation()
    }
    
    @objc func doneButtonDatePicker() {
        self.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.txtDate.text = formatter.string(from: datePicker.date)
        self.txtDate.resignFirstResponder()
    }
    
    //MARK:- TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtDate && DeviceType.IS_IPAD{
            let alertView = UIAlertController(title:" ", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet);
            alertView.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            if !DeviceType.IS_IPAD{
                datePicker.center.x = self.view.center.x
            }
            alertView.view.addSubview(datePicker)
            if let popover = alertView.popoverPresentationController {
                //            alertView.preferredContentSize = CGSize(width: 400,height: 400)
                popover.permittedArrowDirections = .up
                alertView.popoverPresentationController?.sourceView = self.txtDate
                alertView.popoverPresentationController?.sourceRect = self.txtDate.bounds
            }
            datePicker.datePickerMode = .date
//            datePicker.minimumDate = Date()
            let action = UIAlertAction(title: Messages.OK, style: .default, handler: { (alert) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                self.txtDate.text = dateFormatter.string(from: self.datePicker.date)
            })
            action.setValue(UIColor(named: "Color_appTheme")!, forKey: "titleTextColor")
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        return true
    }
}

extension AddNewStudentVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            //cellOne.backgroundColor = .red
            return cellOne
        }
        else if indexPath.row == 2{
            //cellSecond.backgroundColor = .cyan
            return cellSecond
        }
        else if indexPath.row == 4{
            //cellThird.backgroundColor = .red
            return cellThird
        }
        else if indexPath.row == 6{
            //cellForth.backgroundColor = .cyan
            return cellForth
        }
        else if indexPath.row == 8{
            //cellFifth.backgroundColor = .red
            return cellFifth
        }
        else if indexPath.row == 10{
            //cellSix.backgroundColor = .cyan
            return cellSix
        }
        else if indexPath.row == 12{
            //cellSeven.backgroundColor = .red
            return cellSeven
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE{
            if (indexPath.row % 2 == 1){
                return 10
            }
            else{
                return (indexPath.row == 4) ? 90:80
            }
        }
        else{
            return (indexPath.row % 2 == 1) ? ScreenSize.SCREEN_HEIGHT*0.02 : (indexPath.row == 4 ) ? ScreenSize.SCREEN_HEIGHT*0.10: ScreenSize.SCREEN_HEIGHT*0.09
        }
    }
}
