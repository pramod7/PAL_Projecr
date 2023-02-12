//
//  AddNewPageVC.swift
//  PAL
//
//  Created by i-Verve on 25/11/20.
//

import UIKit

class AddNewPageVC: UIViewController,UITextFieldDelegate,PageListDelegate {
   
    //MARK:- Outlet variable
    @IBOutlet weak var lblAddNewPage: UILabel!{
        didSet{
            self.lblAddNewPage.font = UIFont.Font_ProductSans_Bold(fontsize: 22)
        }
    }
    @IBOutlet weak var lblEnglish: UILabel!{
        didSet{
            self.lblEnglish.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
        }
    }
    @IBOutlet weak var lblPage: UILabel!{
        didSet{
            self.lblPage.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var txtSelectPage: PALTextField!{
        didSet{
            self.txtSelectPage.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var lblTopic: UILabel!{
        didSet{
            self.lblTopic.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var txtSelectTopic: PALTextField!{
        didSet{
            self.txtSelectTopic.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var btnAddPage: UIButton!{
        didSet{
            self.btnAddPage.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
            self.btnAddPage.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var viewNav: UIView!{
        didSet{
            let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor)
            viewNav.backgroundColor = UIColor(named: colorName as! String)
        }
    }
    
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.setHidesBackButton(true, animated: true)
//        let colorName = Singleton.shared.get(key: Keys.navColor)
//        viewNav.backgroundColor = UIColor(named: colorName as! String)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK:- Support Method

    
    //MARK:- btn Click
    @IBAction func btnAddPageClick(_ sender: Any) {
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- txtField delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtSelectPage{
            let nextVC = PageandTopiclistVC.instantiate(fromAppStoryboard: .PopOverStoryboard)
            nextVC.delegate = self
            nextVC.isfromsubject = false
            let nav = UINavigationController(rootViewController: nextVC)
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                nextVC.preferredContentSize = CGSize(width: 400,height: 360)
                popover.permittedArrowDirections = .up
                popover.sourceView = self.txtSelectPage
                popover.sourceRect = self.txtSelectPage.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
            return false
        }
        else if textField == self.txtSelectTopic{
            let nextVC = PageandTopiclistVC.instantiate(fromAppStoryboard: .PopOverStoryboard)
            nextVC.delegate = self
            nextVC.isfromsubject = false
            let nav = UINavigationController(rootViewController: nextVC)
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                nextVC.preferredContentSize = CGSize(width: 400,height: 360)
                popover.permittedArrowDirections = .up
                popover.sourceView = self.txtSelectTopic
                popover.sourceRect = self.txtSelectTopic.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    //MARK:- schoolList delegate
    func saveText(strText: NSString) {
        self.txtSelectPage.text = strText as String
    }
}
