//
//  InterviewRequestVC.swift
//  PAL
//
//  Created by i-Phone7 on 26/11/20.
//

import UIKit

class InterviewRequestVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: - Outlet variable
    @IBOutlet weak var tblInterRewList: UITableView!
    
    @IBOutlet weak var cellDate: UITableViewCell!
    @IBOutlet weak var cellTime: UITableViewCell!
    @IBOutlet weak var cellUserInfo: UITableViewCell!
    @IBOutlet weak var cellBtnSave: UITableViewCell!
    
    @IBOutlet weak var txtDate: PALTextField!{
        didSet{
            txtDate.setRightPaddingWithImage(placeholderTxt: "Select Date", img: UIImage(named: "icon_calendar (1)")!, fontSize: 17, isLeftPadding:false)
        }
    }
    @IBOutlet weak var txtTime: PALTextField!{
        didSet{
            txtTime.setRightPaddingWithImage(placeholderTxt: "Select Time", img: UIImage(named: "Icon_Time")!, fontSize: 17, isLeftPadding:false)
        }
    }
    @IBOutlet weak var btnSave: UIButton!{
        didSet{
            btnSave.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
            btnSave.layer.cornerRadius = 22.5
        }
    }
    @IBOutlet weak var imgView: UIImageView!{
        didSet{
            imgView.layer.cornerRadius = (150*0.4)/2
        }
    }
    @IBOutlet weak var lblImgIcon: UILabel!{
        didSet{
            lblImgIcon.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    //MARK: - btn Click
    @IBAction func btnbtnSaveClick(_ sender: Any) {
        self.validateField()
    }
    
    //MARK: - local variable
    let datePicker = UIDatePicker()
    var parentName = String()
    var parentEmail = String()
    var studentId = Int()
    var strSelectedField = String()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Interview Request", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            self.lblName.text = self.parentName
            self.lblEmail.text = self.parentEmail
            //self.navigationItem.setHidesBackButton(true, animated: true)
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        self.setFont()
        self.setNameOnImage()
    }
    
    //MARK: - Support Method
    func setFont()  {
        self.txtDate.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtTime.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        
        self.lblDate.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblTime.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        
        self.lblName.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
        self.lblEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
        
        self.btnSave.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.btnSave.layer.cornerRadius = 5
    }
    
    func setNameOnImage() {
        self.lblImgIcon.text = self.parentName.first?.uppercased()
        self.lblImgIcon.textColor = .white
        UIGraphicsBeginImageContext(imgView.frame.size)
        UIGraphicsBeginImageContextWithOptions(self.lblImgIcon.bounds.size, false, UIScreen.main.scale)
        lblImgIcon.layer.render(in: UIGraphicsGetCurrentContext()!)
        imgView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.lblImgIcon.textColor = .clear
    }
    
    func validateField() {
        if (self.txtDate.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterDate, txtFeilds: self.txtDate, inView: self)
        }
        else if (self.txtTime.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterTime, txtFeilds: self.txtTime, inView: self)
        }
        else {
            APICallinterviewRequest(showLoader: true)
        }
    }

    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellUserInfo
        case 1:
            return cellDate
        case 2:
            return cellTime
        default:return cellBtnSave
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 1:
            return 120
        case 2:
            return 120
        default:
            return 180
        }
    }
    
    //MARK: - txt delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let alertView = UIAlertController(title: " ", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alertView.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        if !DeviceType.IS_IPAD{
            datePicker.center.x = self.view.center.x
        }
        alertView.view.addSubview(datePicker)
        if let popover = alertView.popoverPresentationController {
//            alertView.preferredContentSize = CGSize(width: 400,height: 400)
            popover.permittedArrowDirections = .up
            alertView.popoverPresentationController?.sourceView = (textField == self.txtDate) ? self.txtDate:self.txtTime
            alertView.popoverPresentationController?.sourceRect = (textField == self.txtDate) ? self.txtDate.bounds:self.txtTime.bounds
        }
        if textField == self.txtDate {
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Date()
        }
        else{
            datePicker.datePickerMode = .time
            datePicker.minimumDate = nil
        }
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            let dateFormatter = DateFormatter()
            if textField == self.txtDate {
                dateFormatter.dateFormat = "dd/MM/yyyy"
                self.txtDate.text = dateFormatter.string(from: self.datePicker.date)
            }
            else {
                dateFormatter.dateFormat = "HH:mm"
                self.txtTime.text = dateFormatter.string(from: self.datePicker.date)
            }
        })
        action.setValue(UIColor(named: "Color_appTheme")!, forKey: "titleTextColor")
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
        return false
    }
    
    //MARK: - btn Click
    @objc func btnBackClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func APICallinterviewRequest(showLoader: Bool){
        var params: [String: Any] = [ : ]
        
        params["studentId"] = studentId
        params["date"] = self.txtDate.text
        params["time"] = self.txtTime.text
        
        APIManager.shared.callPostApi(parameters:params, reqURL: URLs.APIURL + getUserTye() + interviewRequest, showLoader: showLoader, vc:self) { (jsonData, error) in
            APIManager.hideLoader()
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
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
