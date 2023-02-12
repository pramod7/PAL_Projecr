//
//  UpdatedWorkbbokViewController.swift
//  PAL
//
//  Created by Akshay Shah on 09/01/22.
//

import UIKit
import SDWebImage
import AVFoundation
import Alamofire
import SVProgressHUD
import SwiftyJSON

class UpdatedWorkbbokViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //MARK: - Outlet
    @IBOutlet var objCollectionView: UICollectionView!
    
    //MARK: - Local
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width:  view.frame.width, height: view.frame.height)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.minimumInteritemSpacing = 0
        _flowLayout.minimumLineSpacing = 0
        return _flowLayout
    }
    var barSaveWorksheet = UIBarButtonItem()
    var barJumpToPage = UIBarButtonItem()
    var barPlus = UIBarButtonItem()
    var btnSerach: UIButton = UIButton()
    var imgBackground = UIImage()
    var arrImgstr = [String]()
    var WorkbookId = 0
    var workbookPageId = 0
    var arrworkbook = [workbookDataModel]()
    var isFromLast = false
    var arrCount = [String]()
    var count = 0
    var currentIndex = 0
    var SelctedIndex = 0
    var currentCollectionIndex = 0
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.APICallgetWorkbook()
        self.objCollectionView.collectionViewLayout = flowLayout
        
        if let nav = self.navigationController {
            if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
                , colorName.trim.count > 0{
                nav.navigationBar.barTintColor = UIColor.hexStringToUIColor(colorName)
            }
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Workbook", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            
            let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20))
            let imgTemp1 = UIButton(frame: iconSize)
            imgTemp1.imageView?.contentMode = .scaleAspectFit
            let imgTemp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgTemp.image = UIImage(named: "Icon_Add New Card")
            imgTemp1.addSubview(imgTemp)
            imgTemp1.addTarget(self, action: #selector(btnNotificationClick), for: .touchUpInside)
            barPlus = UIBarButtonItem(customView: imgTemp1)
            
            btnSerach = UIButton(frame: iconSize)
            let imgTemp2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgTemp2.image = UIImage(named: "Selection")
            btnSerach.addSubview(imgTemp2)
            btnSerach.addTarget(self, action: #selector(btnJumpClick), for: .touchUpInside)
            barJumpToPage = UIBarButtonItem(customView: btnSerach)
            
            let iconSize2 = CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20))
            let imgTemp3 = UIButton(frame: iconSize2)
            imgTemp3.imageView?.contentMode = .scaleAspectFit
            let imgTemp33 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgTemp33.image = UIImage(named: "Icon_SaveWorksheet")
            imgTemp3.addSubview(imgTemp33)
            imgTemp3.addTarget(self, action: #selector(btnNotificationClick), for: .touchUpInside)
            barSaveWorksheet = UIBarButtonItem(customView: imgTemp3)
        }
        self.objCollectionView.showsHorizontalScrollIndicator = false
        self.objCollectionView.showsVerticalScrollIndicator = false
    }
    
    
    //MARK: - Button Click
    @objc func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnNotificationClick(_ sender: Any) {
        
        let objNext = StudentNewPageVC.instantiate(fromAppStoryboard: .Student)
        objNext.dismissStudent = { (count,index,img) in
            DispatchQueue.main.async {
                self.isFromLast = true
                let UpdatedEdit = UpdatedEditWorkbookViewController.instantiate(fromAppStoryboard: .Student)
                UpdatedEdit.imgBackground = img
                UpdatedEdit.workbookPageId = 0
                UpdatedEdit.WorkbookId = self.WorkbookId
                UpdatedEdit.dismissimg = { (objWorkbook) in
                    DispatchQueue.main.async {
                        self.arrworkbook.append(objWorkbook)
                        self.objCollectionView.reloadData()
//                        let delayTime = DispatchTime.now() + 1.0
//                        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
//                            self.objCollectionView.scrollToItem(at:IndexPath(item: self.arrworkbook.count - 1, section: 0), at: .left, animated: false)
//                        })
                    }
                }
                self.navigationController?.pushViewController(UpdatedEdit, animated: true)
            }
        }
        self.present(objNext, animated: true, completion: nil)
    }
    
    
    @objc func btnJumpClick(_ sender: Any) {
        if arrworkbook.count > 1 {
            count = 0
            arrCount.removeAll()
            for _ in 0...arrworkbook.count - 1{
                count = count + 1
                arrCount.append("\(count)")
                print(arrCount.count)
            }
            let nextVC = Size_ColorSelectionVC.instantiate(fromAppStoryboard: .Student)
            nextVC.isFromSize = false
            nextVC.isfromSelection = true
            nextVC.SelctedIndex = SelctedIndex
            nextVC.arrcount = arrCount
            nextVC.dismisssSize = { (count) in
                DispatchQueue.main.async { [self] in
                    self.SelctedIndex = count - 1
                    if self.currentIndex < self.arrCount.count {
                        let pageSize = self.view.bounds.size
                        let contentOffset = CGPoint(x: Int(pageSize.width) * (count-1), y: 0)
                        self.objCollectionView.setContentOffset(contentOffset, animated: true)
                        self.currentIndex = count-1
                        if (self.SelctedIndex == self.arrworkbook.count - 1 ) { //it's your last cell
                            //Show jump to page button only when there are more than one images
                            //Show save worksheet button only when worksheet is in edit mode
                            print("lastindex")
                            self.navigationItem.rightBarButtonItems = [self.barJumpToPage, self.barPlus]
                        }else{
                            self.navigationItem.rightBarButtonItems = [self.barJumpToPage]
                        }
                    }
                    else{
                        print("Crash point")
                    }
                }
            }
            let nav = UINavigationController(rootViewController: nextVC)
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                var int = arrCount.count
                if arrCount.count > 10 {
                    int = 10
                }
                nextVC.preferredContentSize = CGSize(width: 80,height: int*50 + 40)
                popover.permittedArrowDirections = .up
                popover.sourceView = self.btnSerach
                popover.sourceRect = self.btnSerach.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? UpdatedEditWorkbookViewController {
            detail.imgBackground = imgBackground
            detail.workbookPageId = self.workbookPageId
            detail.WorkbookId = WorkbookId
            detail.dismissimg = { (objWorkbook) in
                DispatchQueue.main.async {
                    self.arrworkbook[self.currentCollectionIndex].workbookImageUrl = objWorkbook.workbookImageUrl
                    
                    self.objCollectionView.reloadData()
//                    let delayTime = DispatchTime.now() + 1.0
//                    DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
//                        self.APICallgetWorkbook()
//                    })
                }
            }
        }
    }
    
    // MARK: - API call
    func APICallgetWorkbook(){
        var params: [String: Any] = [ : ]
        params["studentId"] = Preferance.user.userId
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getWorkbook, showLoader: true, vc: self) { (jsonData, error) in
            
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        self.arrworkbook.removeAll()
                        let id = jsonData?["workbookId"].int
                        self.WorkbookId = id ?? 0
                        if let linkTeacher = userData.workbookData {
                            self.arrworkbook = linkTeacher
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if Preferance.user.workbookId == 0{
                            Preferance.user.workbookId = self.WorkbookId
                            Singleton.shared.save(object: Preferance.user.toJSON(), key: UserDefaultsKeys.userData)
                        }
                        if (self.currentCollectionIndex == self.arrworkbook.count - 1 ) {
                            self.navigationItem.rightBarButtonItems = [self.barJumpToPage, self.barPlus]
                        }
                        else{
                            self.navigationItem.rightBarButtonItems = [self.barJumpToPage]
                        }
                        if self.arrworkbook.count > 0{
                            self.objCollectionView.backgroundView = nil
                        }
                        else{
                            let lbl = UILabel.init(frame: self.objCollectionView.frame)
                            lbl.text = "No workbook(s) found"
                            lbl.textAlignment = .center
                            lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
                            self.objCollectionView.backgroundView = lbl
                        }
                        self.objCollectionView.reloadData()
                        if self.arrworkbook.count > 1
                        {
                            self.navigationItem.rightBarButtonItems = [self.barJumpToPage, self.barPlus]
                        }else{
                            self.navigationItem.rightBarButtonItems = [self.barPlus]
                        }
                        let pageSize = self.view.bounds.size
                        let contentOffset = CGPoint(x: Int(pageSize.width) * (self.arrworkbook.count - 1), y: 0)
                        self.objCollectionView.setContentOffset(contentOffset, animated: true)
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
    
    // MARK: - CollectionView delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrworkbook.count > 0{
            return self.arrworkbook.count
        }
        else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if arrworkbook.count > 0{
            let cell = objCollectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCollectionViewCell", for: indexPath) as! ThumbnailCollectionViewCell
            var photourl = String()
            photourl = self.arrworkbook[indexPath.row].workbookImageUrl ?? ""
            if photourl.textlength > 0{
                cell.imageView.imageFromURL(photourl, placeHolder: imgWorksheetPlaceholder)
            }
            cell.imageView.contentMode = .scaleAspectFit
            cell.imageView.backgroundColor = .white
            return cell
        }
        else{
            let cell = objCollectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCollectionViewCell", for: indexPath) as! ThumbnailCollectionViewCell
            
            cell.imageView.image = imgBackground
            cell.imageView.contentMode = .scaleAspectFit
            cell.imageView.backgroundColor = .white
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        workbookPageId = self.arrworkbook[indexPath.row].workbookPageId ?? 0
        if arrworkbook.count > 0{
            var photourl = String()
            photourl = self.arrworkbook[indexPath.row].workbookImageUrl ?? ""
            if photourl.textlength > 0{
                let img =  UIImageView()
                img.sd_setImage(with: URL(string: photourl), placeholderImage: UIImage(named: ""), options: .refreshCached)
                imgBackground = img.image ?? UIImage()
            }
            self.performSegue(withIdentifier: "isWorkbooks", sender: nil)
        }
        else{
            // imgBackground = imgBackground
            self.performSegue(withIdentifier: "isWorkbooks", sender: nil)
        }
    }
    
    //MARK: - scrollView delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        var previousPage: Int = 0
        let pageWidth: CGFloat = scrollView.frame.size.width
        let fractionalPage = Float(scrollView.contentOffset.x / pageWidth)
        let page: Int = lround(Double(fractionalPage))
        if previousPage != page {
            previousPage = page
        }
        print("CurrentPage : \(previousPage)")
        self.currentCollectionIndex = previousPage
        if (previousPage == self.arrworkbook.count - 1 ) { //it's your last cell
            //Show jump to page button only when there are more than one images
            //Show save worksheet button only when worksheet is in edit mode
            print("lastindex")
            self.navigationItem.rightBarButtonItems = [self.barJumpToPage, self.barPlus]
        }
        else{
            self.navigationItem.rightBarButtonItems = [self.barJumpToPage]
        }
    }
}
