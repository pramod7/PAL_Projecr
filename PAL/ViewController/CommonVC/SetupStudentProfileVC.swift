//
//  SetupStudentProfileVC.swift
//  PAL
//
//  Created by i-Verve on 06/11/20.
//

import UIKit

class SetupStudentProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - Outlet variable
    @IBOutlet weak var lblAllStudent: UILabel!{
        didSet{
            lblAllStudent.font = UIFont.Font_ProductSans_Bold(fontsize: 20)
        }
    }
    @IBOutlet weak var btnAdd: UIButton!{
        didSet{
            self.btnAdd.layer.borderWidth = 1
            self.btnAdd.layer.borderColor = UIColor.kbtnAgeSetup().cgColor
            self.btnAdd.layer.cornerRadius = DeviceType.IS_IPAD ?  ((ScreenSize.SCREEN_HEIGHT*0.07)*0.55)/2 :  ((ScreenSize.SCREEN_HEIGHT*0.07)*0.7)/2
            self.btnAdd.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
        }
    }
    @IBOutlet weak var lblNoStudentFound: UILabel!{
        didSet{
            lblNoStudentFound.text = "No Student(s) found"
            lblNoStudentFound.isHidden = true
        }
    }
    @IBOutlet weak var tblStudent: UITableView!
    @IBOutlet weak var nslcViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var btnaddwidth: NSLayoutConstraint!
    @IBOutlet weak var nslcAddBtnViewHeight: NSLayoutConstraint!
    
    //MARK: - Local variable
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.StudentSetUp, titleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        
        if DeviceType.IS_IPAD{
            btnaddwidth.isActive = false
            nslcAddBtnViewHeight.isActive = false
        }
        else{
            btnaddwidth.isActive = true
            nslcAddBtnViewHeight.isActive = true
            nslcViewTopSpace.constant = 35
        }
        
        self.APICallGetChild(showLoader: true)
    }
    
    //MARK: - support Method
    
    
    //MARK: - ParentProfileDelegate
    func dimissEditVC() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - API Call
    func APICallGetChild(showLoader: Bool) {
        
        let params: [String: Any] = [ : ]
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getChildList, showLoader: true, vc:self) { (jsonData, error) in
            
            if let json = jsonData{
                if let userData = ListResponse(JSON:json.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let child = userData.childInfo {
                            Preferance.user.childInfo = child
                            Singleton.shared.save(object: Preferance.user.toJSON(), key: UserDefaultsKeys.userData)
                        }
                        else{
                            if let msg = json[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if let childInfo = Preferance.user.childInfo{
                            if childInfo.count > 0 {
                                self.tblStudent.backgroundView = nil
                            }
                            else{
                                let lbl = UILabel.init(frame: self.tblStudent.frame)
                                lbl.text = "No Student(s) found"
                                lbl.textAlignment = .center
                                lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
                                self.tblStudent.backgroundView = lbl
                            }
                        }
                        self.tblStudent.reloadData()
                    }
                    else{
                        if let msg = json[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                }
            }
        }
    }
    
    func APICallDeleteChild(tag: Int) {
        
        var params: [String: Any] = [ : ]
        if let childInfo = Preferance.user.childInfo{
            params["childId"] =  childInfo[tag].childId
        }
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + deleteChild, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        Preferance.user.childInfo?.remove(at: tag)
                        Singleton.shared.save(object: Preferance.user.toJSON(), key: UserDefaultsKeys.userData)
                        
                        if let childInfo = Preferance.user.childInfo{
                            if childInfo.count > 0 {
                                self.tblStudent.backgroundView = nil
                            }
                            else{
                                let lbl = UILabel.init(frame: self.tblStudent.frame)
                                lbl.text = "No Student(s) found"
                                lbl.textAlignment = .center
                                lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
                                self.tblStudent.backgroundView = lbl
                            }
                        }
                        self.tblStudent.reloadData()
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
    
    //MARK: - btn Click
    @IBAction func btnAddStudentclick(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        
        let nextVC = AddStudentVC.instantiate(fromAppStoryboard: .Main)
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.dismissAddStudent = { (isAPICall) in
            DispatchQueue.main.async {
                self.tabBarController?.tabBar.isHidden = false
                if isAPICall {
                    self.APICallGetChild(showLoader: true)
                }
            }
        }
        self.navigationController?.present(nextVC, animated: true)
    }
       
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonClicked(sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = true
        
        let nextVC = AddStudentVC.instantiate(fromAppStoryboard: .Main)
        nextVC.modalPresentationStyle = .overCurrentContext
        if let childTemp = Preferance.user.childInfo{
            nextVC.childInfoModel = childTemp[sender.tag]
        }
        nextVC.isEdit = true
        nextVC.dismissAddStudent = { (isAPICall) in
            DispatchQueue.main.async {
                self.tabBarController?.tabBar.isHidden = false
                if isAPICall {
                    self.APICallGetChild(showLoader: true)
                }
            }
        }
        self.navigationController?.present(nextVC, animated: true)    }
    
    @objc func buttonDeleteClicked(sender:UIButton) {
        if let childInfo = Preferance.user.childInfo{
            var strName = ""
            if let fName = childInfo[sender.tag].firstName{
                strName = fName
            }
            if let lName = childInfo[sender.tag].lastName{
                strName = strName + " " + lName
            }
            let alert = UIAlertController(title: APP_NAME, message: ScreenText.StudentDelete + " \(strName)?", preferredStyle: .alert)
            alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: {action in
                self.APICallDeleteChild(tag: sender.tag)
            })
            let btnCancel = UIAlertAction(title: Messages.CANCEL, style: .destructive, handler: nil)
            alert.addAction(btnCancel)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let childInfo = Preferance.user.childInfo{
            return childInfo.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var strIdetifire = String()
        if DeviceType.IS_IPAD{
            strIdetifire = "SetupStudentProfileCellI_iPad"
        }
        else{
            strIdetifire = "SetupStudentProfileCell"
        }
        let cell = tblStudent.dequeueReusableCell(withIdentifier: strIdetifire) as! SetupStudentProfileCell
        
        if let childTemp = Preferance.user.childInfo{
            let childInfo = childTemp[indexPath.row]
            
            var strName = ""
            if let fName = childInfo.firstName{
                strName = fName
                if fName.count > 0 {
                    cell.lblIndicator.text = getNthCharacter(strText: fName)
                }
            }
            if let lName = childInfo.lastName{
                strName = strName + " " + lName
            }
            cell.lblTechaerName.text = strName
            cell.lblId.text = childInfo.student_Id
            
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(buttonDeleteClicked(sender:)), for: UIControl.Event.touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ChildrenProfileVC.instantiate(fromAppStoryboard: .ParentDashboard)
        if let childata = Preferance.user.childInfo{
            let childin = childata[indexPath.row]
            var strnameee = ""
            if let fchild = childin.firstName{
                strnameee = fchild
                if fchild.count > 0{
                    nextVC.lblDateValue.text = childin.dob
                    nextVC.lblUserid.text = childin.student_Id
                    nextVC.childID = childin.childId!
                    if let temp = childin.childStrugleArea{
                        if temp == "Others"{
                            nextVC.strugleArea = childin.otherDescription!
                        }
                        else{
                            nextVC.strugleArea = temp
                        }
                    }
                    if childin.gender == "0"{
                        nextVC.lblGenderValue.text = "Boy"
                    }
                    else{
                        nextVC.lblGenderValue.text = "Girl"
                    }
                }
            }
            if let lnn = childin.lastName{
                strnameee = strnameee + " " + lnn
            }
            nextVC.lblUserName.text = strnameee
            nextVC.lblNameIndicator.text = strnameee.first?.uppercased()
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE{
           return 85
        }
        else{
            return ScreenSize.SCREEN_HEIGHT * 0.1
        }
    }
}
