//
//  TipsViewController.swift
//  PAL
//
//  Created by i-Verve on 24/11/20.
//

import UIKit

class TipsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: Outlet Variable
    @IBOutlet var tblTips: UITableView!
    @IBOutlet var cell: UITableViewCell!
    
    //MARK: Local Variable
    var arrTips = [TipsModel]()
    
    //MARK: life cyclt
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "Tips", titleColor: .white)
        self.navigationItem.titleView = titleLabel
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(BackClicked), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.APICallGetTips()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.arrTips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipsTableViewCell") as! TipsTableViewCell
            cell.lblData.text = self.arrTips[indexPath.row-1].tip
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return ScreenSize.SCREEN_HEIGHT/2.5
        }
        else{
            return UITableView.automaticDimension
        }
    }
    
    //MARK:- btn Click
    @objc func BackClicked(_ sender: Any){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- API Call
    func APICallGetTips() {
        
        var params: [String: Any] = [ : ]
        params["userType"] = Preferance.user.userType
        params["pageIndex"] = 0
        
        APIManager.shared.callPostApi(parameters: params, reqURL: URLs.APIURL + getUserTye() + getTips, showLoader: true, vc:self) { (jsonData, error) in

            if let json = jsonData{
                if let userData = ListResponse(JSON: json.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let tips = userData.tips {
                            for tempTips in tips {
                                self.arrTips.append(tempTips)
                            }
//                            APIManager.hideLoader()
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        self.tblTips.reloadData()
//                        APIManager.hideLoader()
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
//                            APIManager.hideLoader()
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                    if self.arrTips.count > 0{
                        self.tblTips.backgroundView = nil
                    }
                    else{
                        let lbl = UILabel.init(frame: self.tblTips.frame)
                        lbl.text = "No Tip(s) found"
                        lbl.textAlignment = .center
                        lbl.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
                        self.tblTips.backgroundView = lbl
                    }
                }
            }
            else{
                APIManager.hideLoader()
                showAlert(title: APP_NAME, message: error?.debugDescription)
            }
        }
    }
}
