//
//  ParentDashbaordVC.swift
//  
//
//  Created by i-Verve on 23/10/20.
//

import UIKit

class ParentDashbaordVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets variable
    @IBOutlet weak var tblCategory: UITableView!
    
    //MARK: - local variable
    var arrayPAL = [String]()
    private var popGesture: UIGestureRecognizer?
    
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.arrayPAL = ["Student Profiles","Teacher Link","View Progress Reports","View Certificates","Manage Subscription","Referrals"]
        
        self.screenTitle()
        
        if let childInfo = Preferance.user.childInfo{
            if childInfo.count == 0{
                showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
            }
        }
        else{
            // showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.disableSwipeToPop()
        if let nav = self.navigationController{
            transparentNav(nav: nav)
        }
    }
    
    //MARK: - support method
    func screenTitle() {
        let titleLabel = UILabel(frame: CGRect(x: (ScreenSize.SCREEN_WIDTH - 200), y: 0, width: (DeviceType.IS_IPAD) ? 100 : 70, height: 35))
        titleLabel.navTitle(strText: "PAL".localized, titleColor: .white)
        titleLabel.backgroundColor = UIColor(named: "Color_lightSky")
        titleLabel.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        titleLabel.layer.cornerRadius = 5
        titleLabel.clipsToBounds = true
        self.navigationItem.titleView = titleLabel
    }
    
    //MARK: - Button Clicked
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayPAL.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = String()
        if DeviceType.IS_IPAD {
            identifier = "SelectCategoryParentCell_iPad"
        }
        else {
            identifier = "SelectCategoryParentCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! SelectCategoryParentCell
        let strName = self.arrayPAL[indexPath.row]
        cell.lblData.text = strName
        cell.imgIcon.image = UIImage(named: strName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let nextVC = SetupStudentProfileVC.instantiate(fromAppStoryboard: .ParentDashboard)
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 1:
            if let childInfo = Preferance.user.childInfo{
                if childInfo.count == 0{
                    showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
                }
                else {
                    let nextVC = TeacherLinkVC.instantiate(fromAppStoryboard: .ParentDashboard)
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            else{
                showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
            }
        case 2:
            if let childInfo = Preferance.user.childInfo{
                if childInfo.count == 0{
                    showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
                }
                else {
                    let nextVC = ParentReportCardVC.instantiate(fromAppStoryboard: .ParentDashboard)
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            else{
                showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
            }
        case 3:
            if let childInfo = Preferance.user.childInfo{
                if childInfo.count == 0{
                    showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
                }
                else {
                    let nextVC = CertificateListVC.instantiate(fromAppStoryboard: .ParentDashboard)
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            else{
                showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
            }
        case 4:
            //            if let childInfo = Preferance.user.childInfo{
            //                if childInfo.count == 0{
            //                    showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
            //                }
            //                else {
            print("Option 4")
            //                }
            //            }
            //            else{
            //                showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
            //            }
        case 5:
            //            if let childInfo = Preferance.user.childInfo{
            //                if childInfo.count == 0{
            //                    showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
            //                }
            //                else {
            let nextVC = ReferFriendVC.instantiate(fromAppStoryboard: .ParentDashboard)
            self.navigationController?.pushViewController(nextVC, animated: true)
            //                }
            //            }
            //            else{
            //                showAlert(title: APP_NAME, message: ScreenText.ChildAddMssg)
            //            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE{
            return 100.0
        }
        else{
            return ScreenSize.SCREEN_HEIGHT * 0.12
        }
    }
}
extension ParentDashbaordVC:UIGestureRecognizerDelegate {
    func disableSwipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self == self.navigationController?.topViewController ? false : true
    }
}
