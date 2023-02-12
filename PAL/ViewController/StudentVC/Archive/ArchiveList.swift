//
//  ArchiveList.swift
//  PAL
//
//  Created by i-Verve on 08/12/22.
//

import UIKit

class ArchiveList: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlet Variable
    @IBOutlet weak var tblArchive: UITableView!
    @IBOutlet weak var viewButtonContainer: UIView!
    @IBOutlet weak var btnWorksheet: UIButton!{
        didSet{
            btnWorksheet.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnWorkbook: UIButton!{
        didSet{
            btnWorkbook.layer.cornerRadius = 5
        }
    }
    
    //MARK: - Local variable
    var arrArchiveList = [Marking]()
    var strYear = ""
    var subjectId = 0
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            nav.navigationBar.tintColor = .kAppThemeColor()
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Archive", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        
        self.viewButtonContainer.layer.cornerRadius = 15
        self.viewButtonContainer.layer.borderWidth = 1
        self.viewButtonContainer.layer.borderColor = UIColor.kAppThemeColor().cgColor
        self.selectButton(btn: self.btnWorksheet)
        self.unSelectButton(btn: self.btnWorkbook)
        self.btnWorksheet.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.btnWorkbook.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        self.APICallArchiveList(isSelected: 0)
    }
        
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrArchiveList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorksheetCell") as! WorksheetCell
        
        if  self.arrArchiveList[indexPath.row].isWorksheet == 0{
            cell.ArchivelblName.text = self.arrArchiveList[indexPath.row].worksheetName
        }
        else{
            if self.arrArchiveList[indexPath.row].worksheetName == "" || self.arrArchiveList[indexPath.row].worksheetName == nil
            {
                cell.ArchivelblName.text = "Workbook"
            }else{
                cell.ArchivelblName.text = self.arrArchiveList[indexPath.row].worksheetName
            }
            
            if let url = self.arrArchiveList[indexPath.row].pdfThumb,url.trim.count > 0{
                cell.img.imageFromURL(url, placeHolder: imgWorksheetIconPlaceholder)
                cell.img.backgroundColor = .white
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !Connectivity.isConnectedToInternet() {
            showAlert(title: APP_NAME, message: Messages.NOINTERNET)
            return
        }
        let objNext = WorksheetViewVC.instantiate(fromAppStoryboard: .Student)
        objNext.arrImages = self.arrArchiveList[indexPath.row].pdfImages ?? []
        if let arrPdf = arrArchiveList[indexPath.row].pdfImages{
            objNext.arrImages = arrPdf
        }
        if let arrInstruction = self.arrArchiveList[indexPath.row].instruction{
            objNext.arrInstruction = arrInstruction
        }
        if let arrInstructionVoice = self.arrArchiveList[indexPath.row].voiceinstruction{
            objNext.arrvoiceInstruction = arrInstructionVoice
        }
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    //MARK: - btn click
    @IBAction func btnClick(_ sender: UIButton) {
        
        if sender.tag == 0{
            self.selectButton(btn: self.btnWorksheet)
            self.unSelectButton(btn: self.btnWorkbook)
            self.APICallArchiveList(isSelected: 0)
        }
        else{
            self.selectButton(btn: self.btnWorkbook)
            self.unSelectButton(btn: self.btnWorksheet)
            self.APICallArchiveList(isSelected: 1)
        }
    }
    
    @objc func btnBackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Support method
    func unSelectButton(btn:UIButton) {
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 15
        btn.setTitleColor(UIColor.black, for: .normal)
    }
    
    func selectButton(btn:UIButton){
        btn.backgroundColor = UIColor.kbtnAgeSetup()
        btn.layer.borderWidth = 0
        btn.layer.cornerRadius = 15
        btn.setTitleColor(UIColor.white, for: .normal)
    }
    
    //MARK: - API Call
    func APICallArchiveList(isSelected:Int) {
        
        var params: [String: Any] = [ : ]
        
        params["year"] = strYear
        params["subjectId"] = subjectId
        params["studentId"] = Preferance.user.userId
        params["isWorksheet"] = isSelected
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getArchive, showLoader: true, vc:self) { (jsonData, error) in
            if jsonData != nil {
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        self.arrArchiveList.removeAll()
                        if let markingList = userData.Archivemarking {
                            for value in markingList{
                                self.arrArchiveList.append(value)
                            }
                        }
                    }
                    
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                }
                self.tblArchive.reloadData()
            }
            if self.arrArchiveList.count > 0 {
                self.tblArchive.backgroundView = nil
            }
            else{
                let lbl = UILabel.init(frame: self.tblArchive.frame)
                lbl.text = "No archive(s) found"
                lbl.textAlignment = .center
                lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
                self.tblArchive.backgroundView = lbl
            }
        }
    }
}
