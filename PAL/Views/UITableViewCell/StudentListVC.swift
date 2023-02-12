//
//  StudentListVC.swift
//  PAL
//
//  Created by i-Verve on 25/11/20.
//

import UIKit

protocol StudentListDelegate{
    func saveStudent(strText : NSString,strID : NSInteger)
}

class StudentListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate , UISearchBarDelegate{

    //MARK: - Outlet variable
    @IBOutlet weak var tblStudentList: UITableView!
    @IBOutlet weak var lblNoStudent: UILabel!{
        didSet{
            self.lblNoStudent.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
            self.lblNoStudent.text = "No Student(s) found"
            self.lblNoStudent.isHidden = true
        }
    }
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    //MARK: - Local variable
    var arrStudentList = [StudentListModel]()
    var arrSearchStudentList = [StudentListModel]()
    var isPopOver = Bool()
    var isLoadingList : Bool = false
    var pageIndex: Int = 0
    var delegate : StudentListDelegate?
    let pagingSpinner = UIActivityIndicatorView(style: .gray)
    var IsFromAddProgressReport = false
    var isSearch = Bool()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IsFromAddProgressReport{
            self.searchBarHeight.constant = 50
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        else {
            self.searchBarHeight.constant = 0
            if let nav = self.navigationController {
                nonTransparentNav(nav: nav)
                
                let titleLabel = UILabel()
                titleLabel.navTitle(strText: ScreenTitle.Students, titleColor: .white)
                self.navigationItem.titleView = titleLabel
                
                let btnBack: UIButton = UIButton()
                btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
                btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
                btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            }
        }
        
        self.pagingSpinner.activityView()
        self.tblStudentList.tableFooterView = self.pagingSpinner
        
        APIManager.showPopOverLoader(view: self.view)
        self.APICallGetStudentList(showLoader: false)
    }
    
    //MARK: - btn click event
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Support method
    func loadMoreItemsForList(){
        self.pageIndex += 1
        self.APICallGetStudentList(showLoader: !self.isLoadingList)
    }
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if IsFromAddProgressReport{
            return (self.isSearch) ? self.arrSearchStudentList.count : self.arrStudentList.count
        }else{
            return self.arrStudentList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentListTableViewCell") as! StudentListTableViewCell
        if IsFromAddProgressReport{
            cell.lblStudentName.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            cell.lblStudentId.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            if let tempName = (self.isSearch) ? self.arrSearchStudentList[indexPath.row].studentName : self.arrStudentList[indexPath.row].studentName, tempName.count > 0 {
                cell.lblStudentName.text = tempName
                cell.lblIndicatorName.text = getNthCharacter(strText: tempName)
            }
            if let tempId = (self.isSearch) ? self.arrSearchStudentList[indexPath.row].student_Id : self.arrStudentList[indexPath.row].student_Id, tempId.count > 0 {
                cell.lblStudentId.text = tempId
            }
            cell.imgWheels.isHidden = true
            cell.lblStudentName.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            cell.lblStudentId.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
        }
        else{
            if let tempName = self.arrStudentList[indexPath.row].studentName, tempName.count > 0 {
                cell.lblStudentName.text = tempName
                cell.lblIndicatorName.text = getNthCharacter(strText: tempName)
            }
            if let tempId = self.arrStudentList[indexPath.row].student_Id, tempId.count > 0 {
                cell.lblStudentId.text = tempId
            }
            cell.imgWheels.isHidden = false
        }
        if self.isPopOver{
            cell.viewCircle.layer.cornerRadius = 25
            cell.viewCircleWidth.constant = 50
            cell.lblIndicatorName.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        }
        else{
            cell.viewCircle.layer.cornerRadius = (ScreenSize.SCREEN_WIDTH * 0.07) / 2
            cell.viewCircleWidth.constant = (ScreenSize.SCREEN_WIDTH * 0.07)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.IsFromAddProgressReport {
            if self.isSearch {
                self.delegate?.saveStudent(strText:self.arrSearchStudentList[indexPath.row].studentName! as NSString, strID: self.arrSearchStudentList[indexPath.row].studentId ?? 0)
            }
            else{
                self.delegate?.saveStudent(strText: self.arrStudentList[indexPath.row].studentName! as NSString , strID: self.arrStudentList[indexPath.row].studentId ?? 0)
            }
            self.dismiss(animated: true, completion: nil)
        }
        else{
            let objNext = StudentProfileVC.instantiate(fromAppStoryboard: .Teacher)
            objNext.studentId = arrStudentList[indexPath.row].studentId ?? 0
            self.navigationController?.pushViewController(objNext, animated: true)
        }
    }
    
    //MARK: - Searchbar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.first == " "{
            return
        }
        if (searchBar.text?.trim.count)! > 0 {
            self.isSearch = true
            self.arrSearchStudentList.removeAll()
            self.arrSearchStudentList = self.arrStudentList.filter {
                return $0.studentName!.localizedCaseInsensitiveContains(searchBar.text!.trim)
            }
        }
        else {
            self.isSearch = false
        }
        self.tblStudentList.reloadData()
    }
    
    
    //MARK: - scrollView delegate
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

    //MARK: - API Call
    func APICallGetStudentList(showLoader: Bool) {
        
        var params: [String: Any] = [ : ]
        params["pageIndex"] = pageIndex
        
        APIManager.shared.callPostApi(parameters:params, reqURL: URLs.APIURL + getUserTye() + studentList, showLoader: showLoader, vc:self) { (jsonData, error) in
            APIManager.hideLoader()
            if let json = jsonData{
                if let userData = ListResponse(JSON: json.dictionaryObject!){
                    if self.isLoadingList{
                        self.pagingSpinner.stopAnimating()
                    }
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
                        if self.arrStudentList.count > 0{
                            self.tblStudentList.backgroundView = nil
                        }
                        else{
                            let lbl = UILabel.init(frame: self.tblStudentList.frame)
                            lbl.text = "No Student(s) found"
                            lbl.textAlignment = .center
                            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
                            self.tblStudentList.backgroundView = lbl
                        }
                        if let temp = userData.studentList{
                            if temp.count >= 20 {
                                self.pagingSpinner.activityView()
                                self.tblStudentList.tableFooterView = self.pagingSpinner
                            }
                            else {
                                self.isLoadingList = true
                            }
                        }
                        print("Student Count : \(self.arrStudentList.count)")
                        self.tblStudentList.reloadData()
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
        }
    }
}
