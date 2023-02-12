//
//  ParentReportCardDetailsVC.swift
//  PAL
//
//  Created by i-Verve on 23/11/20.
//

import UIKit

class ParentReportCardDetailsVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Outlet variable
    @IBOutlet var headerview: UIView!
    @IBOutlet weak var objtable: UITableView!{
        didSet{
            objtable.delegate = self
            objtable.dataSource = self
        }
    }
    @IBOutlet weak var lblsubjectname: UILabel!{
        didSet{
            lblsubjectname.font = UIFont.Font_ProductSans_Bold(fontsize: 17)
        }
    }
    @IBOutlet weak var objView: UIView!
  
    @IBOutlet var lblView: UIButton!{
        didSet{
            lblView.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 20)
            lblView.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet var lblReport: UILabel!{
        didSet{
            lblReport.lineBreakMode = .byWordWrapping
            lblReport.textAlignment = .center
            lblReport.textColor = .white
            lblReport.font = UIFont.Font_ProductSans_Bold(fontsize: 18)
        }
    }
    @IBOutlet weak var lblname: UILabel!{
        didSet{
            lblname.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            lblname.textColor = .white
        }
    }
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSubjectNameWidth: NSLayoutConstraint!
    @IBOutlet weak var nslcMiddlelblBottomSpace: NSLayoutConstraint!
    
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
    var childId = Int()
    var arrReportList = [ReportCardDetailListModel]()
    var selectedStudent = ReportCardListModel()
    var arrSelectedStudent = [Int]()
    var objPersonalInfo = PersonalInfo()
    var subjectId = Int()
    var subjectName = String()
    var childFirstName = String()
    var childLastName = String()
    var isFromParent = Bool()
    var arrReportname = ["Progress","Attention","Behaviour","Participation","General Notes"]
    var Desc = [String]()
   
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(subjectName).........subname")
        if isFromParent == true{
            self.lblsubjectname.text = self.selectedStudent?.subjectName
        }else{
            self.lblsubjectname.text = subjectName
        }
        
        let titleLabel = UILabel()
//        self.lblname.text = "\(self.childFirstName) \(self.childLastName)"
//        self.lblView.setTitle(self.childFirstName.first?.uppercased(), for: .normal)
//        self.lblView.backgroundColor = UIColor(named: "Color_lightSky")
        
        if Preferance.user.userType == 1 {
            titleLabel.navTitle(strText: ScreenTitle.ProgressCard, titleColor: .white)
        }
        else {
            titleLabel.navTitle(strText: ScreenTitle.ProgressCard, titleColor: .white)
        }
        self.navigationItem.titleView = titleLabel
        //self.navigationItem.setHidesBackButton(true, animated: true)
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.rightBarButtonItems = setRightButton(self, action: #selector(btnBackClick(_:)), imageName: "")
        self.lblsubjectname.font = UIFont.Font_ProductSans_Bold(fontsize: 20)
        
       // self.arrSelectedStudent = [0]
        
        if DeviceType.IS_IPHONE{
        //   self.topViewHeight.isActive = true
       //    self.lblSubjectNameWidth.isActive = true
       //     self.nslcMiddlelblBottomSpace.constant = 10
        }
        else {
           // self.topViewHeight.isActive = false
         //  self.lblSubjectNameWidth.isActive = false
         //   self.nslcMiddlelblBottomSpace.constant = 25
        }
      //  self.objCollection.collectionViewLayout = flowLayout
        self.arrSelectedStudent.append(self.childId)
       // self.navigationController?.setNavigationBarHidden(true, animated: true)

        self.APICallGetReportDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                if let nav = self.navigationController{
//          //  transparentNav(nav: nav)
            nonTransparentNav(nav: nav)
       }
    }

    //MARK:- btn Click
    @objc func btnBackClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnAddNewPageClick(_ sender: Any){
        let objnext = AddProgressReport.instantiate(fromAppStoryboard: .Teacher)
        self.navigationController?.pushViewController(objnext, animated: true)
    }
    
    //MARK:- Tbl delegate/datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrReportList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReportname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var strIdentifier = String()
       
       
        if DeviceType.IS_IPAD {
            strIdentifier = "ReportDetailCell_iPad"
        }
        else {
            strIdentifier = "ReportDetailCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier) as! ReportDetailCell
       // let ff = self.arrReportList[indexPath.row]
        Desc = ["\(arrReportList[indexPath.section].progress ?? "")","\(arrReportList[indexPath.section].attention ?? "")","\(arrReportList[indexPath.section].behaviour ?? "")","\(arrReportList[indexPath.section].participation ?? "" )","\(arrReportList[indexPath.section].generalNotes ?? "")"]
        if indexPath.row == self.arrReportname.count-1{
            cell.viewShadow.isHidden = true
            cell.lblCharcteristicsName.text = arrReportname[indexPath.row]
            cell.lblCharcteristicsDesc.text = Desc[indexPath.row]
            cell.endViewShadow.isHidden = false
           
        }
        else {
            cell.viewShadow.isHidden = false
            cell.lblCharcteristicsName.text = arrReportname[indexPath.row]
            cell.lblCharcteristicsDesc.text = Desc[indexPath.row]
            cell.endViewShadow.isHidden = true
            
        }
//        if indexPath.row % 2 == 0{
//            cell.backgroundColor = .red
//        }
//        else {
//            cell.backgroundColor = .cyan
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var strIdentifier = String()
        if DeviceType.IS_IPAD {
            strIdentifier = "ReportDetailHeaderCell_iPad"
        }
        else {
            strIdentifier = "ReportDetailHeaderCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifier) as! ReportDetailHeaderCell
        cell.lblReportNo.text = "Report-\(section+1)"
        cell.lblName.text = "\(childFirstName) \(childLastName)"
        cell.lblDate.text = arrReportList[section].reportDate!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (DeviceType.IS_IPHONE) ? 80 : 115
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (DeviceType.IS_IPHONE) ? 35 : 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK:- collection delegate/datasource
    func setRightButton(_ target: AnyObject, action:Selector, imageName:String) -> [UIBarButtonItem]
    {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 100,height: 40))
        
        let button1 = UIButton(frame: CGRect(x: 39,y: 0, width: 25, height: 25))
        button1.setTitle(self.childFirstName.first?.uppercased(), for: .normal)
        button1.backgroundColor = UIColor(named: "Color_lightSky")
        button1.layer.cornerRadius = 12.5
        rightView.addSubview(button1)
        
        let lbl1 = UILabel(frame: CGRect(x: 0, y: 25, width: 100, height: 15))
        lbl1.text = "\(self.childFirstName) \(self.childLastName)"
        lbl1.font = UIFont.Font_WorkSans_Regular(fontsize: 9)
        lbl1.textColor = .white
        lbl1.textAlignment = .center
        rightView.addSubview(lbl1)
        
        let rightBarView = UIBarButtonItem(customView: rightView)
        let arrBarItem = [rightBarView]
        return arrBarItem
        
//        let rightBtn = UIButton(type: UIButton.ButtonType.custom)
//        rightBtn.backgroundColor = UIColor(named: "Color_lightSky")
//        rightBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
//        rightBtn.setImage(UIImage(named:imageName), for:UIControl.State())
//        rightBtn.setTitle(self.childFirstName.first?.uppercased(), for: .normal)
//        rightBtn.setTitleColor(.white, for: .normal)
//        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left:0 , bottom: 0, right: rightBtn.frame.size.width - (rightBtn.frame.size.width + 15))
//       // rightBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightBtn.frame.size.width)
//        rightBtn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
//        let negativeSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
//        negativeSpace.width = -5
//        let barButton = UIBarButtonItem(customView:rightBtn)
//        let arrBarItems = [negativeSpace, barButton]
//        return arrBarItems
    }
    //MARK:- API Call
    func APICallGetReportDetail() {
        
        var params : [String : Any] = [:]
        params["childId"] = self.childId
        params["subjectId"] = self.subjectId
        params["pageIndex"] = 0
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getReportDetaill, showLoader: true, vc:self) { (jsonData, error) in
            if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
                if let status = userData.status, status == 1{
                  self.arrReportList.removeAll()
                    if let user = userData.reportDetailList {
                        for tempStudent in user {
                            self.arrReportList.append(tempStudent)
                        }
                        //self.arrReportList = user
                        for i in self.arrReportList{
                            print(i.progress)
                        }
                        print(self.arrReportList)
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                    self.objtable.reloadData()
                   
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
