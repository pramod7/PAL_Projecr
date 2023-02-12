//
//  TeacherSubjectWorkSheetListVC.swift
//  PAL
//
//  Created by i-Verve on 26/11/20.
//

import UIKit
import PDFKit
import SwiftyJSON
import Alamofire

class TeacherSubjectWorkSheetListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate {
    
    //MARK: - Outlet variable
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var pdfViewDisplay: PDFView!
    
    //MARK: - Local variable
    var strSubjectName = String()
    var arrSelectedISheetType = [[String : Int]]()
    var arrSubjectWorkbookList = [SubjectWorkbooksListModel]()
    var subcategoryid = Int()
    var subjectId = Int()
    var arrFav = [Int]()
    var colour = String()
    var WorksheetId = Int()
    var isFavourite = Int()
    var counter = 0
    var timer = Timer()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print( Preferance.user.userId ?? 0)
        print( Preferance.user.schoolId ?? 0)
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "\(self.strSubjectName) - Worksheets", titleColor: .white)
        self.navigationItem.titleView = titleLabel
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        
        let btnBack1: UIButton = UIButton()
        btnBack1.setImage(UIImage(named: "upload_Worksheet"), for: .normal)
        btnBack1.addTarget(self, action: #selector(btnUploadClicked), for: .touchUpInside)
        btnBack1.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnBack1)
        self.APICallGetSubjectWorkbookList()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: colour)
        //        if let nav = self.navigationController{
        //            nonTransparentNav(nav: nav)
        //        }
       
    }    
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSubjectWorkbookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if indexPath.row == 0{
        let cell = tbl.dequeueReusableCell(withIdentifier: "SubjectWorkSheetCell_Assign") as! SubjectWorkSheetCell
        let tempDic = self.arrSelectedISheetType[indexPath.row]
        if tempDic["Practices"] == 0{
            cell.btnUnAssign.btnUnSelectBorder()
        }
        if tempDic["Marking"] == 0{
            cell.btnAssign.btnUnSelectBorder()
        }
        cell.lblName.text = arrSubjectWorkbookList[indexPath.row].worksheetName
        cell.lblDate.text = arrSubjectWorkbookList[indexPath.row].worksheetAddedDate
        if let url = self.arrSubjectWorkbookList[indexPath.row].worksheetThumb,url.trim.count > 0{
            cell.imgPreview.imageFromURL(url, placeHolder: imgWorksheetIconPlaceholder)
            cell.imgPreview.backgroundColor = .white
        }
        print(indexPath.row)
        cell.btnAssign.tag = indexPath.row
        cell.btnUnAssign.tag = indexPath.row
        cell.btnAssign.addTarget(self, action: #selector(btnMarkingClick), for: .touchUpInside)
        cell.btnUnAssign.addTarget(self, action: #selector(btnPractisClick), for: .touchUpInside)
        
        if self.arrFav.contains(indexPath.row){
            cell.imgfav.image = UIImage(named: "Icon_yellowStarSelected")
        }
        else{
            cell.imgfav.image = UIImage(named: "Icon_yellowStarUnSelected")
        }
        
        if arrSubjectWorkbookList[indexPath.row].isAssign == 0{
            cell.imgdelete.isHidden = false
            cell.btndelete.isHidden = false
        }
        else{
            cell.imgdelete.isHidden = true
            cell.btndelete.isHidden = true
        }
        cell.btndelete.tag = indexPath.row
        cell.btndelete.addTarget(self, action: #selector(btnDeleteClick), for: .touchUpInside)
        
        cell.btnfav.tag = indexPath.row
        cell.btnfav.addTarget(self, action: #selector(btnFavClick), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(arrSubjectWorkbookList[indexPath.row].worksheetName ?? "", arrSubjectWorkbookList[indexPath.row].worksheetId ?? 0)
        alertWithTF(str: arrSubjectWorkbookList[indexPath.row].worksheetName ?? "", worksheetId: arrSubjectWorkbookList[indexPath.row].worksheetId ?? 0)
    }
    
    //MARK: - Alert
    func alertWithTF(str:String,worksheetId:Int) {
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: APP_NAME, message: "You can change worksheet name", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.text = str
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in

            // this code runs when the user hits the "save" button

            let inputName = alertController.textFields![0].text

            self.APICallrenameWorksheet(worksheetName: inputName ?? "", worksheetId: worksheetId)

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)

    }
    
    //MARK: - btn Click
    @objc func btnUploadClicked(_ sender: Any){
        print("upload pdf clicked")
        
        
        DispatchQueue.main.async {
            DocumentManager.sharedInstance.showDocumentMenuController(self) { (isFileSelected, fileName, fileExtension, filePath) in
                if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: filePath)) {
                    self.pdfViewDisplay.displayMode = .singlePageContinuous
                    self.pdfViewDisplay.autoScales = true
                    self.pdfViewDisplay.displayDirection = .vertical
                    self.pdfViewDisplay.document = pdfDocument
                    let name = URL(fileURLWithPath: filePath).lastPathComponent
                    print("name",name)
//                    let theURL = URL(string: filePath)  //use your URL
//                    print("theURL", theURL)
//                    let fileNameWithExt = theURL?.lastPathComponent
//                    print("File Name", fileNameWithExt)
                    self.APIUploadPDF(strWorksheetName: name)
                }
//                self.dismiss(animated: true, completion: nil)
            }
//        DispatchQueue.main.async {
//            let pdfurl = URL(string: "https://pal.clouddownunder.com.au/uploads/worksheets/1647532740-worksheet.pdf")
//            self.pdfViewDisplay.document = PDFDocument(url: pdfurl!)
//            self.APIUploadPDF(strWorksheetName: "text1")
//        }
//        }
        
        
      // Get pdf from devices
//        DocumentManager.sharedInstance.showDocumentMenuController(self) { (isFileSelected, fileName, fileExtension, filePath) in
//            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: filePath)) {
//                self.pdfViewDisplay.displayMode = .singlePageContinuous
//                self.pdfViewDisplay.autoScales = true
//                self.pdfViewDisplay.displayDirection = .vertical
//                self.pdfViewDisplay.document = pdfDocument
//                let theURL = URL(string: filePath)  //use your URL
//                let fileNameWithExt = theURL?.lastPathComponent
//                self.APIUploadPDF(strWorksheetName: fileNameWithExt ?? "")
//            }
//            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func btnBackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnMarkingClick(_ sender: UIButton){
        if self.arrSelectedISheetType[sender.tag]["Marking"] == 0 {
            self.arrSelectedISheetType[sender.tag]["Marking"] = 2
            self.arrSelectedISheetType[sender.tag]["Practices"] = 0
        }
        else {
            self.arrSelectedISheetType[sender.tag]["Marking"] = 0
        }
        
        let tag = sender.tag
        
        self.tbl.reloadData()
        let markingdialog = UIAlertController(title: APP_NAME, message: "Are you sure want to assign the worksheet as Marking?", preferredStyle: .alert)
        markingdialog.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            let objNext = WorksheetAssignToStudent.instantiate(fromAppStoryboard: .Teacher)
//            objNext.colour = self.colour
            objNext.worksheetName = self.arrSubjectWorkbookList[tag].worksheetName ?? ""
            objNext.worksheetId = self.arrSubjectWorkbookList[tag].worksheetId
            objNext.subjectId = self.subjectId
            objNext.assigntype = 2
            objNext.category_id = self.subcategoryid
            objNext.colour = self.colour
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
        let tag = sender.tag
        
        self.tbl.reloadData()
        
        let Practicedialog = UIAlertController(title: APP_NAME, message: "Are you sure want to assign the worksheet as Practise?", preferredStyle: .alert)
        Practicedialog.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            let objNext = WorksheetAssignToStudent.instantiate(fromAppStoryboard: .Teacher)
            objNext.worksheetName = self.arrSubjectWorkbookList[tag].worksheetName ?? ""
            objNext.worksheetId = self.arrSubjectWorkbookList[tag].worksheetId
            objNext.subjectId = self.subjectId
            objNext.assigntype = 1
            objNext.category_id = self.subcategoryid
            objNext.colour = self.colour
            self.navigationController?.pushViewController(objNext, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Practicedialog.addAction(ok)
        Practicedialog.addAction(cancel)
        self.present(Practicedialog, animated: true, completion: nil)
    }
    
    @objc func btnDeleteClick(sender: UIButton) {
        
        let Practicedialog = UIAlertController(title: APP_NAME, message: "Are you sure you want to delete this worksheet?", preferredStyle: .alert)
        Practicedialog.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.deleteWorksheet(WorksheetId: self.arrSubjectWorkbookList[sender.tag].worksheetId ?? 0)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Practicedialog.addAction(ok)
        Practicedialog.addAction(cancel)
        self.present(Practicedialog, animated: true, completion: nil)
    }
    
    @objc func btnFavClick(sender: UIButton) {
        if self.arrFav.contains(sender.tag){
            self.arrFav = self.arrFav.filter{ $0 != sender.tag }
        }
        else{
            self.arrFav.append(sender.tag)
        }
        self.WorksheetId = self.arrSubjectWorkbookList[sender.tag].worksheetId ?? 0
        if self.arrSubjectWorkbookList[sender.tag].isFavourite == 1{
            self.isFavourite = 0
        }
        else{
            self.isFavourite = 1
        }
        self.APICallDoFavourite(showLoader: true)
    }
    
    //MARK: - Api Call

    
    func APIUploadPDF(strWorksheetName: String) {
        
        var params: [String: Any] = [ : ]
        params["teacherId"] = Preferance.user.userId ?? 0
        params["schoolId"] = Preferance.user.schoolId ?? 0
        params["subjectId"] = subjectId
        params["categoryId"] = subcategoryid
        params["worksheetData"] = self.pdfViewDisplay.document!
        params["worksheetName"] = strWorksheetName
        params["type"] = 1
        
        let objNext = ProgressBarVC.instantiate(fromAppStoryboard: .Teacher)
        objNext.modalPresentationStyle = .custom
        objNext.paramsPass = params
        objNext.dismisssView = { (size) in
            DispatchQueue.main.async {
                self.APICallGetSubjectWorkbookList()
            }
        }
        self.navigationController?.present(objNext, animated: false, completion: nil)
    }
    
    func APICallrenameWorksheet(worksheetName:String,worksheetId:Int)
    {
        var params: [String: Any] = [ : ]
        
        params["teacherId"] = Preferance.user.userId ?? 0
        params["worksheetId"] = worksheetId
        params["worksheetName"] = worksheetName
      
        APIManager.shared.callPostApi(parameters:params, reqURL: URLs.APIURL + getUserTye() + renameWorksheet, showLoader: true, vc:self) { (jsonData, error) in
            APIManager.hideLoader()
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        self.APICallGetSubjectWorkbookList()
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
    
    
    func APICallGetSubjectWorkbookList() {
        
        var params: [String: Any] = [ : ]
        
        params["subjectId"] = subjectId
        params["subCategoryId"] = subcategoryid
        params["pageIndex"] = 0
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getSubjectWorksheetList, showLoader: true, vc:self) { (jsonData, error) in
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        self.arrFav.removeAll()
                        self.arrSubjectWorkbookList.removeAll()
                        self.arrSelectedISheetType.removeAll()
                        if let linkTeacher = userData.subjectWrokbookList {
                            self.arrSubjectWorkbookList = linkTeacher
                            var isFav = Int()
                            for i in self.arrSubjectWorkbookList{
                                if i.isFavourite == 1{
                                    self.arrFav.append(isFav)
                                }
                                isFav = isFav + 1
                                self.arrSelectedISheetType.append(["Marking" : 0, "Practices" : 0])
                            }
                            self.tbl.reloadData()
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrSubjectWorkbookList.count > 0{
                            self.tbl.backgroundView = nil
                        }
                        else{
                            let lbl = UILabel.init(frame: self.tbl.frame)
                            lbl.text = "No worksheet(s) found"
                            lbl.textAlignment = .center
                            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
                            self.tbl.backgroundView = lbl
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
    
    func APICallDoFavourite(showLoader: Bool){
        var params: [String: Any] = [ : ]
        
        params["worksheetId"] = self.WorksheetId
        params["subjectId"] = self.subjectId
        params["subCategoryId"] = subcategoryid
        params["isFavourite"] = self.isFavourite
        
        APIManager.shared.callPostApi(parameters:params, reqURL: URLs.APIURL + getUserTye() + doFavourite, showLoader: showLoader, vc:self) { (jsonData, error) in
            APIManager.hideLoader()
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
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
    
    func deleteWorksheet(WorksheetId:Int){
                
        var params: [String: Any] = [ : ]
        params["teacherId"] = Preferance.user.userId ?? 0
        params["worksheetId"] = WorksheetId
        
        APIManager.shared.callPostWithMultiPartApi(reqURL: URLs.APIURL + getUserTye() + deleteWorksheets, parameters: params, showLoader: true) { (jsonData, error) in
            
           if jsonData != nil{
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject ?? [String:Any]()){
                    if let status = userData.status, status == 1{
                        self.APICallGetSubjectWorkbookList()
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
