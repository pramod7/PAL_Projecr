//
//  TeacherSubjectListVC.swift
//  PAL
//
//  Created by i-Verve on 24/11/20.
//

import UIKit
import SDWebImage

class TeacherSubjectListVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlet variable
    @IBOutlet weak var btnAddNewSubject: UIButton!
    @IBOutlet weak var objCollection: UICollectionView!
    @IBOutlet weak var lblNoSubjectFound: UILabel!{
        didSet{
            lblNoSubjectFound.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
            lblNoSubjectFound.isHidden = true
        }
    }
    
    //MARK: - Local variable
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: (ScreenSize.SCREEN_WIDTH * 0.9) / 2.05 , height: ScreenSize.SCREEN_HEIGHT/5)
        _flowLayout.sectionInset = UIEdgeInsets(top: 50, left: (ScreenSize.SCREEN_WIDTH * 0.1)/2, bottom: 5, right: (ScreenSize.SCREEN_WIDTH * 0.1)/2)
        _flowLayout.scrollDirection = .vertical
        _flowLayout.minimumInteritemSpacing = 10
        _flowLayout.minimumLineSpacing = 40
        return _flowLayout
    }
    
    var arrSubjectList = [SubjectListModel]()
    var arrcolorcode = [ColorListModel]()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: ScreenTitle.Subjects, titleColor: .white)
        self.navigationItem.titleView = titleLabel
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.setupTeacherSubject()
        self.objCollection.collectionViewLayout = flowLayout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
        }
        self.APICallGetSubjectList()
    }
    
    //MARK: - support method
    func setupTeacherSubject(){
        self.btnAddNewSubject.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 20)
        self.btnAddNewSubject.layer.cornerRadius = 5
    }
    
    //MARK: - btn click event
    @IBAction func btnaddNewSubjectClick(_ sender: Any) {
        let objNext = AddNewSubjectVC.instantiate(fromAppStoryboard: .Teacher)
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnEditSubject(sender: UIButton) {
        let objNext = AddNewSubjectVC.instantiate(fromAppStoryboard: .Teacher)
        objNext.selectedSubject = self.arrSubjectList[sender.tag]
        objNext.isEdit = true
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    //MARK: - collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSubjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherSubjectCollectionViewCell", for: indexPath) as! TeacherSubjectCollectionViewCell
        
        if let color = self.arrSubjectList[indexPath.row].subjectCoverColor, color.count > 0{
            cell.objView.backgroundColor = UIColor.setColor(str:color)
        }
        cell.lblSubjectname.font = UIFont.Font_ProductSans_Bold(fontsize: 22)
        cell.lblSubjectname.text = self.arrSubjectList[indexPath.row].subjectName
        
        if let coverPic = self.arrSubjectList[indexPath.row].subjectCover, coverPic.count > 0 {
            cell.imgSubject.sd_setImage(with: URL(string: coverPic))
            
            cell.imgSubject.layer.cornerRadius = (((ScreenSize.SCREEN_WIDTH * 0.9) / 2.05 ) * 0.25) / 2
            cell.imgSubject.clipsToBounds = true
//            cellimgSubject.layer.cornerRadius = (((ScreenSize.SCREEN_WIDTH - 40) / 3.18)*0.3) / 2
        }
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(btnEditSubject), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objNext = TeacherSubTopicList.instantiate(fromAppStoryboard: .Teacher)
        objNext.strSubjectName = self.arrSubjectList[indexPath.row].subjectName!
        objNext.colour = arrSubjectList[indexPath.row].subjectCoverColor!
        objNext.subjectId = self.arrSubjectList[indexPath.row].subjectId!
        objNext.arrSubjectSubList = self.arrSubjectList[indexPath.row].subCategory!
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    //MARK: - API Call
    func APICallGetSubjectList() {
        APIManager.shared.callGetApi(reqURL: URLs.APIURL + getUserTye() + subjectList, showLoader: true) { (jsonData, error) in
            if let json = jsonData{
                if let userData = ListResponse(JSON: json.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        self.arrSubjectList.removeAll()
                        if let user = userData.subjectList {
                            for tempSub in user {
                                self.arrSubjectList.append(tempSub)
                            }
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
                            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
                            self.objCollection.backgroundView = lbl
                        }
                        self.objCollection.reloadData()
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

