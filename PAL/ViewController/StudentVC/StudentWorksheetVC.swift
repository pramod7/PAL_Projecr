//
//  StudentWorksheetVC.swift
//  PAL
//
//  Created by i-Phone7 on 27/11/20.
//

import UIKit

class StudentWorksheetVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlet Variable
    @IBOutlet weak var tblWorkSheet: UITableView!
    
    //MARK:- Local variable
    var arrFevList = [Int]()

    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Worksheets", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            // self.navigationItem.setHidesBackButton(true, animated: true)
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        self.arrFevList = [1,0,1,0,1,0,1,0,1,0]
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
        if self.arrFevList[indexPath.row] == 1{
            cell.btnFav.setImage(UIImage(named: "Icon_yellowStarSelected"), for: .normal)
        }
        else {
            cell.btnFav.setImage(UIImage(named: "Icon_yellowStarUnSelected"), for: .normal)
        }
        cell.btnDownlaodCompletion = {
            self.downloadReport(index: indexPath.row)
        }
        cell.btnEyeCompletion = {
            self.viewEdited(index: indexPath.row)
        }
        cell.btnFavCompletion = {
            self.favUnFavWorksheet(index: indexPath.row)
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
    
    func favUnFavWorksheet(index: Int) {
        if self.arrFevList[index] == 1 {
            self.arrFevList[index] = 0
        }
        else {
            self.arrFevList[index] = 1
        }
        self.tblWorkSheet.reloadData()
    }
    
    //MARK:- btn Click
    @objc func btnBackClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }    
}
