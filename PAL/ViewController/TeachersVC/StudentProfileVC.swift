//
//  StudentProfileVC.swift
//  PAL
//
//  Created by i-Phone7 on 26/11/20.
//

import UIKit

class StudentProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlet variable
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var collectionMarking: UICollectionView!
    @IBOutlet weak var collectionSubject: UICollectionView!
    @IBOutlet weak var collectionProgress: UICollectionView!
    
    @IBOutlet var cellProgressReportbtn: UITableViewCell!
    @IBOutlet weak var cellUserInfo: UITableViewCell!
    @IBOutlet weak var cellMarking: UITableViewCell!
    @IBOutlet weak var cellSubject: UITableViewCell!
    @IBOutlet weak var cellProgress: UITableViewCell!
    
    @IBOutlet weak var imgView: UIImageView!{
        didSet{
            imgView.layer.cornerRadius = (ScreenSize.SCREEN_WIDTH*0.15)/2
        }
    }
    @IBOutlet weak var lblNameIndicator: UILabel!{
        didSet{
            lblNameIndicator.font = UIFont.Font_ProductSans_Bold(fontsize: 40)
        }
    }
    @IBOutlet weak var lblUserName: UILabel!{
        didSet{
            lblUserName.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
        }
    }
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = UIFont.Font_ProductSans_Bold(fontsize: 22)
        }
    }
    @IBOutlet weak var lblDOBStatic: UILabel!{
        didSet{
            lblDOBStatic.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        }
    }
    @IBOutlet weak var lblDOB: UILabel!{
        didSet{
            lblDOB.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet weak var lblAge: UILabel!{
        didSet{
            lblAge.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet weak var lblGender: UILabel!{
        didSet{
            lblGender.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet weak var lblGenderStatic: UILabel!{
        didSet{
            lblGenderStatic.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        }
    }
    @IBOutlet weak var lblAgeStatic: UILabel!{
        didSet{
            lblAgeStatic.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        }
    }
    
    @IBOutlet weak var objViewProgress: UIView!
    @IBOutlet weak var ObjSubjectView: UIView!
    @IBOutlet weak var ObjMarkingView: UIView!
    @IBOutlet weak var lblNoProgress: UILabel!{
        didSet{
            lblNoProgress.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            lblNoProgress.text = "No progress report(s) generated yet"
            lblNoProgress.isHidden = true
        }
    }
    @IBOutlet weak var lblNoSubject: UILabel!{
        didSet{
            lblNoSubject.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            lblNoSubject.text = "No worksheet(s) assigned yet"
            lblNoSubject.isHidden = true
        }
    }
    @IBOutlet weak var lblNoMarking: UILabel!{
        didSet{
            lblNoMarking.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            lblNoMarking.text = "No worksheet(s) submitted yet"
            lblNoMarking.isHidden = true
        }
    }
    
    //MARK: - local variable
    var isAPICalled = Bool()
    let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.25) + 20
    let cellItemListWidth: CGFloat = ((ScreenSize.SCREEN_WIDTH - 35) - 40) / 2.7
    
    var studentId = 0
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: cellItemListWidth , height: cellItemListHeight)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.minimumInteritemSpacing = 0
        _flowLayout.minimumLineSpacing = 20
        return _flowLayout
    }
    //    var cellItemListHeight: CGFloat = 310
    //var allData = PersonalInfo.init(dictionary: NSDictionary())
    var objPersonalInfo = PersonalInfo()
    var arrsubjectBooksList = [SubjectBooks]()
    var arrprogressSubjectsList = [ProgressSubjects]()
    var arrmarkingList = [Marking]()
    var isFromNotification = false
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setFont()
        self.setUpData()
        self.setUpNavigation()
        
        self.tblProfile.register(UINib(nibName: "StaticTextCell", bundle: nil), forCellReuseIdentifier: "StaticTextCell")
        self.collectionMarking.register(UINib(nibName: "SubjectTilesInfoCell", bundle: nil), forCellWithReuseIdentifier: "SubjectTilesInfoCell")
        self.collectionProgress.register(UINib(nibName: "SubjectTilesInfoCell", bundle: nil), forCellWithReuseIdentifier: "SubjectTilesInfoCell")
        self.collectionSubject.register(UINib(nibName: "SubjectTilesInfoCell", bundle: nil), forCellWithReuseIdentifier: "SubjectTilesInfoCell")
        self.collectionMarking.collectionViewLayout = flowLayout
        self.collectionProgress.collectionViewLayout = flowLayout
        self.collectionSubject.collectionViewLayout = flowLayout
        
        self.APICallGetStudentProfile(showLoader: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func SetupStudentProfile(){
        self.lblUserName.text = self.objPersonalInfo.student_Id ?? ""
        self.lblName.text = self.objPersonalInfo.studentName ?? ""
        self.lblDOB.text = self.objPersonalInfo.dob ?? ""
        self.lblAge.text = "\(self.objPersonalInfo.age ?? 0)"
        self.lblGender.text = self.objPersonalInfo.gender ?? ""
        self.lblNameIndicator.text = self.lblName.text?.first?.uppercased()
    }
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellUserInfo
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
            cell.lblName.text = "Parent"
            cell.btnAction.isHidden = true
            cell.btnActionArrow.isHidden = true
            //cell.backgroundColor = .red
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParentInterViewReqCell", for: indexPath) as! ParentInterViewReqCell
            cell.lblName.text = self.objPersonalInfo.parentName ?? ""
            cell.lblEmail.text = self.objPersonalInfo.parentEmail ?? ""
            cell.lblNameIndicator.text = self.objPersonalInfo.parentName?.first?.uppercased()
            cell.configureCell()
            cell.btnInterViewReqCompletion = {
                self.btnInterViewReCalled(index: indexPath.row)
            }
            //cell.backgroundColor = .cyan
            return cell
        case 3 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
            cell.lblName.text = "Set Work"
            if arrsubjectBooksList.count <= 4{
                cell.btnAction.isHidden = true
                cell.btnActionArrow.isHidden = true
            }
            else{
                cell.btnAction.isHidden = false
                cell.btnActionArrow.isHidden = false
            }
            cell.btnSeeAllCompletion = {
                self.SeeAllSubjectClick()
            }
            //cell.backgroundColor = .red
            return cell
        case 4 :
            //cellSubject.backgroundColor = .cyan
            return cellSubject
        case 5 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
            cell.lblName.text = "Marking"
            if arrmarkingList.count <= 4{
                cell.btnAction.isHidden = true
                cell.btnActionArrow.isHidden = true
            }
            else{
                cell.btnAction.isHidden = false
                cell.btnActionArrow.isHidden = false
            }
            cell.btnSeeAllCompletion = {
                self.SeeAllMarkingClick()
            }
            //cell.backgroundColor = .red
            return cell
        case 6 :
            //cellMarking.backgroundColor = .cyan
            return cellMarking
        case 7 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
            cell.lblName.text = "Progress Report"
            if arrprogressSubjectsList.count <= 4{
                cell.btnAction.isHidden = true
                cell.btnActionArrow.isHidden = true
            }
            else{
                cell.btnAction.isHidden = false
                cell.btnActionArrow.isHidden = false
            }
            
            cell.btnSeeAllCompletion = {
                self.SeeAllProgressClick()
            }
            //cell.backgroundColor = .red
            return cell
        case 8 :
            return cellProgress
        default:
            //cellProgress.backgroundColor = .cyan
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParentInterViewReqCell", for: indexPath) as! ParentInterViewReqCell
            cell.lblName.isHidden = true
            cell.lblEmail.isHidden = true
            cell.lblNameIndicator.isHidden = true
            cell.imgView.isHidden = true
            cell.btnInterViewReq.setTitle("Add New Report", for: .normal)
            cell.configureCell()
            cell.btnInterViewReqCompletion = {
                self.btnAddProgressReportClick(index: indexPath.row)
            }
            //cell.backgroundColor = .cyan
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return ScreenSize.SCREEN_HEIGHT * 0.40
        case 1:
            return (!self.isAPICalled) ?0:60
        case 2:
            return (!self.isAPICalled) ?0:150
        case 3:
            return (!isAPICalled) ?0:60
        case 4:
            if self.arrsubjectBooksList.count > 0{
                let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.25) + 20
                return (!self.isAPICalled) ?0:cellItemListHeight + 10
            }
            else{
                let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.10) + 20
                return (!self.isAPICalled) ?0:cellItemListHeight
            }
        case 5:
            return (!self.isAPICalled) ?0:60
        case 6:
            if self.arrmarkingList.count > 0{
                let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.25) + 20
                return (!self.isAPICalled) ?0:cellItemListHeight + 10
            }
            else{
                let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.10) + 20
                return (!self.isAPICalled) ?0:cellItemListHeight
            }
        case 7:
            return (!self.isAPICalled) ?0:50
        case 8 :
            if self.arrprogressSubjectsList.count > 0{
                let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.22) + 20
                return (!self.isAPICalled) ?0:cellItemListHeight + 10
            }
            else{
                let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.10) + 20
                return (!self.isAPICalled) ?0:cellItemListHeight
            }
        default:
           
            return (!self.isAPICalled) ?0:150
        }
    }
    
    //MARK: - collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionSubject {
            return arrsubjectBooksList.count
        }
        else if collectionView == self.collectionMarking {
            return arrmarkingList.count
        }
        else if collectionView == self.collectionProgress {
            return arrprogressSubjectsList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectTilesInfoCell", for: indexPath) as! SubjectTilesInfoCell
        if collectionView == self.collectionSubject {
            cell.lblDate.text = self.arrsubjectBooksList[indexPath.row].startDate
            cell.lblSubjectName.text = self.arrsubjectBooksList[indexPath.row].subjectName
            cell.lblTeacherName.text = self.arrsubjectBooksList[indexPath.row].subCategory
            cell.lblTeacherId.text = self.arrsubjectBooksList[indexPath.row].worksheetName
            cell.imgMarking.imageFromURL(self.arrsubjectBooksList[indexPath.row].pdfThumb!, placeHolder: imgWorksheetIconPlaceholder)
            cell.imgProgress.isHidden = true
            //            var photourl = String()
            //            photourl = arrsubjectBooksList[indexPath.row].pdfThumb ?? ""
            //            if photourl.textlength > 0
            //            {
            //                cell.imgProgress.sd_setImage(with: URL(string: photourl), placeholderImage: UIImage(named: "AppIcon"), options: .refreshCached)
            //            }
        }
        else if collectionView == self.collectionMarking {
            cell.lblDate.text = self.arrmarkingList[indexPath.row].assignDate
            cell.lblSubjectName.text = self.arrmarkingList[indexPath.row].subjectName
            cell.lblTeacherName.text = self.arrmarkingList[indexPath.row].subCategory
            cell.lblTeacherId.text = self.arrmarkingList[indexPath.row].worksheetName
            if let strImg = self.arrmarkingList[indexPath.row].pdfThumb{
//                cell.imgMarking.sd_setImage(with: URL(string: strImg))
                cell.imgMarking.imageFromURL(strImg, placeHolder: imgWorksheetIconPlaceholder)
            }
        }
        else if collectionView == self.collectionProgress {
            cell.lblTeacherHeight.constant = 0
            cell.lblTeacherIDHeight.constant = 0
            cell.lblDatebottom.constant = 35
            
            cell.lblDate.text = self.arrprogressSubjectsList[indexPath.row].reportAddedDate
            cell.lblSubjectName.text = self.arrprogressSubjectsList[indexPath.row].subjectName
            cell.imgMarking.backgroundColor = .clear
            //            cell.lblTeacherId.text = arrprogressSubjectsList[indexPath.row].subjectId
        }
        cell.imgMarking.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionSubject {
            if !Connectivity.isConnectedToInternet() {
                showAlert(title: APP_NAME, message: Messages.NOINTERNET)
                return
            }
            let objNext = WorksheetViewVC.instantiate(fromAppStoryboard: .Student)
           
            if let arrPdf = arrsubjectBooksList[indexPath.row].pdfImages{
                objNext.arrImages = arrPdf
            }
            if let arrInstruction = self.arrsubjectBooksList[indexPath.row].instruction{
                objNext.arrInstruction = arrInstruction
            }
            if let arrvoiceInstruction = self.arrsubjectBooksList[indexPath.row].voiceinstruction{
                objNext.arrvoiceInstruction = arrvoiceInstruction
            }
            self.navigationController?.pushViewController(objNext, animated: true)
        }
        else if collectionView == self.collectionMarking {
            if let isCompleted = self.arrmarkingList[indexPath.row].isCompleted, isCompleted == 0{
                let objNext = TeacherWorksheetManageVC.instantiate(fromAppStoryboard: .Teacher)
                objNext.objMarkingInfo = self.arrmarkingList[indexPath.row]
                objNext.studentId = Int(self.objPersonalInfo.studentId ?? "0") ?? 0
                self.navigationController?.pushViewController(objNext, animated: true)
            }
            else{
                let objNext = WorksheetViewVC.instantiate(fromAppStoryboard: .Student)
                if let arrPdf = arrmarkingList[indexPath.row].pdfImage{
                    objNext.arrImages = arrPdf
                }
                if let arrInstruction = self.arrmarkingList[indexPath.row].instruction{
                    objNext.arrInstruction = arrInstruction
                }
                if let arrvoiceInstruction = self.arrmarkingList[indexPath.row].voiceinstruction{
                    objNext.arrvoiceInstruction = arrvoiceInstruction
                }
                self.navigationController?.pushViewController(objNext, animated: true)
            }
        }
        else if collectionView == self.collectionProgress {
            let objNext = ParentReportCardDetailsVC.instantiate(fromAppStoryboard: .ParentDashboard)
            objNext.objPersonalInfo = self.objPersonalInfo
            objNext.childId = studentId
            objNext.isFromParent = false
            objNext.subjectName = arrprogressSubjectsList[indexPath.row].subjectName ?? ""
            objNext.subjectId = arrprogressSubjectsList[indexPath.row].subjectId ?? 0
            objNext.childFirstName = self.objPersonalInfo.studentName ?? ""
            self.navigationController?.pushViewController(objNext, animated: true)
        }
    }
    
    //MARK: - Support Method
    func SeeAllProgressClick()  {
        let objNext = ParentReportCardVC.instantiate(fromAppStoryboard: .ParentDashboard)
        objNext.childId = studentId
        objNext.childFirstName = self.objPersonalInfo.studentName ?? ""
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    func SeeAllMarkingClick()  {
        let objNext = TeacherMarkingListVC.instantiate(fromAppStoryboard: .Teacher)
        objNext.childId = studentId
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    func SeeAllSubjectClick()  {
        let objNext = TeacherSubjectBookListVC.instantiate(fromAppStoryboard: .Teacher)
        objNext.childId = studentId
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    func btnInterViewReCalled(index: Int)  {
        let objNext = InterviewRequestVC.instantiate(fromAppStoryboard: .Teacher)
        objNext.studentId = studentId
        objNext.parentName = self.objPersonalInfo.parentName ?? ""
        objNext.parentEmail = self.objPersonalInfo.parentEmail ?? ""
        self.navigationController?.pushViewController(objNext, animated: true)
        
    }
    func btnAddProgressReportClick(index: Int)  {
        let objNext = AddProgressReport.instantiate(fromAppStoryboard: .Teacher)
        objNext.studentName = self.objPersonalInfo.studentName ?? ""
        objNext.StudentID = studentId
        objNext.isProgress = false
        objNext.txtSelectStudent.setRightPaddingPoints()
        objNext.txtSelectStudent.isEnabled = false
        self.navigationController?.pushViewController(objNext, animated: true)
        
    }
    @objc func btnBackClick() {
////        if isFromNotification{
//            let objNext = TeacherDashboardVC.instantiate(fromAppStoryboard: .TabBar)
//            self.navigationController?.pushViewController(objNext, animated: false)
//        }else{
            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    @objc func btnCertificateClick(_ sender: Any){
        let objNext = StudentCertificateVC.instantiate(fromAppStoryboard: .Teacher)
        objNext.strStudentName = self.lblName.text!
        objNext.StudentID = self.studentId
        objNext.isFromStudentProfile = true
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    //MARK: - Support Method
    func setUpNavigation() {
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "Student Profile", titleColor: .white)
        self.navigationItem.titleView = titleLabel
        //self.navigationItem.setHidesBackButton(true, animated: true)
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        let btnCertificate = UIButton(type: .custom)
        btnCertificate.setImage(UIImage(named: "Icon_whiteBadge"), for: .normal)
        btnCertificate.addTarget(self, action: #selector(btnCertificateClick), for: .touchUpInside)
        
        let barText = UIBarButtonItem(customView: btnCertificate)
        self.navigationItem.setRightBarButtonItems([barText], animated: true)
        
        
    }
    
    func setUpData() {
        // self.lblNameIndicator.text = self.lblName.text?.first?.uppercased()
        //        self.lblNameIndicator.textColor = .white
        //        UIGraphicsBeginImageContext(self.lblNameIndicator.frame.size)
        //        UIGraphicsBeginImageContextWithOptions(self.lblNameIndicator.bounds.size, false, UIScreen.main.scale)
        //        self.lblNameIndicator.layer.render(in: UIGraphicsGetCurrentContext()!)
        //        self.imgView.image = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        //        self.lblNameIndicator.textColor = .clear
    }
    
    func setFont()  {
        //        self.lblEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
        
        //        self.btnSave.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        //        self.btnSave.layer.cornerRadius = 5
    }
    
    func setBorderView(objView: UIView){
        let cellItemListHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT*0.10) + 20
        print((ScreenSize.SCREEN_WIDTH * 0.9))
        print(cellItemListHeight*0.85)
        let rect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: (ScreenSize.SCREEN_WIDTH * 0.9), height: (cellItemListHeight*0.85)))//0.86
        let layer = CAShapeLayer.init()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        layer.path = path.cgPath
        layer.strokeColor = UIColor.black.cgColor
        layer.lineDashPattern = [10,10]
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        objView.layer.addSublayer(layer)
    }
    
    //MARK: - API Call
    func APICallGetStudentProfile(showLoader: Bool) {
        var params : [String : Any] = [:]
        params["studentId"] = self.studentId
        
        APIManager.showPopOverLoader(view: self.view)
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getStudentProfile, showLoader: false, vc:self) { [self] (jsonData, error) in
            APIManager.hideLoader()
            if jsonData != nil{
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let temp = userData.personalInfo{
                            self.objPersonalInfo = temp
                        }
                        if let temp = userData.marking {
                            self.arrmarkingList = temp
                        }
//                        //
//                        for i in self.arrmarkingList{
//                            self.arrmarkingList.append(i)
//                        }
//                        for i in self.arrmarkingList{
//                            self.arrmarkingList.append(i)
//                        }
//                        //
                        if let temp = userData.progressSubjects{
                            self.arrprogressSubjectsList = temp
                        }
                        if let temp = userData.subjectBooks {
                            self.arrsubjectBooksList = temp
                        }
                        
                        if self.arrmarkingList.count > 0{
                            self.ObjMarkingView.isHidden = true
                            self.lblNoMarking.isHidden = true
                        }
                        else{
                            self.ObjMarkingView.isHidden = false
                            self.lblNoMarking.isHidden = false
                        }
                        
                        if self.arrprogressSubjectsList.count > 0{
                            self.objViewProgress.isHidden = true
                            self.lblNoProgress.isHidden = true
                        }
                        else{
                            self.objViewProgress.isHidden = false
                            self.lblNoProgress.isHidden = false
                        }
                        
                        if self.arrsubjectBooksList.count > 0{
                            self.ObjSubjectView.isHidden = true
                            self.lblNoSubject.isHidden = true
                        }
                        else{
                            self.ObjSubjectView.isHidden = false
                            self.lblNoSubject.isHidden = false
                        }
                        
                        self.SetupStudentProfile()
                        self.isAPICalled = true
                        self.tblProfile.reloadData()
                        self.collectionMarking.reloadData()
                        self.collectionSubject.reloadData()
                        self.collectionProgress.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.setBorderView(objView: self.ObjSubjectView)
                            self.setBorderView(objView: self.objViewProgress)
                            self.setBorderView(objView: self.ObjMarkingView)
                        }
                    }
                }
            }
        }
    }
}

class DashedBorderView: UIView {
    
    let _border = CAShapeLayer()
    var crnrVal = Int()
    var dashPattern = [NSNumber]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(color: UIColor.black)
        crnrVal = 12
        dashPattern = [6, 3]
    }
    
    init() {
        super.init(frame: .zero)
        setup(color: UIColor.black)
        
    }
    
    func setup(color: UIColor) {
        _border.strokeColor = color.cgColor
        _border.fillColor = nil
        _border.lineDashPattern = dashPattern
        self.layer.addSublayer(_border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:CGFloat(crnrVal)).cgPath
        _border.frame = self.bounds
    }
}
