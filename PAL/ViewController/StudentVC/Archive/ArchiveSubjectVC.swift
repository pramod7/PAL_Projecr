//
//  ArchiveSubjectVC.swift
//  PAL
//
//  Created by Akshay Shah on 31/03/22.
//

import UIKit

class ArchiveSubjectVC: UIViewController, UITextFieldDelegate, SchoolListDelegate {

    @IBOutlet weak var lblSelectSubject: UILabel!
    @IBOutlet weak var txtYears: UITextField!
    @IBOutlet weak var objCollection: UICollectionView!
    
    //MARK: - Local variable
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: (ScreenSize.SCREEN_WIDTH - 40) / 3.18 , height: ScreenSize.SCREEN_HEIGHT/5)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        _flowLayout.scrollDirection = .vertical
        _flowLayout.minimumInteritemSpacing = 5
        _flowLayout.minimumLineSpacing = 40
        return _flowLayout
    }
    var arrSubjectList = [SubjectListModel]()
    var selectedSubject: Int = 99
    var strYear = ""
    var SubjectId = 0
    var arrYear = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.objCollection.collectionViewLayout = flowLayout
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            nav.navigationBar.tintColor = .kAppThemeColor()
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Archive", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        
        if self.arrSubjectList.count > 0{
            self.objCollection.backgroundView = nil
        }
        else{
            let lbl = UILabel.init(frame: self.objCollection.frame)
            lbl.text = "No Subject(s) found"
            lbl.textAlignment = .center
            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
            self.objCollection.backgroundView = lbl
        }
        txtYears.delegate = self
        self.APICallGetYearList()
        self.SetupArchiveList()
    }
    
    
    @objc func btnBackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - support method
    
    
    func saveCount(strText: String) {
        txtYears.text = strText
        strYear = strText
        self.APICallGetStudentArchiveWorkbookList(year: strText)
        
    }
    
    func saveFont(SelectedFont: Int) {
        
    }
    
    func saveText(objSchool: SchoolListModel) {
    }
    
    func SetupArchiveList(){
        self.lblSelectSubject.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtYears.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
    }
    
    //MARK: - txt delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtYears{
           if DeviceType.IS_IPAD{
               self.view.endEditing(true)
               let nextVC = SchoolListVC.instantiate(fromAppStoryboard: .PopOverStoryboard)
               nextVC.delegate = self
               nextVC.isChildCount = true
               nextVC.arrChildList = arrYear
               let nav = UINavigationController(rootViewController: nextVC)
               nav.modalPresentationStyle = .popover
               if let popover = nav.popoverPresentationController {
                   nextVC.preferredContentSize = CGSize(width: 200,height: 300)
                   popover.permittedArrowDirections = .unknown
                   popover.sourceView = self.txtYears
                   popover.sourceRect = self.txtYears.bounds
               }
               self.present(nav, animated: true, completion: nil)
               return false
           }
        }
        return true
    }
    
    func Setup()
    {   txtYears.text = arrYear[0]
        self.strYear = arrYear[0]
        self.APICallGetStudentArchiveWorkbookList(year: arrYear[0])
    }
    
    func APICallGetYearList()
    {
        var params: [String: Any] = [ : ]
        params["studentId"] = Preferance.user.userId
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getYearList, showLoader: true, vc:self) { (jsonData, error) in
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1 {
                        self.arrYear = userData.yearList?[0].year ?? [String]()
                        self.Setup()
                    }
                }
            }else{
                
            }
        }
    }
    
    func APICallGetStudentArchiveWorkbookList(year: String) {
        
        var params: [String: Any] = [ : ]
        params["studentId"] = Preferance.user.userId
        params["year"] = year
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getArchiveSubject, showLoader: true, vc:self) { (jsonData, error) in
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let linkTeacher = userData.subjectList {
                            self.arrSubjectList = linkTeacher
                            self.objCollection.reloadData()
                           
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrSubjectList.count > 0{
                            self.objCollection.backgroundView = nil
                        }
                        else{
                            let lbl = UILabel.init(frame: self.objCollection.frame)
                            lbl.text = "No Subject(s) found"
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
extension ArchiveSubjectVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherSubjectCollectionViewCell", for: indexPath) as! TeacherSubjectCollectionViewCell
        
        if self.selectedSubject == indexPath.row {
            cell.objView.layer.borderWidth = 2
            cell.objView.layer.borderColor = UIColor.lightGray.cgColor
        }
        else {
            cell.objView.layer.borderWidth = 0
            cell.objView.layer.borderColor = UIColor.clear.cgColor
        }
        if let color = self.arrSubjectList[indexPath.row].subjectCoverColor, color.count > 0{
            cell.objView.backgroundColor = UIColor.setColor(str:color)
            cell.objView.layer.cornerRadius = 10
        }
        if let temp = self.arrSubjectList[indexPath.row].subjectName{
            cell.lblSubjectname.text = temp
        }
        if let temp = self.arrSubjectList[indexPath.row].teahcerName{
            cell.lblteachername.text = temp
        }
        if let url = self.arrSubjectList[indexPath.row].subjectCover,url.trim.count > 0{
            cell.imgSubject.clipsToBounds = true
            cell.imgSubject.layer.cornerRadius = (((ScreenSize.SCREEN_WIDTH - 40) / 3.18)*0.3) / 2
            cell.imgSubject.sd_setImage(with: URL(string: url))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            let nextVC = ArchiveList.instantiate(fromAppStoryboard: .Student)
            nextVC.subjectId = self.arrSubjectList[indexPath.row].subjectId ?? 0
            nextVC.strYear = self.strYear
            self.navigationController?.pushViewController(nextVC, animated: true)
        })
    }
}
