//
//  WorkBookStudentVC.swift
//  PAL
//
//  Created by i-Verve on 02/12/20.
//

import UIKit
import FSCalendar

class WorkBookStudentVC: UIViewController {
    
    //MARK: - Outlet variable
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var objWeeklyWorkList: UICollectionView!
    @IBOutlet weak var objCollectionWeek: UICollectionView!
    @IBOutlet weak var objCollectionRecentWork: UICollectionView!
    @IBOutlet weak var collectionTeacherAssigned: UICollectionView!
    
    @IBOutlet var cellWeekWorksheetList: UITableViewCell!
    @IBOutlet var cellMyWorkBookButton: UITableViewCell!
    @IBOutlet var CellDatePicker: UITableViewCell!
    @IBOutlet var cellTeacherAssigned: UITableViewCell!
    @IBOutlet var cellRecentWork: UITableViewCell!
    @IBOutlet var objWorkDoneView: UIView!
    @IBOutlet var lblNoWorkDone: UILabel!{
        didSet{
            lblNoWorkDone.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            lblNoWorkDone.text = "No work done yet"
        }
    }
    @IBOutlet weak var lblCurrentMonth: UILabel!{
        didSet{
            self.lblCurrentMonth.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    @IBOutlet var objAssignTeacherView: UIView!
    @IBOutlet var lblNoTeacherAssign: UILabel!{
        didSet{
            lblNoTeacherAssign.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            lblNoTeacherAssign.text = "No work assign yet"
        }
    }
    @IBOutlet weak var objviewUpper: UIView!
    @IBOutlet weak var btnRecent: UIButton!
    @IBOutlet weak var btnWeeks: UIButton!
    @IBOutlet weak var btnNewPage: UIButton!{
        didSet{
            btnNewPage.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnMyWorkbook: UIButton!{
        didSet{
            btnMyWorkbook.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var objView: UIView!{
        didSet{
            objView.borderShadowAllSide(Radius: 5)
        }
    }
    @IBOutlet weak var objCalender: FSCalendar!{
        didSet{
            self.objCalender.calendarHeaderView.isHidden = true
            self.objCalender.appearance.weekdayFont = UIFont.Font_WorkSans_Regular(fontsize: 12)
            self.objCalender.appearance.titleFont = UIFont.Font_WorkSans_Regular(fontsize: 14)
            self.objCalender.swipeToChooseGesture.isEnabled = false
            self.objCalender.allowsMultipleSelection = false
            self.objCalender.firstWeekday = 2
        }
    }
    //    @IBOutlet var viewCardCalender: UIView!{
    //        didSet{
    //           viewCardCalender.borderShadowAllSide(Radius: 15)
    //        }
    //    }
    @IBOutlet var viewCardCalender: UIView!{
        didSet{
            self.viewCardCalender.shadowWithCornerReduisAndRect(cornerReduis: 15, layerColor: .white, width:(ScreenSize.SCREEN_WIDTH*0.95), height:calenderHeight)
            //            self.viewCardCalender.backgroundColor = UIColor.red
        }
    }
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNoData: UILabel!{
        didSet{
            lblNoData.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            lblNoData.text = "No Worksheet(s) found"
            lblNoData.textColor = .black
        }
    }
    
    //MARK: - Local variable
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
    
    fileprivate lazy var Month: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        return formatter
    }()
    
    fileprivate lazy var year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    fileprivate let Sendformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    let cellRecentHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT / 5) + 20//240
    var flowlayoutWeekWorkList: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: ((ScreenSize.SCREEN_WIDTH*0.95) - 40) / 3 , height: cellRecentHeight)
        _flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        _flowLayout.minimumInteritemSpacing = 10
        _flowLayout.minimumLineSpacing = 10
        return _flowLayout
    }
    
    var flowLayoutSecond: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: ((ScreenSize.SCREEN_WIDTH*0.95) - 20) / 3 , height: cellRecentHeight)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        _flowLayout.minimumInteritemSpacing = 10
        _flowLayout.minimumLineSpacing = 10
        return _flowLayout
    }
    
    var flowLayoutweek: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: 230 , height: 70)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        _flowLayout.minimumInteritemSpacing = 20
        _flowLayout.minimumLineSpacing = 40
        return _flowLayout
    }
    let calenderHeight: CGFloat = 485
    var SelectedbtnRecent = Bool()
    var numberOfWeeks = Int()
    var selectedWeek = Int()
    var subjectId = Int()
    var strStartDate = ""
    var strEndDate = ""
    var strScreenTitle = String()
    var arrSubjectWiseWorkbook = [SubjectBooksList]()
    var arrWorkDone = [SubjectBooksList]()
    var isFromStudent = false
    var isFromnotification = false
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionTeacherAssigned.collectionViewLayout = flowLayoutSecond
        self.objCollectionRecentWork.collectionViewLayout = flowLayoutSecond
        self.objCollectionWeek.collectionViewLayout = flowLayoutweek
        self.objWeeklyWorkList.collectionViewLayout = self.flowlayoutWeekWorkList
        
        self.setBorderView(objView: self.objWorkDoneView)
        self.setBorderView(objView: self.objAssignTeacherView)
        self.objAssignTeacherView.isHidden = true
        self.objWorkDoneView.isHidden = true
        
        let weekRange = NSCalendar.current.range(of: .weekOfYear, in: .yearForWeekOfYear, for: Date())
        self.numberOfWeeks = weekRange?.count ?? 0
        
        let weekOfYear = Calendar.current.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        self.selectedWeek = weekOfYear - 1
//        let _ = self.dayRangeOf(weekOfMonth: weekOfYear, year: Int(self.year.string(from: Date())) ?? 0, month: Int(self.Month.string(from: Date())) ?? 0)
        
        let _ = self.dayRangeOfnew(weekOfYear: weekOfYear, for: Date())

        self.setUpScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.SelectedbtnRecent {
            self.getWorkListList()
        }
        else{
            self.getWorksheetWeeklyList()
        }
        self.view.bringSubviewToFront(objCollectionWeek)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.objCollectionWeek)
        }
    }
        
    //MARK: - Setup Method
    func setUpScreen(){
        if DeviceType.IS_IPAD {
            //            self.calendarHeightConstraint.constant = 400
        }
        
        self.objCalender.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        DispatchQueue.main.async {
            //            self.viewCardCalenderLess.isHidden = true
            self.viewCardCalender.isHidden = false
            
            self.objCalender.calendarHeaderView.backgroundColor = .clear
            self.objCalender.calendarWeekdayView.backgroundColor = .clear
            self.objCalender.appearance.eventSelectionColor = UIColor.white
            self.objCalender.appearance.eventOffset = CGPoint(x: 0, y: -7)
            self.objCalender.today = nil // Hide the today circle
            
            self.objCalender.swipeToChooseGesture.isEnabled = false // Swipe-To-Choose
            //            self.objCelenderView.calendarHeaderView.backgroundColor = .red
            self.objCalender.calendarWeekdayView.backgroundColor = .clear
            self.objCalender.allowsSelection = true
            self.objCalender.clipsToBounds = true
            
            self.objCalender.scrollEnabled = false
            self.objCalender.pagingEnabled = false

            self.lblCurrentMonth.text = self.Formatter.string(from: Date())
            self.tbl.reloadData()
        }
        
        self.objCalender.select(Date())
        self.objCalender.pagingEnabled = true
        self.objCalender.scope = .month
        self.objCalender.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        self.objCalender.appearance.todayColor = UIColor.kbtnAgeSetup()
        self.objCalender.accessibilityIdentifier = "calendar"
        
        if let nav = self.navigationController{
//            if let nav = self.navigationController{
//                nonTransparentNav(nav: nav)
//            }
            StudentnonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: self.strScreenTitle, titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(BackClicked), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            
        }
        btnSelected(btn: btnRecent)
        btnUnSelected(btn: btnWeeks)
        self.objviewUpper.layer.cornerRadius = 15
        self.objviewUpper.layer.borderWidth = 1
        self.objviewUpper.layer.borderColor = UIColor.kAppThemeColor().cgColor
        self.btnRecent.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.btnWeeks.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.btnNewPage.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        self.btnMyWorkbook.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        
        self.tbl.register(UINib(nibName: "StaticTextCell", bundle: nil), forCellReuseIdentifier: "StaticTextCell")
        self.collectionTeacherAssigned.register(UINib(nibName: "workBookstudentCell", bundle: nil), forCellWithReuseIdentifier: "workBookstudentCell")
        self.objCollectionRecentWork.register(UINib(nibName: "workBookstudentCell", bundle: nil), forCellWithReuseIdentifier: "workBookstudentCell")
        self.SelectedbtnRecent = true
        //        DispatchQueue.main.async {
        //            self.setBorderView(objView: self.objWorkDoneView)
        //            self.setBorderView(objView: self.objAssignTeacherView)
        //        }
        self.objCollectionWeek.reloadData()
    }
    
    func getWeekOfYear(from week: Int, year: Int? = Date().year, locale: Locale? = nil) -> Date? {
        var calendar = Calendar.current
        calendar.locale = locale
        let dateComponents = DateComponents(calendar: calendar, year: year, weekday: 2, weekOfYear: week)
        return calendar.date(from: dateComponents)
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to: date)!
    }
    
    func seeAllWorkDone()  {
        let nextVC = TaskListViewController.instantiate(fromAppStoryboard: .Student)
        nextVC.isSubjectList = false
        nextVC.isFromStudent = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func seeAllSubjectBook()  {
        let nextVC = TaskListViewController.instantiate(fromAppStoryboard: .Student)
        nextVC.isSubjectList = true
        nextVC.isFromStudent = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: - btn Click
    @objc func BackClicked(_ sender: Any){
        if isFromnotification{
            let nextVC = WelcomeStudentVC.instantiate(fromAppStoryboard: .Student)
            self.navigationController?.pushViewController(nextVC, animated: false)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    @IBAction func btnRecentClick(_ sender: Any) {
        btnSelected(btn: btnRecent)
        btnUnSelected(btn: btnWeeks)
        self.SelectedbtnRecent = true
        self.getWorkListList()
    }
    
    @IBAction func btnWeeksClick(_ sender: Any) {
        btnSelected(btn: btnWeeks)
        btnUnSelected(btn: btnRecent)
        self.arrSubjectWiseWorkbook.removeAll()
        self.arrWorkDone.removeAll()
        self.SelectedbtnRecent = false
        DispatchQueue.main.async {
            self.objCollectionWeek.scrollToItem(at: IndexPath(row: self.selectedWeek, section: 0), at: .centeredHorizontally, animated: true)
        }
        self.getWorksheetWeeklyList()
    }
    
    @IBAction func btnMyWorkbookClick(_ sender: Any) {
        if Preferance.user.workbookId == 0{
            let alert = UIAlertController(title: "PAL", message: "Are you sure want to add new workbook?",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in

            }))
            alert.addAction(UIAlertAction(title: "Yes",style: .default,handler: {(_: UIAlertAction!) in
                let objNext = StudentNewPageVC.instantiate(fromAppStoryboard: .Student)

                objNext.dismissStudent = { (count,index,img) in
                    DispatchQueue.main.async {
                        self.APICallcreateWorkbook(img: img)
                    }
                }
                self.present(objNext, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let objNext = UpdatedWorkbbokViewController.instantiate(fromAppStoryboard: .Student)
            self.navigationController?.pushViewController(objNext, animated: true)
        }
    }
    
    @IBAction func btnNewPageClick(_ sender: Any) {
        let objNext = StudentNewPageVC.instantiate(fromAppStoryboard: .Student)
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    func btnUnSelected(btn:UIButton) {
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 15
        btn.setTitleColor(UIColor.black, for: .normal)
    }
    
    func btnSelected(btn:UIButton){
        btn.backgroundColor = UIColor.kbtnAgeSetup()
        btn.layer.borderWidth = 0
        btn.layer.cornerRadius = 15
        btn.setTitleColor(UIColor.white, for: .normal)
    }
        
    func setBorderView(objView: UIView){
        let cellItemListHeight: CGFloat = cellRecentHeight - 120
        print((ScreenSize.SCREEN_WIDTH * 0.9))
        let rect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: (ScreenSize.SCREEN_WIDTH * 0.9), height: (cellItemListHeight*0.95)))//0.86
        let layer = CAShapeLayer.init()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        layer.path = path.cgPath
        layer.strokeColor = UIColor.black.cgColor
        layer.lineDashPattern = [10,10]
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        objView.layer.addSublayer(layer)
    }
    
    func dayRangeOfnew(weekOfYear: Int, for date: Date) -> Range<Date>
    {
        let calendar = Calendar.current
        let year = calendar.component(.yearForWeekOfYear, from: date)
        let startComponents = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year)
        let startDate = calendar.date(from: startComponents)!
        let endComponents = DateComponents(day:7, second: -1)
        let endDate = calendar.date(byAdding: endComponents, to: startDate)!
        let previousDate = self.gregorian.date(byAdding: .day, value: 1, to: startDate)!
        let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: endDate)!
        self.strStartDate = Sendformatter.string(from: previousDate)
        self.strEndDate = Sendformatter.string(from: nextDate)
        return startDate..<endDate
    }
    
    func dayRangeOf(weekOfMonth: Int, year: Int, month: Int) -> Range<Date>? {
        let calendar = Calendar.current
        //  let gregorian = Calendar(identifier: .gregorian)
        guard let startOfMonth = calendar.date(from: DateComponents(year:year, month:month)) else { return nil }
        var startDate = Date()
        if weekOfMonth == 1 {
            var interval = TimeInterval()
            guard calendar.dateInterval(of: .weekOfMonth, start: &startDate, interval: &interval, for: startOfMonth) else { return nil }
        }
        else {

            
            let nextComponents = DateComponents(year: year, month: month, weekOfMonth: weekOfMonth)
            guard let weekStartDate = calendar.nextDate(after: startOfMonth, matching: nextComponents, matchingPolicy: .nextTime) else {
                return nil
            }
            startDate = weekStartDate
        }
        let endComponents = DateComponents(day:7, second: -1)
        let endDate = calendar.date(byAdding: endComponents, to: startDate)!
        
        let previousDate = self.gregorian.date(byAdding: .day, value: 1, to: startDate)!
        let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: endDate)!
        
        self.strStartDate = Sendformatter.string(from: previousDate)
        self.strEndDate = Sendformatter.string(from: nextDate)
        print("test1 \(strEndDate)")
        print("test2 \(strStartDate)")
        return startDate..<endDate
    }
    
    //MARK: - API Call
    func APICallcreateWorkbook(img:UIImage){
        var params: [String: Any] = [ : ]
        params["studentId"] = Preferance.user.userId
        params["workbookImage"] = img
        
        APIManager.shared.callPostWithMultiPartApi(reqURL: URLs.APIURL + getUserTye() + createWorkbook, parameters: params, showLoader: true) { (jsonData, error) in
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1 {
                        let objNext = UpdatedWorkbbokViewController.instantiate(fromAppStoryboard: .Student)
                        objNext.imgBackground = img
                        self.navigationController?.pushViewController(objNext, animated: true)
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
    
    func getWorkListList() {
        
        var params: [String: Any] = [ : ]
        
        params["subjectId"] = subjectId
        params["pageIndex"] = 0
        params["isWeek"] = 0
        params["startDate"] = self.strStartDate
        params["endDate"] = self.strEndDate
        params["deviceType"] = MyApp.device_type
        
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getStudentWorksheetList, showLoader: true, vc:self) { (jsonData, error) in
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        self.arrSubjectWiseWorkbook.removeAll()
                        if let linkTeacher = userData.newStudentWorkBook {
                            self.arrSubjectWiseWorkbook = linkTeacher.assigned!
                            if self.arrSubjectWiseWorkbook.count > 0{
                                self.objAssignTeacherView.isHidden = false
                            }
                            else{
                                self.objAssignTeacherView.isHidden = true
                            }
                            self.objWeeklyWorkList.reloadData()
                        }
                        if let workdone = userData.newStudentWorkBook?.WorkDone{
                            self.arrWorkDone = workdone
                            if self.arrWorkDone.count > 0{
                                self.objWorkDoneView.isHidden = true
                            }
                            else{
                                self.objWorkDoneView.isHidden = false
                            }
                            self.objCollectionRecentWork.reloadData()
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrSubjectWiseWorkbook.count > 0{
                            self.objWeeklyWorkList.backgroundView = nil
                            self.objAssignTeacherView.isHidden = true
                            self.lblNoTeacherAssign.isHidden = true
                            self.lblNoData.isHidden = true
                            self.lblNoData.text = "No Data Found."
                        }
                        else{
                            self.objAssignTeacherView.isHidden = false
                            self.lblNoTeacherAssign.isHidden = false
                            self.lblNoData.isHidden = false
                        }
                        self.objCollectionWeek.reloadData()
                        self.collectionTeacherAssigned.reloadData()
                        
                        self.tbl.reloadData()
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
    
    func getWorksheetWeeklyList() {
        
        var params: [String: Any] = [ : ]
        
        params["subjectId"] = subjectId
        params["startDate"] = self.strStartDate
        params["endDate"] = self.strEndDate
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getWeeklyWorksheet, showLoader: true, vc:self) { (jsonData, error) in
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        self.arrSubjectWiseWorkbook.removeAll()
                        if let linkTeacher = userData.studentWorkbooklist {
                            self.arrSubjectWiseWorkbook = linkTeacher
                            if self.arrSubjectWiseWorkbook.count > 0{
                                self.objAssignTeacherView.isHidden = false
                            }
                            else{
                                self.objAssignTeacherView.isHidden = true
                            }
                            self.objWeeklyWorkList.reloadData()
                        }
                        if self.arrSubjectWiseWorkbook.count == 0{
                            self.objWeeklyWorkList.backgroundView = nil
                            self.objAssignTeacherView.isHidden = false
                            self.lblNoTeacherAssign.isHidden = false
                            self.lblNoData.isHidden = false
                            self.lblNoData.text = "No Data Found."
                        }
                        else{
                            self.objAssignTeacherView.isHidden = true
                            self.lblNoTeacherAssign.isHidden = true
                            self.lblNoData.isHidden = true
                        }
                        self.objCollectionWeek.reloadData()
                        self.tbl.reloadData()
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

//MARK: - tbl delegate/datasource
extension WorkBookStudentVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.SelectedbtnRecent) ? 5:2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.SelectedbtnRecent {
            switch indexPath.row {
            case 0:
                return self.cellMyWorkBookButton
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
                let isIndexValid = arrSubjectWiseWorkbook.indices.contains(indexPath.row)
                if isIndexValid{
                    if let strTeacher = self.arrSubjectWiseWorkbook[indexPath.row].teacherName{
                        cell.lblName.text = "Assigned Work by \(strTeacher)"
                        
                    }
                    else {
                        cell.lblName.text =  "Assigned Work by "
                    }
                }
                else{
                    cell.lblName.text =  "Assigned Work by"
                }
                if self.arrSubjectWiseWorkbook.count > 2 {
                    cell.btnAction.isHidden = false
                    cell.btnActionArrow.isHidden = false
                }
                else{
                    cell.btnAction.isHidden = true
                    cell.btnActionArrow.isHidden = true
                }
                cell.btnSeeAllCompletion = {
                    self.seeAllSubjectBook()
                }
                return cell
            case 2 :
                return cellTeacherAssigned
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
                cell.lblName.text = "Recent Work By Student"
                if self.arrWorkDone.count > 2 {
                    cell.btnAction.isHidden = false
                    cell.btnActionArrow.isHidden = false
                }
                else{
                    cell.btnAction.isHidden = true
                    cell.btnActionArrow.isHidden = true
                }
                cell.btnSeeAllCompletion = {
                    self.seeAllWorkDone()
                }
                return cell
            default:
                return cellRecentWork
            }
        }
        else{
            switch indexPath.row {
            case 0:
                return CellDatePicker
            default:
                self.cellWeekWorksheetList.backgroundColor = .clear
                return self.cellWeekWorksheetList
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.SelectedbtnRecent {
            switch indexPath.row {
            case 0:
                return 140
            case 1:
                return 80
            case 2 :
                if self.arrSubjectWiseWorkbook.count == 0{
                    return cellRecentHeight - 120
                }
                else{
                    return cellRecentHeight
                }
            case 3:
                return 80
            case 4 :
                if self.arrWorkDone.count == 0{
                    return cellRecentHeight - 120
                }
                else{
                    self.objWorkDoneView.isHidden = true
                    self.lblNoWorkDone.isHidden = true
                    return cellRecentHeight
                }
                
            default:
                return 120
            }
        }
        else{
            switch indexPath.row {
            case 0:
                return 500
            case 1 :
                if self.arrSubjectWiseWorkbook.count > 0{
                    if self.arrSubjectWiseWorkbook.count < 3 {
                        return self.cellRecentHeight + 35
                    }
                    else {
                        return ((CGFloat((self.arrSubjectWiseWorkbook.count / 3)) * self.cellRecentHeight) + 35)
                    }
                }
                else{
                    return 0
                }
            default:
                return 120
            }
        }
    }
}

//MARK: - collection delegate/datasource
extension WorkBookStudentVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{//Assigned Worksheet list
            return self.arrSubjectWiseWorkbook.count
        }
        else if collectionView.tag == 2{//RecentWork Worksheet list(Completed)
            return self.arrWorkDone.count
        }
        else if collectionView.tag == 3{//Weekly worksheet (Week Tap Selected item)
            return self.arrSubjectWiseWorkbook.count
        }
        else if collectionView.tag == 4{//Calender week (52 week && 53 week)
            return self.numberOfWeeks
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workBookstudentCell", for: indexPath) as! workBookstudentCell
            if arrSubjectWiseWorkbook[indexPath.row].assign_type == 1{
                cell.objViewCircle.backgroundColor = UIColor.kAppThemeColor()
                cell.lblChar.text = "P"
            }
            else{
                cell.objViewCircle.backgroundColor = .red
                cell.lblChar.text = "M"
            }
            cell.lblName.text = arrSubjectWiseWorkbook[indexPath.row].worksheetName
            cell.lblData.text = arrSubjectWiseWorkbook[indexPath.row].subCategory
            if let url = self.arrSubjectWiseWorkbook[indexPath.row].pdfThumb,url.trim.count > 0{
                cell.imgView.imageFromURL(url, placeHolder: imgWorksheetIconPlaceholder)
                cell.imgView.backgroundColor = .white
            }
            return cell
            
        }
        else if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workBookstudentCell", for: indexPath) as! workBookstudentCell
            if self.arrWorkDone[indexPath.row].assign_type == 1{
                cell.objViewCircle.backgroundColor = UIColor.kAppThemeColor()
                cell.lblChar.text = "P"
            }
            else{
                cell.objViewCircle.backgroundColor = .red
                cell.lblChar.text = "M"
            }
            cell.lblName.text = arrWorkDone[indexPath.row].worksheetName
            cell.lblData.text = arrWorkDone[indexPath.row].subCategory
            if let url = self.arrWorkDone[indexPath.row].pdfThumb,url.trim.count > 0{
                cell.imgView.imageFromURL(url, placeHolder: imgWorksheetIconPlaceholder)
                cell.imgView.backgroundColor = .white
            }
            return cell
            
        }
        else  if collectionView.tag == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskListCollectionViewCell", for: indexPath) as! TaskListCollectionViewCell
            cell.lblSubject.text = self.arrSubjectWiseWorkbook[indexPath.row].subjectName
            cell.lblTeacherName.text = "Teacher : \(self.arrSubjectWiseWorkbook[indexPath.row].teacherName ?? "")"
            cell.lblDate.text = self.arrSubjectWiseWorkbook[indexPath.row].startDate
            if let url = self.arrSubjectWiseWorkbook[indexPath.row].pdfThumb,url.trim.count > 0{
                cell.imgview.imageFromURL(url, placeHolder: imgWorksheetIconPlaceholder)
            }
            return cell
        }
        else if collectionView.tag == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekSelectionCell", for: indexPath) as! weekSelectionCell
            cell.lblWeek.text = "Week \(indexPath.row+1)"
            
            if self.selectedWeek == indexPath.row{
                cell.objView.backgroundColor = UIColor.kApp_Sky_Color()
                cell.lblWeek.textColor = UIColor.white
            }
            else{
                cell.objView.backgroundColor = UIColor.clear
                cell.lblWeek.textColor = UIColor.kApp_Sky_Color()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1{
            if arrSubjectWiseWorkbook[indexPath.row].pdfImages?.count ?? 0 > 0{
                let objnext = WorksheetViewController.instantiate(fromAppStoryboard: .Student)
                objnext.isMarking = arrSubjectWiseWorkbook[indexPath.row].assign_type ?? 0
                objnext.arrAllImg = arrSubjectWiseWorkbook[indexPath.row].pdfImages
                objnext.workSheetId = arrSubjectWiseWorkbook[indexPath.row].worksheetId ?? 0
                objnext.teacherName = arrSubjectWiseWorkbook[indexPath.row].teacherName ?? ""
                objnext.uniqueID = arrSubjectWiseWorkbook[indexPath.row].worksheetId ?? 0
                objnext.subjectId = arrSubjectWiseWorkbook[indexPath.row].subjectId ?? 0
                objnext.teacherId = arrSubjectWiseWorkbook[indexPath.row].teacherId ?? ""
                objnext.subCategoryId = arrSubjectWiseWorkbook[indexPath.row].subCategoryId ?? 0
                objnext.assign_type = arrSubjectWiseWorkbook[indexPath.row].assign_type ?? 0
                objnext.eraser = arrSubjectWiseWorkbook[indexPath.row].eraser ?? 0
                objnext.spellChecker = arrSubjectWiseWorkbook[indexPath.row].spellChecker ?? 0
                objnext.worksheetName = arrSubjectWiseWorkbook[indexPath.row].worksheetName ?? ""
                objnext.isFromStudent = true
                if let arrTemp = arrSubjectWiseWorkbook[indexPath.row].instruction{
                    objnext.arrInstruction = arrTemp
                }
                if let arrVoiceTemp = arrSubjectWiseWorkbook[indexPath.row].voiceinstruction{
                    objnext.arrvoiceInstruction = arrVoiceTemp
                }
                self.navigationController?.pushViewController(objnext, animated: true)
            }
            else{
                print("No Worksheet Found.")
            }
        }
        else if collectionView.tag == 2{
            if !Connectivity.isConnectedToInternet() {
                showAlert(title: APP_NAME, message: Messages.NOINTERNET)
                return
            }
            let objNext = WorksheetViewVC.instantiate(fromAppStoryboard: .Student)
            objNext.arrImages = self.arrWorkDone[indexPath.row].pdfImages ?? []
            if let arrPdf = arrWorkDone[indexPath.row].pdfImages{
                objNext.arrImages = arrPdf
            }
            if let arrInstruction = self.arrWorkDone[indexPath.row].instruction{
                objNext.arrInstruction = arrInstruction
            }
            if let arrvoiceInstruction = self.arrWorkDone[indexPath.row].voiceinstruction{
                objNext.arrvoiceInstruction = arrvoiceInstruction
            }
            
            self.navigationController?.pushViewController(objNext, animated: true)
        }
        else if collectionView.tag == 3{
            if let isComplete = self.arrSubjectWiseWorkbook[indexPath.row].isComplete,  isComplete == 1{
                let objNext = WorksheetViewVC.instantiate(fromAppStoryboard: .Student)
                objNext.arrImages = self.arrSubjectWiseWorkbook[indexPath.row].pdfImages ?? []
                if let arrPdf = arrSubjectWiseWorkbook[indexPath.row].pdfImages{
                    objNext.arrImages = arrPdf
                }
                if let arrInstruction = self.arrSubjectWiseWorkbook[indexPath.row].instruction{
                    objNext.arrInstruction = arrInstruction
                }
                if let arrvoiceInstruction = self.arrSubjectWiseWorkbook[indexPath.row].voiceinstruction{
                    objNext.arrvoiceInstruction = arrvoiceInstruction
                }
                self.navigationController?.pushViewController(objNext, animated: true)
            }
            else{
                if arrSubjectWiseWorkbook[indexPath.row].pdfImages?.count ?? 0 > 0{
                    let objnext = WorksheetViewController.instantiate(fromAppStoryboard: .Student)
                    objnext.isMarking = arrSubjectWiseWorkbook[indexPath.row].assign_type ?? 0
                    objnext.arrAllImg = arrSubjectWiseWorkbook[indexPath.row].pdfImages
                    objnext.workSheetId = arrSubjectWiseWorkbook[indexPath.row].worksheetId ?? 0
                    objnext.teacherName = arrSubjectWiseWorkbook[indexPath.row].teacherName ?? ""
                    objnext.uniqueID = arrSubjectWiseWorkbook[indexPath.row].worksheetId ?? 0
                    objnext.subjectId = arrSubjectWiseWorkbook[indexPath.row].subjectId ?? 0
                    objnext.teacherId = arrSubjectWiseWorkbook[indexPath.row].teacherId ?? ""
                    objnext.subCategoryId = arrSubjectWiseWorkbook[indexPath.row].subCategoryId ?? 0
                    objnext.assign_type = arrSubjectWiseWorkbook[indexPath.row].assign_type ?? 0
                    objnext.eraser = arrSubjectWiseWorkbook[indexPath.row].eraser ?? 0
                    objnext.spellChecker = arrSubjectWiseWorkbook[indexPath.row].spellChecker ?? 0
                    objnext.worksheetName = arrSubjectWiseWorkbook[indexPath.row].worksheetName ?? ""
                    objnext.isFromStudent = true
                    if let arrTemp = arrSubjectWiseWorkbook[indexPath.row].instruction{
                        objnext.arrInstruction = arrTemp
                    }
                    if let arrTemp = arrSubjectWiseWorkbook[indexPath.row].voiceinstruction{
                        objnext.arrvoiceInstruction = arrTemp
                    }
                    self.navigationController?.pushViewController(objnext, animated: true)
                }
                else{
                    print("No Worksheet Found.")
                }
            }
        }
        else if collectionView.tag == 4{
            self.selectedWeek = indexPath.row
            
            //self.objCollectionWeek.reloadData()
            
//            let _ = self.dayRangeOf(weekOfMonth: indexPath.row + 1, year: Int(self.year.string(from: self.objCalender.currentPage)) ?? 0, month: Int(self.Month.string(from: self.objCalender.currentPage)) ?? 0)
            let _ = self.dayRangeOfnew(weekOfYear: indexPath.row + 1, for: Date())
            self.objCalender.select(getWeekOfYear(from: self.selectedWeek+1)!)
            self.objCalender.setCurrentPage(getWeekOfYear(from: self.selectedWeek+1)!, animated: true)
            let _ = self.calendar(self.objCalender, shouldSelect: getWeekOfYear(from: self.selectedWeek+1)!, at: .current)
            self.calendar(self.objCalender, didSelect:getWeekOfYear(from: self.selectedWeek+1)!, at: .current)
            
            self.getWorksheetWeeklyList()
        }
    }
}

//MARK: - FSCalender delegate/datasource
extension WorkBookStudentVC:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.objCalender.frame.size.height = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        var firstDate: Date?
        var lastDate: Date?
        var datesRange: [Date]?
        //self.arrWeekDate.removeAll()
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            print("datesRange contains: \(datesRange!)")
            configureVisibleCells()
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            //            if date <= firstDate! {
            calendar.deselect(firstDate!)
            firstDate = date
            datesRange = [firstDate!]
            
            print("datesRange contains: \(datesRange!)")
            configureVisibleCells()
            return
        }
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            lastDate = nil
            firstDate = nil
            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        cell.backgroundColor = .clear
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == FSCalendarMonthPosition.current
    }
    
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        print("did deselect date \(self.formatter.string(from: date))")
        configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        cell.numberOfEvents = 0
        cell.eventIndicator.isHidden = false
        cell.eventIndicator.color = UIColor.clear
        cell.backgroundColor = .clear
        self.configureCell(cell, for: date, at: monthPosition)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.lblCurrentMonth.text = self.Formatter.string(from: calendar.currentPage)
        self.objCollectionWeek.reloadData()
        let _ = self.dayRangeOfnew(weekOfYear: 1, for: Date())
//        let _ = self.dayRangeOf(weekOfMonth: 1, year: Int(self.year.string(from: calendar.currentPage)) ?? 0, month: Int(self.Month.string(from: calendar.currentPage)) ?? 0)
    }
}

//MARK: - screen support methods
extension WorkBookStudentVC {
    
    func configureVisibleCells() {
        self.objCalender.visibleCells().forEach { (cell) in
            let date = self.objCalender.date(for: cell)
            let position = self.objCalender.monthPosition(for: cell)
            self.configureCell(cell, for: date, at: position)
        }
    }
    
    func configureCell(_ cell: FSCalendarCell?, for date: Date?, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        //        print(date)
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            var calendarstr = Calendar.autoupdatingCurrent
            calendarstr.firstWeekday = 2 // Start on Monday (or 1 for Sunday)
            let today = calendarstr.startOfDay(for: date!)
            var week = [Date]()
            if #available(iOS 10.0, *) {
                if let weekInterval = calendarstr.dateInterval(of: .weekOfYear, for: today) {
                    for i in 0...6 {
                        if let day = calendarstr.date(byAdding: .day, value: i, to: weekInterval.start) {
                            week += [day]
                            if self.objCalender.selectedDates.contains(day) {
                                print(self.objCalender.selectedDates)
                                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: day)!
                                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: day)!
                                let startWeek = (date?.startOfWeek)!
                                let endWeek = date?.endOfWeek
                                let dateFormat1 = DateFormatter()
                                dateFormat1.dateFormat = "dd-MM-yyyy"
                                let startWeek2 = dateFormat1.string(from: startWeek)
                                let dateFormat12 = DateFormatter()
                                dateFormat12.dateFormat = "dd-MM-yyyy"
                                let endWeek2 = dateFormat12.string(from: endWeek!)
                                
                                let tempFormatter = DateFormatter()
                                tempFormatter.dateFormat = "dd-MM-yyyy"
                                //self.arrWeekDate.append(date!)
                                if self.objCalender.selectedDates.contains(day) {
                                    if self.objCalender.selectedDates.contains(previousDate) && self.objCalender.selectedDates.contains(nextDate) {
                                        selectionType = .single
                                    }
                                    else {
                                        selectionType = .single
                                    }
                                    //print(self.arrWeekDate)
                                }
                            }
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            //print(self.arrWeekDate)
            
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            diyCell.selectionLayer?.isHidden = true
        }
    }
    
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
}
