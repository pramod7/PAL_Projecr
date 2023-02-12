//
//  ChildrenProfileVC.swift
//  PAL
//
//  Created by i-Phone7 on 31/10/20.
//

import UIKit
import SDWebImage

class ChildrenProfileVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource, ParentProfileDelegate {
    
    //MARK: - Outlet Variable
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet var cellUserInfo: UITableViewCell!
    @IBOutlet var cellThird: UITableViewCell!
    @IBOutlet var cellTeacherList: UITableViewCell!
    @IBOutlet var cellWorkBookList: UITableViewCell!
    @IBOutlet var collectionTeacher: UICollectionView!
    @IBOutlet var collectionWorkbooks: UICollectionView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.layer.cornerRadius = (DeviceType.IS_IPHONE) ? (ScreenSize.SCREEN_WIDTH*0.20)/2 : (ScreenSize.SCREEN_WIDTH*0.20)/2
        }
    }
    @IBOutlet weak var lblUserid: UILabel!{
        didSet{
            lblUserid.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDateValue: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblGenderValue: UILabel!
    @IBOutlet weak var objView: UIView!
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var btnOption: UIButton!{
        didSet{
            btnOption.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet var lblNameIndicator: UILabel!{
        didSet{
            lblNameIndicator.font = UIFont.Font_ProductSans_Bold(fontsize: 40)
        }
    }
    @IBOutlet weak var nslcTeacherCollectionWidth: NSLayoutConstraint!
    @IBOutlet weak var nslcWOrkbookCollectionWidth: NSLayoutConstraint!
    @IBOutlet weak var nslcTOpViewWidth: NSLayoutConstraint!
    @IBOutlet weak var objviewBirthdaywidth: NSLayoutConstraint!
    @IBOutlet weak var imgProfileWidth: NSLayoutConstraint!
    @IBOutlet weak var imgTopSPace: NSLayoutConstraint!
    @IBOutlet var objProgressView: UIView!
    @IBOutlet var objTeacherView: UIView!
    @IBOutlet var lblNoTeacher: UILabel!{
        didSet{
            lblNoTeacher.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            lblNoTeacher.text = "No any teacher linked yet"
            lblNoTeacher.isHidden = true
        }
    }
    @IBOutlet var lblNoReport: UILabel!{
        didSet{
            lblNoReport.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            lblNoReport.text = "No worksheet(s) assigned yet"
            lblNoReport.isHidden = true
        }
    }
    
    //MARK: - Local Variable
    let teacherCellHeight: CGFloat = DeviceType.IS_IPHONE ? 180 : (ScreenSize.SCREEN_HEIGHT*0.20)
    let teacherCellectionWidth: CGFloat = DeviceType.IS_IPHONE ? ((ScreenSize.SCREEN_WIDTH*0.95) - 20) / 2: (ScreenSize.SCREEN_WIDTH - 40) / 3.5
    
    let workbookCellHeight: CGFloat  = DeviceType.IS_IPHONE ? 240 : (ScreenSize.SCREEN_HEIGHT * 0.25)
    let workbookCellectionWidth: CGFloat  = DeviceType.IS_IPHONE ? ((ScreenSize.SCREEN_WIDTH*0.95) - 20) / 2 : ((ScreenSize.SCREEN_WIDTH*0.9) - 75) / 2.7
    
    let spacing: CGFloat = DeviceType.IS_IPHONE ? 10 : 20
    
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width:  workbookCellectionWidth, height: workbookCellHeight)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.minimumInteritemSpacing = spacing
        _flowLayout.minimumLineSpacing = spacing
        return _flowLayout
    }
    var childID = Int()
    var isAPICall = Bool()
    var strugleArea = String()
    var Row = Int()
    var isAPICalled = Bool()
    var arrLinkTeacher = [TeacherLinkModel]()
    var arrWorkbookList = [WorkbookListModel]()
    var flowLayoutTeacher: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: teacherCellectionWidth , height: teacherCellHeight)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.minimumInteritemSpacing = spacing
        _flowLayout.minimumLineSpacing = spacing
        return _flowLayout
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.Profile, titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            self.navigationItem.setHidesBackButton(true, animated: true)
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            
            let btnEdit: UIButton = UIButton()
            btnEdit.setTitle("EDIT PROFILE", for: .normal)
            btnEdit.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            btnEdit.addTarget(self, action: #selector(btnEditProfile), for: .touchUpInside)
            btnEdit.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnEdit)
            btnEdit.isHidden = true
        }
        self.SeupProfile()
        
        self.tblProfile.register(UINib(nibName: "StaticTextCell", bundle: nil), forCellReuseIdentifier: "StaticTextCell")
        if DeviceType.IS_IPHONE {
            self.collectionWorkbooks.register(UINib(nibName: "SubjectTilesInfoCell", bundle: nil), forCellWithReuseIdentifier: "SubjectTilesInfoCell")
        }
        else {
            self.collectionWorkbooks.register(UINib(nibName: "SubjectTilesInfoiPadCell", bundle: nil), forCellWithReuseIdentifier: "SubjectTilesInfoiPadCell")
        }
        self.collectionTeacher.collectionViewLayout = flowLayoutTeacher
        self.collectionWorkbooks.collectionViewLayout = flowLayout
        
        self.btnOption.setTitle(self.strugleArea, for: .normal)
        self.APICallGetTeacherLinks()
    }
    
    //MARK: - Support Method
    func SeupProfile(){
        self.lblUserName.font = UIFont.Font_ProductSans_Bold(fontsize: 20)
        self.lblDate.font = UIFont.Font_WorkSans_Bold(fontsize: 14)
        self.lblDateValue.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
        self.lblGender.font = UIFont.Font_WorkSans_Bold(fontsize: 14)
        self.lblGenderValue.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
        self.lblOption.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        
        if DeviceType.IS_IPHONE{
            self.objviewBirthdaywidth.isActive = true
            self.imgProfileWidth.isActive = true
            self.nslcTeacherCollectionWidth.isActive = true
            self.nslcWOrkbookCollectionWidth.isActive = true
            self.nslcTOpViewWidth.isActive = true
            self.imgTopSPace.constant = 30
        }
        else{
            self.objviewBirthdaywidth.isActive = false
            self.imgProfileWidth.isActive = false
            self.nslcTeacherCollectionWidth.isActive = false
            self.nslcWOrkbookCollectionWidth.isActive = false
            self.nslcTOpViewWidth.isActive = false
            //self.imgTopSPace.constant = 50
        }
        // self.lblNameIndicator.text = "G"
        btnUnSelectedSetup(btn: btnOption)
    }
    
    func btnUnSelectedSetup(btn:UIButton){
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.kAppThemeColor().cgColor
        btn.layer.cornerRadius = 5
        //btn.setTitleColor(UIColor.black, for: .normal)
    }
    
    //MARK: - Support Method
    func SeeAllTeacherClick()  {
        let objNextVC = TeacherLinkVC.instantiate(fromAppStoryboard: .ParentDashboard)
        self.navigationController?.pushViewController(objNextVC, animated: true)
    }
    
    func SeeAllWorkBooksClick()  {
        let objNext = ParentSubCategoryVC.instantiate(fromAppStoryboard: .ParentDashboard)
        objNext.childId = self.childID
        objNext.subjectID = self.arrWorkbookList[3].subjectId!
        self.navigationController?.pushViewController(objNext, animated: true)
        
    }
    
    func dimissEditVC(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.tabBarController?.tabBar.isHidden = false
        })
    }
    
    func SetView(objView:UIView){
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.black.cgColor
        yourViewBorder.lineDashPattern = [6, 7]
        yourViewBorder.frame = objView.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.cornerRadius = 10
        yourViewBorder.path = UIBezierPath(rect: objView.bounds).cgPath
        objView.layer.addSublayer(yourViewBorder)
    }
    
    //MARK: - btn Click
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnEditProfile() {
        let objNext = AddNewStudentVC.instantiate(fromAppStoryboard: .Main)
        objNext.delegate = self
        objNext.isFromAdd = true
        objNext.modalPresentationStyle = .overCurrentContext
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.present(objNext, animated: true)
    }
    
    @IBAction func btnChildStrugleInfoClick(_ sender: Any) {
        let alert = UIAlertController(title: "", message: ScreenText.childToolTip, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellUserInfo
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
            cell.lblName.text = "Teachers"
            cell.lblName.textColor = UIColor(named: "Color_lightGrey_112")
            cell.btnAction.setTitle("See All", for: .normal)
            cell.btnAction.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
            cell.btnAction.setTitleColor(UIColor(named: "Color_morelightSky")!, for: .normal)
            if arrLinkTeacher.count <= 4{
                cell.btnAction.isHidden = true
                cell.btnActionArrow.isHidden = true
            }
            else{
                cell.btnAction.isHidden = false
                cell.btnActionArrow.isHidden = false
            }
            cell.btnSeeAllCompletion = {
                self.SeeAllTeacherClick()
            }
            return cell
        case 2:
            return cellTeacherList
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
            cell.lblName.text = "Workbooks"
            cell.lblName.textColor = UIColor(named: "Color_lightGrey_112")
            cell.btnAction.setTitle("See All", for: .normal)
            cell.btnAction.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
            cell.btnAction.setTitleColor(UIColor(named: "Color_morelightSky")!, for: .normal)
            if arrWorkbookList.count <= 4{
                cell.btnAction.isHidden = true
                cell.btnActionArrow.isHidden = true
            }
            else{
                cell.btnAction.isHidden = false
                cell.btnActionArrow.isHidden = false
            }
            
            cell.btnSeeAllCompletion = {
                self.SeeAllWorkBooksClick()
            }
            return cell
        case 4:
            return cellWorkBookList
        default:
            return cellThird
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return (DeviceType.IS_IPHONE) ? 320 : ScreenSize.SCREEN_HEIGHT * 0.40
        case 2:
            if self.isAPICall{
                if self.arrLinkTeacher.count > 0{
                    let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.20) + 20
                    return cellItemListHeight + 10
                }
                else{
                    let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.10) + 20
                    return cellItemListHeight
                }
            }
            else{
                return 0
            }
            //            return teacherCellHeight + 40
        case 4:
            if self.isAPICall{
                if self.arrWorkbookList.count > 0{
                    let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.25) + 20
                    return cellItemListHeight + 10
                }
                else{
                    let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.10) + 20
                    return cellItemListHeight
                }
            }
            else{
                return 0
            }
        case 5:
            return self.isAPICall ?(DeviceType.IS_IPHONE) ?120:145 :0
        default:
            return self.isAPICall ?(DeviceType.IS_IPHONE) ?35:70 :0
        }
    }
    
    //MARK: - collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionTeacher{
            return self.arrLinkTeacher.count
        }
        else if collectionView == self.collectionWorkbooks{
            return self.arrWorkbookList.count
        }
        else{
            return self.arrLinkTeacher.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionTeacher{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParentProfileCell", for: indexPath) as! ParentProfileCell
            
            if indexPath.row % 2 == 0 {
                Row = indexPath.row
                print("\(Row).............................rio")
                cell.lblTeacherName.text = self.arrLinkTeacher[indexPath.row].teacherName
                cell.lblIndicatorName.text = self.arrLinkTeacher[indexPath.row].teacherName?.first?.uppercased()
                cell.lblTeacherID.text = "Teacher ID: \(self.arrLinkTeacher[indexPath.row].teacher_Id ?? "")"
                //      cell.btnUnlinkTeacher.addTarget(Any?.self, action: #selector(unlinkk), for: .touchUpInside)
                cell.btnUnlinkTeacher.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
                cell.btnUnlinkTeacher.tag = indexPath.row
            }
            else {
                Row = indexPath.row
                print("\(Row).............................rio")
                cell.lblTeacherName.text = self.arrLinkTeacher[indexPath.row].teacherName
                cell.lblIndicatorName.text = self.arrLinkTeacher[indexPath.row].teacherName?.first?.uppercased()
                cell.lblTeacherID.text = "Teacher ID: \(self.arrLinkTeacher[indexPath.row].teacher_Id ?? "")"
                //     cell.btnUnlinkTeacher.addTarget(Any?.self, action: #selector(unlinkk), for: .touchUpInside)
                cell.btnUnlinkTeacher.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
                cell.btnUnlinkTeacher.tag = indexPath.row
            }
            if let status = self.arrLinkTeacher[indexPath.row].linkStatus, status == 1{
                cell.btnUnlinkTeacher.setTitle("Link", for: .normal)
                cell.btnUnlinkTeacher.backgroundColor = .white
                cell.btnUnlinkTeacher.layer.borderWidth = 1.0
                cell.btnUnlinkTeacher.layer.borderColor = UIColor(named: "Color_lightSky")?.cgColor
            }
            else{
                cell.btnUnlinkTeacher.setTitle("Unlink", for: .normal)
                cell.btnUnlinkTeacher.backgroundColor = UIColor(named: "Color_morelightSky")
                cell.btnUnlinkTeacher.layer.borderWidth = 0.0
                cell.btnUnlinkTeacher.layer.borderColor = UIColor.clear.cgColor
            }
            cell.objTeacherview.layer.cornerRadius = 10
            return cell
        }
        else{
            if DeviceType.IS_IPHONE {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectTilesInfoCell", for: indexPath) as! SubjectTilesInfoCell
                if indexPath.row % 2 == 0 {
                    cell.lblSubjectName.text = self.arrWorkbookList[indexPath.row].subjectName
                    cell.lblTeacherName.text = self.arrWorkbookList[indexPath.row].teacherName
                    cell.lblTeacherId.text = self.arrWorkbookList[indexPath.row].teacher_Id
                    cell.lblDate.text = self.arrWorkbookList[indexPath.row].worksheetsAssignDate
                    cell.imgMarking.sd_setImage(with: URL(string: self.arrWorkbookList[indexPath.row].pdfThumb!))
                    cell.imgMarking.layer.cornerRadius = 5.0
                }
                else {
                    cell.imgMarking.sd_setImage(with: URL(string: self.arrWorkbookList[indexPath.row].pdfThumb!))
                    cell.imgMarking.layer.cornerRadius = 5.0
                    cell.lblTeacherName.text = self.arrWorkbookList[indexPath.row].teacherName
                    cell.lblTeacherId.text = self.arrWorkbookList[indexPath.row].teacher_Id
                    cell.lblDate.text = self.arrWorkbookList[indexPath.row].worksheetsAssignDate
                    cell.lblSubjectName.text = self.arrWorkbookList[indexPath.row].subjectName
                }
                cell.imgProgress.isHidden = true
                cell.imgMarking.isHidden = false
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectTilesInfoiPadCell", for: indexPath) as! SubjectTilesInfoiPadCell
                if indexPath.row % 2 == 0 {
                    cell.lblSubjectName.text = self.arrWorkbookList[indexPath.row].subjectName
                    cell.lblTeacherName.text = self.arrWorkbookList[indexPath.row].teacherName
                    cell.lblTeacherId.text = self.arrWorkbookList[indexPath.row].teacher_Id
                    cell.lblDate.text = self.arrWorkbookList[indexPath.row].worksheetsAssignDate
                    cell.imgMarking.sd_setImage(with: URL(string: self.arrWorkbookList[indexPath.row].pdfThumb!))
                    cell.imgMarking.layer.cornerRadius = 5.0
                }
                else {
                    cell.imgMarking.sd_setImage(with: URL(string: self.arrWorkbookList[indexPath.row].pdfThumb!))
                    cell.imgMarking.layer.cornerRadius = 5.0
                    cell.lblSubjectName.text = self.arrWorkbookList[indexPath.row].subjectName
                    cell.lblTeacherName.text = self.arrWorkbookList[indexPath.row].teacherName
                    cell.lblTeacherId.text = self.arrWorkbookList[indexPath.row].teacher_Id
                    cell.lblDate.text = self.arrWorkbookList[indexPath.row].worksheetsAssignDate
                }
                cell.imgProgress.isHidden = true
                cell.imgMarking.isHidden = false
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionTeacher{
            
        }
        else {
            let objNext = WorksheetViewVC.instantiate(fromAppStoryboard: .Student)
            objNext.arrImages = self.arrWorkbookList[indexPath.row].pdfImage ?? []
            if let arrPdf = arrWorkbookList[indexPath.row].pdfImage{
                objNext.arrImages = arrPdf
            }
            if let arrInstruction = self.arrWorkbookList[indexPath.row].instruction{
                objNext.arrInstruction = arrInstruction
            }
            if let arrvoiceInstruction = self.arrWorkbookList[indexPath.row].voiceinstruction{
                objNext.arrvoiceInstruction = arrvoiceInstruction
            }
            self.navigationController?.pushViewController(objNext, animated: true)
        }
    }
    
    @objc func buttonTapped(sender : UIButton) {
        print("\(arrLinkTeacher[sender.tag].teacherId ?? 0).........teacher id ")
        print("\(sender.tag).........row")
        var strMssg = String()
        if let status = self.arrLinkTeacher[Row].linkStatus, status == 1{
            strMssg = "Are you sure you want to Link teacher \(self.arrLinkTeacher[sender.tag].teacherName ?? "")."
        }
        else{
            strMssg = "Are you sure you want to Unlink teacher \(self.arrLinkTeacher[sender.tag].teacherName ?? "")."
        }
        let alert = UIAlertController(title: APP_NAME, message: strMssg, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        alert.addAction(UIAlertAction(title: Messages.CANCEL, style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: Messages.OK, style: .default, handler: { [self] action in
            let objNext = TeacherLinkVC.instantiate(fromAppStoryboard: .ParentDashboard)
            objNext.arrLinkTeacher = arrLinkTeacher
            objNext.childId = self.childID
            objNext.table = false
            objNext.APICallLinkUnLink(index: sender.tag)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.APICallGetTeacherLinks()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //    @objc func unlinkk() {
    //
    //        var strMssg = String()
    //        if let status = self.arrLinkTeacher[Row].linkStatus, status == 1{
    //            strMssg = "Are you sure you want to Link teacher \(self.arrLinkTeacher[Row].teacherName ?? "")."
    //        }
    //        else{
    //            strMssg = "Are you sure you want to Unlink teacher \(self.arrLinkTeacher[Row].teacherName ?? "")."
    //        }
    //        let alert = UIAlertController(title: APP_NAME, message: strMssg, preferredStyle: .alert)
    //        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
    //        alert.addAction(UIAlertAction(title: Messages.CANCEL, style: .destructive, handler: nil))
    //        alert.addAction(UIAlertAction(title: Messages.OK, style: .default, handler: { [self] action in
    //            let objNext = TeacherLinkVC.instantiate(fromAppStoryboard: .ParentDashboard)
    //
    //         //       self.arrLinkTeacher[Row].teacherId = objNext.arrLinkTeacher[Row].teacherId
    //            print("\(arrLinkTeacher[Row].teacherId).........teacher id ")
    //            print("\(Row).........row")
    //          //  objNext.APICallLinkUnLink(index: Row)
    //        }))
    //        self.present(alert, animated: true, completion: nil)
    //    }
    //Ramdhani Yadav 40
    //MARK: - API Call
    func APICallGetTeacherLinks() {
        
        var params: [String: Any] = [ : ]
        params["childId"] = self.childID
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getTeacherLinkList, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let linkTeacher = userData.teacherLink {
                            self.arrLinkTeacher = linkTeacher
                            //self.collectionTeacher.reloadData()
                            
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrLinkTeacher.count > 0{
                            self.collectionTeacher.backgroundView = nil
                            self.objTeacherView.isHidden = true
                            self.lblNoTeacher.isHidden = true
                        }
                        else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.objTeacherView.isHidden = false
                                self.lblNoTeacher.isHidden = false
                                self.SetView(objView: self.objTeacherView)
                            }
                        }
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                    self.APICallGetWorkbookList()
                }
            }
        }
    }
    
    func APICallGetWorkbookList() {
        
        var params: [String: Any] = [ : ]
        params["childId"] = self.childID
        params["pageIndex"] = 0
        params["isFive"] = 1
        params["subjectId"] = 0
        params["subCategoryId"] = 0
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getParentChildWorksheetsList, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let linkTeacher = userData.WorkbookList {
                            self.arrWorkbookList = linkTeacher
                            
                            self.tblProfile.reloadData()
                            self.collectionWorkbooks.reloadData()
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrWorkbookList.count > 0{
                            self.collectionWorkbooks.backgroundView = nil
                            self.objProgressView.isHidden = true
                            self.lblNoReport.isHidden = true
                        }
                        else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.objProgressView.isHidden = false
                                self.lblNoReport.isHidden = false
                                self.SetView(objView: self.objProgressView)
                            }
                        }
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                    self.isAPICall = true
                    self.collectionTeacher.reloadData()
                }
            }
        }
    }
}
