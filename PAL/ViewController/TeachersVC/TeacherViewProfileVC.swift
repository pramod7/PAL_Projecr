//
//  TeacherViewProfileVC.swift
//  PAL
//
//  Created by i-Phone7 on 05/12/20.
//

import UIKit

class TeacherViewProfileVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Outlet variable
    @IBOutlet weak var tblViewProfile: UITableView!
    @IBOutlet var cellUserInfo: UITableViewCell!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.layer.cornerRadius = (ScreenSize.SCREEN_WIDTH*0.15)/2
        }
    }
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var lblSchoolValue: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblEmailValue: UILabel!
    @IBOutlet weak var lblTeacherId: UILabel!
    @IBOutlet weak var lblTeacherIdValue: UILabel!
    @IBOutlet weak var lblSubrub: UILabel!
    @IBOutlet weak var lblSubrubValue: UILabel!{
        didSet{
            self.lblSubrubValue.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        }
    }
    @IBOutlet var lblNameIndicator: UILabel!{
        didSet{
            lblNameIndicator.font = UIFont.Font_ProductSans_Bold(fontsize: 35)
        }
    }
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: ScreenTitle.Profile, titleColor: .white)
        self.navigationItem.titleView = titleLabel
        
        let btnBack: UIButton = UIButton()
        btnBack.setTitle("Edit Profile", for: .normal)
        btnBack.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        btnBack.addTarget(self, action: #selector(btnEditProfile), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        self.SeupProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disableSwipeToPop()
        if let nv = self.navigationController{
            nonTransparentNav(nav: nv)
        }
        self.lblSchoolValue.text = Preferance.user.schoolName
        self.lblEmailValue.text = Preferance.user.email
        self.lblUserName.text = Preferance.user.firstName! + " " + Preferance.user.lastName!
        self.lblSubrubValue.text = Preferance.user.suburb
        self.lblTeacherIdValue.text = Preferance.user.teacher_Id
        self.lblNameIndicator.text = getNthCharacter(strText: Preferance.user.firstName!)
    }
    
    //MARK:- Support Method
    func SeupProfile(){
        self.lblUserName.font = UIFont.Font_ProductSans_Bold(fontsize: 19)
        self.lblSchool.font = UIFont.Font_WorkSans_Bold(fontsize: 18)
        self.lblSchoolValue.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        self.lblEmail.font = UIFont.Font_WorkSans_Bold(fontsize: 18)
        self.lblEmailValue.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        self.lblTeacherId.font = UIFont.Font_WorkSans_Bold(fontsize: 18)
        self.lblTeacherIdValue.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        self.lblSubrub.font = UIFont.Font_WorkSans_Bold(fontsize: 18)
    }
    
    //MARK:- btn Click
    @objc func btnEditProfile() {
        let objNext = TeacherEditProfileVC.instantiate(fromAppStoryboard: .Teacher)
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        default:
            //cellUserInfo.backgroundColor = .red
            return cellUserInfo
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        default:
            return UITableView.automaticDimension
        }
    }
    
    //MARK:- API Call
//    func APICallGetProfile() {
//
//        let params: [String: Any] = [ : ]
//
//        APIManager.showLoader()
//        APIManager.shared.callPostApi(parameters: params, reqURL: APIEndpoint.getProfile) { (jsonData, error) in
//            APIManager.hideLoader()
//
//            if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
//                if let status = userData.status, status == 1{
//                    if let user = userData.user {
//                        Preferance.user = user
//
//                    }
//                    else{
//                        if let msg = jsonData?[APIKey.message].string {
//                            showAlert(title: APP_NAME, message: msg)
//                        }
//                    }
//                }
//                else{
//                    if let msg = jsonData?[APIKey.message].string {
//                        showAlert(title: APP_NAME, message: msg)
//                    }
//                }
//            }
//        }
//    }
}
extension TeacherViewProfileVC:UIGestureRecognizerDelegate {
    func disableSwipeToPop() {
          self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
           self.navigationController?.interactivePopGestureRecognizer?.delegate = self
       }
    
       func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self == self.navigationController?.topViewController ? false : true
       }
}
