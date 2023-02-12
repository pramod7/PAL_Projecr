//
//  SelectCategoryVC.swift
//  PAL
//
//  Created by i-Verve on 27/10/20.
//

import UIKit

class SelectCategoryVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var imgCategory: UIImageView!{
        didSet{
            self.imgCategory.layer.cornerRadius = (DeviceType.IS_IPHONE) ? ((ScreenSize.SCREEN_HEIGHT * 0.35) * 0.5)/2 : ((ScreenSize.SCREEN_HEIGHT * 0.30) * 0.5)/2
        }
    }
    @IBOutlet weak var imgArrowParent: UIImageView!{
        didSet{
            if DeviceType.IS_IPAD{
                self.imgArrowParent.setImageColor(color: .black)
            }
            else{
                self.imgArrowParent.setImageColor(color: .white)
            }
        }
    }
    @IBOutlet weak var imgArrowTeacher: UIImageView!{
        didSet{
            self.imgArrowTeacher.setImageColor(color: .black)
        }
    }
    @IBOutlet weak var lbliam: UILabel!
    @IBOutlet weak var btnParent: UIButton!{
        didSet{
            self.btnParent.layer.cornerRadius = 5
            if DeviceType.IS_IPAD{
                self.btnParent.isSelected = false
                self.btnParent.backgroundColor = UIColor.white
                self.btnParent.layer.borderColor = UIColor.black.cgColor
                self.btnParent.layer.borderWidth = 0.5
            }
            else{
                self.btnParent.isSelected = true
            }
        }
    }
    @IBOutlet weak var btnTeacher: UIButton!{
        didSet{
            self.btnTeacher.layer.cornerRadius = 5
            self.btnTeacher.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var btnParentHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnParentWidth: NSLayoutConstraint!
    @IBOutlet weak var nslcTopViewHeight: NSLayoutConstraint!
    
    //MARK:- Button Click
    @IBAction func btnClickUserType(_ sender: UIButton) {
        var userDetail = User()
        let nextVC = SignupVC.instantiate(fromAppStoryboard: .Main)
        if sender.tag == 0{
            self.btnParent.isSelected = true
            self.btnTeacher.isSelected = false
            self.btnParent.backgroundColor = UIColor.kAppThemeColor()
            self.btnTeacher.backgroundColor = UIColor.white
            
            self.btnParent.layer.borderWidth = 0
            self.btnTeacher.layer.borderColor = UIColor.black.cgColor
            self.btnTeacher.layer.borderWidth = 0.5
            
            self.imgArrowParent.setImageColor(color: .white)
            self.imgArrowTeacher.setImageColor(color: .black)
            userDetail.userType = 1
            nextVC.isUserType = 1
        }
        else {
            self.btnTeacher.isSelected = true
            self.btnParent.isSelected = false
            self.btnTeacher.backgroundColor = UIColor.kAppThemeColor()
            self.btnParent.backgroundColor = UIColor.white
            
            self.btnTeacher.layer.borderWidth = 0
            self.btnParent.layer.borderColor = UIColor.black.cgColor
            self.btnParent.layer.borderWidth = 0.5
            
            self.imgArrowParent.setImageColor(color: .black)
            self.imgArrowTeacher.setImageColor(color: .white)
            if DeviceType.IS_IPHONE {
                showAlertWithBackAction(title: APP_NAME, message: Validation.iPadTCompatible)
                return
            }
            userDetail.userType = 2
            nextVC.isUserType = 2
        }
        Preferance.user = userDetail
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
        
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController{
            transparentNav(nav: nav)            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        self.SetupSelectCategory()
    }
    
    //MARK:- support method
    func SetupSelectCategory(){
        self.lbliam.font = UIFont.Font_ProductSans_Bold(fontsize: 32)
        self.btnParent.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        self.btnTeacher.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        if DeviceType.IS_IPHONE{
            self.nslcTopViewHeight.isActive = true
            self.btnParentHeight.isActive = true
            self.nslcbtnParentWidth.isActive = true
        }
        else{
            self.nslcTopViewHeight.isActive = false
            self.btnParentHeight.isActive = false
            self.nslcbtnParentWidth.isActive = false
        }
    }
    
    //MARK:- btn Click
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
