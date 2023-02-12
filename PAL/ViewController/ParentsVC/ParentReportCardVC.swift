//
//  ParentReportCardVC.swift
//  PAL
//
//  Created by i-Verve on 23/11/20.
//

import UIKit

class ParentReportCardVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //MARK:- Outlet variable
    @IBOutlet weak var objCollection: UICollectionView!{
        didSet{
//            objCollection.backgroundColor = .red
            objCollection.delegate = self
            objCollection.dataSource = self
        }
    }
    @IBOutlet weak var objtable: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblImg: UILabel!{
        didSet{
            lblImg.font = UIFont.Font_ProductSans_Bold(fontsize: 20)
            lblImg.textColor = .black
        }
    }
    @IBOutlet weak var lblname: UILabel!{
        didSet{
            lblname.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            lblname.textColor = .white
        }
    }
    
    //@IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionheight: NSLayoutConstraint!
    @IBOutlet weak var collectionBottomSpace: NSLayoutConstraint!
    
    //MARK:- local variable
    let width = (DeviceType.IS_IPHONE) ? (ScreenSize.SCREEN_HEIGHT * 0.2) * 0.45 : ((ScreenSize.SCREEN_HEIGHT * 0.2) * 0.5)
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width: width , height: width)
        _flowLayout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.minimumInteritemSpacing = (DeviceType.IS_IPHONE) ? 5 : 10
        _flowLayout.minimumLineSpacing = (DeviceType.IS_IPHONE) ? 10 : 20
        return _flowLayout
    }
    var arrReportList = [ReportCardListModel]()
    var arrSelectedStudent = [Int]()
    var childId = Int()
    var childFirstName = String()
    var childLastName = String()
    var reportDate = String()
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        if let childInfo = Preferance.user.childInfo,childInfo.count > 0{
            if self.childFirstName != childInfo[0].firstName{
                self.childFirstName = childInfo[0].firstName!
                self.childLastName = childInfo[0].lastName!
            }
        }
        if Preferance.user.userType == 1 {
            titleLabel.navTitle(strText: ScreenTitle.ProgressCard, titleColor: .white)
            self.imgView.isHidden = true
            self.lblImg.isHidden = true
            self.lblname.isHidden = true
           
        }
        else {
            titleLabel.navTitle(strText: ScreenTitle.ProgressCard, titleColor: .white)
            
//            let btnAddNewText = UIButton(type: .custom)
//            btnAddNewText.setTitle("Add new", for: .normal)
//            btnAddNewText.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
//            btnAddNewText.addTarget(self, action: #selector(btnAddNewPageClick), for: .touchUpInside)
//
//            let btnAddNewImg = UIButton(type: .custom)
//            btnAddNewImg.setImage(UIImage(named: "Icon_newPage"), for: .normal)
//            btnAddNewImg.addTarget(self, action: #selector(btnAddNewPageClick), for: .touchUpInside)
//
//            let barText = UIBarButtonItem(customView: btnAddNewText)
//            let barImg = UIBarButtonItem(customView: btnAddNewImg)
//            self.navigationItem.setRightBarButtonItems([barImg, barText], animated: true)
            
            self.objCollection.isHidden = true
            self.lblname.text = childFirstName
            self.lblImg.text = childFirstName.first?.uppercased()
            self.imgView.backgroundColor = .white
            self.imgView.layer.cornerRadius = ((ScreenSize.SCREEN_HEIGHT * 0.2) * 0.4) / 2
        }
        self.navigationItem.titleView = titleLabel
        //self.navigationItem.setHidesBackButton(true, animated: true)
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
                
        if DeviceType.IS_IPHONE{
           // self.topViewHeight.isActive = true
            self.collectionheight.isActive = true
            self.collectionBottomSpace.isActive = true
        }
        else {
            //self.topViewHeight.isActive = false
            self.collectionheight.isActive = false
            self.collectionBottomSpace.isActive = false
        }
        self.objCollection.collectionViewLayout = flowLayout
        
        if let childTemp = Preferance.user.childInfo, childTemp.count > 0{
            self.childId = childTemp[0].childId!
        }
        self.APICallGetReportList(isFromCollectionSelect: false, Index: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            transparentNav(nav: nav)
            
        }
    }
        
    //MARK:- btn Click
    
    @objc func btnBackClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnAddNewPageClick(_ sender: Any){
        let objnext = CreateSubject.instantiate(fromAppStoryboard: .Teacher)
        self.navigationController?.pushViewController(objnext, animated: true)
    }
   
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var strIdentifier = String()
        if DeviceType.IS_IPAD {
            strIdentifier = "ReportCardListTableViewCell_iPad"
        }
        else {
            strIdentifier = "ReportCardListTableViewCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier) as! ReportCardListTableViewCell
        
        cell.lblSubject.text = self.arrReportList[indexPath.row].subjectName
        cell.lblTotal.text = "Total Report \(self.arrReportList[indexPath.row].totalReport ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE{
            return 100
        }
        else{
            return  120 //UITableView.automaticDimension 
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ParentReportCardDetailsVC.instantiate(fromAppStoryboard: .ParentDashboard)
        nextVC.selectedStudent = self.arrReportList[indexPath.row]
        nextVC.childId = self.childId
        nextVC.isFromParent = true
        nextVC.subjectId = self.arrReportList[indexPath.row].subjectId!
        nextVC.childFirstName = self.childFirstName
        nextVC.childLastName = self.childLastName
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK:- collection delegate/datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let childInfo = Preferance.user.childInfo{
            return childInfo.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var strIdentifier = String()
        if DeviceType.IS_IPAD {
            strIdentifier = "ReportCardCell_iPad"
        }
        else {
            strIdentifier = "ReportCardCell"
        }
        let cell = objCollection.dequeueReusableCell(withReuseIdentifier: strIdentifier, for: indexPath) as! ReportCardCell
        
        if let childTemp = Preferance.user.childInfo{
            let childInfo = childTemp[indexPath.row]
            
            var strName = ""
            if let fName = childInfo.firstName{
                strName = fName
                if fName.count > 0 {
                    cell.lblCharcter.text = getNthCharacter(strText: fName)
                    
                }
            }
            if let lName = childInfo.lastName{
                strName = strName + " " + lName
            }
            cell.username.text = strName
            
        }
        DispatchQueue.main.async {
            cell.img.layer.cornerRadius = cell.img.frame.width / 2
        }
        if self.arrSelectedStudent.contains(indexPath.row){
            cell.img.layer.borderColor = UIColor.clear.cgColor
            cell.img.backgroundColor = UIColor(named: "Color_lightSky")
        }
        else {
            cell.img.layer.borderColor = UIColor.white.cgColor
            cell.img.backgroundColor = .clear
        }
//        cell.username.backgroundColor = .magenta
//        if indexPath.row % 2 == 0{
//            cell.backgroundColor = .cyan
//        }
//        else {
//            cell.backgroundColor = .red
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let childInfo = Preferance.user.childInfo{
            if self.childId != childInfo[indexPath.row].childId{
                self.childId = childInfo[indexPath.row].childId!
                self.APICallGetReportList(isFromCollectionSelect: true, Index: indexPath.row)
            }
        }
        if let childInfo = Preferance.user.childInfo{
            if self.childFirstName != childInfo[indexPath.row].firstName{
                self.childFirstName = childInfo[indexPath.row].firstName!
                self.childLastName = childInfo[indexPath.row].lastName!
            }
        }
    }
    
    //MARK:- API Call
    func APICallGetReportList(isFromCollectionSelect: Bool, Index: Int) {
        
        var params : [String : Any] = [:]
        params["userType"] = Preferance.user.userType
        params["childId"] = self.childId
        params["pageIndex"] = 0
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getReportCardList, showLoader: true, vc:self) { (jsonData, error) in
            if jsonData != nil {
                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        self.arrReportList.removeAll()
                        if let user = userData.reportList {
                            for tempSub in user {
                                self.arrReportList.append(tempSub)
                            }
                            
                            if isFromCollectionSelect {
                                if !self.arrSelectedStudent.contains(Index) {
                                    self.arrSelectedStudent.removeAll()
                                    self.arrSelectedStudent.append(Index)
                                }
                            }
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if !isFromCollectionSelect {
                            self.arrSelectedStudent.append(0)
                        }
                        self.objCollection.reloadData()
                    }
                    else{
                        self.childId = 0
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                }
                if self.arrReportList.count > 0{
                    self.objtable.backgroundView = nil
                }
                else{
                    let lbl = UILabel.init(frame: self.objtable.frame)
                    lbl.text = "No Progress Report(s) found"
                    lbl.textAlignment = .center
                    lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
                    self.objtable.backgroundView = lbl
                }
                self.objtable.reloadData()
            }
        }
    }
}
