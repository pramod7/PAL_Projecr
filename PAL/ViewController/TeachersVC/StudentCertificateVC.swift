//
//  StudentCertificateVC.swift
//  PAL
//
//  Created by i-Verve on 02/06/21.
//

import UIKit

class StudentCertificateVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate {
    
    //MARK:- Outlet Variable
    @IBOutlet weak var tblCertificate: UITableView!
    
    
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
    var datePickerChild = UIDatePicker(){
        didSet{
            self.datePickerChild.datePickerMode = .date
            self.datePickerChild.minimumDate = Date()
        }
    }
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
                
            }else{
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
        
        self.APICallGetCertificateList(showLoader: self.isLoadingList)
        
        if #available(iOS 13.4, *) {
            self.datePickerChild.preferredDatePickerStyle = .wheels
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.APICallGetCertificateType(showLoader: isShowLoader)
    }
    
    @objc func btnBackClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func selectionView(img: String) {
        let imgView = UIImageView()
        imgView.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: Placeholder.subjectImg))
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
        cell.lblName.text = strStudentName
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
    
    //MARK:- Support method
    func loadMoreItemsForList(){
        self.pageIndex += 1
        self.APICallGetCertificateList(showLoader: !self.isLoadingList)
    }
    
    //MARK:- btn click
    @objc func BackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK:- API Call
    
    
    func APICallGetCertificateList(showLoader: Bool) {
        
        var params : [String : Any] = [:]
        params["studentId"] = StudentID
        params["pageIndex"] = 0
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getCertificateList, showLoader: true, vc:self) { (jsonData, error) in
            
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
