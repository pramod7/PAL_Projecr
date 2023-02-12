//
//  FavouriteVC.swift
//  PAL
//
//  Created by i-Phone7 on 23/11/20.
//

import UIKit

class FavouriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //MARK:- Outlet Variable
    @IBOutlet weak var tblFavourite: UITableView!
    @IBOutlet weak var lblNoFav: UILabel!{
        didSet{
            self.lblNoFav.isHidden = true
        }
    }
    
    //MARK:- local variable
    var arrFavList = [FavouriteListModel]()
    var arrSelectedISheetType = [[String : Int]]()
    var isAPICalled: Bool = true
    var isLoadingList : Bool = false
    var pageIndex: Int = 0
    let pagingSpinner = UIActivityIndicatorView(style: .gray)
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "Favourites", titleColor: .white)
        self.navigationItem.titleView = titleLabel
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
        }
        self.APICallGetFavList(showLoader: isAPICalled)
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFavList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectWorkSheetCell_Assign") as! SubjectWorkSheetCell
        let tempDic = self.arrSelectedISheetType[indexPath.row]
        if tempDic["Practices"] == 0{
            cell.btnUnAssign.btnUnSelectBorder()
        }
        if tempDic["Marking"] == 0{
            cell.btnAssign.btnUnSelectBorder()
        }
        if let url = self.arrFavList[indexPath.row].worksheetThumb,url.trim.count > 0{
            cell.imgPreview.imageFromURL(url, placeHolder: imgWorksheetIconPlaceholder)
            cell.imgPreview.backgroundColor = .white
        }
        cell.lblSubjectName.text = self.arrFavList[indexPath.row].subjectName
        cell.lblName.text = self.arrFavList[indexPath.row].worksheetName
        cell.lblDate.text = self.arrFavList[indexPath.row].date
        cell.btnAssign.tag = indexPath.row
        
        cell.btnUnAssign.tag = indexPath.row
        cell.btnAssign.addTarget(self, action: #selector(btnMarkingClick), for: .touchUpInside)
        cell.btnUnAssign.addTarget(self, action: #selector(btnPractisClick), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
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
        self.pageIndex += 0
        self.APICallGetFavList(showLoader: !self.isLoadingList)
    }
    
    //MARK:- btn Click
    
    @objc func btnMarkingClick(_ sender: UIButton){
        if self.arrSelectedISheetType[sender.tag]["Marking"] == 0 {
            self.arrSelectedISheetType[sender.tag]["Marking"] = 2
            self.arrSelectedISheetType[sender.tag]["Practices"] = 0
        }
        else {
            self.arrSelectedISheetType[sender.tag]["Marking"] = 0
        }
        self.tblFavourite.reloadData()
        
        let markingdialog = UIAlertController(title: APP_NAME, message: "Are you sure want to assign the worksheet as Marking?", preferredStyle: .alert)
        markingdialog.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            let objNext = WorksheetAssignToStudent.instantiate(fromAppStoryboard: .Teacher)
            objNext.isFromFav = true
            objNext.worksheetName = self.arrFavList[sender.tag].worksheetName ?? ""
            objNext.worksheetId = self.arrFavList[sender.tag].worksheetId
            objNext.subjectId = self.arrFavList[sender.tag].subjectId ?? 0
            objNext.assigntype = 2
            objNext.category_id = self.arrFavList[sender.tag].subCategoryId ?? 0
            objNext.isFromFav = true
            self.navigationController?.pushViewController(objNext, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        markingdialog.addAction(ok)
        markingdialog.addAction(cancel)
        self.present(markingdialog, animated: true, completion: nil)
    }
    
    @objc func btnPractisClick(_ sender: UIButton){
        if self.arrSelectedISheetType[sender.tag]["Practices"] == 0 {
            self.arrSelectedISheetType[sender.tag]["Practices"] = 1
            self.arrSelectedISheetType[sender.tag]["Marking"] = 0
        }
        else {
            self.arrSelectedISheetType[sender.tag]["Practices"] = 0
        }
        self.tblFavourite.reloadData()
        
        let Practicedialog = UIAlertController(title: APP_NAME, message: "Are you sure want to assign the worksheet as Practise?", preferredStyle: .alert)
        Practicedialog.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            let objNext = WorksheetAssignToStudent.instantiate(fromAppStoryboard: .Teacher)
            objNext.isFromFav = true
            objNext.worksheetName = self.arrFavList[sender.tag].worksheetName ?? ""
            objNext.worksheetId =  self.arrFavList[sender.tag].worksheetId
            objNext.subjectId = self.arrFavList[sender.tag].subjectId ?? 0
            objNext.assigntype = 1
            objNext.category_id = self.arrFavList[sender.tag].subCategoryId ?? 0
            objNext.isFromFav = true
            self.navigationController?.pushViewController(objNext, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Practicedialog.addAction(ok)
        Practicedialog.addAction(cancel)
        self.present(Practicedialog, animated: true, completion: nil)
    }
    
    //MARK:- API Call
    func APICallGetFavList(showLoader: Bool) {
        
        var params: [String: Any] = [ : ]
        params["pageIndex"] = pageIndex
        
        APIManager.shared.callPostApi(parameters:params, reqURL: URLs.APIURL + getUserTye() + getFavList, showLoader: showLoader, vc:self) { (jsonData, error) in
            if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                if self.isLoadingList{
                    self.pagingSpinner.stopAnimating()
                }
                
                if let status = userData.status, status == 1{
                    self.isAPICalled = false
                    self.arrFavList.removeAll()
                    self.arrSelectedISheetType.removeAll()
                    if let user = userData.favList {
                        for tempStudent in user {
                            self.arrFavList.append(tempStudent)
                            self.arrSelectedISheetType.append(["Marking" : 0, "Practices" : 0])
                        }
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                    if self.arrFavList.count > 0{
                        self.tblFavourite.backgroundView = nil
                    }
                    else{
                        let lbl = UILabel.init(frame: self.tblFavourite.frame)
                        lbl.text = "No Favourite(s) found"
                        lbl.textAlignment = .center
                        lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
                        self.tblFavourite.backgroundView = lbl
                    }
                    self.tblFavourite.reloadData()
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
