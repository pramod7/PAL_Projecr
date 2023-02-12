//
//  SubjectWorkSheetListVC.swift
//  PAL
//
//  Created by i-Verve on 25/11/20.
//

import UIKit

class SubjectWorkSheetListVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Outlet variable
    @IBOutlet weak var lblSubjectName: UILabel!{
        didSet{
            self.lblSubjectName.font = UIFont.Font_ProductSans_Bold(fontsize: 22)
        }
    }
    @IBOutlet weak var lblworkSheet: UILabel!{
        didSet{
            self.lblworkSheet.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
        }
    }
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var viewNav: UIView!{
        didSet{
            let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor)
            viewNav.backgroundColor = UIColor(named: colorName as! String)
        }
    }
    @IBOutlet weak var btnAdd: UIButton!{
        didSet{
            self.btnAdd.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 12)
        }
    }
    
    //MARK:- Local variable
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl.dequeueReusableCell(withIdentifier: "TeacherSubjectWorksheetTableViewCell") as! TeacherSubjectWorksheetTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    //MARK:- Support method

    //MARK:- btn Click
    @IBAction func btnNavItemClick(_ sender: UIButton) {
        if sender.tag == 0 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            let objNext = AddNewPageVC.instantiate(fromAppStoryboard: .Teacher)
            self.navigationController?.pushViewController(objNext, animated: true)
        }
    }
}
