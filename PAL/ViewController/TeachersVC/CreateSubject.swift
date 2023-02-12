//
//  CreateSubject.swift
//  PAL
//
//  Created by i-Phone7 on 25/11/20.
//

import UIKit
import KTCenterFlowLayout

class CreateSubject: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- Outlet variable
    @IBOutlet weak var tblCreateSubList: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
//            collectionView.backgroundColor = .red
            if let layout = collectionView.collectionViewLayout as? KTCenterFlowLayout {
                layout.minimumInteritemSpacing = 10
                layout.minimumLineSpacing = 10
            }
        }
    }
    @IBOutlet weak var cellSubject: UITableViewCell!
    @IBOutlet weak var cellSubCategory: UITableViewCell!
    @IBOutlet weak var cellSubCategoryItem: UITableViewCell!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblAddSubCategory: UILabel!
    @IBOutlet weak var txtSubject: PALTextField!
    @IBOutlet weak var txtVerb: PALTextField!
    @IBOutlet weak var btnAddSubject: UIButton!
    @IBOutlet weak var btnAdd: UIButton!{
        didSet{
            btnAdd.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
            btnAdd.layer.cornerRadius = 22.5
        }
    }
    
    
    //MARK:- btn Click
    @IBAction func btnAddSubjectClick(_ sender: Any) {
//        self.validateField()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        if (self.txtVerb.text?.isBlank)!{
            showAlertWithFocus(message: "Please enter Category Name.", txtFeilds: self.txtVerb, inView: self)
        }
//        else if ((self.txtVerb.text?.trim.count)! < 2){
//            showAlertWithFocus(message: Validation.subjectNameError, txtFeilds: self.txtVerb, inView: self)
//        }
        else{
            if !self.arrSubCategory.contains(self.txtVerb.text!.trim){
                self.arrSubCategory.append(self.txtVerb.text!.trim)
                self.txtVerb.text = ""
                self.collectionView.reloadData()
                self.tblCreateSubList.reloadData()
            }
            else {
                showAlert(title: APP_NAME, message: "Category name already added.")
            }
        }
    }
    
    //MARK:- local variable
    var arrSubCategory = [String]()
    var referencelabel = UILabel()
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Create Subject", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            //self.navigationItem.setHidesBackButton(true, animated: true)
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        self.setFont()
    }
    
    //MARK:- Support Method
    func setFont()  {
        self.lblSubject.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblAddSubCategory.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        
        self.txtSubject.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        self.txtVerb.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        
        self.btnAddSubject.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.btnAddSubject.layer.cornerRadius = 5
    }
    
    
    func validateField() {
        if (self.txtSubject.text?.isBlank)!{
            showAlertWithFocus(message: Validation.subjectName, txtFeilds: self.txtSubject, inView: self)
        }
        else if ((self.txtSubject.text?.trim.count)! < 2){
            showAlertWithFocus(message: Validation.subjectNameError, txtFeilds: self.txtSubject, inView: self)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func removeCategory(index: Int) {
        if let index = self.arrSubCategory.firstIndex(of: self.arrSubCategory[index]) {
            self.arrSubCategory.remove(at: index)
            self.collectionView.reloadData()
            self.tblCreateSubList.reloadData()
        }
        else {
            print("Not Found")
        }
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellSubject
        case 1:
            return cellSubCategory
        default:
//            cellSubCategoryItem.backgroundColor = .yellow
            return cellSubCategoryItem
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(collectionView.collectionViewLayout.collectionViewContentSize.height)
        return (indexPath.row == 2) ? (collectionView.collectionViewLayout.collectionViewContentSize.height + 25) : 150
    }
    
    //MARK:- collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSubCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddSubCategoryCell", for: indexPath) as! AddSubCategoryCell
        cell.lblCategoryName.text = arrSubCategory[indexPath.item]
        cell.btnRemoveCategoryCompletion = {
            self.removeCategory(index: indexPath.row)
        }
        cell.lblCategoryName.backgroundColor = .clear
        cell.backgroundColor = .clear
//        if indexPath.row % 2 == 0 {
//            cell.backgroundColor = .red
//        }
//        else {
//            cell.backgroundColor = .cyan
//        }
//        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.referencelabel.text = self.arrSubCategory[indexPath.item]
        self.referencelabel.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        let size = referencelabel.intrinsicContentSize
        
        if referencelabel.text?.count ?? 0 <= 5 {
            return CGSize.init(width: size.width + 90, height: size.height + 15)
        }else if (referencelabel.text?.count)! > 5 && (referencelabel.text?.count)! <= 10 {
            return CGSize.init(width: size.width + 75, height: size.height + 15)
        }else {
            return CGSize.init(width: size.width + 55, height: size.height + 15)
        }
    }
        
    //MARK:- txt delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- btn Click
    @objc func btnBackClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
