//
//  TaskListViewController.swift
//  PAL
//
//  Created by i-Verve on 01/12/20.
//

import UIKit
import SDWebImage

class TaskListViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, StudentWorkbookDelegate {
   
    //MARK: - Outlet variable
    @IBOutlet weak var objCollection: UICollectionView!
    
    //MARK: - Local variable
    let cellRecentHeight: CGFloat = (ScreenSize.SCREEN_HEIGHT / 5) + 20//240
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: ((ScreenSize.SCREEN_WIDTH*0.95) - 20) / 3 , height: cellRecentHeight)
        _flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        _flowLayout.minimumInteritemSpacing = 10
        _flowLayout.minimumLineSpacing = 20
        return _flowLayout
    }

    var arrStudentWorkbookList = [SubjectBooksList]()
    var btnFilter : UIButton?
    var subjectId = Int()
    var arrSubjectName : [String?] = []
    var arrSubjectId : [Int?] = []
    var isSubjectList = Bool()
    var isFromStudent = Bool()
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController{
            //nonTransparentNav(nav: nav)
            
            if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
                , colorName.trim.count > 0{
                nav.navigationBar.barTintColor = UIColor.hexStringToUIColor(colorName)
            }
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Task List", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(BackClicked), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            
            let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 20))
            let btnFilterr = UIButton(frame: iconSize)
            btnFilterr.imageView?.contentMode = .scaleAspectFit
            let imgTemp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgTemp.image = UIImage(named: "Group3751")
            btnFilterr.addSubview(imgTemp)
            btnFilter = btnFilterr
            btnFilterr.addTarget(self, action: #selector(btnFilterClick), for: .touchUpInside)
           
            let barFilerButton = UIBarButtonItem(customView: btnFilterr)
            self.navigationItem.rightBarButtonItems = [barFilerButton]
        }
        self.objCollection.collectionViewLayout = self.flowLayout

        self.APICallGetStudentWorkbookList()
    }
    
    //MARK: - btn Click
    @objc func BackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnFilterClick(){
        if self.arrSubjectId.count > 0 && self.arrSubjectName.count > 0{
        let nextVC = StudentWorkbookListPopoverVC.instantiate(fromAppStoryboard: .PopOverStoryboard)
        nextVC.delegate = self
        nextVC.isStudent = true
        nextVC.arrsubCategory = self.arrSubjectName
        nextVC.arrSubjectId = self.arrSubjectId
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            var popOverHight = (self.arrSubjectName.count) * 60
            if popOverHight > 480{
                popOverHight = 480
            }
            nextVC.preferredContentSize = CGSize(width: 250,height: popOverHight)
            popover.permittedArrowDirections = .up
            popover.sourceView = self.btnFilter
            popover.sourceRect = self.btnFilter!.bounds
        }
        self.present(nav, animated: true, completion: nil)
        self.view.endEditing(true)
        }
    }
    
    func saveSubject(strText: NSString, strID: NSInteger) {
        if strText == "See All"{
            self.subjectId = 0
        }
        else{
            self.subjectId = strID
        }
        APICallGetStudentWorkbookList()
    }
    
    func saveChildInfo(childInfo: ChildInfoModel) {
        
    }
   
    //MARK: - collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrStudentWorkbookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskListCollectionViewCell", for: indexPath) as! TaskListCollectionViewCell
        cell.lblSubject.text = self.arrStudentWorkbookList[indexPath.row].subjectName
//        cell.lblTeacherName.text = "Teacher:-\(self.arrStudentWorkbookList[indexPath.row].teacherName ?? "")"
        //cell.lblDate.text = self.arrStudentWorkbookList[indexPath.row].startDate
        //cell.lblSubcategory.text = self.arrStudentWorkbookList[indexPath.row].subCategory
        cell.lblWorksheetName.text = self.arrStudentWorkbookList[indexPath.row].worksheetName
        cell.lblDate.isHidden = true
        cell.lblSubcategory.isHidden = true
        cell.lblTeacherName.isHidden = true
        if self.arrStudentWorkbookList[indexPath.row].assign_type == 1{
            cell.objViewCircle.backgroundColor = UIColor.kAppThemeColor()
            cell.lblChar.text = "P"
        }
        else{
            cell.objViewCircle.backgroundColor = .red
            cell.lblChar.text = "M"
        }

        if let url = self.arrStudentWorkbookList[indexPath.row].pdfThumb,url.trim.count > 0{
            cell.imgview.sd_setImage(with: URL(string: url) )
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isSubjectList{
            if self.arrStudentWorkbookList[indexPath.row].pdfImages?.count ?? 0 > 0{
                let objnext = WorksheetViewController.instantiate(fromAppStoryboard: .Student)
                objnext.isMarking = self.arrStudentWorkbookList[indexPath.row].assign_type ?? 0
                objnext.arrAllImg = self.arrStudentWorkbookList[indexPath.row].pdfImages
                objnext.workSheetId = self.arrStudentWorkbookList[indexPath.row].worksheetId ?? 0
                objnext.teacherName = self.arrStudentWorkbookList[indexPath.row].teacherName ?? ""
                objnext.uniqueID = self.arrStudentWorkbookList[indexPath.row].worksheetId ?? 0
                objnext.subjectId = self.arrStudentWorkbookList[indexPath.row].subjectId ?? 0
                objnext.teacherId = self.arrStudentWorkbookList[indexPath.row].teacherId ?? ""
                objnext.subCategoryId = self.arrStudentWorkbookList[indexPath.row].subCategoryId ?? 0
                objnext.assign_type = self.arrStudentWorkbookList[indexPath.row].assign_type ?? 0
                objnext.eraser = self.arrStudentWorkbookList[indexPath.row].eraser ?? 0
                objnext.spellChecker = self.arrStudentWorkbookList[indexPath.row].spellChecker ?? 0
                objnext.worksheetName = self.arrStudentWorkbookList[indexPath.row].worksheetName ?? ""
                if let arrTemp = self.arrStudentWorkbookList[indexPath.row].instruction{
                    objnext.arrInstruction = arrTemp
                }
                if let arrTempVoice = self.arrStudentWorkbookList[indexPath.row].voiceinstruction{
                    objnext.arrvoiceInstruction = arrTempVoice
                }
                objnext.isFromStudent = true
                self.navigationController?.pushViewController(objnext, animated: true)
            }
            else{
                print("No Worksheet Found.")
            }
        }
        else {
            if !Connectivity.isConnectedToInternet() {
                showAlert(title: APP_NAME, message: Messages.NOINTERNET)
                return
            }
            let objNext = WorksheetViewVC.instantiate(fromAppStoryboard: .Student)
            objNext.arrImages = self.arrStudentWorkbookList[indexPath.row].pdfImages ?? []
            if let arrPdf = self.arrStudentWorkbookList[indexPath.row].pdfImages{
                objNext.arrImages = arrPdf
            }
            if let arrInstruction = self.arrStudentWorkbookList[indexPath.row].instruction{
                objNext.arrInstruction = arrInstruction
            }
            if let arrvoiceInstruction = self.arrStudentWorkbookList[indexPath.row].voiceinstruction{
                objNext.arrvoiceInstruction = arrvoiceInstruction
            }
            self.navigationController?.pushViewController(objNext, animated: true)
        }
    }
    
    //MARK: - API Call
    func APICallGetStudentWorkbookList() {
        
        var params: [String: Any] = [ : ]
       
        params["subjectId"] = subjectId
        params["pageIndex"] = 0
        params["isWeek"] = 0
        
//        params["startDate"] = ""
//        params["endDate"] = ""
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getStudentWorksheetList, showLoader: true, vc:self) { (jsonData, error) in
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let linkTeacher = userData.newStudentWorkBook {
                            if self.isSubjectList {
                                self.arrStudentWorkbookList = linkTeacher.assigned!
                            }
                            else{
                                self.arrStudentWorkbookList = linkTeacher.WorkDone!
                            }
                            
                            for i in self.arrStudentWorkbookList{
                                self.arrSubjectName.append(i.subjectName)
                                self.arrSubjectId.append(i.subjectId)
                            }
                            self.arrSubjectName.removeDuplicates()
                            self.arrSubjectId.removeDuplicates()
                            self.objCollection.reloadData()
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrStudentWorkbookList.count > 0{
                            self.objCollection.backgroundView = nil
                        }
                        else{
                            let lbl = UILabel.init(frame: self.objCollection.frame)
                            lbl.text = "No task assigned yet."
                            lbl.textAlignment = .center
                            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
                            self.objCollection.backgroundView = lbl
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
