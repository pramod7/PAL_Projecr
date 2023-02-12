//
//  TeacherSubjectBookListVC.swift
//  PAL
//
//  Created by i-Verve on 25/05/21.
//

import UIKit

class TeacherSubjectBookListVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, SubjectListDelegate {
    
    //MARK: - Outlet variable
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - local variable
    var flowLayoutWorkBook: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: teacherCellectionWidth , height: teacherCellHeight)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        _flowLayout.scrollDirection = .vertical
        _flowLayout.minimumInteritemSpacing = spacing
        _flowLayout.minimumLineSpacing = spacing
        return _flowLayout
    }
    var arrSubjectBooksList = [SubjectBooksList]()
    var childId = Int()
    let teacherCellHeight: CGFloat = DeviceType.IS_IPHONE ? 200 : (ScreenSize.SCREEN_HEIGHT*0.25)
    let teacherCellectionWidth: CGFloat = DeviceType.IS_IPHONE ? (ScreenSize.SCREEN_WIDTH - 60) / 2: (ScreenSize.SCREEN_WIDTH - 60) / 3
    var subjectID = Int()
    var filterButton : UIButton!
    let spacing: CGFloat = DeviceType.IS_IPHONE ? 10 : 10
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.SubjectBooks, titleColor: .white)
            self.navigationItem.titleView = titleLabel
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            
            let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 20))
            let btnFilter = UIButton(frame: iconSize)
            btnFilter.imageView?.contentMode = .scaleAspectFit
            let imgTemp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgTemp.image = UIImage(named: "Group3751")
            btnFilter.addSubview(imgTemp)
            filterButton = btnFilter
            btnFilter.addTarget(self, action: #selector(btnFilterClick), for: .touchUpInside)
            
            let barFilerButton = UIBarButtonItem(customView: btnFilter)
            self.navigationItem.rightBarButtonItems = [barFilerButton]
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
    
    //MARK: - btn Click
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnFilterClick(){
        let nextVC = SubjectListPopOver.instantiate(fromAppStoryboard: .PopOverStoryboard)
        nextVC.delegate = self
        nextVC.isStudent = true
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            var popOverHight = 240
            if popOverHight > 480 {
                popOverHight = 480
            }
            nextVC.preferredContentSize = CGSize(width: 250,height: popOverHight)
            popover.permittedArrowDirections = .up
            popover.sourceView = filterButton
            popover.sourceRect = filterButton.bounds
        }
        self.present(nav, animated: true, completion: nil)
        self.view.endEditing(true)
    }
    
    //MARK: - collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubjectBooksList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if DeviceType.IS_IPHONE {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectTilesInfoCell", for: indexPath) as! SubjectTilesInfoCell
            if indexPath.row % 2 == 0 {
                cell.lblSubjectName.text = self.arrSubjectBooksList[indexPath.row].subjectName
                cell.lblTeacherName.text = "Teacher : \(self.arrSubjectBooksList[indexPath.row].teacherName ?? "")"
                cell.lblTeacherId.text = "Teacher ID : \(self.arrSubjectBooksList[indexPath.row].teacherId ?? "")"
                cell.lblDate.text = self.arrSubjectBooksList[indexPath.row].startDate
                cell.imgMarking.sd_setImage(with: URL(string: self.arrSubjectBooksList[indexPath.row].pdfThumb!))
                cell.imgMarking.layer.cornerRadius = 5.0
            }
            else {
                cell.imgMarking.image = UIImage(named: "Icon_PrimaryBook")
                cell.lblSubjectName.text = self.arrSubjectBooksList[indexPath.row].subjectName
                cell.lblTeacherName.text = "Teacher : \(self.arrSubjectBooksList[indexPath.row].teacherName ?? "")"
                cell.lblTeacherId.text = "Teacher ID : \(self.arrSubjectBooksList[indexPath.row].teacherId ?? "")"
                cell.lblDate.text = self.arrSubjectBooksList[indexPath.row].startDate
                cell.imgMarking.sd_setImage(with: URL(string: self.arrSubjectBooksList[indexPath.row].pdfThumb!))
                cell.imgMarking.layer.cornerRadius = 5.0
            }
            cell.imgProgress.isHidden = true
            cell.imgMarking.isHidden = false
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectTilesInfoiPadCell", for: indexPath) as! SubjectTilesInfoiPadCell
            if indexPath.row % 2 == 0 {
                cell.lblSubjectName.text = self.arrSubjectBooksList[indexPath.row].subjectName
                cell.lblTeacherName.text = "Teacher : \(self.arrSubjectBooksList[indexPath.row].teacherName ?? "")"
                cell.lblTeacherId.text = "Teacher ID : \(self.arrSubjectBooksList[indexPath.row].teacherId ?? "")"
                cell.lblDate.text = self.arrSubjectBooksList[indexPath.row].startDate
                cell.imgMarking.sd_setImage(with: URL(string: self.arrSubjectBooksList[indexPath.row].pdfThumb!))
                cell.imgMarking.layer.cornerRadius = 5.0
            }
            else {
                cell.imgMarking.image = UIImage(named: "Icon_PrimaryBook")
                cell.lblSubjectName.text = self.arrSubjectBooksList[indexPath.row].subjectName
                cell.lblTeacherName.text = "Teacher : \(self.arrSubjectBooksList[indexPath.row].teacherName ?? "")"
                cell.lblTeacherId.text = "Teacher ID : \(self.arrSubjectBooksList[indexPath.row].teacherId ?? "")"
                cell.lblDate.text = self.arrSubjectBooksList[indexPath.row].startDate
                cell.imgMarking.sd_setImage(with: URL(string: self.arrSubjectBooksList[indexPath.row].pdfThumb!))
                cell.imgMarking.layer.cornerRadius = 5.0
            }
            cell.imgProgress.isHidden = true
            cell.imgMarking.isHidden = false
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !Connectivity.isConnectedToInternet() {
            showAlert(title: APP_NAME, message: Messages.NOINTERNET)
            return
        }
        let objNext = WorksheetViewVC.instantiate(fromAppStoryboard: .Student)
        objNext.arrImages = self.arrSubjectBooksList[indexPath.row].pdfImages ?? []
        if let arrPdf = arrSubjectBooksList[indexPath.row].pdfImages{
            objNext.arrImages = arrPdf
        }
        if let arrInstruction = self.arrSubjectBooksList[indexPath.row].instruction{
            objNext.arrInstruction = arrInstruction
        }
        if let arrvoiceInstruction = self.arrSubjectBooksList[indexPath.row].voiceinstruction{
            objNext.arrvoiceInstruction = arrvoiceInstruction
        }
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    //MARK: - Support Method
    func saveSubject(strText: NSString, strID: NSInteger) {
        self.subjectID = strID
        APICallGetSubjectsForWorkbooks()
    }
    
    func saveChildInfo(childInfo: ChildInfoModel) {
        
    }
    
    //MARK: - API Call
    func APICallGetSubjectsForWorkbooks() {
        
        var params: [String: Any] = [ : ]
        params["pageIndex"] = 0
        params["subjectId"] = self.subjectID
        params["studentId"] = self.childId
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getSubjectBooksList, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let linkTeacher = userData.SubjectBooksList {
                            self.arrSubjectBooksList = linkTeacher
                            self.collectionView.reloadData()
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrSubjectBooksList.count > 0{
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
