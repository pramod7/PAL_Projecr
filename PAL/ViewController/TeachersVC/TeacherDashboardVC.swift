//
//  TeacherDashboardVC.swift
//  PAL
//
//  Created by i-Phone7 on 27/11/20.
//

import UIKit

//
class TeacherDashboardVC: UIViewController , UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: - Outlet variable
    @IBOutlet weak var tblDashboard: UITableView!
    
    @IBOutlet weak var lblSchool: UILabel!{
        didSet{
            lblSchool.font = UIFont.Font_ProductSans_Regular(fontsize: 20)
        }
    }
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = UIFont.Font_WorkSans_Bold(fontsize: 30)
        }
    }
    @IBOutlet weak var lblCode: UILabel!{
        didSet{
            lblCode.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
        }
    }
    @IBOutlet weak var lblNoData: UILabel!{
        didSet{
            lblNoData.font = UIFont.Font_ProductSans_Regular(fontsize: 20)
        }
    }
    @IBOutlet weak var cellUserInfo: UITableViewCell!
    @IBOutlet weak var cellSubject: UITableViewCell!
    
    @IBOutlet weak var collectionCharacteristics: UICollectionView!
    @IBOutlet weak var collectionSubject: UICollectionView!
    
    //MARK: - Local variable
    //    var flowLayout : UICollectionViewFlowLayout {
    //        print(ScreenSize.SCREEN_WIDTH)
    //        print((((ScreenSize.SCREEN_WIDTH - 70) * 0.98)-50) / 2)
    //        let _flowLayout = UICollectionViewFlowLayout()
    //        _flowLayout.itemSize = CGSize(width: (((ScreenSize.SCREEN_WIDTH * 0.95) * 0.98) - 35) / 2, height: 220)
    //        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
    //        _flowLayout.minimumInteritemSpacing = 30
    //        _flowLayout.minimumLineSpacing = 30 //between two item top bottom
    //        return _flowLayout
    //    }
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: (ScreenSize.SCREEN_WIDTH * 0.9) / 2.05 , height: ScreenSize.SCREEN_HEIGHT/5)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        _flowLayout.minimumInteritemSpacing = 10
        _flowLayout.minimumLineSpacing = 40
        return _flowLayout
    }
    //    var flowLayoutSubject : UICollectionViewFlowLayout {
    //        let _flowLayout = UICollectionViewFlowLayout()
    //        _flowLayout.itemSize = CGSize(width: ((ScreenSize.SCREEN_WIDTH * 0.98)) / 4 , height: 240)
    //        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
    //        _flowLayout.minimumInteritemSpacing = 0
    //        _flowLayout.minimumLineSpacing = 20
    //        return _flowLayout
    //    }
    
    var arrSubjectImg = [String]()
    var arrCategoryImg = [String]()
    var arrSubject = [String]()
    var arrCategory = [String]()
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.arrSubjectImg = ["Icon_subjectSubjectCat","Icon_studentCat", "Icon_CertificatesCateg","Icon_ReportCatg"]
        self.arrSubject = ["Reading","Spelling","Writing","Reading","Spelling","Writing"]
        self.arrCategoryImg = ["Icon_readingSubject","Icon_spellingSubject", "Icon_writingSubject", "Icon_readingSubject","Icon_spellingSubject", "Icon_writingSubject"]
        self.arrCategory = ["Subject","Student","Certificates","Report Cards"]
        self.lblName.text = "\(Preferance.user.firstName ?? "") \(Preferance.user.lastName ?? "")"
        self.lblSchool.text = Preferance.user.schoolName
        self.lblCode.text = Preferance.user.teacher_Id
        self.collectionCharacteristics.isScrollEnabled = false
        self.collectionCharacteristics.collectionViewLayout = flowLayout
        //self.collectionSubject.collectionViewLayout = flowLayoutSubject
        //self.tblDashboard.register(UINib(nibName: "StaticTextCell", bundle: nil), forCellReuseIdentifier: "StaticTextCell")
        //self.navButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NoInterNet"), object: nil)
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 2 // Start on Monday (or 1 for Sunday)
        let today = calendar.startOfDay(for: Date())
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController{
            transparentNav(nav: nav)
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disableSwipeToPop()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Support method
    @objc func methodOfReceivedNotification(notification: Notification) {
       
    }
    
    func ViewAllClick()  {
        
    }
    
    func navButton() {
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        let iconButton = UIButton(frame: iconSize)
        iconButton.imageView?.contentMode = .scaleAspectFill
        iconButton.setImage(UIImage(named: "Icon_download"), for: .normal)
        let barButton = UIBarButtonItem(customView: iconButton)
        iconButton.addTarget(self, action: #selector(btnDownload), for: .touchUpInside)
        
        let iconDownloadButton = UIButton(frame: iconSize)
        iconDownloadButton.imageView?.contentMode = .scaleAspectFill
        iconDownloadButton.setImage(UIImage(named: "Icon_search"), for: .normal)
        let barDownlaodButton = UIBarButtonItem(customView: iconDownloadButton)
        iconDownloadButton.addTarget(self, action: #selector(btnSearchClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [barDownlaodButton, barButton]
    }
    
    //MARK: - Button Clicked
    @objc func btnDownload() {
        
    }
    
    @objc func btnSearchClick() {
        //        navigationItem.titleView = nil
        //        if self.isIconSearchClick {
        //            self.isIconSearchClick = false
        //            self.screenTitle()
        //        }
        //        else {
        //            self.isIconSearchClick = true
        //            let searchBar = UISearchBar()
        //            searchBar.placeholder = "Search"
        //            searchBar.tintColor = UIColor(named: "Color_appTheme")
        //            searchBar.delegate = self
        //            searchBar.searchBarStyle = .minimal
        //            searchBar.sizeToFit()
        //            self.navigationItem.titleView = searchBar
        //        }
    }
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                //cellUserInfo.backgroundColor = .cyan
                return cellUserInfo
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StaticTextCell", for: indexPath) as! StaticTextCell
                cell.lblName.text = "Subject"
                cell.btnActionArrow.isHidden = true
                cell.btnAction.setTitle("View All", for: .normal)
                cell.btnAction.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
                cell.btnAction.setTitleColor(UIColor(named: "Color_morelightSky")!, for: .normal)
                cell.btnSeeAllCompletion = {
                    self.ViewAllClick()
                }
                //cell.backgroundColor = .red
                return cell
            default:
                //cellSubject.backgroundColor = .magenta
                return cellSubject
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return ((ScreenSize.SCREEN_HEIGHT/5)*2) + 240 + 30 + 10
            case 1:
                return 60
            default:
                return 270
        }
    }
    
    //MARK: - collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == self.collectionCharacteristics) ? self.arrCategory.count : self.arrSubject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionCharacteristics{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherSubjectCollectionViewCell", for: indexPath) as! TeacherSubjectCollectionViewCell
            
            cell.lblSubjectname.text = self.arrCategory[indexPath.row]
            cell.imgSubject.image = UIImage(named: self.arrSubjectImg[indexPath.row])
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherDashboardSubjectCell", for: indexPath) as! TeacherDashboardSubjectCell
            cell.lblName.text = self.arrSubject[indexPath.row]
            cell.imgSubjects.image = UIImage(named: self.arrCategoryImg[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionCharacteristics {
            switch indexPath.row {
                case 0:
                    let objNext = TeacherSubjectListVC.instantiate(fromAppStoryboard: .Teacher)
                    self.navigationController?.pushViewController(objNext, animated: true)
                case 1:
                    let objNext = StudentListVC.instantiate(fromAppStoryboard: .Teacher)
                    self.navigationController?.pushViewController(objNext, animated: true)
                case 2:
                    let objNext = CertificateTypeVC.instantiate(fromAppStoryboard: .Teacher)
                    objNext.isFromStudentProfile = false
                    self.navigationController?.pushViewController(objNext, animated: true)
                default:
                    let objNext = AddProgressReport.instantiate(fromAppStoryboard: .Teacher)
                    objNext.isProgress = true
                    self.navigationController?.pushViewController(objNext, animated: true)
            }
        }
        else {
            print("Subject: \(indexPath.row)")
        }
    }
}

extension TeacherDashboardVC:UIGestureRecognizerDelegate {
    func disableSwipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self == self.navigationController?.topViewController ? false : true
    }
}
