//
//  WorksheetManagement.swift
//  PAL
//
//  Created by i-Phone7 on 25/11/20.
//

import UIKit

class WorksheetManagement: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SubjectListDelegate {

    //MARK:- Outlet variable
    @IBOutlet weak var tblWorkManageList: UITableView!
    @IBOutlet weak var cellSubject: UITableViewCell!
    @IBOutlet weak var cellSubCategory: UITableViewCell!
    @IBOutlet weak var cellSelectFile: UITableViewCell!
    @IBOutlet weak var cellBtnSave: UITableViewCell!
    @IBOutlet weak var txtSubject: PALTextField!{
        didSet{
            txtSubject.setRightPaddingWithImage(placeholderTxt: "Select Subject", img: UIImage(named: "Icon_downArrow")!, fontSize: 17, isLeftPadding:false)
        }
    }
    @IBOutlet weak var txtVerb: PALTextField!{
        didSet{
            txtVerb.setRightPaddingWithImage(placeholderTxt: "Select Category", img: UIImage(named: "Icon_downArrow")!, fontSize: 17, isLeftPadding:false)
        }
    }
    @IBOutlet weak var btnSelectFile: UIButton!{
        didSet{
            btnSelectFile.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 18)
        }
    }
    @IBOutlet weak var btnSave: UIButton!{
        didSet{
            btnSave.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
            btnSave.layer.cornerRadius = 22.5
        }
    }
    
    //MARK:- btn Click
    @IBAction func btnSelectDocClick(_ sender: Any) {

    }
    
    @IBAction func btnbtnSaveClick(_ sender: Any) {
        self.validateField()
    }
    
    //MARK:- local variable
    var strTextFiled = String()
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Worksheet Management", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            //self.navigationItem.setHidesBackButton(true, animated: true)
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        self.setFont()
    }
    
    //MARK:- Support Method
    func setFont()  {
        self.txtSubject.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.txtVerb.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        
        self.btnSave.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.btnSave.layer.cornerRadius = 5
    }
    
    func validateField() {
        if (self.txtSubject.text?.isBlank)!{
            showAlertWithFocus(message: Validation.subjectName, txtFeilds: self.txtSubject, inView: self)
        }
        else if (self.txtVerb.text?.isBlank)!{
            showAlertWithFocus(message: Validation.categoryName, txtFeilds: self.txtVerb, inView: self)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            //cellSubject.backgroundColor = .cyan
            return cellSubject
        case 1:
            //cellSubCategory.backgroundColor = .red
            return cellSubCategory
        case 2:
            return cellSelectFile
        case 5:
            return cellBtnSave
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UploadPDFCell") as! UploadPDFCell
            cell.lblDocName.text = "Upload \(indexPath.row+1).pdf"
            cell.lblDocSize.text = "6.7 Mb"
            cell.lblProgress.text = "50%"
            
            if indexPath.row == 4 {
                cell.lblLine.isHidden = true
            }
            else {
                cell.lblLine.isHidden = false
            }
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 140
        case 1:
            return 140
        case 2:
            return 190
        case 5:
            return 160
        default:
            return 120
        }
    }
    
    //MARK:- saveSubject delegate
    func saveSubject(strText: NSString, strID: NSInteger) {
        if self.strTextFiled == "1"{
            self.txtSubject.text = strText as String
        }
        else {
            self.txtVerb.text = strText as String
        }
    }
    
    func saveChildInfo(childInfo: ChildInfoModel) {
        print("Child Info")
    }
        
    //MARK:- txt delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtSubject {
            self.strTextFiled = "1"
        }
        else if textField == self.txtVerb{
            self.strTextFiled = "2"
        }
        let nextVC = SubjectListPopOver.instantiate(fromAppStoryboard: .PopOverStoryboard)
        nextVC.delegate = self
        nextVC.isStudent = true
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            nextVC.preferredContentSize = CGSize(width: 400,height: 300)
            popover.permittedArrowDirections = .unknown
            popover.sourceView = self.txtSubject
            popover.sourceRect = self.txtSubject.bounds
        }
        self.present(nav, animated: true, completion: nil)
        self.view.endEditing(true)
        return false
    }
    
    //MARK:- btn Click
    @objc func btnBackClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
