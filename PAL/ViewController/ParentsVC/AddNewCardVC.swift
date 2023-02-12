//
//  AddNewCardVC.swift
//  PAL
//
//  Created by i-Verve on 21/11/20.
//

import UIKit

class AddNewCardVC: UIViewController {
    
    //MARK:- Outlet variable
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblCardhilder: UILabel!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var lblExpiry: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCardHolderName: UILabel!

    @IBOutlet weak var lblBottomCardHolderName: UILabel!
    @IBOutlet weak var txtHolderName: UITextField!
    @IBOutlet weak var lblVisa: UILabel!
    
    @IBOutlet weak var txtNumberOne: UITextField!
    @IBOutlet weak var txtNumberTwo: UITextField!
    @IBOutlet weak var txtnumberThree: UITextField!
    @IBOutlet weak var txtForth: UITextField!
    
    @IBOutlet weak var lblBottomexpiryDate: UILabel!
    @IBOutlet weak var txtDateOne: UITextField!
    @IBOutlet weak var txtDateTwo: UITextField!
    
    @IBOutlet weak var lblCVV: UILabel!
    @IBOutlet weak var txtnumberCvv: UITextField!
    
    @IBOutlet weak var btnSaveCard: UIButton!
    @IBOutlet weak var SatckFirst: UIStackView!
    @IBOutlet weak var StackSecond: UIStackView!
    
    @IBOutlet weak var objCardWidth:NSLayoutConstraint!
    @IBOutlet weak var objBottomViewWidth: NSLayoutConstraint!
    @IBOutlet weak var btnsaveTop: NSLayoutConstraint!
    @IBOutlet weak var objLeadingView: NSLayoutConstraint!
    @IBOutlet weak var lbCardHolderlinelTrilling: NSLayoutConstraint!
    @IBOutlet weak var lbDatelinelTrilling: NSLayoutConstraint!
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.SetupAddCard()
    }
    
    //MARK:- support method
    func SetupAddCard(){
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.AddNewCard, titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(BackClicked), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        lbl1.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lbl2.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lbl3.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblNumber.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblCardhilder.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        lblCardName.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        lblExpiry.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        lblDate.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        lblCardHolderName.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        
        lblBottomCardHolderName.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblVisa.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblBottomexpiryDate.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        lblCVV.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        
        txtNumberOne.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtNumberTwo.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtnumberThree.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtForth.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtDateOne.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtDateTwo.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtnumberCvv.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        txtHolderName.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.btnSaveCard.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        btnSaveCard.layer.cornerRadius = 5
        
        txtNumberOne.SetupTextfiledborder()
        txtNumberTwo.SetupTextfiledborder()
        txtnumberThree.SetupTextfiledborder()
        txtForth.SetupTextfiledborder()
        txtDateOne.SetupTextfiledborder()
        txtDateTwo.SetupTextfiledborder()
        txtnumberCvv.SetupTextfiledborder()
        
        if DeviceType.IS_IPHONE{
            objCardWidth.isActive = true
            objBottomViewWidth.isActive = true
            objLeadingView.isActive = true
            StackSecond.spacing = 10
            SatckFirst.spacing = 10
            btnsaveTop.constant = 50
            lbCardHolderlinelTrilling.constant = -10
            lbDatelinelTrilling.constant = -10
        }
        else{
            objCardWidth.isActive = false
            objBottomViewWidth.isActive = false
            objLeadingView.isActive = false
            StackSecond.spacing = 30
            SatckFirst.spacing = 30
            btnsaveTop.constant = 100
            lbCardHolderlinelTrilling.constant = -20
            lbDatelinelTrilling.constant = -20
        }
    }
    
    //MARK:- support Method
    func validateAllField() {
        let month = self.txtDateOne.text?.trim
        let intMonth = Int(month!)
        if (self.txtHolderName.text?.trim.count)! == 0 {
            showAlertWithFocus(message: Validation.CardHolder, txtFeilds: self.txtHolderName, inView: self)
        }
        else if (self.txtNumberOne.text?.trim.count)! < 4 {
            showAlertWithFocus(message: Validation.CardNumber, txtFeilds: self.txtNumberOne, inView: self)
        }
        else if (self.txtNumberTwo.text?.trim.count)! < 4 {
            showAlertWithFocus(message: Validation.CardNumber, txtFeilds: self.txtNumberTwo, inView: self)
        }
        else if (self.txtnumberThree.text?.trim.count)! < 4 {
            showAlertWithFocus(message: Validation.CardNumber, txtFeilds: self.txtnumberThree, inView: self)
        }
        else if (self.txtForth.text?.trim.count)! < 4 {
            showAlertWithFocus(message: Validation.CardNumber, txtFeilds: self.txtForth, inView: self)
        }
        else if month!.count < 2 {
            showAlertWithFocus(message: Validation.CardExpMonth, txtFeilds: self.txtDateOne, inView: self)
        }
        else if (intMonth! > 12) {
            showAlertWithFocus(message: Validation.CardExpMonthProper, txtFeilds: self.txtDateOne, inView: self)
        }
        else if (self.txtDateTwo.text?.trim.count)! < 4 {
            showAlertWithFocus(message: Validation.CardExpYear, txtFeilds: self.txtDateTwo, inView: self)
        }
        else if (self.txtnumberCvv.text?.trim.count)! < 2 {
            showAlertWithFocus(message: Validation.CardCVV, txtFeilds: self.txtnumberCvv, inView: self)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- btn click
    @objc func BackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        self.validateAllField()
    }
}

extension  UITextField{
    func SetupTextfiledborder(){
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.kAppThemeColor().cgColor
        self.layer.cornerRadius = 5
    }
}
