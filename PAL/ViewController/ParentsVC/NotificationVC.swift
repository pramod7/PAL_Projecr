//
//  NotificationVC.swift
//  PAL Design
//
//  Created by i-Phone7 on 02/11/20.
//

import UIKit

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    //MARK: - Outlet variable
    @IBOutlet var tblNotification: UITableView!{
        didSet{
            tblNotification.rowHeight = UITableView.automaticDimension
        }
    }
    
    //MARK: - Local variable
    private var refreshControl = UIRefreshControl()
    var arrNotificationList = [NotificationListModel]()
    var arrSection = [String]()
    var showLoader = Bool()
    var datePicker = UIDatePicker(){
        didSet{
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Date()
        }
    }
    var strSelectedDate = ""
    var strSelectedTime = ""
    var selectedRow = 0
    var selectedSection = 0

    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tblNotification.addSubview(refreshControl) // not required when using UITableViewController
        
        self.APICallGetNotificationList()
        if self.arrNotificationList.count > 0{
            self.tblNotification.backgroundView = nil
        }
        else{
            let lbl = UILabel.init(frame: self.tblNotification.frame)
            lbl.text = "No Notification(s) found"
            lbl.textAlignment = .center
            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
            self.tblNotification.backgroundView = lbl
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: ScreenTitle.Notifications, titleColor: .white)
        self.navigationItem.titleView = titleLabel
        
        if Preferance.user.userType == 0{
            
            Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
        }
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @objc func buttonAccept(sender : UIButton) {
        self.APICallInterviewReq(isAvailable: 0, teacherId: arrNotificationList[sender.tag].interviewRequestTeacherId ?? 0, studentId: arrNotificationList[sender.tag].childId ?? 0,staticdate: arrNotificationList[sender.tag].interviewRequestDate ?? "",staticTime: arrNotificationList[sender.tag].interviewRequestTime ?? "")
    }
    
    @objc func buttonChangeDate(sender : UIButton) {
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        selectedRow = row
        selectedSection = section
        print(row)
        print(section)
        let cell = self.tblNotification.cellForRow(at: IndexPath(row: row, section: section)) as! NotificationCell
        
        self.strSelectedDate = ""
        self.datePicker.datePickerMode = .date
        cell.txtDate.becomeFirstResponder()
        
//        date = "11/10/2022"
//        time = "21:03"
//        self.APICallInterviewReq(isAvailable: 1, teacherId: arrNotificationList[sender.tag].interviewRequestTeacherId ?? 0, studentId: arrNotificationList[sender.tag].childId ?? 0,staticdate: arrNotificationList[sender.tag].interviewRequestDate ?? "",staticTime: arrNotificationList[sender.tag].interviewRequestTime ?? "")
    }
    
    
    //MARK: - txt delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if DeviceType.IS_IPAD{
            
            self.view.endEditing(true)
            let alertView = UIAlertController(title:" ", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet);
            alertView.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            if !DeviceType.IS_IPAD{
                self.datePicker.center.x = self.view.center.x
            }
            alertView.view.addSubview(self.datePicker)
            if let popover = alertView.popoverPresentationController {
                popover.permittedArrowDirections = .up
                alertView.popoverPresentationController?.sourceView = textField
                alertView.popoverPresentationController?.sourceRect = textField.bounds
            }
            let action = UIAlertAction(title: Messages.OK, style: .default, handler: { [self] (alert) in
                let dateFormatter = DateFormatter()
                
                if self.strSelectedDate.trim.count == 0{
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    self.strSelectedDate = dateFormatter.string(from: self.datePicker.date)
                    print("Selected Date: ", self.strSelectedDate)
                    
                    self.datePicker.datePickerMode = .time
                    textField.becomeFirstResponder()
                }
                else{
                    dateFormatter.dateFormat = "HH:mm"
                    self.strSelectedTime = dateFormatter.string(from: self.datePicker.date)
                    print("Selected Time: ", self.strSelectedTime)
                    //API Call
                    
                    self.APICallInterviewReq(isAvailable: 1, teacherId: self.arrNotificationList[selectedSection].interviewRequestTeacherId ?? 0, studentId: self.arrNotificationList[selectedSection].childId ?? 0,staticdate: self.arrNotificationList[selectedSection].interviewRequestDate ?? "",staticTime: self.arrNotificationList[selectedSection].interviewRequestTime ?? "")
                }
            })
            action.setValue(UIColor(named: "Color_appTheme")!, forKey: "titleTextColor")
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    @objc func donePressed() {
        var strIdentifier = String()
        if DeviceType.IS_IPAD {
            strIdentifier = "NotificationCell_iPad"
        }
        else {
            strIdentifier = "NotificationCell"
        }
        let cell1 = self.tblNotification.dequeueReusableCell(withIdentifier: strIdentifier) as! NotificationCell
        cell1.txtDate.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }
    
    @objc func doneButtonDatePicker() {
        self.view.endEditing(true)
        
        let cell1 = self.tblNotification.cellForRow(at: IndexPath(row: selectedRow, section: selectedSection)) as! NotificationCell
        let formatter = DateFormatter()
        
        if self.strSelectedDate.trim.count == 0{
            formatter.dateFormat = "dd/MM/yyyy"
            self.strSelectedDate = formatter.string(from: self.datePicker.date)
            print("Selected Date: ", self.strSelectedDate)
            cell1.txtDate.resignFirstResponder()
            self.datePicker.datePickerMode = .time
           
            let delayTime = DispatchTime.now() + 1.0
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                cell1.txtDate.becomeFirstResponder()
            })
            
        }
        else{
            formatter.dateFormat = "HH:mm"
            self.strSelectedTime = formatter.string(from: self.datePicker.date)
            print("Selected Time: ", self.strSelectedTime)
            
            
            //API Call
            self.APICallInterviewReq(isAvailable: 1, teacherId: self.arrNotificationList[selectedSection].interviewRequestTeacherId ?? 0, studentId: self.arrNotificationList[selectedSection].childId ?? 0,staticdate: self.arrNotificationList[selectedSection].interviewRequestDate ?? "",staticTime: self.arrNotificationList[selectedSection].interviewRequestTime ?? "")
        }
    }
    
    
    
    
    
    //MARK: - tbl delegate/datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrNotificationList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleStaticLineCell") as! SingleStaticLineCell
        let strTime = arrNotificationList[section].date ?? ""
        let myDate = strTime.getDateFromString(_dateFormat: "yyyy-MM-dd hh:mm:ss")
        let convertedTime = myDate.getElapsedIntervalll()
        cell.lblText.text = convertedTime
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var strIdentifier = String()
        if DeviceType.IS_IPAD {
            strIdentifier = "NotificationCell_iPad"
        }
        else {
            strIdentifier = "NotificationCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier) as! NotificationCell
        cell.lblLine.isHidden = (indexPath.section == 1) ? true : false
       
        if arrNotificationList[indexPath.section].notificationType != 14 {
            cell.lblNameIndicator.text = arrNotificationList[indexPath.section].fullName?.first?.uppercased()
            cell.lblName.text = arrNotificationList[indexPath.section].fullName ?? ""
            cell.lblMssg.text = arrNotificationList[indexPath.section].message ?? ""
        }else{
            cell.lblNameIndicator.text = "A"
            cell.lblName.text = "Admin"
            cell.lblMssg.text = arrNotificationList[indexPath.section].message ?? ""
        }
        
        
        if arrNotificationList[indexPath.section].notificationType != 15
        {
            cell.objRequestView.isHidden = true
            cell.objTop.constant = 0
            cell.objRequestViewHeight.constant = 0
            cell.objBottom.constant = 15
        }else{
            if arrNotificationList[indexPath.section].interviewRequestAccept == 0
            {
                cell.objRequestView.isHidden = false
                
              
                if DeviceType.IS_IPAD{
                    cell.objRequestViewHeight.constant = 65
                    cell.objTop.constant = 15
                    cell.objBottom.constant = 15
                }else{
                    cell.objRequestViewHeight.constant = 40
                    cell.objTop.constant = 10
                    cell.objBottom.constant = 10
                }
            }else{
                cell.objRequestView.isHidden = true
                cell.objTop.constant = 0
                cell.objRequestViewHeight.constant = 0
                cell.objBottom.constant = 15
            }
        }
        
        
        cell.btnAccept.tag = indexPath.section
        cell.btnAccept.addTarget(self, action: #selector(buttonAccept(sender:)), for: UIControl.Event.touchUpInside)
        cell.btnChangeDate.tag = (indexPath.section * 1000) + indexPath.row
        
        //cell.btnChangeDate.tag = indexPath.section
        cell.btnChangeDate.addTarget(self, action: #selector(buttonChangeDate(sender:)), for: UIControl.Event.touchUpInside)
        
        
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
//        cell.txtDate.inputAccessoryView = toolBar
//        cell.txtDate.inputView = self.datePicker
//        cell.txtDate.text = "\(self.datePicker.date)"
//        toolBar.setItems([doneBtn], animated: true)
        
        if DeviceType.IS_IPHONE{
            cell.txtDate.inputView = self.datePicker
            let toolbar = UIToolbar();
            toolbar.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            toolbar.sizeToFit()
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonDatePicker));
            toolbar.setItems([spaceButton,doneButton], animated: false)
            cell.txtDate.inputAccessoryView = toolbar
        }
        
        //        UIGraphicsBeginImageContext(cell.lblNameIndicator.frame.size)
        //        UIGraphicsBeginImageContextWithOptions(cell.lblNameIndicator.bounds.size, false, UIScreen.main.scale)
        //        cell.lblNameIndicator.layer.render(in: UIGraphicsGetCurrentContext()!)
        //        cell.imgUserPic.image = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        //        cell.lblNameIndicator.textColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Preferance.user.userType == 0{
            if arrNotificationList[indexPath.section].notificationType != 14 {
                let color = arrNotificationList[indexPath.section].subjectCoverColor ?? ""
                Singleton.shared.save(object: color, key: UserDefaultsKeys.navColor)
                let objNextVC = WorkBookStudentVC.instantiate(fromAppStoryboard: .Student)
                objNextVC.isFromStudent = true
                objNextVC.subjectId = arrNotificationList[indexPath.section].subjectId ?? 0
                objNextVC.strScreenTitle = arrNotificationList[indexPath.section].subjectName ?? ""
                self.navigationController?.pushViewController(objNextVC, animated: true)
            }
        }else if Preferance.user.userType == 1{
            if arrNotificationList[indexPath.section].notificationType != 14 {
            let objNextVC = ChildrenProfileVC.instantiate(fromAppStoryboard: .ParentDashboard)
            objNextVC.childID = arrNotificationList[indexPath.section].childId ?? 0
            objNextVC.lblDateValue.text = arrNotificationList[indexPath.section].dob ?? ""
            objNextVC.lblUserid.text = arrNotificationList[indexPath.section].student_Id ?? ""
            objNextVC.strugleArea = arrNotificationList[indexPath.section].childStrugleArea ?? ""
            if arrNotificationList[indexPath.section].gender == 0{
                objNextVC.lblGenderValue.text = "Boy"
            }
            else{
                objNextVC.lblGenderValue.text = "Girl"
            }
            let FirstName = arrNotificationList[indexPath.section].firstName ?? ""
            let LastName = arrNotificationList[indexPath.section].lastName ?? ""
            objNextVC.lblUserName.text = FirstName + " " + LastName
            objNextVC.lblNameIndicator.text =  arrNotificationList[indexPath.section].firstName?.first?.uppercased()
            self.navigationController?.pushViewController(objNextVC, animated: true)
            }
        }else{
            if arrNotificationList[indexPath.section].notificationType != 14 {
            let objNext = StudentProfileVC.instantiate(fromAppStoryboard: .Teacher)
            objNext.studentId = arrNotificationList[indexPath.section].childId ?? 0
            self.navigationController?.pushViewController(objNext, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            if DeviceType.IS_IPHONE{
                return section == 0 ? 60:40
            }
            else {
                return section == 0 ? 80:50
            }
        }else{
            let strTime = arrNotificationList[section].date ?? ""
            let myDate = strTime.getDateFromString(_dateFormat: "yyyy-MM-dd hh:mm:ss")
            
            let strATime = arrNotificationList[section-1].date ?? ""
            let myADate = strATime.getDateFromString(_dateFormat: "yyyy-MM-dd hh:mm:ss")
            
            
            let lastMssgDateTime = myDate
            
            let CurrentMssgDateTime = myADate
            
            if Calendar.current.isDate(lastMssgDateTime, inSameDayAs: CurrentMssgDateTime)   {
                return 0
            }
            else {
                if DeviceType.IS_IPHONE{
                    return section == 0 ? 60:40
                }
                else {
                    return section == 0 ? 80:50
                }
                
            }
            
        }
        
    }
    
    
    //MARK: - API Call
    func APICallInterviewReq(isAvailable:Int,teacherId:Int,studentId:Int,staticdate:String,staticTime:String) {
    
        var params : [String : Any] = [:]
        params["studentId"] = studentId
        params["deviceType"] = MyApp.device_type
        params["teacherId"] = teacherId
        params ["isAvailable"] = isAvailable
        params ["date"] = staticdate
        params ["time"] = staticTime
        
        if isAvailable == 1
        {
            params["changeDate"] = self.strSelectedDate
            params["changeTime"] = self.strSelectedTime
        }
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getInetrviewRequest, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil{
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                        self.APICallGetNotificationList()
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
    
    
    func APICallGetNotificationList() {
        self.refreshControl.beginRefreshing()
        var params : [String : Any] = [:]
        params["userId"] = Preferance.user.userId
        params["userType"] = Preferance.user.userType
        params["deviceType"] = MyApp.device_type
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getNotifications, showLoader: true, vc:self) { (jsonData, error) in
            
            self.refreshControl.endRefreshing()
            self.arrNotificationList.removeAll()
            if jsonData != nil{
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let user = userData.NotificationList {
                            for tempStudent in user {
                                self.arrNotificationList.append(tempStudent)
                            }
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        self.tblNotification.reloadData()
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                }
            }
            if self.arrNotificationList.count > 0{
                self.tblNotification.backgroundView = nil
            }
            else{
                let lbl = UILabel.init(frame: self.tblNotification.frame)
                lbl.text = "No Notification(s) found"
                lbl.textAlignment = .center
                lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
                self.tblNotification.backgroundView = lbl
            }
            self.tblNotification.reloadData()
        }
    }
    
    //MARK: - btn click event
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.refreshControl.endRefreshing()
        //        self.APICallGetNotificationList()
    }
    
}
extension Date {
    func getElapsedIntervalll() -> String {
        let todayDF = DateFormatter()
        todayDF.dateFormat = "dd MMM yyyy"
        let todayTime = DateFormatter()
        todayTime.dateFormat = "hh:mm a"
        if Calendar.current.isDateInToday(self) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        }else {
            return "\(todayDF.string(from: self))"
        }
    }
}
extension String {
    func getDateFromString(_dateFormat: String) -> Date{
        var _date = Date()
        let df = DateFormatter()
        df.dateFormat = _dateFormat
        if let _tempDate = df.date(from: self) {
            _date = _tempDate
        }
        return _date
    }
    
    func convertDate(date: Date, formate: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        let date = formatter.string(from: date)
        return date.uppercased()
    }
}
