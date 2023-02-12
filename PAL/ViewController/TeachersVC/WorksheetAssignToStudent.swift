//
//  WorksheetAssignToStudent.swift
//  PAL
//
//  Created by i-Verve on 18/12/20.
//

import UIKit
import FSCalendar

class WorksheetAssignToStudent: UIViewController, UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate {
    
    //MARK: - Outlets variable
    @IBOutlet weak var tblAssign: UITableView!
    @IBOutlet weak var lblWeekTitle: UILabel!{
        didSet{
            self.lblWeekTitle.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    @IBOutlet weak var lblCurrentMonth: UILabel!{
        didSet{
            self.lblCurrentMonth.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    //cell studentList
    @IBOutlet var cellStudentList: UITableViewCell!
    @IBOutlet weak var viewCardStudent: UIView!{
        didSet{
            self.viewCardStudent.shadowWithCornerReduisAndRect(cornerReduis: 15, layerColor: .white, width:(ScreenSize.SCREEN_WIDTH*0.95), height: 445 )
        }
    }
    
    //cell SelectAll
    @IBOutlet var cellSelectAll: UITableViewCell!
    @IBOutlet var viewSelectAll: UIView!{
        didSet{
            viewSelectAll.layer.shadowColor = UIColor.black.cgColor
            viewSelectAll.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            viewSelectAll.layer.shadowOpacity = 0.2
            viewSelectAll.layer.shadowRadius = 5
        }
    }
    @IBOutlet var lblSelectAll: UILabel!{
        didSet{
            lblSelectAll.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    
    //cell Calender
    @IBOutlet var cellCalender: UITableViewCell!
    @IBOutlet var viewCardCalender: UIView!{
        didSet{
            self.viewCardCalender.shadowWithCornerReduisAndRect(cornerReduis: 15, layerColor: .white, width:(ScreenSize.SCREEN_WIDTH*0.95), height:calenderHeight - 55)
        }
    }
    @IBOutlet var viewCardCalenderLess: UIView!{
        didSet{
            self.viewCardCalenderLess.shadowWithCornerReduisAndRect(cornerReduis: 15, layerColor: .white, width:(ScreenSize.SCREEN_WIDTH*0.95), height:200 - 55)
        }
    }
    @IBOutlet var objCelenderView: FSCalendar!{
        didSet{
            self.objCelenderView.calendarHeaderView.isHidden = true
            self.objCelenderView.appearance.weekdayFont = UIFont.Font_WorkSans_Regular(fontsize: 12)
            self.objCelenderView.appearance.titleFont = UIFont.Font_WorkSans_Regular(fontsize: 14)
            self.objCelenderView.allowsMultipleSelection = true
            self.objCelenderView.firstWeekday = 2
            self.objCelenderView.swipeToChooseGesture.isEnabled = true
        }
    }
    
    @IBOutlet weak var btnAssignWorkSheet: UIButton!{
        didSet{
            self.btnAssignWorkSheet.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
            self.btnAssignWorkSheet.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var lblNoStudent: UILabel!{
        didSet{
            self.lblNoStudent.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    
    //MARK: - Local variable
    var arrWeekDate = [Date]()
    var arrSelectedStudent = [Int]()
    var arrStudentList = [StudentListModel]()
    var pageIndex: Int = 0
    var worksheetName = String()
    var worksheetId: Int?
    var subjectId = Int()
    var assigntype = Int()
    var colour = String()
    var studentId = String()
    var startDate = ""
    var endDate = ""
    var category_id = Int()
    var isFromFav = Bool()
    var strStartOfWeek = ""
    var strEndOfWeek = ""
 
    
    var firstDate: Date?
    var lastDate: Date?
    var datesRange: [Date]?
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
    let highlightedColorForRange = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
    let staticTextHeight: CGFloat = 40
    let calenderHeight: CGFloat = 445
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "\(self.worksheetName) - Work Sheet", titleColor: .white)
        self.navigationItem.titleView = titleLabel
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        self.tblAssign.register(UINib(nibName: "StaticTextCell", bundle: nil), forCellReuseIdentifier: "StaticTextCell")
        
        self.objCelenderView.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        DispatchQueue.main.async {
            self.viewCardCalenderLess.isHidden = true
            self.viewCardCalender.isHidden = false
            
            self.objCelenderView.calendarHeaderView.backgroundColor = .clear
            self.objCelenderView.calendarWeekdayView.backgroundColor = .clear
            self.objCelenderView.appearance.eventSelectionColor = UIColor.white
            self.objCelenderView.appearance.eventOffset = CGPoint(x: 0, y: -7)
            self.objCelenderView.today = nil // Hide the today circle
            
            self.objCelenderView.swipeToChooseGesture.isEnabled = false // Swipe-To-Choose
            //            self.objCelenderView.calendarHeaderView.backgroundColor = .red
            self.objCelenderView.calendarWeekdayView.backgroundColor = .clear
            self.objCelenderView.allowsMultipleSelection = true
            self.objCelenderView.clipsToBounds = true
            
            self.lblCurrentMonth.text = self.dateFormatter.string(from: Date())
            self.tblAssign.reloadData()
        }
        self.APICallGetStudentList(showLoader: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if self.isFromFav{
            if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
                , colorName.trim.count > 0{
                self.navigationController?.navigationBar.barTintColor = UIColor(named: colorName)
            }
        }
        else{
            self.navigationController?.navigationBar.barTintColor = UIColor(hexString: colour)
        }
    }
    
    //MARK: - Button Click
    @IBAction func btnAssignWorkSheet(_ sender: Any) {
        
        if strStartOfWeek == "" || strEndOfWeek == ""{
            showAlert(title: APP_NAME, message: "Please select Date.")
        }
        else if self.arrSelectedStudent.count == 0{
            showAlert(title: APP_NAME, message: "Please choose at least one student.")
        }
        else{
            let formatter = NumberFormatter()
            formatter.numberStyle = .none
            
            let nextVC =  AddInstructionVC.instantiate(fromAppStoryboard: .Teacher)
            nextVC.studentIds = self.arrSelectedStudent.compactMap { formatter.string(for: $0) }
            .joined(separator: ", ")
            nextVC.worksheet_id = self.worksheetId ?? 0
            nextVC.subjectId = self.subjectId
            nextVC.categoryId = self.category_id
            nextVC.assigntype = self.assigntype
            nextVC.strStartOfWeek = self.strStartOfWeek
            nextVC.strEndOfWeek = self.strEndOfWeek
            nextVC.isFromFav = isFromFav
//            nextVC.dismissInstruction = { (arrinstruction,isEraser,isSpellchecker) in
//                DispatchQueue.main.async {
//                    self.teacherWorkSheetAssign(showLoader: true, isEraser: isEraser, isSpellchecker: isSpellchecker, arrinstruction: arrinstruction)
//                }
//            }
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func btnCalenderClick(_ sender: Any) {
        //        if self.objCelenderView.scope == .month {
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        //                self.viewCardCalenderLess.isHidden = false
        //            }
        //            self.viewCardCalender.isHidden = true
        //            self.objCelenderView.setScope(.week, animated: true)
        //        }
        //        else {
        //            self.viewCardCalenderLess.isHidden = true
        //            self.viewCardCalender.isHidden = false
        //            self.objCelenderView.setScope(.month, animated: true)
        //        }
        //        self.tblAssign.reloadData()
    }
    
    @objc func btnBackClick(){
        self.arrWeekDate.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - support method
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4 + self.arrStudentList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if tableView.tag == 0 {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
                cell.lblName.text = "Select Week"
                cell.btnAction.isHidden = true
                cell.btnActionArrow.isHidden = true
                //cell.backgroundColor = .red
                return cell
            case 1:
                return cellCalender
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
                cell.lblName.text = "Select Student"
                cell.btnAction.isHidden = true
                cell.btnActionArrow.isHidden = true
                //cell.backgroundColor = .red
                return cell
            case 3:
                return cellSelectAll
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AllocationStudentCell") as! AllocationStudentCell
                if arrStudentList.count > 0
                {
                    if let name = self.arrStudentList[indexPath.row - 4].studentName{
                        cell.lblName.text = name
                        cell.lblIndicator.text = name.first?.uppercased()
                    }
                    if let tempId = self.arrStudentList[indexPath.row - 4].studentId{
                        if self.arrSelectedStudent.contains(tempId){
                            cell.imgSelect.image = UIImage(named: "Icon_Selected")
                        }
                        else{
                            cell.imgSelect.image = UIImage(named: "Icon_Non_Selected")
                        }
                    }
                }
                if self.arrStudentList.count + 4 == indexPath.row + 1
                {
                    cell.objBottomshadoview.constant = 1
                }
                
                return cell
        }
        //        }
        //        else{
        //            if indexPath.row == 0 {
        //                return cellSelectAll
        //            }
        //            else {
        //                let cell = tableView.dequeueReusableCell(withIdentifier: "AllocationStudentCell") as! AllocationStudentCell
        //                if let name = self.arrStudentList[indexPath.row - 1].studentName{
        //                    cell.lblName.text = name
        //                    cell.lblIndicator.text = name.first?.uppercased()
        //                }
        //                if let tempId = self.arrStudentList[indexPath.row - 1].studentId{
        //                    if self.arrSelectedStudent.contains(tempId){
        //                        cell.imgSelect.image = UIImage(named: "Icon_Selected")
        //                    }
        //                    else{
        //                        cell.imgSelect.image = UIImage(named: "Icon_Non_Selected")
        //                    }
        //                }
        //
        //                return cell
        //            }
        //        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
            case 1:
                if self.objCelenderView.scope == .month {
                    return calenderHeight
                }
                else {
                    return 200
                }
                //return (self.objCelenderView.scope == .month) ?calenderHeight:200
            case 3:
                return 100
            case 4:
                return CGFloat(self.arrStudentList.count + 1 * 100)
            default:
                return (indexPath.row == 0) ?75:80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            print(indexPath.row)
        case 2:
            print(indexPath.row)
        case 3:
            if self.arrSelectedStudent.count < self.arrStudentList.count{
                self.arrSelectedStudent.removeAll()
                self.imgSelected.image = UIImage(named: "Icon_Selected")
                for i in self.arrStudentList{
                    self.arrSelectedStudent.append(i.studentId ?? 0)
                }
                print(self.arrSelectedStudent)
            }
            else {
                self.arrSelectedStudent.removeAll()
                self.imgSelected.image = UIImage(named: "Icon_Non_Selected")
            }
            self.tblAssign.reloadData()
        default:
            if let tempId = self.arrStudentList[indexPath.row - 4].studentId{
                if self.arrSelectedStudent.contains(tempId){
                    self.arrSelectedStudent = self.arrSelectedStudent.filter{ $0
                        != tempId }
                }
                else {
                    self.arrSelectedStudent.append(tempId)
                }
            }
            print(self.arrSelectedStudent)
            if self.arrSelectedStudent.count < self.arrStudentList.count {
                self.imgSelected.image = UIImage(named: "Icon_Non_Selected")
            }
            else{
                self.imgSelected.image = UIImage(named: "Icon_Selected")
            }
            self.tblAssign.reloadData()
        }
    }
    
    //MARK: - API Call
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    // MARK: - Private functions
    //
    //    private func configureVisibleCells() {
    //        calendar.visibleCells().forEach { (cell) in
    //            let date = calendar.date(for: cell)
    //            let position = calendar.monthPosition(for: cell)
    //            self.configure(cell: cell, for: date!, at: position)
    //        }
    //    }
    //
    //    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    //
    //        let diyCell = (cell as! DIYCalendarCell)
    //        // Custom today circle
    //        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
    //        // Configure selection layer
    //        if position == .current {
    //
    //            var selectionType = SelectionType.none
    //
    //            var calendarstr = Calendar.autoupdatingCurrent
    //            calendarstr.firstWeekday = 2 // Start on Monday (or 1 for Sunday)
    //            let today = calendarstr.startOfDay(for: date)
    //            var week = [Date]()
    //            if #available(iOS 10.0, *) {
    //                if let weekInterval = calendarstr.dateInterval(of: .weekOfYear, for: today) {
    //                    for i in 0...6 {
    //                        if let day = calendarstr.date(byAdding: .day, value: i, to: weekInterval.start) {
    //                            week += [day]
    //                            if calendar.selectedDates.contains(day) {
    //                                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: day)!
    //                                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: day)!
    //
    //                                if calendar.selectedDates.contains(day) {
    //
    //                                    print(date)
    //                                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
    //                                        selectionType = .middle
    //                                    }
    //                                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(day) {
    //                                        selectionType = .rightBorder
    //                                    }
    //                                    else if calendar.selectedDates.contains(nextDate) {
    //                                        selectionType = .leftBorder
    //                                    }
    //                                    else {
    //                                        selectionType = .single
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            } else {
    //                // Fallback on earlier versions
    //            }
    //
    //            if selectionType == .none {
    //                diyCell.selectionLayer.isHidden = true
    //                return
    //            }
    //            diyCell.selectionLayer.isHidden = false
    //            diyCell.selectionType = selectionType
    //
    //        } else {
    //            diyCell.circleImageView.isHidden = true
    //            diyCell.selectionLayer.isHidden = true
    //        }
    //    }
    
    
    func APICallGetStudentList(showLoader: Bool) {
        
        var params: [String: Any] = [ : ]
        params["pageIndex"] = pageIndex
        
        APIManager.shared.callPostApi(parameters:params, reqURL: URLs.APIURL + getUserTye() + studentList, showLoader: showLoader, vc:self) { (jsonData, error) in
            APIManager.hideLoader()
            if let json = jsonData{
                if let userData = ListResponse(JSON: json.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let user = userData.studentList {
                            for tempStudent in user {
                                self.arrStudentList.append(tempStudent)
                            }
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrStudentList.count > 0{
//                            self.tblAssign.backgroundView = nil
//                            self.tblAssign.reloadData()
                            self.tblAssign.isHidden = false
                            self.lblWeekTitle.isHidden = false
                            self.lblNoStudent.isHidden = true
                            self.btnAssignWorkSheet.isHidden = false
                        }
                        else{
                            self.tblAssign.isHidden = true
                            self.lblWeekTitle.isHidden = true
                            self.lblNoStudent.isHidden = false
                            self.btnAssignWorkSheet.isHidden = true
//                            let lbl = UILabel.init(frame: self.tblAssign.frame)
//                            lbl.text = "No Student(s) found"
//                            lbl.textAlignment = .center
//                            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
//                            self.tblAssign.backgroundView = lbl
                        }
                        self.lblNoStudent.backgroundColor = .red
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                }
            }
            else{
                showAlert(title: APP_NAME, message: error?.debugDescription)
            }
            if self.arrStudentList.count > 0{
                self.tblAssign.reloadData()
            }
        }
    }
    
    
    func teacherWorkSheetAssign(showLoader: Bool,isEraser:Int,isSpellchecker:Int,arrinstruction:[String]){
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        
        var params: [String: Any] = [ : ]
        params["studentId"] = self.arrSelectedStudent.compactMap { formatter.string(for: $0) }
        .joined(separator: ", ")
        params["worksheet_id"] = self.worksheetId
        params["subjectId"] = self.subjectId
        params["category_id"] = self.category_id
        params["assign_type"] = self.assigntype
        params["assign_status"] = 1
        params["assigned_by"] = (Preferance.user.userType == 0) ?2:1
        params["startDate"] = self.strStartOfWeek//self.startDate
        params["endDate"] = self.strEndOfWeek//self.endDate
        params["instruction"] = arrinstruction
        params["eraser"] = isEraser
        params["spellChecker"] = isSpellchecker
        params["reAssign"] = 0
        params["device_type"] = 1
        
        APIManager.shared.callPostApi(parameters:params, reqURL: URLs.APIURL + getUserTye() + doTeacherWorkSheetAssign, showLoader: showLoader, vc:self) { (jsonData, error) in
            APIManager.hideLoader()
            if let json = jsonData{
                if let userData = ListResponse(JSON: json.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        let alert = UIAlertController(title: APP_NAME, message: userData.message, preferredStyle: .alert)
                        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
                        let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: {action in
                            
                            if self.isFromFav {
                                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                                for aViewController in viewControllers {
                                    if aViewController is TeacherSubjectWorkSheetListVC {
                                        self.navigationController!.popToViewController(aViewController, animated: true)
                                    }
                                }
                            }
                            else {
                                if let viewControllers = self.navigationController?.viewControllers{
                                    for controller in viewControllers{
                                        if controller is TeacherDashboardVC{
                                            self.navigationController?.popToViewController(controller, animated: true)
                                        }
                                    }
                                }
                            }
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
    
    // MARK:- FSCalendarDelegate
    //
    //    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    //        self.objCelenderView.frame.size.height = bounds.height
    //        //self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    //    }
    //
    //    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
    //        return monthPosition == .current
    //    }
    //
    //    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    //        return monthPosition == .current
    //    }
    //
    //    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    //        print("did select date \(self.formatter.string(from: date))")
    //        self.configureVisibleCells()
    //    }
    //
    //    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
    //        print("did deselect date \(self.formatter.string(from: date))")
    //        self.configureVisibleCells()
    //    }
    //
    //    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
    //        if self.gregorian.isDateInToday(date) {
    //            return [UIColor.orange]
    //        }
    //        return [appearance.eventDefaultColor]
    //    }
    //
    //    // MARK: - Private functions
    //
    //    private func configureVisibleCells() {
    //        self.objCelenderView.visibleCells().forEach { (cell) in
    //            let date = self.objCelenderView.date(for: cell)
    //            let position = self.objCelenderView.monthPosition(for: cell)
    //            self.configure(cell: cell, for: date!, at: position)
    //        }
    //    }
    //
    //    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    //        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
    //        return cell
    //    }
    //
    //    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    //
    //        let diyCell = (cell as! DIYCalendarCell)
    //        // Custom today circle
    ////        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
    //        // Configure selection layer
    //        if position == .current {
    //
    //            var selectionType = SelectionType.none
    //
    //            var calendarstr = Calendar.autoupdatingCurrent
    //            calendarstr.firstWeekday = 2 // Start on Monday (or 1 for Sunday)
    //            let today = calendarstr.startOfDay(for: date)
    //            var week = [Date]()
    //            if #available(iOS 10.0, *) {
    //                if let weekInterval = calendarstr.dateInterval(of: .weekOfYear, for: today) {
    //                    for i in 0...6 {
    //                        if let day = calendarstr.date(byAdding: .day, value: i, to: weekInterval.start) {
    //                            week += [day]
    //                            if self.objCelenderView.selectedDates.contains(day) {
    //                                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: day)!
    //                                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: day)!
    //
    //                                if self.objCelenderView.selectedDates.contains(day) {
    //
    //                                    print(date)
    //                                    if self.objCelenderView.selectedDates.contains(previousDate) && self.objCelenderView.selectedDates.contains(nextDate) {
    //                                        selectionType = .middle
    //                                    }
    ////                                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(day) {
    ////                                        selectionType = .rightBorder
    ////                                    }
    ////                                    else if calendar.selectedDates.contains(nextDate) {
    ////                                        selectionType = .leftBorder
    ////                                    }
    //                                    else {
    //                                        selectionType = .single
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            } else {
    //                // Fallback on earlier versions
    //            }
    //
    //
    //
    ////            if calendar.selectedDates.contains(week) {
    ////                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
    ////                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
    ////                if calendar.selectedDates.contains(date) {
    ////
    ////                    print(date)
    ////                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
    ////                        selectionType = .middle
    ////                    }
    ////                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
    ////                        selectionType = .rightBorder
    ////                    }
    ////                    else if calendar.selectedDates.contains(nextDate) {
    ////                        selectionType = .leftBorder
    ////                    }
    ////                    else {
    ////                        selectionType = .single
    ////                    }
    ////                }
    ////            }
    ////            else {
    ////                selectionType = .none
    ////            }
    //            if selectionType == .none {
    //                diyCell.selectionLayer.isHidden = true
    //                return
    //            }
    //            diyCell.selectionLayer.isHidden = false
    //            diyCell.selectionType = selectionType
    //
    //        } else {
    ////            diyCell.circleImageView.isHidden = true
    //            diyCell.selectionLayer.isHidden = true
    //        }
    //    }
}

extension WorksheetAssignToStudent {
    
    func configureVisibleCells() {
        self.objCelenderView.visibleCells().forEach { (cell) in
            let date = self.objCelenderView.date(for: cell)
            let position = self.objCelenderView.monthPosition(for: cell)
            self.configureCell(cell, for: date, at: position)
        }
    }
    
    func configureCell(_ cell: FSCalendarCell?, for date: Date?, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        //        print(date)
        
        //
        
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
                            if self.objCelenderView.selectedDates.contains(day) {
                                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: day)!
                                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: day)!
                                // print(date!)
                                let startWeek = (date?.startOfWeek)!
                                let endWeek = date?.endOfWeek
                                let dateFormat1 = DateFormatter()
                                dateFormat1.dateFormat = "dd-MM-yyyy"
                                let startWeek2 = dateFormat1.string(from: startWeek)
                                let dateFormat12 = DateFormatter()
                                dateFormat12.dateFormat = "dd-MM-yyyy"
                                let endWeek2 = dateFormat12.string(from: endWeek!)
                                
                                //                                if strStartOfWeek == ""
                                //                                {
                                self.strStartOfWeek = startWeek2
                                print(self.strStartOfWeek)
                                //                                }
                                
                                //                                if strEndOfWeek == ""
                                //                                {
                                self.strEndOfWeek = endWeek2
                                print(self.strEndOfWeek)
                                
                                let tempFormatter = DateFormatter()
                                tempFormatter.dateFormat = "dd-MM-yyyy"
                                //                                self.arrWeekDate.append(tempFormatter.string(from: date!))
                                self.arrWeekDate.append(date!)
                                
                                if self.objCelenderView.selectedDates.contains(day) {
                                    if self.objCelenderView.selectedDates.contains(previousDate) && self.objCelenderView.selectedDates.contains(nextDate) {
                                        selectionType = .single
                                    }
                                    //                                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(day) {
                                    //                                        selectionType = .rightBorder
                                    //                                    }
                                    //                                    else if calendar.selectedDates.contains(nextDate) {
                                    //                                        selectionType = .leftBorder
                                    //                                    }
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

extension WorksheetAssignToStudent:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.self.objCelenderView.frame.size.height = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print(date)
        let calendarData = Calendar.current
        let weekOfYear = calendarData.component(.weekOfMonth, from: date)
        print("Week of Month \(weekOfYear)")
        self.lblWeekTitle.text = "Week -\(weekOfYear)"
        
        self.arrWeekDate.removeAll()
       
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
            //            }
            //            let range = datesRange(from: firstDate!, to: date)
            //            lastDate = range.last
            //            for d in range {
            //                calendar.select(d)
            //            }
            //            datesRange = range
            //            print("datesRange contains: \(datesRange!)")
            //            configureVisibleCells()
            //            return
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
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.lblCurrentMonth.text = self.dateFormatter.string(from: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        cell.backgroundColor = .clear
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        cell.numberOfEvents = 0
        cell.eventIndicator.isHidden = false
        cell.eventIndicator.color = UIColor.clear
        cell.backgroundColor = .clear
        self.configureCell(cell, for: date, at: monthPosition)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == FSCalendarMonthPosition.current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did deselect date \(self.formatter.string(from: date))")
        configureVisibleCells()
    }
}
