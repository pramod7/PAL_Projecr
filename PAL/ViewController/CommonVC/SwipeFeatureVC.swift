//
//  SwipeFeatureVC.swift
//  PAL
//
//  Created by i-Verve on 05/11/20.
//

import UIKit
import SDWebImage
class SwipeFeatureVC: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Outlet variable
    @IBOutlet var pageControll: UIPageControl!{
        didSet{
            pageControll.subviews.forEach {
                if DeviceType.IS_IPAD{
                    $0.transform = CGAffineTransform(scaleX: 2, y: 2)
                }
                else{
                    $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }
            }
        }
    }
    @IBOutlet var objCollectionView: UICollectionView!
    @IBOutlet var lblFeatureName: UILabel!{
        didSet{
            lblFeatureName.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    @IBOutlet var imgArrowSkip: UIImageView!
    @IBOutlet var imgArrowNext: UIImageView!
    @IBOutlet weak var btnskip: UIButton!{
        didSet{
            btnskip.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 17)
        }
    }
    @IBOutlet weak var btnNext: UIButton!{
        didSet{
            btnNext.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 17)
        }
    }
    
    @IBOutlet weak var nslcSkipImgHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcNextImgHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcNextbtnHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcNextbtnBottomSpace: NSLayoutConstraint!
    
    //MARK: - btn Click
    @IBAction func btnSkipClick(_ sender: UIButton) {
        Singleton.shared.save(object: true, key: LocalKeys.isFeature)
        
        let nextVC = LoginVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        if sender.titleLabel?.text == "FINISH"{
            Singleton.shared.save(object: true, key: LocalKeys.isFeature)
            
            let nextVC = LoginVC.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else{
            if self.currentIndex < 3 {
                print("Height : \(UIApplication.shared.statusBarFrame.size.height)")
                print("Height : \(self.navigationController?.navigationBar.frame.height ?? 0.0)")

                let pageSize = self.view.bounds.size
                let contentOffset = CGPoint(x: Int(pageSize.width) * (self.currentIndex+1), y: 0)
                self.objCollectionView.setContentOffset(contentOffset, animated: true)
                if self.currentIndex == 0{
                    self.lblFeatureName.text = "Setup Student Profile"
                }
                else if self.currentIndex == 1{
                    self.lblFeatureName.text = "Report Card"
                }
                else if self.currentIndex == 2{
                    self.lblFeatureName.text = "Certificate"
                }
                self.currentIndex = self.currentIndex+1
                if self.currentIndex == 3{
                    self.btnNext.setTitle("FINISH", for: .normal)
                }
                
                if (0.0 != fmodf(Float(self.currentIndex), 1.0)){
                    self.pageControll.currentPage = self.currentIndex + 1
                }
                else{
                    self.pageControll.currentPage = self.currentIndex
                }
            }
            else{
                print("Crash point")
            }
        }
    }
    
    //MARK: - Local variable
    var isFromSetting = Bool()
    var currentIndex = Int()
    var arrImgName = ["img_Dashboard","img_SetupStudentProfile","img_ReportCard","img_certificate"]
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width:ScreenSize.SCREEN_WIDTH , height: ScreenSize.SCREEN_HEIGHT)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.minimumInteritemSpacing = 0
        _flowLayout.minimumLineSpacing = 0
        return _flowLayout
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nav = self.navigationController{

            if self.isFromSetting {
                nonTransparentNav(nav: nav)
                
                let titleLabel = UILabel()
                titleLabel.navTitle(strText: "Features", titleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                self.navigationItem.titleView = titleLabel
                
                let btnBack: UIButton = UIButton()
                btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
                btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
                btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
                
                self.btnNext.isHidden = true
                self.btnskip.isHidden = true
                self.imgArrowNext.isHidden = true
                self.imgArrowSkip.isHidden = true
                
                self.nslcNextbtnHeight.constant = 0
                self.nslcNextbtnBottomSpace.constant = 0
            }
            else{
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
        self.lblFeatureName.text = "Dashboard"
        self.objCollectionView.collectionViewLayout = flowLayout
//        self.objCollectionView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        self.tabBarController?.tabBar.isHidden = true
        if DeviceType.IS_IPHONE{
            self.nslcSkipImgHeight.constant = 20
            self.nslcNextImgHeight.constant = 20
        }
        else{
            self.nslcSkipImgHeight.constant = 25
            self.nslcNextImgHeight.constant = 25
        }        
    }
            
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
        
    //MARK: - Collection delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCell", for: indexPath) as! FeatureCell
        
        cell.imgFeature.image = UIImage(named: self.arrImgName[indexPath.row])
        cell.imgFeature.contentMode = .scaleAspectFill
        return cell
    }
    
    //MARK: - btn Click
    @objc func btnBackClick() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
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
        self.currentIndex = previousPage

        if self.currentIndex == 0{
            self.lblFeatureName.text = "Dashboard"
            pageControll.currentPageIndicatorTintColor = UIColor(named: "Color_morelightSky")
        }
        else if self.currentIndex == 1{
            self.lblFeatureName.text = "Setup Student Profile"
            pageControll.currentPageIndicatorTintColor = UIColor.hexStringToUIColor("#70A6A8")
        }
        else if self.currentIndex == 2{
            self.lblFeatureName.text = "Report Card"
            pageControll.currentPageIndicatorTintColor = UIColor(named: "Color_appTheme")
        }
        if self.currentIndex == 3{
            self.lblFeatureName.text = "Certificate"
            pageControll.currentPageIndicatorTintColor = UIColor(named: "Color_lightSky")
            self.btnNext.setTitle("FINISH", for: .normal)
        }
        else{
            self.btnNext.setTitle("NEXT", for: .normal)
        }
        if (0.0 != fmodf(Float(page), 1.0)){
            self.pageControll.currentPage = page + 1
        }
        else{
            self.pageControll.currentPage = page
        }
    }
}
