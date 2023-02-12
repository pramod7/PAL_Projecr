//
//  WorksheetViewVC.swift
//  Planner
//
//  Created by Andrea Clare Lam on 05/01/2022.
//  Copyright © 2020 Andrea Clare Lam. All rights reserved.
//

import UIKit
import SDWebImage

class WorksheetViewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlet
    @IBOutlet weak var objCollection: UICollectionView!
    
    // MARK: - Local Variable
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width:  view.frame.width, height: view.frame.height)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.minimumInteritemSpacing = 0
        _flowLayout.minimumLineSpacing = 0
        return _flowLayout
    }
    
    var arrInstruction = [String]()
    var arrvoiceInstruction = [String]()
    var arrImages = [String]()
    var currentIndex = Int()
    var btnJump = UIButton()
    var btnInstruct = UIButton()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //APIManager.showLoader()
        self.objCollection.collectionViewLayout = flowLayout
        
        if let nav = self.navigationController {
            if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
                , colorName.trim.count > 0{
                nav.navigationBar.barTintColor = UIColor.hexStringToUIColor(colorName)
            }
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Worksheet View", titleColor: .white)
            self.navigationItem.titleView = titleLabel
        }
        self.rightNavItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Preferance.user.userType != 0{
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if Preferance.user.userType != 0{
            self.tabBarController?.tabBar.isHidden = false
        }
    }
        
    // MARK: - Other Method
    func rightNavItem(){
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        self.btnInstruct = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        btnInstruct.imageView?.contentMode = .scaleAspectFit
        let imgInstruct = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgInstruct.image = UIImage(named: "Icon_Instruction")
        self.btnInstruct.addSubview(imgInstruct)
        self.btnInstruct.addTarget(self, action: #selector(btnInstructionClick), for: .touchUpInside)
        let barInstruction = UIBarButtonItem(customView: self.btnInstruct)
                
        self.btnJump = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        let imgTemp2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgTemp2.image = UIImage(named: "Selection")
        self.btnJump.addSubview(imgTemp2)
        self.btnJump.addTarget(self, action: #selector(btnJumpToPageClick), for: .touchUpInside)
        let barJumpToPage = UIBarButtonItem(customView: self.btnJump)
        
        if self.arrImages.count > 1{
            self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]
        }
        else{
            self.navigationItem.rightBarButtonItems = [barInstruction]
        }
    }
    
    //MARK: - btn Click
    @objc func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnInstructionClick(_ sender: Any) {

//        if self.arrInstruction.count > 0 || self.arrvoiceInstruction.count > 0{
//        let nextVC = InstructionVC.instantiate(fromAppStoryboard: .Student)
//            nextVC.arrInstruction = self.arrInstruction
//            nextVC.arrvoiceInstruction = self.arrvoiceInstruction
//            nextVC.isFromStudent = false
//        let nav = UINavigationController(rootViewController: nextVC)
//        nav.modalPresentationStyle = .popover
//        if let popover = nav.popoverPresentationController {
//            let int = self.arrInstruction.count
//            if self.arrInstruction.count > 5
//            {
//                nextVC.preferredContentSize = CGSize(width: 250,height: 90 + 300)
//            }else{
//                nextVC.preferredContentSize = CGSize(width: 250,height: 90 + int*60)
//            }
//            popover.permittedArrowDirections = .up
//            popover.sourceView = self.btnInstruct
//            popover.sourceRect = self.btnInstruct.bounds
//        }
//        self.present(nav, animated: true, completion: nil)
//        self.view.endEditing(true)
//        }
//        else{
//            showAlert(title: APP_NAME, message: "Teacher had not added Instruction for this worksheet.")
//        }
        
        if self.arrInstruction.count > 0 || self.arrvoiceInstruction.count > 0{
            let objNext = InstructionVC.instantiate(fromAppStoryboard: .Student)
            
            objNext.isFromStudent = false
            objNext.arrInstruction = self.arrInstruction
            objNext.arrvoiceInstruction = self.arrvoiceInstruction
            objNext.modalPresentationStyle = UIModalPresentationStyle.automatic
            self.present(objNext, animated: true, completion: nil)
        }
        else{
            showAlert(title: APP_NAME, message: "Teacher had not added Instruction for this worksheet.")
        }
    }
    
    @objc func btnJumpToPageClick(_ sender: Any) {
        
        if self.arrImages.count  > 1 {
            var arrCount = [String]()
            var count = Int()
            for _ in 0...self.arrImages.count - 1{
                count = count + 1
                arrCount.append("\(count)")
            }
            
            let nextVC = Size_ColorSelectionVC.instantiate(fromAppStoryboard: .Student)
            nextVC.isFromSize = false
            nextVC.isfromSelection = true
            nextVC.SelctedIndex = currentIndex
            nextVC.arrcount = arrCount
            nextVC.dismisssSize = { (count) in
                DispatchQueue.main.async {
                    self.currentIndex = count - 1
                    if self.currentIndex < arrCount.count {
                        let pageSize = self.view.bounds.size
                        let contentOffset = CGPoint(x: Int(pageSize.width) * (count-1), y: 0)
                        self.objCollection.setContentOffset(contentOffset, animated: true)
                        self.currentIndex = count-1
                    }
                    else{
                        print("Crash point")
                    }
                }
            }
            let nav = UINavigationController(rootViewController: nextVC)
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                let int = arrCount.count
                nextVC.preferredContentSize = CGSize(width: 80,height: int*50)
                popover.permittedArrowDirections = .up
                popover.sourceView = self.btnJump
                popover.sourceRect = self.btnJump.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
        }
    }
    
    // MARK: - CollectionView delegate methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCollectionViewCell", for: indexPath) as! ThumbnailCollectionViewCell
//        cell.imageView.sd_setImage(with: URL(string: self.arrImages[indexPath.row]))
        cell.imageView.imageFromURL(self.arrImages[indexPath.row], placeHolder: imgWorksheetPlaceholder)
        cell.imageView.backgroundColor = .white
        return cell
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
        self.currentIndex = previousPage
    }
}
