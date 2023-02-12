//
//  CertificateTypeVC.swift
//  PAL
//
//  Created by i-Verve on 24/11/20.
//

import UIKit

class CertificateTypeVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,StudentListDelegate, CertificateSelectionListDelegate {
    
    //MARK:- Outlet Variable
    @IBOutlet weak var lblType: UILabel!{
        didSet{
            self.lblType.font = UIFont.Font_ProductSans_Bold(fontsize: 22)
        }
    }
    @IBOutlet weak var btnExcellence: UIButton!{
        didSet{
            self.btnExcellence.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 20)
            self.btnExcellence.alpha = 0.5
        }
    }
    @IBOutlet weak var btnimprovemnt: UIButton!{
        didSet{
            self.btnimprovemnt.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 20)
            self.btnimprovemnt.alpha = 0.5
        }
    }
    @IBOutlet weak var btnparticipation: UIButton!{
        didSet{
            self.btnparticipation.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 20)
            self.btnparticipation.alpha = 0.5
        }
    }
    @IBOutlet weak var objView: UIView!{
        didSet{
            self.objView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var tblCertificate: UITableView!
    @IBOutlet weak var objFilter: UIView!
    @IBOutlet weak var btnExcellenceb: UIButton!{
        didSet{
            self.btnExcellenceb.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            self.btnExcellenceb.alpha = 0.5
        }
    }
    @IBOutlet weak var btnImprovement: UIButton!{
        didSet{
            self.btnImprovement.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            self.btnImprovement.alpha = 0.5
        }
    }
    @IBOutlet weak var btnParticipationb: UIButton!{
        didSet{
            self.btnParticipationb.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            self.btnParticipationb.alpha = 0.5
        }
    }
    @IBOutlet weak var btnNofilterb: UIButton!{
        didSet{
            self.btnNofilterb.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            self.btnNofilterb.alpha = 0.5
        }
    }
    @IBOutlet weak var btnaddCerti: UIButton!{
        didSet{
            self.btnaddCerti.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            self.btnaddCerti.alpha = 0.5
            self.btnaddCerti.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var btncancelCerti: UIButton!{
        didSet{
            self.btncancelCerti.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            self.btncancelCerti.alpha = 0.5
        }
    }
    @IBOutlet weak var objViewFilter: UIView!{
        didSet{
            objViewFilter.layer.cornerRadius = 5
            objViewFilter.borderShadowAllSide(Radius: 5)
        }
    }
    @IBOutlet weak var objViewAddInner: UIView!{
        didSet{
            objViewAddInner.layer.cornerRadius = 10
            objViewAddInner.borderShadowAllSide(Radius: 5)
        }
    }
    @IBOutlet weak var objaddView: UIView!{
        didSet{
            objaddView.layer.cornerRadius = 10
            objaddView.borderShadowAllSide(Radius: 5)
        }
    }
    @IBOutlet weak var lblCertificateType: UILabel!
    @IBOutlet weak var txtCertificateType: UITextField!
    
    @IBOutlet weak var lblStudentName: UILabel!
    @IBOutlet weak var txtStudentName: UITextField!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtSelectDate: UITextField!
    
    //MARK:- local variable
    var isShowLoader: Bool = true
    var arrCertificateType = [CertificateTypeListModel]()
    var arrCertificateList = [CertificateListModel]()
    var strStudentName = String()
    var isLoadingList : Bool = false
    var pageIndex: Int = 0
    var isFilter: Int = 0
    let pagingSpinner = UIActivityIndicatorView(style: .gray)
    var pickerView = UIPickerView()
    var arrChildrenCount = [String]()
    var StudentID: Int = 0
    var CertificateID: Int = 0
    var isFromStudentProfile: Bool = false
    var arrStudentList = [StudentListModel]()
    var datePickerChild = UIDatePicker(){
        didSet{
            self.datePickerChild.datePickerMode = .date
            self.datePickerChild.minimumDate = Date()
        }
    }
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        objFilter.isHidden = true
        objaddView.isHidden = true
        self.btnNofilterb.setTitleColor(.black, for: .normal)
        self.btnParticipationb.setTitleColor(.black, for: .normal)
        self.btnImprovement.setTitleColor(.black, for: .normal)
        self.btnExcellenceb.setTitleColor(.black, for: .normal)
        txtCertificateType.delegate = self
        txtStudentName.delegate = self
        txtSelectDate.delegate = self
        self.datePickerChild.datePickerMode = .date
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            if isFromStudentProfile == false {
                let titleLabel = UILabel()
                titleLabel.navTitle(strText: "Certificates", titleColor: .white)
                self.navigationItem.titleView = titleLabel
                //self.navigationItem.setHidesBackButton(true, animated: true)
                
                let btnBack: UIButton = UIButton()
                btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
                btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
                btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
                
                let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 20))
                let btnNotification = UIButton(frame: iconSize)
                btnNotification.imageView?.contentMode = .scaleAspectFit
                let imgTemp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                imgTemp.image = UIImage(named: "Icon_FIlter")
                btnNotification.addSubview(imgTemp)
                btnNotification.addTarget(self, action: #selector(btnNotificationClick), for: .touchUpInside)
                
                let barNotificationsButton = UIBarButtonItem(customView: btnNotification)
                
                let btnTaskList = UIButton(frame: iconSize)
                let imgTemp2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                imgTemp2.image = UIImage(named: "Icon_New Page")
                btnTaskList.addSubview(imgTemp2)
                btnTaskList.addTarget(self, action: #selector(btnNewCertificateClick), for: .touchUpInside)
                let barTaskListButton = UIBarButtonItem(customView: btnTaskList)
                
                self.navigationItem.rightBarButtonItems = [barNotificationsButton, barTaskListButton]
            }
            else{
                let titleLabel = UILabel()
                titleLabel.navTitle(strText: "Certificates", titleColor: .white)
                self.navigationItem.titleView = titleLabel
                
                let btnBack: UIButton = UIButton()
                btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
                btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
                btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            }
        }
        self.pickerViewSetUp()
        self.APICallGetCertificateList(showLoader: self.isLoadingList, isFilter: 4)
        APICallGetStudentList(showLoader: false)
        if #available(iOS 13.4, *) {
            self.datePickerChild.preferredDatePickerStyle = .wheels
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.APICallGetCertificateType(showLoader: isShowLoader)
    }
    
    //MARK:- Support Method
    
    func pickerViewSetUp() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.pickerDone))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.txtCertificateType.inputAccessoryView = toolBar
        
        
        self.lblCertificateType.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
        self.txtCertificateType.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblStudentName.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
        self.txtStudentName.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblDate.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
        self.txtSelectDate.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        
        let dateFormater: DateFormatter = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let _: String = dateFormater.string(from: self.datePickerChild.date) as String
    }
    
    //MARK:- pickerView delegate/datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrChildrenCount.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrChildrenCount[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtCertificateType.text = self.arrChildrenCount[row]
    }
    //MARK:- btn Click
    @IBAction func btnCloseAddView(_ sender: Any) {
        objaddView.isHidden = true
    }
    
    @IBAction func btnCloseFilter(_ sender: Any) {
        objFilter.isHidden = true
    }
    
    @IBAction func btnExcellence(_ sender: Any) {
        self.btnExcellenceb.setTitleColor(UIColor(named: "Color_appTheme")!, for: .selected)
        self.btnNofilterb.setTitleColor(.black, for: .normal)
        self.btnParticipationb.setTitleColor(.black, for: .normal)
        self.btnImprovement.setTitleColor(.black, for: .normal)
        objFilter.isHidden = true
        isFilter = 1
        self.APICallGetCertificateList(showLoader: self.isLoadingList, isFilter: isFilter)
    }
    
    @IBAction func btnImprovement(_ sender: Any) {
        self.btnImprovement.setTitleColor(.orange, for: .selected)
        self.btnNofilterb.setTitleColor(.black, for: .normal)
        self.btnParticipationb.setTitleColor(.black, for: .normal)
        self.btnExcellenceb.setTitleColor(.black, for: .normal)
        objFilter.isHidden = true
        isFilter = 2
        self.APICallGetCertificateList(showLoader: self.isLoadingList, isFilter: isFilter)
    }
    
    @IBAction func btnConfrimAddCerti(_ sender: Any) {
        if self.txtCertificateType.text == ""
        {
            showAlertWith(message: "Please enter Certificate type", inView: self)
        }else if self.txtStudentName.text == ""
        {
            showAlertWith(message: "Please enter Student name", inView: self)
        }else if self.txtSelectDate.text == ""
        {
            showAlertWith(message: "Please select Date", inView: self)
        }else{
            self.APIcreateCertificate()
        }
    }
    
    @IBAction func btnCancelAddCerti(_ sender: Any) {
        objaddView.isHidden = false
    }
    
    @IBAction func btnNoFilter(_ sender: Any) {
        self.btnNofilterb.setTitleColor(.orange, for: .selected)
        self.btnExcellenceb.setTitleColor(.black, for: .normal)
        self.btnParticipationb.setTitleColor(.black, for: .normal)
        self.btnImprovement.setTitleColor(.black, for: .normal)
        objFilter.isHidden = true
        isFilter = 4
        self.APICallGetCertificateList(showLoader: self.isLoadingList, isFilter: isFilter)
    }
    @IBAction func btnParticipation(_ sender: Any) {
        self.btnParticipationb.setTitleColor(.orange, for: .selected)
        self.btnExcellenceb.setTitleColor(.black, for: .normal)
        self.btnNofilterb.setTitleColor(.black, for: .normal)
        self.btnImprovement.setTitleColor(.black, for: .normal)
        objFilter.isHidden = true
        isFilter = 3
        self.APICallGetCertificateList(showLoader: self.isLoadingList, isFilter: isFilter)
    }
    
    @objc func btnNotificationClick(){
        objFilter.isHidden = false
    }
    
    @objc func btnNewCertificateClick(){
        if arrStudentList.isEmpty {
            showAlertWith(message: "You have not any student Linked.so,you can not create Certificate", inView: self)
        }
        else{
            txtSelectDate.text = ""
            txtStudentName.text = ""
            txtCertificateType.text = ""
            objaddView.isHidden = false
        
        }
            
      
    }
    
    @objc func btnBackClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func selectionView(img: String) {
        let imgView = UIImageView()
        imgView.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: Placeholder.subjectImg))
    }
    
    @IBAction func btnExcellenceClick(_ sender: UIButton) {
        var certificateType = Int()
        if sender.tag == 0{
            self.btnimprovemnt.alpha = 0.5
            self.btnparticipation.alpha = 0.5
            self.btnExcellence.alpha = 1
            certificateType = 3
        }
        else if sender.tag == 1{
            self.btnimprovemnt.alpha = 1
            self.btnparticipation.alpha = 0.5
            self.btnExcellence.alpha = 0.5
            certificateType = 2
        }
        else if sender.tag == 2{
            self.btnimprovemnt.alpha = 0.5
            self.btnparticipation.alpha = 1
            self.btnExcellence.alpha = 0.5
            certificateType = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let nextVC = CertificateInfoVC.instantiate(fromAppStoryboard: .ParentDashboard)
            nextVC.isCertificateType = certificateType
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func pickerDone() {
        self.view.endEditing(true)
        if self.txtCertificateType.text?.trim.count == 0{
            self.txtCertificateType.text = self.arrChildrenCount[0]
        }
    }
    
    func saveStudent(strText: NSString, strID: NSInteger) {
        self.txtStudentName.text = strText as String
        self.StudentID = strID
    }
    
    func CertificateSelection(strText: NSString, strID: NSInteger) {
        self.txtCertificateType.text = strText as String
        self.CertificateID = strID
    }
    
    //MARK:- API Call
    func APICallGetCertificateType(showLoader: Bool) {
        APIManager.shared.callGetApi(reqURL: URLs.APIURL + getUserTye() + getCertificateType, showLoader: showLoader) { (jsonData, error) in
            self.isShowLoader = false
            if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                if let status = userData.status, status == 1{
                    self.arrCertificateType.removeAll()
                    if let user = userData.certificateTypeList {
                        for tempSub in user {
                            self.arrCertificateType.append(tempSub)
                        }
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
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
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCertificateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var strIdentifier = String()
        if DeviceType.IS_IPAD {
            strIdentifier = "CertificateCellIpad"
        }
        else {
            strIdentifier = "CertificateCell"
        }
        let cell = tblCertificate.dequeueReusableCell(withIdentifier: strIdentifier) as! CertificateCell
//        if DeviceType.IS_IPAD {
//            cell.backgroundColor = .red
//        }
        cell.lblName.text = self.arrCertificateList[indexPath.row].studentName!
        cell.lblCertificate.attributedText = certificateType(str: self.arrCertificateList[indexPath.row].certificateName!)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.date(from: self.arrCertificateList[indexPath.row].date!)
        formatter.dateFormat = "d MMM, yyyy"
        cell.lblDate.text = formatter.string(from: date!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DeviceType.IS_IPHONE ?100:140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = CertificateInfoVC.instantiate(fromAppStoryboard: .ParentDashboard)
        nextVC.isCertificateType = (indexPath.row == 1) ? 2:3
        nextVC.childName = self.arrCertificateList[indexPath.row].studentName ?? ""
        nextVC.IsString = self.arrCertificateList[indexPath.row].pdfUrl!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK:- scrollView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.pagingSpinner.startAnimating()
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
        else {
            self.pagingSpinner.stopAnimating()
        }
    }
    
    //MARK:- Textfield Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtSelectDate && DeviceType.IS_IPAD{
            self.view.endEditing(true)
            let alertView = UIAlertController(title:" ", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet);
            alertView.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            if !DeviceType.IS_IPAD{
                datePickerChild.center.x = self.view.center.x
            }
            alertView.view.addSubview(datePickerChild)
            if let popover = alertView.popoverPresentationController {
                popover.permittedArrowDirections = .up
                alertView.popoverPresentationController?.sourceView = self.txtSelectDate
                alertView.popoverPresentationController?.sourceRect = self.txtSelectDate.bounds
            }
            let action = UIAlertAction(title: Messages.OK, style: .default, handler: { (alert) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM yyyy"
                self.txtSelectDate.text = dateFormatter.string(from: self.datePickerChild.date)
            })
            action.setValue(UIColor(named: "Color_appTheme")!, forKey: "titleTextColor")
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        else if textField == self.txtStudentName {
            let nextVC = StudentListVC.instantiate(fromAppStoryboard: .Teacher)
            nextVC.delegate = self
            nextVC.isPopOver = true
            nextVC.IsFromAddProgressReport = true
            let nav = UINavigationController(rootViewController: nextVC)
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                nextVC.preferredContentSize = CGSize(width: popoverWidth,height: 320)
                popover.permittedArrowDirections = .up
                popover.sourceView = self.txtStudentName
                popover.sourceRect = self.txtStudentName.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
            return false
        }
        else if textField == self.txtCertificateType{
            let nextVC = CertificateSelectionVC.instantiate(fromAppStoryboard: .Teacher)
            nextVC.delegate = self
            nextVC.isPopOver = true
            let nav = UINavigationController(rootViewController: nextVC)
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                nextVC.preferredContentSize = CGSize(width: popoverWidth,height: 320)
                popover.permittedArrowDirections = .up
                popover.sourceView = self.txtCertificateType
                popover.sourceRect = self.txtCertificateType.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
            return false
        }
        return false
    }
    
    
    //MARK:- Support method
    
    @objc func doneButtonDatePicker() {
        self.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        self.txtSelectDate.text = formatter.string(from: datePickerChild.date)
        self.txtSelectDate.resignFirstResponder()
    }
    
    func saveSubject(strText: NSString, strID: NSInteger) {
        self.txtStudentName.text = strText as String
        self.StudentID = strID
    }
    
    func loadMoreItemsForList(){
        self.pageIndex += 1
        self.APICallGetCertificateList(showLoader: !self.isLoadingList, isFilter: isFilter)
    }
    
    //MARK:- btn click
    @objc func BackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK:- API Call
    
    func APIcreateCertificate()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM,yyyy"
        let date = formatter.date(from: self.txtSelectDate.text!)
        formatter.dateFormat = "dd-MM-yyyy"
        let Datestr = formatter.string(from: date!)
        
        var params : [String : Any] = [:]
        params["studentId"] = self.StudentID
        params["date"] = Datestr
        params["schoolId"] = Preferance.user.schoolId
        params["certificateType"] = self.CertificateID
        
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + createCertificate, showLoader: true, vc:self) { (jsonData, error) in
            if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                if let status = userData.status, status == 1{
                    self.APICallGetCertificateList(showLoader: self.isLoadingList, isFilter: self.isFilter)
                    self.objaddView.isHidden = true
                }
                else{
                    if let msg = jsonData?[APIKey.message].string {
                        showAlert(title: APP_NAME, message: msg)
                    }
                }
            }
        }
    }
    func APICallGetStudentList(showLoader: Bool) {
        var params: [String: Any] = [ : ]
        params["pageIndex"] = pageIndex
        
        APIManager.shared.callPostApi(parameters:params, reqURL: URLs.APIURL + getUserTye() + studentList, showLoader: showLoader, vc:self) { (jsonData, error) in
            APIManager.hideLoader()
            if let json = jsonData{
                if let userData = ListResponse(JSON: json.dictionaryObject!){
                    self.arrStudentList.removeAll()
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
                    }
                }
            }
        }
    }
    func APICallGetCertificateList(showLoader: Bool,isFilter: Int) {
        
        var params : [String : Any] = [:]
        params["isFilter"] = isFilter
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getAllCertificateList, showLoader: true, vc:self) { (jsonData, error) in
            
            self.arrCertificateList.removeAll()
            if jsonData != nil{
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if self.isLoadingList{
                        self.pagingSpinner.stopAnimating()
                    }
                    if let status = userData.status, status == 1{
                        
                        if let user = userData.certificateList {
                            for tempStudent in user {
                                self.arrCertificateList.append(tempStudent)
                            }
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if userData.certificateList!.count >= 20 {
                            self.pagingSpinner.activityView()
                            self.tblCertificate.tableFooterView = self.pagingSpinner
                        }
                        else {
                            self.isLoadingList = true
                        }
                        print("Certificate Count : \(self.arrCertificateList.count)")
                        self.tblCertificate.reloadData()
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                }
            }
            if self.arrCertificateList.count > 0{
                self.tblCertificate.backgroundView = nil
            }
            else{
                let lbl = UILabel.init(frame: self.tblCertificate.frame)
                lbl.text = "No Certificate(s) found"
                lbl.textAlignment = .center
                lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
                self.tblCertificate.backgroundView = lbl
            }
            self.tblCertificate.reloadData()
        }
    }
    
}

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
