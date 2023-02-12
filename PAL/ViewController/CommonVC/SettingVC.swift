//
//  SettingVC.swift
//  PAL
//
//  Created by i-Verve on 29/10/20.
//

import UIKit


class SettingVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - Outlet variable
    @IBOutlet weak var tblSetting: UITableView!
    
    //MARK: - Local variable
    var arrAllItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: ScreenTitle.Settings, titleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        self.navigationItem.titleView = titleLabel
        if Preferance.user.userType == 1 {
            self.arrAllItems = ["Terms & Conditions", "Privacy Policy", "Tips", "FAQ's", "Features" ,"Feedback","Manage Card","Change Password", "Logout"]
            titleLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        }
        else {
            
            
            if Preferance.user.userType == 0 {
                self.arrAllItems = ["Tips", "FAQ's", "Features", "Feedback", "Change Password", "Archive", "Logout"]
                let btnBack: UIButton = UIButton()
                btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
                btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
                btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            }else{
                self.arrAllItems = ["Tips", "FAQ's", "Features", "Feedback", "Change Password", "Logout"]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disableSwipeToPop()
        if Preferance.user.userType == 1 {
            if let nav = self.navigationController{
                nonTransparentNav(nav: nav)
            }
        }
        else {
            if let nav = self.navigationController{
                nonTransparentNav(nav: nav)
            }
        }
    }
    
    //MARK: - Support method
    func logoutConfirmation(){
        if Preferance.user.userType == 1{
            let alert = UIAlertController(title: APP_NAME, message: Validation.LogOut, preferredStyle: .alert)
            alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            alert.addAction(UIAlertAction(title: Messages.CANCEL, style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: Messages.Logout, style: .default, handler: { action in
                self.APICallLogout()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: APP_NAME, message: Validation.LogOut, preferredStyle: .alert)
            alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            alert.addAction(UIAlertAction(title: Messages.CANCEL, style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: Messages.Logout, style: .default, handler: { action in
                let result = WorksheetDBManager.shared.GetData()
                if result.count > 0 {
                    let alert = UIAlertController(title: APP_NAME, message: "You have offline worksheet data saved locally which still need to sync, Do you still want to logout?", preferredStyle: .alert)
                    alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
                    alert.addAction(UIAlertAction(title: Messages.CANCEL, style: .destructive, handler: nil))
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.APICallLogout()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    self.APICallLogout()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - btn click event
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - btl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var strIdentifier = String()
        if DeviceType.IS_IPAD {
            strIdentifier = "SettingCell_iPad"
        }
        else {
            strIdentifier = "SettingCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier) as! SettingCell
        cell.lblTitle.text = arrAllItems[indexPath.row]
        cell.img.image = UIImage(named: self.arrAllItems[indexPath.row])
        if Preferance.user.userType == 2 {
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Preferance.user.userType == 1{
            switch indexPath.row {
            case 0:
                //this the second screen of terms & condition for settingVC
                let nextVC = Terms_ConditionVC.instantiate(fromAppStoryboard: .Settings)
                nextVC.isPrivacyPolicy = false
                nextVC.isFromSetting = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 1:
                //this the second screen of terms & condition for settingVC
                let nextVC = Terms_ConditionVC.instantiate(fromAppStoryboard: .Settings)
                nextVC.isPrivacyPolicy = true
                nextVC.isFromSetting = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 2:
                let nextVC = TipsViewController.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 3 :
                let nextVC = FAQViewController.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 4:
                let nextVC = SwipeFeatureVC.instantiate(fromAppStoryboard: .Main)
                nextVC.isFromSetting = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 5:
                let nextVC = FeedbackVC.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 6:
                let nextVC = AddCardViewCardVC.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 7:
                let nextVC = ChangePasswordVC.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 8:
                self.logoutConfirmation()
            default:
                break
            }
        }
        else if Preferance.user.userType == 0{
            switch indexPath.row {
            case 0:
                let nextVC = TipsViewController.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 1:
                let nextVC = FAQViewController.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 2:
                let nextVC = SwipeFeatureVC.instantiate(fromAppStoryboard: .Main)
                nextVC.isFromSetting = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 3:
                let nextVC = FeedbackVC.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 4:
                let nextVC = ChangePasswordVC.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 5 :
                let nextVC = ArchiveSubjectVC.instantiate(fromAppStoryboard: .Student)
                self.navigationController?.pushViewController(nextVC, animated: true)
            default:
                self.logoutConfirmation()
                break
            }
        }else{
            switch indexPath.row {
            case 0:
                let nextVC = TipsViewController.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 1:
                let nextVC = FAQViewController.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 2:
                let nextVC = SwipeFeatureVC.instantiate(fromAppStoryboard: .Main)
                nextVC.isFromSetting = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 3:
                let nextVC = FeedbackVC.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            case 4:
                let nextVC = ChangePasswordVC.instantiate(fromAppStoryboard: .Settings)
                self.navigationController?.pushViewController(nextVC, animated: true)
            default:
                self.logoutConfirmation()
                break
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Preferance.user.userType == 1 && indexPath.row == 6 {
            return 0
        }
//        else if Preferance.user.userType != 1 && indexPath.row == 5 {
//            return 0
//        }
        else{
            return DeviceType.IS_IPHONE ?80:100
        }
    }
    
    //MARK: - API Call
    func APICallLogout() {
        
        //Please remove ifuturz and i-verve refrensh from project in which you working or going to work.
        var params: [String: Any] = [ : ]
        params["userId"] = Preferance.user.userId
        params["userType"] = Preferance.user.userType
                
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + doLogout, showLoader: true, vc:self) { (jsonData, error) in
            
            if let json = jsonData{
                if let userData = ObjectResponse(JSON: json.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        Preferance.user = User()
                        Singleton.shared.save(object: Preferance.user.toJSON(), key: UserDefaultsKeys.userData)
                        Singleton.shared.save(object: "0", key: LocalKeys.isLogin)
                        Singleton.shared.save(object: "", key: LocalKeys.password)
                        
                        WorksheetDBManager.shared.truncateDB()
                        clearStudentTempDir()
                        clearTeacherTempDir()
                        if let viewControllers = self.navigationController?.viewControllers{
                            for controller in viewControllers{
                                if controller is LoginVC{
                                    self.navigationController?.popToViewController(controller, animated: true)
                                    return
                                }
                            }
                        }
                        appdelegate.window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNav")
                        appdelegate.window?.makeKeyAndVisible()
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                }
            }
            else{
                showAlert(title: APP_NAME, message: error?.debugDescription)
            }
        }
    }
}
extension SettingVC:UIGestureRecognizerDelegate {
    func disableSwipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self == self.navigationController?.topViewController ? false : true
    }
}
