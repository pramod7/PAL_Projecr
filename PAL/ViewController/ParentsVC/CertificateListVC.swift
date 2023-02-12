//
//  CertificateListVC.swift
//  PAL
//
//  Created by i-Verve on 11/11/20.
//

import UIKit

class CertificateListVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate {
    
    //MARK:- Outlet variable
    @IBOutlet weak var tblCertificate: UITableView!
    
    //MARK:- local variable
    var arrCertificateList = [ParentCertificateListModel]()
    var strStudentName = String()
    var isLoadingList : Bool = false
    var pageIndex: Int = 0
    let pagingSpinner = UIActivityIndicatorView(style: .gray)
    var isFromNotification = false
    var ChildID = 0
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.Certificates, titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(BackClicked), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        self.APICallGetCertificateList(showLoader: self.isLoadingList)
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
        cell.lblName.text = self.arrCertificateList[indexPath.row].childName
        if self.arrCertificateList[indexPath.row].certificateType == 1 {
            cell.lblCertificate.attributedText = certificateType(str: "Excellence")
        }
        else if self.arrCertificateList[indexPath.row].certificateType == 2{
            cell.lblCertificate.attributedText = certificateType(str: "Imporvement")
        }
        else{
            cell.lblCertificate.attributedText = certificateType(str: "Participation")
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.date(from: self.arrCertificateList[indexPath.row].certificateCreatedDate!)
        formatter.dateFormat = "d MMM,yyyy"
        cell.lblDate.text = formatter.string(from: date!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DeviceType.IS_IPHONE ?100:140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = CertificateInfoVC.instantiate(fromAppStoryboard: .ParentDashboard)
        nextVC.isCertificateType = (indexPath.row == 1) ? 2:3
        nextVC.childName = self.arrCertificateList[indexPath.row].childName ?? ""
        nextVC.IsString = self.arrCertificateList[indexPath.row].pdfURl ?? ""
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK:- scrollView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.pagingSpinner.startAnimating()
            self.isLoadingList = true
//            self.loadMoreItemsForList()
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
        var childIDS = ""
        if let childInfo = Preferance.user.childInfo, childInfo.count > 0{
            for i in 0...childInfo.count-1{
                if childIDS.trim.count == 0{
                    childIDS = "\(childInfo[i].childId ?? 0)"
                }
                else{
                    childIDS = childIDS + "," + "\(childInfo[i].childId ?? 0)"
                }
            }
        }
        
        var params : [String : Any] = [:]
        if isFromNotification
        {
            params["childId"] = ChildID
        }else{
            params["childId"] = childIDS
        }
        
        params["pageIndex"] = pageIndex
        params["deviceType"] = MyApp.device_type
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getChildCertifiList, showLoader: true, vc:self) { (jsonData, error) in
            
            self.arrCertificateList.removeAll()
            if jsonData != nil{
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if self.isLoadingList{
                        self.pagingSpinner.stopAnimating()
                    }
                    if let status = userData.status, status == 1{
                        
                        if let user = userData.parentCertificateList {
                            for tempStudent in user {
                                self.arrCertificateList.append(tempStudent)
                            }
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if userData.parentCertificateList!.count >= 20 {
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
