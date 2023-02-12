//
//  ParentViewProfileVC.swift
//  PAL
//
//  Created by i-Phone7 on 05/12/20.
//

import UIKit

class ParentViewProfileVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Outlet variable
    @IBOutlet weak var tblViewProfile: UITableView!
    @IBOutlet var cellUserInfo: UITableViewCell!
    
    @IBOutlet weak var lblUserName: UILabel!{
        didSet{
            self.lblUserName.font = UIFont.Font_ProductSans_Bold(fontsize: 20)
        }
    }
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.layer.cornerRadius = (DeviceType.IS_IPHONE) ?(ScreenSize.SCREEN_WIDTH*0.2)/2:(ScreenSize.SCREEN_WIDTH*0.15)/2
        }
    }

    @IBOutlet weak var lblSuburb: UILabel!{
        didSet{
            lblSuburb.font = UIFont.Font_WorkSans_Bold(fontsize: 18)
        }
    }
    @IBOutlet weak var lblSuburbValue: UILabel!{
        didSet{
            lblSuburbValue.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        }
    }
    @IBOutlet weak var lblChildrenCount: UILabel!{
        didSet{
            self.lblChildrenCount.font = UIFont.Font_WorkSans_Bold(fontsize: 18)
        }
    }
    @IBOutlet weak var lblChildrenCountValue: UILabel!{
        didSet{
            self.lblChildrenCountValue.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        }
    }
    @IBOutlet weak var lblEmail: UILabel!{
        didSet{
            self.lblEmail.font = UIFont.Font_WorkSans_Bold(fontsize: 18)
        }
    }
    @IBOutlet weak var lblEmailValue: UILabel!{
        didSet{
            self.lblEmailValue.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        }
    }
    @IBOutlet var lblNameIndicator: UILabel!{
        didSet{
            lblNameIndicator.font = UIFont.Font_WorkSans_Bold(fontsize: 35)
        }
    }
    @IBOutlet weak var nslcImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var nslclblNameIndicatorWidth: NSLayoutConstraint!
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.Profile, titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setTitle("Edit Profile", for: .normal)
            btnBack.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            btnBack.addTarget(self, action: #selector(btnEditProfile), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        if DeviceType.IS_IPHONE{
            self.nslcImgViewWidth.isActive = true
            self.nslclblNameIndicatorWidth.isActive = true
        }
        else{
            self.nslcImgViewWidth.isActive = false
            self.nslclblNameIndicatorWidth.isActive = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disableSwipeToPop()
        self.SetupProfile()
    }
    
    //MARK:- Support Method
    func SetupProfile(){
        
        var strName = ""
        if let fName = Preferance.user.firstName{
            strName = fName
            if fName.count > 0 {
                self.lblNameIndicator.text = getNthCharacter(strText: fName)
            }
        }
        if let lName = Preferance.user.lastName{
            strName = strName + " " + lName
        }
        self.lblUserName.text = strName
        if let email = Preferance.user.email{
            self.lblEmailValue.text = email
        }
        if let suburb = Preferance.user.suburb{
            self.lblSuburbValue.text = suburb
        }
        if let childInfo = Preferance.user.childInfo{
            self.lblChildrenCountValue.text = "\(childInfo.count)"
        }
    }
    
    //MARK:- btn Click
    @objc func btnEditProfile() {
        let objNext = ParentEditProfile.instantiate(fromAppStoryboard: .ParentDashboard)
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        default:
            return cellUserInfo
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        default:
            return UITableView.automaticDimension//(DeviceType.IS_IPHONE) ? 330:420//ScreenSize.SCREEN_HEIGHT * 0.45
        }
    }
}
extension ParentViewProfileVC:UIGestureRecognizerDelegate {
    func disableSwipeToPop() {
          self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
           self.navigationController?.interactivePopGestureRecognizer?.delegate = self
       }
    
       func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self == self.navigationController?.topViewController ? false : true
       }
}
