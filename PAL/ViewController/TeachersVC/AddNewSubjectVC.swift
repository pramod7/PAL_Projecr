//
//  AddNewSubjectVC.swift
//  PAL
//
//  Created by i-Verve on 26/11/20.
//

import UIKit
import SDWebImage
import KTCenterFlowLayout

class AddNewSubjectVC: UIViewController,PageListDelegate,UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK:- Outlet variable
    @IBOutlet weak var objView: UIView!
    @IBOutlet weak var imgUplaod: UIImageView!
    @IBOutlet weak var imgSubject: UIImageView!
    @IBOutlet weak var lblUpload: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblSubcategory: UILabel!
    @IBOutlet weak var txtEnglish: PALTextField!{
        didSet{
            txtEnglish.autocapitalizationType = .words
        }
    }
    @IBOutlet weak var txtVerb: PALTextField!
    @IBOutlet weak var btnAssign: UIButton!
    @IBOutlet weak var btnAdd: UIButton!{
        didSet{
            btnAdd.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
            btnAdd.layer.cornerRadius = 20
        }
    }//KTCenterFlowLayout
    @IBOutlet weak var lblChooseColorofSubject: UILabel!
    @IBOutlet weak var lblSubCategoryStatic: UILabel!
    @IBOutlet weak var objCollection: UICollectionView!
    @IBOutlet weak var collectionCategoryView: UICollectionView!{
        didSet{
            //            if let layout = collectionCategoryView.collectionViewLayout as? KTCenterFlowLayout {
            //                layout.minimumInteritemSpacing = 5
            //                layout.minimumLineSpacing = 5
            //            }
        }
    }
    
    //MARK:- Local variable
    var imgCover = UIImage()
    var isEdit = Bool()
    var isImgChange = Bool()
    var selectedColor: Int = 9999
    var arrColorCode = [ColorListModel]()
    var selectedSubject = SubjectListModel()
    var arrSubCategory = [SubjectSubCategoryModel]()
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
        }
        txtEnglish.delegate = self
        txtVerb.delegate = self
        let titleLabel = UILabel()
        if isEdit {
            titleLabel.navTitle(strText: ScreenTitle.EditSubject, titleColor: .white)
            let btnEdit: UIButton = UIButton()
            btnEdit.setTitle("Delete", for: .normal)
            btnEdit.addTarget(self, action: #selector(btnDeleteClick), for: .touchUpInside)
            btnEdit.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
            btnEdit.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnEdit)
            
            self.txtEnglish.text = self.selectedSubject?.subjectName
            self.btnAssign.setTitle(ScreenTitle.EditSubject, for: .normal)
            
            if let coverPic =  self.selectedSubject?.subjectCover, coverPic.count > 0 {
                self.imgSubject.sd_setImage(with: URL(string: coverPic), placeholderImage: UIImage(named: Placeholder.subjectImg))
            }
            
            self.lblUpload.isHidden = true
            self.imgUplaod.isHidden = true
            
            if let arrTemp = self.selectedSubject?.subCategory, arrTemp.count > 0 {
                self.arrSubCategory = arrTemp
            }
        }
        else {
            titleLabel.navTitle(strText: ScreenTitle.AddNewSubj, titleColor: .white)
        }
        self.navigationItem.titleView = titleLabel
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(BackClicked), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.objView.addGestureRecognizer(tap)
        
        self.SetupaddNewSubject()
        
        self.APICallGetColor()
    }
    
    //MARK:- Support Method
    func SetupaddNewSubject(){
        self.objView.layer.borderWidth = 0.5
        self.objView.layer.borderColor = UIColor.black.cgColor
        self.lblUpload.font = UIFont.Font_ProductSans_Regular(fontsize: 8)
        self.lblSubject.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtEnglish.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.txtVerb.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblChooseColorofSubject.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.lblSubCategoryStatic.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        self.btnAssign.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        self.btnAssign.layer.cornerRadius = 5
    }
    
    //MARK:- gesture click
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let Camera = UIAlertAction(title: Messages.Camera, style: .default) {(action) in
            self.ImageFromCamera()
        }
        let Gallery = UIAlertAction(title: Messages.Gallary, style: .default) {(action) in
            self.ImageFromGallery()
        }
        let Cancel = UIAlertAction(title: Messages.CANCEL, style: .cancel, handler: nil)
        
        Camera.setValue(UIColor.darkGray, forKey: "titleTextColor")
        Gallery.setValue(UIColor.darkGray, forKey: "titleTextColor")
        
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(Cancel)
        if let popover = alert.popoverPresentationController {
            alert.preferredContentSize = CGSize(width: 400,height: 360)
            popover.permittedArrowDirections = .up
            popover.sourceView = self.imgSubject
            popover.sourceRect = self.imgSubject.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- btn Click
    @objc func buttonClicked(sender:UIButton) {
        self.objCollection.reloadData()
    }
    
    @objc func BackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnDeleteClick(_ sender: Any){
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure want to delete \(self.selectedSubject?.subjectName ?? "") Subject?", preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: {action in
            self.APICallDeleteSubject()
        })
        alert.addAction(btnOK)
        let cancelAction = UIAlertAction(title: Messages.CANCEL, style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnAssignClick(_ sender: Any) {
        
        if self.imgSubject.image == nil{
            showAlert(title: APP_NAME, message: Validation.subCover)
        }
        else if self.txtEnglish.text?.trim.count == 0{
            showAlertWithFocus(message: Validation.subjectName, txtFeilds: self.txtEnglish, inView: self)
        }
        else if (self.txtEnglish.text?.containsEmoji)!{
            showAlertWithFocus(message: Validation.firstnameEmoji, txtFeilds: self.txtEnglish, inView: self)
        }
        else if self.selectedColor == 9999{
            showAlert(title: APP_NAME, message: Validation.subClr)
        }
        else if self.arrSubCategory.count == 0{
            showAlertWithFocus(message: Validation.enterCategory, txtFeilds: self.txtVerb, inView: self)
        }
        else{
            self.APIAddEditSubject()
        }
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        if (self.txtVerb.text?.isBlank)!{
            showAlertWithFocus(message: Validation.enterCategory, txtFeilds: self.txtVerb, inView: self)
        }
        else{
            let arrTemp = self.arrSubCategory.filter { $0.subCategory!.localizedCaseInsensitiveContains(self.txtVerb.text!.trim) }
            if arrTemp.count > 0 {
                showAlert(title: APP_NAME, message: Validation.selectSubjectCatName)
            }
            else {
                var tempCat: [String: Any] = [ : ]
                tempCat["subCategory"] = self.txtVerb.text?.trim
                tempCat["subCategoryId"] = 0
                
                self.arrSubCategory.append(SubjectSubCategoryModel(JSON: tempCat)!)
                self.txtVerb.text = ""
                self.collectionCategoryView.reloadData()
            }
        }
    }
    
    //MARK:- txtfield delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        if textField == self.txtEnglish{
        //            let nextVC = PageandTopiclistVC.instantiate(fromAppStoryboard: .PopOverStoryboard)
        //            nextVC.delegate = self
        //            nextVC.isfromsubject = true
        //            let nav = UINavigationController(rootViewController: nextVC)
        //            nav.modalPresentationStyle = .popover
        //            if let popover = nav.popoverPresentationController {
        //                nextVC.preferredContentSize = CGSize(width: 400,height: 360)
        //                popover.permittedArrowDirections = .up
        //                popover.sourceView = self.txtEnglish
        //                popover.sourceRect = self.txtEnglish.bounds
        //            }
        //            self.present(nav, animated: true, completion: nil)
        //            self.view.endEditing(true)
        //            return false
        //        }
        return true
    }
    
    //MARK:- schoolList delegate
    func saveText(strText: NSString) {
        self.txtEnglish.text = strText as String
    }
    
    //MARK:- support method
    func ImageFromGallery() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(image , animated: true)
    }
    
    func ImageFromCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) == true {
            checkForCameraPermission { (isPermit) in
                DispatchQueue.main.async { // Correct
                if isPermit {
                        let image = UIImagePickerController()
                        image.delegate = self
                        image.sourceType = UIImagePickerController.SourceType.camera
                        self.present(image , animated: true)
                    }
                else{
                    cameraPermissionAlert(from: self, showCancel: true)
                }
            }
            }
        } else {
            print("Camera is not available..")
        }
    }
    
    func removeCategory(index: Int) {
        self.arrSubCategory.remove(at: index)
        self.collectionCategoryView.reloadData()
    }
    
    //MARK:- pickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            DispatchQueue.main.async {
                self.imgSubject.image = image
                self.isImgChange = true
                //                self.btnSubjectImg.setImage(image, for: .normal)
                //                let cropViewController = CropViewController(croppingStyle: .default, image: image)
                //                //                cropViewController.toolbar.resetButtonHidden = true
                //                cropViewController.toolbar.rotateClockwiseButtonHidden = true
                //                cropViewController.toolbar.rotateCounterclockwiseButtonHidden = true
                //                cropViewController.cropView.gridOverlayView.displayHorizontalGridLines = false
                //                cropViewController.cropView.gridOverlayView.displayVerticalGridLines = false
                //                cropViewController.toolbar.doneIconButton.setTitleColor(UIColor(named: "Color_AppTheme"), for: .normal)
                //                cropViewController.toolbar.cancelIconButton.setTitleColor(UIColor(named: "Color_AppTheme"), for: .normal)
                //                cropViewController.delegate = self
                //                cropViewController.aspectRatioLockEnabled = true
                //                self.present(cropViewController, animated: true, completion: nil)
            }
        }else{
            print("Error in Select Image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- collection delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.collectionCategoryView == collectionView) ? self.arrSubCategory.count : self.arrColorCode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.collectionCategoryView == collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddSubCategoryCell", for: indexPath) as! AddSubCategoryCell
            cell.lblCategoryName.text = self.arrSubCategory[indexPath.item].subCategory
            cell.btnRemoveCategoryCompletion = {
                self.removeCategory(index: indexPath.row)
            }
            cell.lblCategoryName.backgroundColor = .clear
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewsubjectCollectionViewCell", for: indexPath) as! AddNewsubjectCollectionViewCell
            let tempColor =  self.arrColorCode[indexPath.row]
            if let color = tempColor.subjectCoverColor, color.count > 0 {
                cell.ObjView.backgroundColor = UIColor.setColor(str: color)
                
                if self.selectedColor == indexPath.row{
                    cell.imgselect.isHidden = false
                }
                else{
                    cell.imgselect.isHidden = true
                }
            }
            cell.btnSelected.tag = indexPath.item
            cell.btnSelected.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.objCollection == collectionView{
            self.selectedColor = indexPath.row
            self.objCollection.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.collectionCategoryView == collectionView{
            let referencelabel = UILabel()
            referencelabel.text = self.arrSubCategory[indexPath.item].subCategory
            referencelabel.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
            let size = referencelabel.intrinsicContentSize
            
            if referencelabel.text?.count ?? 0 <= 5 {
                return CGSize.init(width: size.width + 50, height: size.height + 15)
            }
            else if (referencelabel.text?.count)! > 5 && (referencelabel.text?.count)! <= 10 {
                return CGSize.init(width: size.width + 60, height: size.height + 15)
            }
            else {
                return CGSize.init(width: size.width + 60, height: size.height + 15)
            }
        }
        else {
            return CGSize(width: 40, height: 60)
        }
    }
    
    //MARK:- API Call
    func APIAddEditSubject() {
        
        var arrSubCategory = [[String: Any]]()
        
        for subCat in self.arrSubCategory {
            var tempCat: [String: Any] = [ : ]
            tempCat["subCategory"] = subCat.subCategory
            tempCat["subCategoryId"] = "0"
            arrSubCategory.append(tempCat)
        }
        
        var params: [String: Any] = [ : ]
        if self.isEdit {
            params["subjectId"] = self.selectedSubject?.subjectId
        }
        else {
            params["subjectId"] = 0
        }
        params["subjectCoverColor"] = self.arrColorCode[self.selectedColor].subjectCoverColor
        params["subjectCover"] = self.imgSubject.image
        params["subjectName"] = self.txtEnglish.text?.trim
        params["data"] = arrSubCategory
        params["isPicChange"] = (self.isImgChange) ?1:0
        
        APIManager.shared.callPostWithMultiPartApi(reqURL: URLs.APIURL + getUserTye() + addSubject, parameters: params, showLoader: true) { (jsonData, error) in
            if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                if let status = userData.status, status == 1{
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    if let msg = jsonData?[APIKey.message].string {
                        showAlert(title: APP_NAME, message: msg)
                    }
                }
            }
        }
    }
    
    func APICallGetColor() {
        
        APIManager.shared.callGetApi(reqURL: URLs.APIURL + getUserTye() + getColorCode, showLoader: true) { (jsonData, error) in
            
            if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                if let status = userData.status, status == 1{
                    if let user = userData.colorList {
                        for temp in user {
                            self.arrColorCode.append(temp)
                        }
                        
                        if self.isEdit {
                            var index = Int()
                            for colorCode in self.arrColorCode {
                                if let color = self.selectedSubject?.subjectCoverColor, color.count > 0{
                                    if UIColor.setColor(str: color) == UIColor.setColor(str: colorCode.subjectCoverColor!) {
                                        self.selectedColor = index
                                        return
                                    }
                                    index = index + 1
                                }
                                self.objCollection.reloadData()
                            }
                        }
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                    self.objCollection.reloadData()
                }
                else{
                    if let msg = jsonData?[APIKey.message].string {
                        showAlert(title: APP_NAME, message: msg)
                    }
                }
            }
        }
    }
    
    func APICallDeleteSubject() {
        
        var params: [String: Any] = [ : ]
        params["subjectId"] = self.selectedSubject?.subjectId
        
        APIManager.shared.callPostApi(parameters: params ,reqURL: URLs.APIURL + getUserTye() + deleteSub, showLoader: true, vc:self) { (jsonData, error) in
            
            if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                if let status = userData.status, status == 1{
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    if let msg = jsonData?[APIKey.message].string {
                        showAlert(title: APP_NAME, message: msg)
                    }
                }
            }
        }
    }
}
extension AddNewSubjectVC:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
