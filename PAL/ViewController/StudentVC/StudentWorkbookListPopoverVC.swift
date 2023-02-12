//
//  StudentWorkbookListPopoverVC.swift
//  PAL
//
//  Created by i-Verve on 15/06/21.
//

import UIKit
protocol StudentWorkbookDelegate{
    func saveSubject(strText : NSString,strID : NSInteger)
    func saveChildInfo(childInfo: ChildInfoModel)
}
class StudentWorkbookListPopoverVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tblWorkbook: UITableView!
    //MARK:- Local variable
    var isStudent = Bool()
    var childId = Int()
    var subjectID = Int()
    var subCategoryId = [Int]()
    var arrsubCategory : [String?] = []
    var arrSubjectId : [Int?] = []
    var delegate : StudentWorkbookDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        arrsubCategory.append("See All")
        arrSubjectId.append(0)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
      // APICallGetWorkbookList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      // APIManager.showPopOverLoader(view: self.view)
       
           
        
        
       
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isStudent {
            return self.arrsubCategory.count
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
           
            cell.lblSchoolName?.text = arrsubCategory[indexPath.row]
           
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
            self.delegate?.saveSubject(strText: arrsubCategory[indexPath.row]! as NSString, strID: arrSubjectId[indexPath.row] ?? 0)
          
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
   

}
