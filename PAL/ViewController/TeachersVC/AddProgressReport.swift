//
//  AddProgressReport.swift
//  PAL Design
//
//  Created by i-Phone7 on 24/11/20.
//

import UIKit

class AddProgressReport: UIViewController, UITableViewDelegate, UITableViewDataSource, SubjectListDelegate, UITextViewDelegate, UITextFieldDelegate, StudentListDelegate {
    
    //MARK: - Outlet variable
    @IBOutlet weak var tblReport: UITableView!
    @IBOutlet weak var cellSelectStudent: UITableViewCell!
    @IBOutlet weak var cellSelectSubject: UITableViewCell!
    @IBOutlet weak var cellParticipation: UITableViewCell!
    @IBOutlet weak var cellProgress: UITableViewCell!
    @IBOutlet weak var cellBehaviour: UITableViewCell!
    @IBOutlet weak var cellAttention: UITableViewCell!
    @IBOutlet weak var cellGeneral: UITableViewCell!
    @IBOutlet weak var cellButton: UITableViewCell!
    
    @IBOutlet weak var lblStudentStatic: UILabel!
    @IBOutlet weak var lblSubjectStatic: UILabel!
    @IBOutlet weak var lblParticipationStatic: UILabel!
    @IBOutlet weak var lblProgressStatic: UILabel!
    @IBOutlet weak var lblBehaviourStatic: UILabel!
    @IBOutlet weak var lblAttentionStatic: UILabel!
    @IBOutlet weak var lblGeneralStatic: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!{
        didSet{
            //imgArrow.transform = imgArrow.transform.rotated(by: .pi/2)
        }
    }
    @IBOutlet weak var btnCreate: UIButton!
    
    @IBOutlet weak var txtSelectStudent: PALTextField!{
        didSet{
                txtSelectStudent.setRightPaddingWithImage(placeholderTxt: "Select Student", img: UIImage(named: "Icon_downArrow")!, fontSize: 15, isLeftPadding: false)
        }
    }
    
    @IBOutlet weak var txtSelectSubject: PALTextField!{
        didSet{
            txtSelectSubject.setRightPaddingWithImage(placeholderTxt: "Select Subject", img: UIImage(named: "Icon_downArrow")!, fontSize: 15, isLeftPadding: false)
        }
    }
    @IBOutlet weak var txtParticipation: UITextView!
    @IBOutlet weak var txtProgress: UITextView!
    @IBOutlet weak var txtBehaviour: UITextView!
    @IBOutlet weak var txtAttention: UITextView!
    @IBOutlet weak var txtGeneral: UITextView!
    
    
    var SubjectID = 0
    var StudentID = 0
    var isProgress = Bool()
    var studentName = ""
    //MARK: - btn Click
    @IBAction func btnCreateClick(_ sender: Any) {
        self.validateField()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if isProgress == false{
            txtSelectStudent.text = studentName
        }
        print("\(isProgress)")
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.ProgressReport, titleColor: .white)
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
    
    //MARK: - Support Methof
    func setFont()  {
        self.lblStudentStatic.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblSubjectStatic.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblProgressStatic.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblParticipationStatic.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblBehaviourStatic.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblAttentionStatic.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblGeneralStatic.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        
        self.txtSelectStudent.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtSelectSubject.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtProgress.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtParticipation.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtBehaviour.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtAttention.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtGeneral.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        
        self.txtSelectStudent.textColor = UIColor.kTextFieldColorColor()
        self.txtSelectSubject.textColor = UIColor.kTextFieldColorColor()
        self.txtProgress.textColor = UIColor.kTextFieldColorColor()
        self.txtParticipation.textColor = UIColor.kTextFieldColorColor()
        self.txtBehaviour.textColor = UIColor.kTextFieldColorColor()
        self.txtAttention.textColor = UIColor.kTextFieldColorColor()
        self.txtGeneral.textColor = UIColor.kTextFieldColorColor()
        
        self.btnCreate.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.btnCreate.layer.cornerRadius = 5
//        
//        self.txtSelectSubject.textColor = UIColor(named: "Color_Light")
    }
    
    func scrollToRow(index: Int) {
        let indexPath = NSIndexPath(row: index, section: 0)
        self.tblReport.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    func validateField() {
        
        if (self.txtSelectStudent.text?.isBlank)!{
            self.scrollToRow(index: 0)
            showAlertWithFocus(message: Validation.studentName, txtFeilds: self.txtSelectStudent, inView: self)
        }
        else if (self.txtSelectSubject.text?.isBlank)!{
            self.scrollToRow(index: 1)
            showAlertWithFocus(message: Validation.subjectName, txtFeilds: self.txtSelectSubject, inView: self)
        }
        else if (self.txtProgress.text?.isBlank)!{
            self.scrollToRow(index: 2)
            showAlertWithFocusOnTxtView(message: Validation.progressMssg, txtFeilds: self.txtProgress, inView: self)
        }
        else if ((self.txtProgress.text?.trim.count)! < 2){
            self.scrollToRow(index: 2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showAlertWithFocusOnTxtView(message: Validation.progressMssgError, txtFeilds: self.txtProgress, inView: self)
            }
        }
        else if (self.txtParticipation.text?.isBlank)!{
            self.scrollToRow(index: 3)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showAlertWithFocusOnTxtView(message: Validation.participationMssg, txtFeilds: self.txtParticipation, inView: self)
            }
        }
        else if ((self.txtParticipation.text?.trim.count)! < 2){
            self.scrollToRow(index: 3)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showAlertWithFocusOnTxtView(message: Validation.participationMssgError, txtFeilds: self.txtParticipation, inView: self)
            }
        }
        else if (self.txtBehaviour.text?.isBlank)!{
            self.scrollToRow(index: 4)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showAlertWithFocusOnTxtView(message: Validation.behaviourMssg, txtFeilds: self.txtBehaviour, inView: self)
            }
        }
        else if ((self.txtBehaviour.text?.trim.count)! < 2){
            self.scrollToRow(index: 4)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showAlertWithFocusOnTxtView(message: Validation.behaviourMssgError, txtFeilds: self.txtBehaviour, inView: self)
            }
        }
        else if (self.txtAttention.text?.isBlank)!{
            self.scrollToRow(index: 5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showAlertWithFocusOnTxtView(message: Validation.attentionMssg, txtFeilds: self.txtAttention, inView: self)
            }
        }
        else if ((self.txtAttention.text?.trim.count)! < 2){
            self.scrollToRow(index: 5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showAlertWithFocusOnTxtView(message: Validation.attentionMssgError, txtFeilds: self.txtAttention, inView: self)
            }
        }
        else if (self.txtGeneral.text?.isBlank)!{
            self.scrollToRow(index: 6)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showAlertWithFocusOnTxtView(message: Validation.generalNotesMssg, txtFeilds: self.txtGeneral, inView: self)
            }
        }
        else if ((self.txtGeneral.text?.trim.count)! < 2){
            self.scrollToRow(index: 6)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showAlertWithFocusOnTxtView(message: Validation.generalNotesMssgError, txtFeilds: self.txtGeneral, inView: self)
            }
        }
        else{
            self.view.endEditing(true)
            self.APICallAddProgress()
        }
    }
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellSelectStudent
        case 1:
            return cellSelectSubject
        case 2:
            return cellProgress
        case 3:
            return cellParticipation
        case 4:
            return cellBehaviour
        case 5:
            return cellAttention
        case 6:
            return cellGeneral
        default:
            return cellButton
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 6) ? 170 : (indexPath.row == 0 || indexPath.row == 1) ?150:200
    }
    
    //MARK: - txt delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtSelectSubject{
            let nextVC = SubjectListPopOver.instantiate(fromAppStoryboard: .PopOverStoryboard)
            nextVC.delegate = self
            nextVC.isStudent = true
            let nav = UINavigationController(rootViewController: nextVC)
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                nextVC.preferredContentSize = CGSize(width: popoverWidth,height: 320)
                popover.permittedArrowDirections = .up
                popover.sourceView = self.txtSelectSubject
                popover.sourceRect = self.txtSelectSubject.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
            return false
        }
        else if textField == self.txtSelectStudent{
            if isProgress == true {
                let nextVC = StudentListVC.instantiate(fromAppStoryboard: .Teacher)
                nextVC.delegate = self
                nextVC.isPopOver = true
                nextVC.IsFromAddProgressReport = true
                let nav = UINavigationController(rootViewController: nextVC)
                nav.modalPresentationStyle = .popover
                if let popover = nav.popoverPresentationController {
                    nextVC.preferredContentSize = CGSize(width: popoverWidth,height: 320)
                    popover.permittedArrowDirections = .up
                    popover.sourceView = self.txtSelectStudent
                    popover.sourceRect = self.txtSelectStudent.bounds
                }
                self.present(nav, animated: true, completion: nil)
                self.view.endEditing(true)
                return false
            }
        }
        
        return true
    }
   
    
    //MARK: - schoolList delegate
    func saveSubject(strText: NSString, strID: NSInteger) {
        self.txtSelectSubject.text = strText as String
        self.SubjectID = strID
    }
    
    func saveChildInfo(childInfo: ChildInfoModel) {
        print("ChildInfo")
    }
    
    //MARK: - StudentList Delegate
    func saveStudent(strText: NSString, strID: NSInteger) {
        self.txtSelectStudent.text = strText as String
        self.StudentID = strID
    }
    
    //MARK: - btn Click
    @objc func btnBackClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - API Call
    func APICallAddProgress() {
        var params: [String: Any] = [ : ]
        params["studentId"] = self.StudentID
        params["subjectId"] = self.SubjectID
        params["progress"] = self.txtProgress.text.trim
        params["participation"] = self.txtParticipation.text.trim
        params["behaviour"] = self.txtBehaviour.text.trim
        params["attentionRequired"] = self.txtAttention.text.trim
        params["generalNotes"] = self.txtGeneral.text.trim
        params["deviceType"] = MyApp.device_type
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + addProgressReport, showLoader: true, vc:self) { (jsonData, error) in
            if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
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
