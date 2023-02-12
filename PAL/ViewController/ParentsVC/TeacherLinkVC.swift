//
//  TeacherLinkVC.swift
//  PAL
//
//  Created by i-Verve on 11/11/20.
//

import UIKit
import Alamofire

class TeacherLinkVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, SubjectListDelegate {
    
    //MARK: - Outlet variable
    @IBOutlet weak var tblTeacherLink: UITableView!
    @IBOutlet weak var lblAllTeacher: UILabel!{
        didSet{
            lblAllTeacher.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet weak var lblChooseTeacher: UILabel!{
        didSet{
            lblChooseTeacher.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet weak var txtSearchteacher: UITextField!{
        didSet{
            txtSearchteacher.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            txtSearchteacher.placeholder = "Student Name"
        }
    }
    @IBOutlet weak var lblNameIndicator: UILabel!{
        didSet{
            lblNameIndicator.font = (DeviceType.IS_IPAD) ?UIFont.Font_ProductSans_Bold(fontsize: 11):UIFont.Font_ProductSans_Bold(fontsize: 13)
        }
    }
    @IBOutlet weak var imgTeacher: UIImageView!{
        didSet{
            imgTeacher.layer.cornerRadius = (DeviceType.IS_IPAD) ?(100 * 0.3)/2:(100 * 0.25)/2
        }
    }
    @IBOutlet weak var imgArrow: UIImageView!{
        didSet{
            imgArrow.transform = imgArrow.transform.rotated(by: .pi/2)
            imgArrow.setImageColor(color: UIColor(named: "Color_appTheme")!)
        }
    }
    @IBOutlet weak var nslcNameIndicatorHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcToViewWidth: NSLayoutConstraint!
    @IBOutlet weak var ChooseTop: NSLayoutConstraint!
    @IBOutlet weak var imgTop: NSLayoutConstraint!
    
    //MARK: - Local variable
    var arrLinkTeacher = [TeacherLinkModel]()
    var childId = Int()
    var tag  = Int()
    var teacherID = Int()
    var table = Bool()
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table = true
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Teacher Link", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        self.lblNameIndicator.text = "G"
        self.lblNameIndicator.textColor = .white
        if DeviceType.IS_IPAD {
            self.imgTop.constant = 10
            self.ChooseTop.constant = 15
            self.nslcToViewWidth.isActive = false
            self.nslcNameIndicatorHeight.isActive = false
        }
        else{
            self.imgTop.constant = 15
            self.ChooseTop.constant = 10
            self.nslcToViewWidth.isActive = true
            self.nslcNameIndicatorHeight.isActive = true
        }
        
        if let childInfo = Preferance.user.childInfo{
            if childInfo.count > 0{
                if let childId = childInfo[0].childId{
                    self.childId = childId
                    print("\(self.childId)...........childoididiid")
                }
                
                var strName = ""
                if let fName = childInfo[0].firstName{
                    strName = fName
                    self.lblNameIndicator.text = getNthCharacter(strText: fName)
                }
                if let lName = childInfo[0].lastName{
                    strName = strName + " " + lName
                }
                self.txtSearchteacher.text = strName
            }
        }
        
        self.APICallGetTeacherLink()
    }
        
    //MARK: - support Method
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLinkTeacher.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var strIdentifier = String()
        if DeviceType.IS_IPAD {
            strIdentifier = "TeacherLinkCellIpad"
        }
        else {
            strIdentifier = "TeacherLinkCell"
        }
        let cell = tblTeacherLink.dequeueReusableCell(withIdentifier: strIdentifier) as! TeacherLinkCell
        
        if let status = self.arrLinkTeacher[indexPath.row].linkStatus, status == 1{
            cell.btnLink.setTitle("Link", for: .normal)
            cell.btnLink.backgroundColor = .white
            cell.btnLink.layer.borderWidth = 1.0
            cell.btnLink.layer.borderColor = UIColor(named: "Color_lightSky")?.cgColor
        }
        else{
            cell.btnLink.setTitle("Unlink", for: .normal)
            cell.btnLink.backgroundColor = UIColor(named: "Color_morelightSky")
            cell.btnLink.layer.borderWidth = 0.0
            cell.btnLink.layer.borderColor = UIColor.clear.cgColor
        }
        
        cell.lblName.text = self.arrLinkTeacher[indexPath.row].teacherName
        cell.lblTeacherId.text = "Teacher ID: \(self.arrLinkTeacher[indexPath.row].teacher_Id ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var strMssg = String()
        if let status = self.arrLinkTeacher[indexPath.row].linkStatus, status == 1{
            strMssg = "Are you sure want to Link teacher \(self.arrLinkTeacher[indexPath.row].teacherName ?? "")?"
        }
        else{
            strMssg = "Are you sure want to Unlink teacher \(self.arrLinkTeacher[indexPath.row].teacherName ?? "")?"
        }
        let alert = UIAlertController(title: APP_NAME, message: strMssg, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        alert.addAction(UIAlertAction(title: Messages.CANCEL, style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: Messages.OK, style: .default, handler: { action in
            self.APICallLinkUnLink(index: indexPath.row)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension//DeviceType.IS_IPHONE ? 90:110
    }
    
    //MARK: - txt delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let nextVC = SubjectListPopOver.instantiate(fromAppStoryboard: .PopOverStoryboard)
        nextVC.delegate = self
        nextVC.isStudent = false
        
        let nav = UINavigationController(rootViewController: nextVC)
        if DeviceType.IS_IPHONE {
            nextVC.modalPresentationStyle = .custom
        }
        else {
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                nextVC.preferredContentSize = CGSize(width: 400,height: 200)
                popover.permittedArrowDirections = .unknown
                popover.sourceView = self.txtSearchteacher
                popover.sourceRect = self.txtSearchteacher.bounds
            }
        }
        self.present(nav, animated: true, completion: nil)
        return false
    }
    
    //MARK: - SubjectList delegate
    func saveChildInfo(childInfo: ChildInfoModel){
        var strName = ""
        self.childId = childInfo.childId!
        if let fName = childInfo.firstName{
            strName = fName
            if fName.count > 0 {
                self.txtSearchteacher.text = getNthCharacter(strText: fName)
            }
        }
        if let lName = childInfo.lastName{
            strName = strName + " " + lName
        }
        
        self.txtSearchteacher.text = strName
        self.APICallGetTeacherLink()
        if self.txtSearchteacher.text!.count > 0{
            self.lblNameIndicator.text = String(self.txtSearchteacher.text!.prefix(1))
        }
    }
    
    func saveSubject(strText: NSString, strID: NSInteger) {
        print("Subject")
    }

    //MARK: - btn Click
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - API Call
    func APICallGetTeacherLink() {
        
        var params: [String: Any] = [ : ]
        params["childId"] = self.childId
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getTeacherLinkList, showLoader: true, vc:self) { (jsonData, error) in
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let linkTeacher = userData.teacherLink {
                            self.arrLinkTeacher = linkTeacher
                            self.tblTeacherLink.reloadData()
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrLinkTeacher.count > 0{
                            self.tblTeacherLink.backgroundView = nil
                        }
                        else{
                            let lbl = UILabel.init(frame: self.tblTeacherLink.frame)
                            lbl.text = "No Link Teacher(s) found"
                            lbl.textAlignment = .center
                            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
                            self.tblTeacherLink.backgroundView = lbl
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
    
    func APICallLinkUnLink(index: Int) {
        var params: [String: Any] = [ : ]
        params["teacherId"] = self.arrLinkTeacher[index].teacherId!
        params["childId"] = self.childId
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + teacherLinkUnlink, showLoader: true, vc:self) { [self] (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        self.arrLinkTeacher[index].linkStatus = self.arrLinkTeacher[index].linkStatus?.switchNumber
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                        if table == true {
                            self.tblTeacherLink.reloadData()
                        }
                        else{
                        
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
