//
//  WorkBookListVC.swift
//  PAL
//
//  Created by i-Verve on 10/12/21.
//

import UIKit

@available(iOS 13.0, *)
class WorkBookListVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlet Variable
    @IBOutlet weak var tblWorkSheet: UITableView!
    
    //MARK:- Local variable
    var arrList = [Int]()
    let id = 0
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let nav = self.navigationController {
            if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
               , colorName.trim.count > 0{
                nav.navigationBar.barTintColor = UIColor.hexStringToUIColor(colorName)
            }
        }
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "WorkBook", titleColor: .white)
        self.navigationItem.titleView = titleLabel
        
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        var barTaskListButton = UIBarButtonItem()
        var btnPlus: UIButton = UIButton()
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20))
        btnPlus = UIButton(frame: iconSize)
        let imgTemp2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgTemp2.image = UIImage(named: "Icon_Add")
        imgTemp2.image = imgTemp2.image?.withRenderingMode(.alwaysTemplate)
        imgTemp2.tintColor = UIColor.white
        btnPlus.addSubview(imgTemp2)
        btnPlus.addTarget(self, action: #selector(btnPlusClick), for: .touchUpInside)
        barTaskListButton = UIBarButtonItem(customView: btnPlus)
        self.navigationItem.rightBarButtonItems = [barTaskListButton]
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if arrList.count > 0
        {
            
        }
        self.tblWorkSheet.reloadData()
    }
    
    @objc func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnPlusClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "PAL", message: "Are you sure want to add new workbook?",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "Yes",style: .default,handler: {(_: UIAlertAction!) in
            let objNext = StudentNewPageVC.instantiate(fromAppStoryboard: .Student)
            objNext.uniqID = self.id
            objNext.dismissStudent = { (count,index,img) in
                DispatchQueue.main.async {
                    print(count)
                }
            }
            self.navigationController?.pushViewController(objNext, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorksheetCell") as! WorksheetCell
        cell.lblName.text = "WorkBook_" + "\(arrList[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = 000
        let nextVc = WorksheetViewController.instantiate(fromAppStoryboard: .Student)
        nextVc.uniqueID = id + arrList[indexPath.row]
        self.navigationController?.pushViewController(nextVc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    

}

