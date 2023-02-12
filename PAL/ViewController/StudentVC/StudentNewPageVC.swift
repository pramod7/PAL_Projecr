//
//  StudentNewPageVC.swift
//  PAL
//
//  Created by i-Verve on 03/12/20.
//

import UIKit
//@available(iOS 13.0, *)
class StudentNewPageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlet variable
    @IBOutlet weak var objCollection: UICollectionView!
    
    // MARK: - Local variable
    
    var arrType = ["Example 1","Example 2","Example 3","Example 4","Example 5","Example 6","Example 7","Example 8","Example 9"]
    var arrimg = ["Example 1", "Example 2", "Example 3", "Example 4", "Example 5", "Example 6", "Example 7", "Example 8", "Example 9"]
    var uniqID = 000
    var dismissStudent : ((Int,Int,UIImage) -> Void)?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController{
            // nonTransparentNav(nav: nav)
            if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
                , colorName.trim.count > 0{
                nav.navigationBar.barTintColor = UIColor.hexStringToUIColor(colorName)
            }
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "New Page", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(BackClicked), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            // self.objCollection.collectionViewLayout = flowLayout
        }
    }
    
    // MARK: - btn Click
    @objc func BackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudentNewPageCell", for: indexPath) as! StudentNewPageCell
        cell.lblData.text = arrType[indexPath.row]
        cell.imgview.image = UIImage(named: arrimg[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: (ScreenSize.SCREEN_WIDTH * 0.1)/2, bottom: 0, right: (ScreenSize.SCREEN_WIDTH * 0.1)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = uniqID + 1
        let indx = indexPath.row
        if let _ = self.dismissStudent{
            self.dismissStudent!(id,indx,UIImage(named: arrimg[indexPath.row]) ?? UIImage())
            print("dismissID",id)
            dismiss(animated: true, completion: nil)
        }
    }
}
