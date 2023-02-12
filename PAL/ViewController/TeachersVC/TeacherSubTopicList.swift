//
//  TeacherSubTopicList.swift
//  PAL
//
//  Created by i-Verve on 24/11/20.
//

import UIKit

class TeacherSubTopicList: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlet variable
    @IBOutlet weak var objCollection: UICollectionView!
    @IBOutlet weak var lblNoSubjectFound: UILabel!{
        didSet{
            lblNoSubjectFound.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
        }
    }
    
    //MARK: - Local variable
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: (ScreenSize.SCREEN_WIDTH * 0.9) / 2.05 , height: ScreenSize.SCREEN_HEIGHT/5)
        _flowLayout.sectionInset = UIEdgeInsets(top: 30, left: (ScreenSize.SCREEN_WIDTH * 0.1)/2, bottom: 20, right: (ScreenSize.SCREEN_WIDTH * 0.1)/2)
        _flowLayout.scrollDirection = .vertical
        _flowLayout.minimumInteritemSpacing = 10
        _flowLayout.minimumLineSpacing = 10
        return _flowLayout
    }
    var strSubjectName = String()
    //    var arrTopicName = [String]()
    var arrSubjectSubList = [SubjectSubCategoryModel]()
    var subjectId = Int()
    var colour = String()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "\(self.strSubjectName)" + " - " + ScreenTitle.TopicList, titleColor: .white)
        
        self.navigationItem.titleView = titleLabel
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.objCollection.collectionViewLayout = flowLayout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: colour)
    }
    
    //MARK: - support method
    //    func setupTeacherSubject(){
    //        self.arrTopicName = ["Verb", "Noun", "Punctuation", "Spelling", "English"]
    //    }
    
    //MARK: - btn click event
    @objc func btnBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSubjectSubList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherSubjectCollectionViewCell", for: indexPath) as! TeacherSubjectCollectionViewCell
        
        if let strTemp = self.arrSubjectSubList[indexPath.row].subCategory {
            cell.lblSubjectname.text = strTemp
        }
        cell.imgSubject.image = UIImage(named: "Icon_writingSubject")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objNext = TeacherSubjectWorkSheetListVC.instantiate(fromAppStoryboard: .Teacher)
        if let temp = arrSubjectSubList[indexPath.row].subCategoryId{
            objNext.subcategoryid = temp
        }
        objNext.subjectId = self.subjectId
        objNext.colour = self.colour
        if let strTemp = self.arrSubjectSubList[indexPath.row].subCategory {
            objNext.strSubjectName = strTemp
        }
        self.navigationController?.pushViewController(objNext, animated: true)
    }
}

extension UIColor {
    
    convenience init(hexString: String) {
        
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (0, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
