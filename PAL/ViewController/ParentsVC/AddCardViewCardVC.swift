//
//  AddCardViewCardVC.swift
//  PAL
//
//  Created by i-Verve on 19/11/20.
//

import UIKit

class AddCardViewCardVC: UIViewController {
    
    //MARK:- Outlet variable
    @IBOutlet weak var btnAddCard: UIButton!{
        didSet{
            btnAddCard.titleLabel?.font =  UIFont.Font_ProductSans_Bold(fontsize: 17)
        }
    }
    @IBOutlet weak var viewCardInfo: UIView!
    @IBOutlet weak var objCornerView: UIView!{
        didSet{
            objCornerView.borderShadowAllSide(Radius: 20)
        }
    }
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblCardhilder: UILabel!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var lblExpiry: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCardHolderName: UILabel!
    
    @IBOutlet weak var btnAddNewCardTop: NSLayoutConstraint!
    @IBOutlet weak var objCardWidth:NSLayoutConstraint!
    @IBOutlet weak var objCardleading: NSLayoutConstraint!
    @IBOutlet weak var nslcAddbtnWidth: NSLayoutConstraint!
    @IBOutlet weak var btnSaveTop: NSLayoutConstraint!
    
    //MARK:- local variable
    var isCardView = Bool()
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupCard()
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Manage Cards", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        self.btnAddCard.isHidden = false
        self.viewCardInfo.isHidden = true
        
        if DeviceType.IS_IPHONE{
            self.nslcAddbtnWidth.isActive = true
        }
        else {
            self.nslcAddbtnWidth.isActive = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isCardView {
            if self.viewCardInfo.isHidden == true{
                self.viewCardInfo.isHidden = false
                self.btnAddCard.isHidden = true
            }
            else {
                self.viewCardInfo.isHidden = true
                self.btnAddCard.isHidden = false
            }
        }
    }
    
    //MARK:- Support Method
    func SetupCard(){
        lbl1.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lbl2.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lbl3.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblNumber.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblCardhilder.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        lblCardName.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        lblExpiry.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        lblDate.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        lblCardHolderName.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        if DeviceType.IS_IPHONE{
            btnAddCard.layer.cornerRadius = 5
            btnAddNewCardTop.constant = 80
            objCardWidth.isActive = true
            objCardleading.constant = 10
        }
        else{
            btnAddCard.layer.cornerRadius = 10
            btnAddNewCardTop.constant = 120
            objCardWidth.isActive = false
            objCardleading.constant = 20
        }
    }
    
    //MARK:- btn Click
    @IBAction func btnAddCardClick(_ sender: Any) {
        self.isCardView = true
        let objNext = AddNewCardVC.instantiate(fromAppStoryboard: .Settings)
        self.navigationController?.pushViewController(objNext, animated: true)
        //        if self.viewCardInfo.isHidden == true{
        //            self.viewCardInfo.isHidden = false
        //            self.btnAddCard.isHidden = true
        //        }
        //        else {
        //            self.viewCardInfo.isHidden = true
        //            self.btnAddCard.isHidden = false
        //        }
    }
    
    @IBAction func btnAddDeleteClick(_ sender: UIButton) {
        if sender.tag == 1 {
            let alert = UIAlertController(title: APP_NAME, message: ScreenText.DeleteCard, preferredStyle: .alert)
            alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: {action in
                self.btnAddCard.isHidden = false
                self.viewCardInfo.isHidden = true
            })
            alert.addAction(btnOK)
            let cancelAction = UIAlertAction(title: Messages.CANCEL, style: .cancel) {
                UIAlertAction in
                // It will dismiss action sheet
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let objNext = AddNewCardVC.instantiate(fromAppStoryboard: .Settings)
            self.navigationController?.pushViewController(objNext, animated: true)
        }
    }
    
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
