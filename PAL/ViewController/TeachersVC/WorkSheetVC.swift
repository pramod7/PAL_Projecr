//
//  WorkSheetVC.swift
//  PAL
//
//  Created by i-Phone7 on 25/11/20.
//

import UIKit

class WorkSheetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlet Variable
    @IBOutlet weak var tblWorkSheet: UITableView!

    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Worksheets", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            //self.navigationItem.setHidesBackButton(true, animated: true)
            
            let btnAddNewText = UIButton(type: .custom)
            btnAddNewText.setTitle("Add new", for: .normal)
            btnAddNewText.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            btnAddNewText.addTarget(self, action: #selector(btnAddNewClick), for: .touchUpInside)
            
            let btnAddNewImg = UIButton(type: .custom)
            btnAddNewImg.setImage(UIImage(named: "Icon_newPage"), for: .normal)
            btnAddNewImg.addTarget(self, action: #selector(btnAddNewClick), for: .touchUpInside)
            
            let barText = UIBarButtonItem(customView: btnAddNewText)
            let barImg = UIBarButtonItem(customView: btnAddNewImg)
            self.navigationItem.setRightBarButtonItems([barImg, barText], animated: true)
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorksheetCell") as! WorksheetCell
        if indexPath.row % 2 == 0{
            cell.lblName.text = "English"
            cell.lblDate.text = "Friday, 9 March2020"
            cell.btnEye.setImage(UIImage(named: "Icon_Eye"), for: .normal)
        }
        else {
            cell.lblName.text = "Science"
            cell.lblDate.text = "Friday, 9 March2020"
            cell.btnEye.setImage(UIImage(named: "Icon_Editable"), for: .normal)
        }
        cell.btnDownlaodCompletion = {
            self.downloadReport(index: indexPath.row)
        }
        cell.btnEyeCompletion = {
            self.viewEdited(index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    //MARK:- support Method
    func downloadReport(index: Int) {
        print("downlaod click")
    }
    
    func viewEdited(index: Int) {
        print("viewEdited")
    }
    
    //MARK:- btn Click
    @objc func btnBackClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnAddNewClick(_ sender: Any){
        let objnext = WorksheetManagement.instantiate(fromAppStoryboard: .Teacher)
        self.navigationController?.pushViewController(objnext, animated: true)
    }
}
