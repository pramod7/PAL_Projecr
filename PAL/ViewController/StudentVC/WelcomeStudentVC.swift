//
//  WelcomeStudentVC.swift
//  PAL
//
//  Created by i-Verve on 27/11/20.
//

import UIKit
import SDWebImage

class WelcomeStudentVC: UIViewController {
    
    //MARK: - Outlet variable
    @IBOutlet weak var lblwelcome: UILabel!{
        didSet{
            lblwelcome.font = UIFont.Font_ProductSans_Regular(fontsize: 28)
        }
    }
    @IBOutlet weak var lblUserName: UILabel!{
        didSet{
            lblUserName.font = UIFont.Font_WorkSans_Bold(fontsize: 35)
        }
    }
    @IBOutlet weak var objCollection: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!{
        didSet{
            lblNoData.font = UIFont.Font_ProductSans_Regular(fontsize: 20)
        }
    }
    
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
    var selectedSubject: Int = 99
    var arrSubjectList = [SubjectListModel]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.objCollection.collectionViewLayout = flowLayout
        self.lblUserName.text = "\(Preferance.user.firstName ?? "") \(Preferance.user.lastName ?? "")"
        self.navItemSetUp()
        if !Connectivity.isConnectedToInternet() {
            self.lblNoData.isHidden = false
        }else{
            self.lblNoData.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.disableSwipeToPop()
        Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
        }
        self.APICallGetStudentWorkbookList()
      
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    //MARK: - Support method
    func navItemSetUp() {
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "Subjects", titleColor: .white)
        self.navigationItem.titleView = titleLabel
        
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20))
        let btnNotification = UIButton(frame: iconSize)
        btnNotification.imageView?.contentMode = .scaleAspectFit
        let imgTemp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgTemp.image = UIImage(named: "Icon_Notification_StudentNav")
        btnNotification.addSubview(imgTemp)
        btnNotification.addTarget(self, action: #selector(btnNotificationClick), for: .touchUpInside)
        let barNotificationsButton = UIBarButtonItem(customView: btnNotification)
        
        //        let btnColorPadList = UIButton(frame: iconSize)
        //        btnColorPadList.imageView?.contentMode = .scaleAspectFit
        //        btnColorPadList.setImage(UIImage(named: "Icon_ColorPad"), for: .normal)
        //        btnColorPadList.addTarget(self, action: #selector(btnColorPad), for: .touchUpInside)
        //        let barColorPadButton = UIBarButtonItem(customView: btnColorPadList)
        
        let btnTaskList = UIButton(frame: iconSize)
        let imgTemp2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgTemp2.image = UIImage(named: "icon_setting_white")
        btnTaskList.addSubview(imgTemp2)
        btnTaskList.addTarget(self, action: #selector(btnsettingClick), for: .touchUpInside)
        let barTaskListButton = UIBarButtonItem(customView: btnTaskList)
        
        self.navigationItem.rightBarButtonItems = [barNotificationsButton, barTaskListButton]//barColorPadButton
    }
    
    //MARK: - btn Click
    @objc func btnNotificationClick(){
        let nextVC = NotificationVC.instantiate(fromAppStoryboard: .TabBar)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func btnColorPad(){
        let nextVC = ColorSelectionVC.instantiate(fromAppStoryboard: .Student)
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func btnsettingClick(){
       
        let nextVC = SettingVC.instantiate(fromAppStoryboard: .TabBar)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnTaskListClick(_ sender: Any) {
        let nextVC = TaskListViewController.instantiate(fromAppStoryboard: .Student)
        nextVC.isSubjectList = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: - API Call
    func APICallGetStudentWorkbookList() {
        
        let params: [String: Any] = [ : ]
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getStudentSubjectList, showLoader: true, vc:self) { (jsonData, error) in
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

extension WelcomeStudentVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
        if let url = self.arrSubjectList[indexPath.row].subjectCover,url.trim.count > 0{
            cell.imgSubject.clipsToBounds = true
            cell.imgSubject.layer.cornerRadius = (((ScreenSize.SCREEN_WIDTH - 40) / 3.18)*0.3) / 2
            cell.imgSubject.sd_setImage(with: URL(string: url))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedSubject != indexPath.row {
            self.selectedSubject = indexPath.row
            self.objCollection.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            let objItem : SubjectListModel = self.arrSubjectList[indexPath.row]
            
            if let strClr = objItem.subjectCoverColor{
                Singleton.shared.save(object: strClr, key: UserDefaultsKeys.navColor)
            }
            let objNextVC = WorkBookStudentVC.instantiate(fromAppStoryboard: .Student)
            objNextVC.isFromStudent = true
            if let strName = objItem.subjectName{
                objNextVC.strScreenTitle = strName
            }
            if let subId = objItem.subjectId{
                objNextVC.subjectId = subId
            }
            self.navigationController?.pushViewController(objNextVC, animated: true)
        })
    }
}
extension WelcomeStudentVC:UIGestureRecognizerDelegate {
    func disableSwipeToPop() {
          self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
           self.navigationController?.interactivePopGestureRecognizer?.delegate = self
       }
    
       func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self == self.navigationController?.topViewController ? false : true
       }
}
