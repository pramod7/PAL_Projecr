//
//  FAQViewController.swift
//  PAL
//
//  Created by i-Verve on 25/11/20.
//

import UIKit

class FAQViewController: UIViewController {
    
    //MARK: Outlet variable
    @IBOutlet var cell: UITableViewCell!
    @IBOutlet var tbl: UITableView!
    
    //MARK: Local variable
    var arrSelectedIndex = [Int]()
    var isexpaned = false
    
    var arrFAQ = [FAQModel]()
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "FAQ's", titleColor: .white)
        self.navigationItem.titleView = titleLabel
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(BackClicked), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        self.APICallGetFAQ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    //MARK:- btn Click
    @objc func BackClicked(_ sender: Any){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- API Call
    func APICallGetFAQ() {
        
        var params: [String: Any] = [ : ]
        params["userType"] = Preferance.user.userType
        params["pageIndex"] = 0

        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getFAQs, showLoader: true, vc:self) { (jsonData, error) in
            
            if let json = jsonData{
                if let userData = ListResponse(JSON: json.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let tips = userData.faq {
                            for tempTips in tips {
                                self.arrFAQ.append(tempTips)
                            }
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        self.tbl.reloadData()
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                    if self.arrFAQ.count > 0{
                        self.tbl.backgroundView = nil
                    }
                    else{
                        let lbl = UILabel.init(frame: self.tbl.frame)
                        lbl.text = "No FAQ(s) found"
                        lbl.textAlignment = .center
                        lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
                        self.tbl.backgroundView = lbl
                    }
                }
            }
            else{
                showAlert(title: APP_NAME, message: error?.debugDescription)
            }
        }
    }
}

extension FAQViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.arrFAQ.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            return cell
        }
        else{
            var strIdetifire = String()
            if DeviceType.IS_IPAD{
                strIdetifire = "FAQTableViewCell_iPad"
            }
            else{
                strIdetifire = "FAQTableViewCell"
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: strIdetifire) as! FAQTableViewCell
            
            if self.arrSelectedIndex.contains(indexPath.row){
                cell.lblQuestion.font = UIFont.Font_ProductSans_Bold(fontsize: 18)
                cell.objView.backgroundColor = UIColor.kApp_viewLight_Color().withAlphaComponent(0.2)
                cell.objView.layer.borderWidth = 0
                cell.lblQuestion.text = self.arrFAQ[indexPath.row-1].faqQuestion
                cell.lblanswer.text = self.arrFAQ[indexPath.row-1].faqAnswer
                cell.imgRotate.transform = cell.imgRotate.transform.rotated(by: .pi)
            }
            else {
                cell.lblQuestion.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
                cell.objView.backgroundColor = .clear
                cell.objView.layer.borderWidth = 1
                cell.objView.layer.borderColor = UIColor.kbtnAgeSetup().cgColor
                cell.lblQuestion.text = self.arrFAQ[indexPath.row-1].faqQuestion
                cell.lblanswer.text = ""
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return ScreenSize.SCREEN_HEIGHT/2.5
        }
        else{
            if self.arrSelectedIndex.contains(indexPath.row){
                return UITableView.automaticDimension
            } else {
                if DeviceType.IS_IPHONE{
                    return UITableView.automaticDimension
                }
                else{
                    return UITableView.automaticDimension
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.arrSelectedIndex.contains(indexPath.row) {
            if indexPath.row == 0{
                return
            }
            self.arrSelectedIndex.removeAll()
            self.arrSelectedIndex.append(indexPath.row)
            self.tbl.reloadData()
        }
        else{
            self.arrSelectedIndex.removeAll()
            let cell = tbl.cellForRow(at: indexPath) as! FAQTableViewCell
            cell.imgRotate.transform = cell.imgRotate.transform.rotated(by: .pi)
            self.tbl.reloadData()
            print("\(indexPath.row)......selceted")
        }
    }
}
