//
//  SubjectListPopOver.swift
//  PAL
//
//  Created by i-Phone7 on 25/11/20.
//

import UIKit
import SVProgressHUD

protocol SubjectListDelegate{
    func saveSubject(strText : NSString,strID : NSInteger)
    func saveChildInfo(childInfo: ChildInfoModel)
}

class SubjectListPopOver: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlet variable
    @IBOutlet weak var tblSubjectList: UITableView!
    
    //MARK:- Local variable
    var isStudent = Bool()
    var arrSubjectList = [SubjectListModel]()
    var arrSubList : [String?] = []
    
    var delegate : SubjectListDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if self.isStudent {
            self.APICallGetSubjectList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isStudent {
            APIManager.showPopOverLoader(view: self.view)
        }
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isStudent {
            return self.arrSubjectList.count
        }
        else{
            if let childInfo = Preferance.user.childInfo{
                return childInfo.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolListCell") as! SchoolListCell
    
        if self.isStudent{
        
            cell.lblSchoolName?.text = self.arrSubjectList[indexPath.row].subjectName
            
        }
        else{
            if let childTemp = Preferance.user.childInfo{
                let childInfo = childTemp[indexPath.row]
                var strName = ""
                if let fName = childInfo.firstName{
                    strName = fName
                }
                if let lName = childInfo.lastName{
                    strName = strName + " " + lName
                }
                cell.lblSchoolName.text = strName
            }
        }
        cell.lblLine.isHidden = DeviceType.IS_IPHONE ? false:true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isStudent {
            self.delegate?.saveSubject(strText: self.arrSubjectList[indexPath.row].subjectName! as NSString, strID: self.arrSubjectList[indexPath.row].subjectId ?? 0)
           
            
        }
        else{
            if let childInfo = Preferance.user.childInfo{
                self.delegate?.saveChildInfo(childInfo: childInfo[indexPath.row])
            }
          
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DeviceType.IS_IPHONE ? 55 : 60
    }
   
    
    func APICallGetSubjectList() {
        APIManager.shared.callGetApi(reqURL: URLs.APIURL + getUserTye() + subjectList, showLoader: false) { (jsonData, error) in
            APIManager.hideLoader()
            if let json = jsonData{
                if let userData = ListResponse(JSON: json.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        self.arrSubjectList.removeAll()
                        if let user = userData.subjectList {
                            for tempSub in user {
                                self.arrSubjectList.append(tempSub)
                            }
                            if self.arrSubjectList.count > 0 && !self.isStudent{
                                var temp = SubjectListModel()
                                temp?.subjectName = "See All"
                                self.arrSubjectList.append(temp!)
                            }
                        }
                        else{
                            if let msg = jsonData?[APIKey.message].string {
                                showAlert(title: APP_NAME, message: msg)
                            }
                        }
                        if self.arrSubjectList.count > 0 {
                            self.tblSubjectList.backgroundView = nil
                        }
                        else{
                            let lbl = UILabel.init(frame: self.tblSubjectList.frame)
                            lbl.text = "No Subject(s) found"
                            lbl.textAlignment = .center
//                            lbl.textColor = UIColor.darkGray
                            lbl.font = (self.isStudent) ?UIFont.Font_WorkSans_Regular(fontsize: 16):UIFont.Font_WorkSans_Regular(fontsize: 14)
                            self.tblSubjectList.backgroundView = lbl
                        }
                        self.tblSubjectList.reloadData()
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                             showAlert(title: APP_NAME, message: msg)
                        }
                    }
                }
            }
            else{
                showAlert(title: APP_NAME, message: error?.localizedDescription)
            }
        }
    }
}
