//
//  SchoolListVC.swift
//  PAL
//
//  Created by i-Phone7 on 23/11/20.
//

import UIKit

protocol SchoolListDelegate{
    func saveCount(strText : String)
    func saveText(objSchool : SchoolListModel)
    func saveFont(SelectedFont : Int)
}

class SchoolListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    
    //MARK: outlet variable
    @IBOutlet weak var tblSchoolList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nslcSearchBarHeight: NSLayoutConstraint!
    
    //MARK: local variable
    var delegate : SchoolListDelegate?
    var arrSchoolList = [SchoolListModel]()
    var arrSearchSchoolList = [SchoolListModel]()
    var arrChildList = [String]()
    var isSearch = Bool()
    var isChildCount = Bool()
    var isLoadingList : Bool = false
    var pageIndex: Int = 0
    let pagingSpinner = UIActivityIndicatorView(style: .gray)
    var arrayFont = ["Edu QLD Beginner","Edu NSW ACT Foundation","Edu VIC WA NT Beginner","Edu SA Beginner","Edu TAS Beginner","Kiwi school handwriting"]
    var isFromFont = false
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if self.isChildCount {
            self.searchBar.isHidden = true
            self.nslcSearchBarHeight.constant = 0
//            self.arrChildList = ["1", "2", "3", "4", "5"]
        }
        else {
            APIManager.showPopOverLoader(view: self.view)
            self.APICallGetSchoolList(showLoader: false)
        }
        if self.isFromFont
        {
            self.searchBar.isHidden = true
            self.nslcSearchBarHeight.constant = 0
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - support method
    func loadMoreItemsForList(){
        self.pageIndex += 1
        self.APICallGetSchoolList(showLoader: !self.isLoadingList)
    }
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFromFont
        {
            return self.arrayFont.count
        }else{
        if self.isChildCount {
            return self.arrChildList.count
        }
        else {
            return (self.isSearch) ? self.arrSearchSchoolList.count : self.arrSchoolList.count
        }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolListCell") as! SchoolListCell
        if self.isFromFont
        {
            cell.lblSchoolName?.text = self.arrayFont[indexPath.row]
        }else{
        if self.isChildCount {
            cell.lblSchoolName?.text = self.arrChildList[indexPath.row]
        }
        else {
            cell.lblSchoolName?.text = (self.isSearch) ? self.arrSearchSchoolList[indexPath.row].schoolName : self.arrSchoolList[indexPath.row].schoolName
        }
        if DeviceType.IS_IPHONE && !self.isChildCount{
            cell.lblLine.isHidden = false
        }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isFromFont
        {
            self.delegate?.saveFont(SelectedFont: indexPath.row)
        }else{
        if self.isChildCount {
            self.delegate?.saveCount(strText: self.arrChildList[indexPath.row])
        }
        else {
            self.delegate?.saveText(objSchool: (self.isSearch) ? self.arrSearchSchoolList[indexPath.row] : self.arrSchoolList[indexPath.row])
        }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.isChildCount ? 55 : 60
    }
        
    //MARK: - scrollView delegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
//            self.pagingSpinner.startAnimating()
//            self.isLoadingList = true
//            self.loadMoreItemsForList()
//        }
//    }
    
    //MARK: - searchBar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.first == " "{
            return
        }
        if (searchBar.text?.trim.count)! > 0 {
            self.isSearch = true
            self.arrSearchSchoolList.removeAll()
            self.arrSearchSchoolList = self.arrSchoolList.filter {
                return $0.schoolName!.localizedCaseInsensitiveContains(searchBar.text!.trim)
            }
        }
        else {
            self.isSearch = false
        }
        self.tblSchoolList.reloadData()
    }
    
    //MARK: - API Call
    func APICallGetSchoolList(showLoader: Bool) {
        
        var params: [String: Any] = [ : ]
        params["pageIndex"] = pageIndex
        APIManager.shared.callPostApi(parameters:params, reqURL: URLs.APIURL + getSchoolList, showLoader: showLoader, vc:self) { (jsonData, error) in
            APIManager.hideLoader()
            if let tempJson = jsonData{
                if let json = tempJson.dictionaryObject {
                    if let userData = ListResponse(JSON: json){
                        if self.isLoadingList{
                            self.pagingSpinner.stopAnimating()
                        }
                        if let status = userData.status, status == 1{
                            if let user = userData.schoolList {
                                for tempStudent in user {
                                    self.arrSchoolList.append(tempStudent)
                                }
                            }
                            else{
                                if let msg = jsonData?[APIKey.message].string {
                                    showAlert(title: APP_NAME, message: msg)
                                }
                            }
                            self.tblSchoolList.reloadData()
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrSchoolList.count > 0{
                            self.tblSchoolList.backgroundView = nil
                        }
                        else{
                            let lbl = UILabel.init(frame: self.tblSchoolList.frame)
                            lbl.text = "No School(s) found"
                            lbl.textAlignment = .center
                            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
                            self.tblSchoolList.backgroundView = lbl
                        }
                    }
                }
            }
        }
    }
}
