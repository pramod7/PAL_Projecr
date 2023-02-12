//
//  ParentWorkBookVC.swift
//  PAL
//
//  Created by i-Verve on 13/11/20.
//

import UIKit

class ParentWorkSheetVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:- Outlet variable
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- local variable
    var flowLayoutWorkBook: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: teacherCellectionWidth , height: teacherCellHeight)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        _flowLayout.scrollDirection = .vertical
        _flowLayout.minimumInteritemSpacing = spacing
        _flowLayout.minimumLineSpacing = spacing
        return _flowLayout
    }
    var arrSubjectsForWorkbook = [SubjectsForWorkbooksModel]()
    var childId = Int()
    let teacherCellHeight: CGFloat = DeviceType.IS_IPHONE ? 250 : (ScreenSize.SCREEN_HEIGHT*0.25)
    let teacherCellectionWidth: CGFloat = DeviceType.IS_IPHONE ? (ScreenSize.SCREEN_WIDTH - 60) / 2: (ScreenSize.SCREEN_WIDTH - 70) / 3
    
    let spacing: CGFloat = DeviceType.IS_IPHONE ? 10 : 10

    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.Workbooks, titleColor: .white)
            self.navigationItem.titleView = titleLabel
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        if DeviceType.IS_IPHONE {
            self.collectionView.register(UINib(nibName: "SubjectTilesInfoCell", bundle: nil), forCellWithReuseIdentifier: "SubjectTilesInfoCell")
        }
        else {
            self.collectionView.register(UINib(nibName: "SubjectTilesInfoiPadCell", bundle: nil), forCellWithReuseIdentifier: "SubjectTilesInfoiPadCell")
        }
        self.collectionView.collectionViewLayout = flowLayoutWorkBook
        APICallGetSubjectsForWorkbooks()
    }
    
    //MARK:- btn Click
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubjectsForWorkbook.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var strIdentifier = String()
        if DeviceType.IS_IPAD {
            strIdentifier = "SubjectTilesInfoiPadCell"
        }
        else {
            strIdentifier = "SubjectTilesInfoCell"
        }
        if DeviceType.IS_IPHONE {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectTilesInfoCell", for: indexPath) as! SubjectTilesInfoCell
            if indexPath.row % 2 == 0 {
                cell.lblSubjectName.text = self.arrSubjectsForWorkbook[indexPath.row].subjectName
                cell.lblTeacherName.text = "Teacher : \(self.arrSubjectsForWorkbook[indexPath.row].teacherName ?? "")"
                cell.lblTeacherId.text = "Teacher ID : \(self.arrSubjectsForWorkbook[indexPath.row].teacher_Id ?? "")"
                cell.lblDate.text = self.arrSubjectsForWorkbook[indexPath.row].worksheetsAssignDate
               // cell.imgMarking.sd_setImage(with: URL(string: self.arrSubjectsForWorkbook[indexPath.row].subjectCover!))
            }
            else {
                cell.imgMarking.image = UIImage(named: "Icon_PrimaryBook")
                cell.lblSubjectName.text = self.arrSubjectsForWorkbook[indexPath.row].subjectName
                cell.lblTeacherName.text = "Teacher : \(self.arrSubjectsForWorkbook[indexPath.row].teacherName ?? "")"
                cell.lblTeacherId.text = "Teacher ID : \(self.arrSubjectsForWorkbook[indexPath.row].teacher_Id ?? "")"
                cell.lblDate.text = self.arrSubjectsForWorkbook[indexPath.row].worksheetsAssignDate
               // cell.imgMarking.sd_setImage(with: URL(string: self.arrSubjectsForWorkbook[indexPath.row].subjectCover!))
            }
            cell.imgProgress.isHidden = true
            cell.imgMarking.isHidden = false
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectTilesInfoiPadCell", for: indexPath) as! SubjectTilesInfoiPadCell
            if indexPath.row % 2 == 0 {
                cell.lblSubjectName.text = self.arrSubjectsForWorkbook[indexPath.row].subjectName
                cell.lblTeacherName.text = "Teacher : \(self.arrSubjectsForWorkbook[indexPath.row].teacherName ?? "")"
                cell.lblTeacherId.text = "Teacher ID : \(self.arrSubjectsForWorkbook[indexPath.row].teacher_Id ?? "")"
                cell.lblDate.text = self.arrSubjectsForWorkbook[indexPath.row].worksheetsAssignDate
               // cell.imgMarking.sd_setImage(with: URL(string: self.arrSubjectsForWorkbook[indexPath.row].subjectCover!))
            }
            else {
                cell.imgMarking.image = UIImage(named: "Icon_PrimaryBook")
                cell.lblSubjectName.text = self.arrSubjectsForWorkbook[indexPath.row].subjectName
                cell.lblTeacherName.text = "Teacher : \(self.arrSubjectsForWorkbook[indexPath.row].teacherName ?? "")"
                cell.lblTeacherId.text = "Teacher ID : \(self.arrSubjectsForWorkbook[indexPath.row].teacher_Id ?? "")"
                cell.lblDate.text = self.arrSubjectsForWorkbook[indexPath.row].worksheetsAssignDate
               // cell.imgMarking.sd_setImage(with: URL(string: self.arrSubjectsForWorkbook[indexPath.row].subjectCover!))
            }
            cell.imgProgress.isHidden = true
            cell.imgMarking.isHidden = false
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objNext = ParentSubCategoryVC.instantiate(fromAppStoryboard: .ParentDashboard)
        objNext.childId = self.childId
        objNext.subjectID = self.arrSubjectsForWorkbook[indexPath.row].subjectId!
        objNext.APICallGetWorkbookList()
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    func APICallGetSubjectsForWorkbooks() {
        
        var params: [String: Any] = [ : ]
        params["childId"] = self.childId
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getSubjectsForWorkbooks, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let linkTeacher = userData.subjectsForWorkbook {
                            self.arrSubjectsForWorkbook = linkTeacher
                            self.collectionView.reloadData()
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrSubjectsForWorkbook.count > 0{
                            self.collectionView.backgroundView = nil
                           
                        }
                        else{
                            let lbl = UILabel.init(frame: self.collectionView.frame)
                            lbl.text = "No Workbook(s) found"
                            lbl.textAlignment = .center
                            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
                            self.collectionView.backgroundView = lbl
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
