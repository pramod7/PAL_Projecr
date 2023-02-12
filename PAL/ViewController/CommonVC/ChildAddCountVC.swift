//
//  ChildAddCountVC.swift
//  PAL
//
//  Created by i-Phone7 on 06/01/21.
//

import UIKit

//MARK:- tblView Cell
class childCountCell: UITableViewCell {
    @IBOutlet weak var lblNumber: UILabel!{
        didSet{
            lblNumber.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
}

class ChildAddCountVC: UIViewController,UITableViewDelegate, UITableViewDataSource,DisplayViewControllerDelegate {

    //MARK:- outlet variable
    @IBOutlet weak var tblCount: UITableView!
    @IBOutlet weak var btnAdd: UIButton!{
        didSet{
            btnAdd.layer.cornerRadius = 5
            btnAdd.titleLabel?.font =  UIFont.Font_ProductSans_Regular(fontsize: 16)
        }
    }
    @IBOutlet weak var nslcbtnLoginWidth: NSLayoutConstraint!
    
    //MARK:- local variable
    var childCount = String()
    var childName = String()
    var childIndex = Int()
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "Add Child", titleColor: .white)
        self.navigationItem.titleView = titleLabel
        
        self.navigationItem.setHidesBackButton(true, animated: true)
//        let btnSkip: UIButton = UIButton()
////        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
//        btnSkip.setTitle("SKIP", for: .normal)
//        btnSkip.addTarget(self, action: #selector(btnSkipClicked), for: .touchUpInside)
//        btnSkip.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnSkip)
      
        for _ in 1...Int(childCount)!{
            var params: [String: Any] = [ : ]
            params["childId"] = 0
            params["firstName"] = ""
            params["lastName"] = ""
            params["student_Id"] = ""
            params["dob"] = ""
            params["gender"] = 0
            params["yearOldChild"] = ""
            params["childStrugleArea"] = ""
            params["teacherLinkId"] = Preferance.user.teacher_Id
            params["otherDescription"] = ""
            arrChild.append(params)
        }
        
        if DeviceType.IS_IPHONE {
            self.nslcbtnLoginWidth.isActive = true
        }
        else {
            self.nslcbtnLoginWidth.isActive = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.childName)
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
        }
    }
    func doSomethingWith(data: String,Id: Int) {
        self.childName = data
        self.childIndex = Id
        print("\(data)........data")
        self.tblCount.reloadData()
    }
    //MARK:- tbl delegate/datasource
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.childCount)!
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "childCountCell") as! childCountCell
      
        if self.childName.isEmpty {
            cell.lblNumber.text = "Child - \(indexPath.row+1)"
        }else{
            if childIndex == indexPath.row{
                cell.lblNumber.text = childName
            }
        }
        
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objNext = AddStudentVC.instantiate(fromAppStoryboard: .Main)
        objNext.childIndex = indexPath.row
        objNext.delegate = self
        objNext.isFromSignUp = true
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //MARK:- btn click
    @objc func BackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnSkipClicked(_ sender: Any){

        arrChild.removeAll()
        isCHildrenCount = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let nextVC = PALTabBarController.instantiate(fromAppStoryboard: .TabBar)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnAddChildClick(_ sender: UIButton) {
        
        var childCount: Int = 0
        for tempParam in arrChild {
            if tempParam["firstName"] as? String == ""{
                showAlert(title: APP_NAME , message: "Please fill details for child no \(childCount+1).")
                return
            }
            childCount = childCount+1
        }
        self.addChildAPICall()
    }
    
    //MARK:- API Call
    func addChildAPICall() {
        
        var paramTemp: [String: Any] = [ : ]
        var arrPayment = [[String:Any]]()
        for i in 0...arrChild.count-1 {
            
            var params: [String: Any] = [ : ]
            params["childId"] = arrChild[i]["childId"]
            params["firstName"] = arrChild[i]["firstName"]
            params["lastName"] = arrChild[i]["lastName"]
            params["student_Id"] = arrChild[i]["student_Id"]
            params["gender"] = arrChild[i]["gender"]
            params["yearOldChild"] = arrChild[i]["yearOldChild"]
            params["dob"] = arrChild[i]["dob"]
            params["childStrugleArea"] = arrChild[i]["childStrugleArea"]
            params["otherDescription"] = arrChild[i]["childStrugleArea"] as! String == "Others" ?arrChild[i]["otherDescription"]:""
            
            arrPayment.append(params)
        }
        
        paramTemp["data"] = arrPayment
        
        APIManager.shared.callPostAPI(url: URLs.APIURL + getUserTye() + addEditChild, parameters: paramTemp, showLoader: true) { (status, dictResponse, errorMessage) in
            DispatchQueue.main.async(execute: {
                if (status){
                    arrChild.removeAll()

                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    let nextVC = PALTabBarController.instantiate(fromAppStoryboard: .TabBar)
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                else {
                    if let msg = errorMessage {
                        showAlert(title: APP_NAME, message: msg)
                    }
                }
            })
        }
    }
}
