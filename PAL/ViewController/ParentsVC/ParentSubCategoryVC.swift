//
//  ParentSubCategoryVC.swift
//  PAL
//
//  Created by i-Verve on 10/11/20.
//

import UIKit

class ParentSubCategoryVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, SubCategoryDelegate {
    
    
    
    //MARK:- Outlet variable
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK:- local variable
    var flowLayout: UICollectionViewFlowLayout {
        let width = ((ScreenSize.SCREEN_WIDTH * 0.9) - 30) / 2
        
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width:width , height: ScreenSize.SCREEN_HEIGHT/3)
        _flowLayout.sectionInset = UIEdgeInsets(top: 20, left: (ScreenSize.SCREEN_WIDTH * 0.1)/2, bottom: 0, right: (ScreenSize.SCREEN_WIDTH * 0.1)/2)
        _flowLayout.scrollDirection = .vertical
        _flowLayout.minimumInteritemSpacing = 20
        _flowLayout.minimumLineSpacing = 20
        return _flowLayout
    }
    var arrWorkbookList = [WorkbookListModel]()
    var childId = Int()
    let teacherCellHeight: CGFloat = DeviceType.IS_IPHONE ? 340 : (ScreenSize.SCREEN_HEIGHT*0.33)
    let teacherCellectionWidth: CGFloat = DeviceType.IS_IPHONE ? (ScreenSize.SCREEN_WIDTH - 50) / 2: (ScreenSize.SCREEN_WIDTH - 50) / 3
    var subjectID = Int()
    var subCategoryId = Int()
    var SubjectIdPop = Int()
    var SubcategoryIdPop  = [Int]()
    var btnFilter : UIButton?
    var arrSubcategoryName : [String?] = []
    let spacing: CGFloat = DeviceType.IS_IPHONE ? 5 : 2
    var arrSubjectName : [String?] = []
    var arrSubjectId : [Int?] = []

    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subjectID = 0
        
        if let nav = self.navigationController {
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
//            titleLabel.navTitle(strText: ScreenTitle.SubjectBooks, titleColor: .white)
            titleLabel.navTitle(strText: "SubjectBooks", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
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
        
       self.collectionView.collectionViewLayout = flowLayout
       self.APICallGetWorkbookList()
    }
    
    //MARK:- btn Click
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func btnFilterClick(){
       
        let nextVC = SubcategoryListPopOver.instantiate(fromAppStoryboard: .PopOverStoryboard)
        nextVC.childId = self.childId
        nextVC.subjectID = self.SubjectIdPop
        nextVC.subCategoryId = self.SubcategoryIdPop
        nextVC.arrsubCategory = arrSubcategoryName
        nextVC.delegate = self
        nextVC.isStudent = true
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            var popOverHight = self.arrSubcategoryName.count * 60
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
    func saveSubject(strText: NSString, strID: NSInteger) {
        print("\(strID)")
        if strText == "See All"
        {
            subCategoryId = 0
        }
        else
        {
            self.subCategoryId = strID
        }
        self.subjectID = SubjectIdPop
        APICallGetWorkbookList()
    }
    
    func saveChildInfo(childInfo: ChildInfoModel) {
        
    }
    //MARK:- collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrWorkbookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
       
       
            if indexPath.row % 2 == 0 {
                cell.imgSubCategory.sd_setImage(with: URL(string: self.arrWorkbookList[indexPath.row].pdfThumb!))
                cell.lblDate.text = self.arrWorkbookList[indexPath.row].worksheetsAssignDate
                cell.lblSubCategoryName.text = self.arrWorkbookList[indexPath.row].subCategory
                cell.lblSubjectName.text = self.arrWorkbookList[indexPath.row].subjectName
//                cell.lblTeacherId.text = self.arrWorkbookList[indexPath.row].teacher_Id
                cell.lblTeacherName.text = "Teacher:- \(self.arrWorkbookList[indexPath.row].teacherName ?? "")"
                cell.lblWorkbookName.text = self.arrWorkbookList[indexPath.row].worksheetName
                let SubCategoryId = self.arrWorkbookList[indexPath.row].subCategoryId ?? 0
                SubcategoryIdPop.append(SubCategoryId)
                SubjectIdPop = self.arrWorkbookList[indexPath.row].subjectId ?? 0
                let SubCategoryName = self.arrWorkbookList[indexPath.row].subCategory
                arrSubcategoryName.append(SubCategoryName)
                arrSubcategoryName.removeDuplicates()
               
            }
            else {
                cell.imgSubCategory.sd_setImage(with: URL(string: self.arrWorkbookList[indexPath.row].pdfThumb!))
                cell.lblDate.text = self.arrWorkbookList[indexPath.row].worksheetsAssignDate
                cell.lblSubCategoryName.text = self.arrWorkbookList[indexPath.row].subCategory
                cell.lblSubjectName.text = self.arrWorkbookList[indexPath.row].subjectName
//                cell.lblTeacherId.text = self.arrWorkbookList[indexPath.row].teacher_Id
                cell.lblTeacherName.text = "Teacher:- \(self.arrWorkbookList[indexPath.row].teacherName ?? "")"
                cell.lblWorkbookName.text = self.arrWorkbookList[indexPath.row].worksheetName
            }
      
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objNext = WorksheetViewVC.instantiate(fromAppStoryboard: .Student)
        objNext.arrImages = self.arrWorkbookList[indexPath.row].pdfImage ?? []
        if let arrPdf = arrWorkbookList[indexPath.row].pdfImage{
            objNext.arrImages = arrPdf
        }
        if let arrInstruction = self.arrWorkbookList[indexPath.row].instruction{
            objNext.arrInstruction = arrInstruction
        }
        if let arrvoiceInstruction = self.arrWorkbookList[indexPath.row].voiceinstruction{
            objNext.arrvoiceInstruction = arrvoiceInstruction
        }
        self.navigationController?.pushViewController(objNext, animated: true)
    }
 
    func APICallGetWorkbookList() {
        
        var params: [String: Any] = [ : ]
        params["childId"] = self.childId
        params["pageIndex"] = 0
        params["isFive"] = 0
        params["subjectId"] = self.subjectID
        params["subCategoryId"] = self.subCategoryId
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getParentChildWorksheetsList, showLoader: true, vc:self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let linkTeacher = userData.WorkbookList {
                            self.arrWorkbookList = linkTeacher
                            self.collectionView.reloadData()
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrWorkbookList.count > 0{
                            self.collectionView.backgroundView = nil
                        }
                        else{
                            
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
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
