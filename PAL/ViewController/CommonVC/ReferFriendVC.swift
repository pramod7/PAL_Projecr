//
//  ReferFriendVC.swift
//  PAL
//
//  Created by i-Verve on 05/11/20.
//

import UIKit

class ReferFriendVC: UIViewController {
    
    //MARK:- Outlet variable
    @IBOutlet weak var lblYourCode: UILabel!{
        didSet{
            self.lblYourCode.font = UIFont.Font_ProductSans_Regular(fontsize: 18)
        }
    }
    @IBOutlet weak var lblCode: UILabel!{
        didSet{
            self.lblCode.font = UIFont.Font_ProductSans_Bold(fontsize: 20)
        }
    }
    @IBOutlet weak var viewWidthIphone: NSLayoutConstraint!
    @IBOutlet weak var lblRefer5: UILabel!{
        didSet{
            if DeviceType.IS_IPHONE{
                self.lblRefer5.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            }
            else{
                self.lblRefer5.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
            }
           
        }
    }
    @IBOutlet weak var lblRefer10: UILabel!{
        didSet{
            if DeviceType.IS_IPHONE{
                self.lblRefer10.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            }
            else{
                self.lblRefer10.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
            }
        }
    }
    @IBOutlet weak var lblRefer25: UILabel!{
        didSet{
            if DeviceType.IS_IPHONE{
                self.lblRefer25.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            }
            else{
                self.lblRefer25.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
            }
        }
    }
    
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnThird: UIButton!
    
    @IBOutlet weak var objView: UIView!{
        didSet{
            objView.backgroundColor = UIColor(named: "Color_CollectionBackground")
        }
    }
    @IBOutlet weak var btnSharenow: UIButton!{
        didSet{
            self.btnSharenow.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    
    @IBOutlet weak var nslcbtnShareNowWidth: NSLayoutConstraint!
    @IBOutlet weak var nslcbtnShareNowHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDataWidth: NSLayoutConstraint!
    @IBOutlet weak var btnselectHegiht: NSLayoutConstraint!
    @IBOutlet weak var btnselectWidth: NSLayoutConstraint!
    @IBOutlet weak var imfOne: NSLayoutConstraint!
    @IBOutlet weak var imgTwo: NSLayoutConstraint!
    @IBOutlet weak var imgThird: NSLayoutConstraint!
    
    //MARK:- Outlet variable
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.ReferAFrnnd, titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        self.lblCode.text = Preferance.user.referralCode
        self.SetupReferFriend()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.objView.backgroundColor = UIColor(named: "Color_CollectionBackground")
        //self.objView.backgroundColor = .red
    }
    
    //MARK:- support method
    func SetupReferFriend(){
        self.objView.layer.cornerRadius = 5
        self.btnSharenow.layer.cornerRadius = 5
        
        if DeviceType.IS_IPHONE{
            self.viewWidthIphone.isActive = false
            self.lblDataWidth.isActive = true
            self.btnselectHegiht.isActive = false
            self.btnselectWidth.isActive = false
            self.nslcbtnShareNowWidth.isActive = false
            self.nslcbtnShareNowHeight.isActive = true
            
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_6_7_8{
                self.imfOne.constant = -7
                self.imgTwo.constant = -7
                self.imgThird.constant = -7
            }
            else{
                self.imfOne.constant = -10
                self.imgTwo.constant = -10
                self.imgThird.constant = -10
            }
        }
        else{
            self.imfOne.constant = -15
            self.imgTwo.constant = -15
            self.imgThird.constant = -15
            self.viewWidthIphone.isActive = false
            self.lblDataWidth.isActive = false
            self.btnselectHegiht.isActive = false
            self.btnselectWidth.isActive = false
            self.nslcbtnShareNowWidth.isActive = false
            self.nslcbtnShareNowHeight.isActive = false
        }
    }
    
    //MARK:- support method
    func shareText() {
        // text to share
        let text = "You can use \(Preferance.user.referralCode ?? "") as referal code."
        let textToShare = [ text ]
        let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        if let wPPC = activityVC.popoverPresentationController {
            wPPC.sourceView = self.btnSharenow
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    //MARK:- btn click
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShareNowClick(_ sender: UIButton) {
//        #if targetEnvironment(simulator)
//          // your simulator code
//        showAlert(title: APP_NAME, message: Validation.ShareNow)
//        #else
        self.shareText()
//        #endif
    }
    
    @IBAction func btnActionClick(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.btnFirst.isSelected = true
            self.btnSecond.isSelected = false
            self.btnThird.isSelected = false
            break
        case 2:
            self.btnFirst.isSelected = false
            self.btnSecond.isSelected = true
            self.btnThird.isSelected = false
            break
        case 3:
            self.btnFirst.isSelected = false
            self.btnSecond.isSelected = false
            self.btnThird.isSelected = true
            break
        default:
            break
        }
    }
}
