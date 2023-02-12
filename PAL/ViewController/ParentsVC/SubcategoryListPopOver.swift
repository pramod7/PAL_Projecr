//
//  SubcategoryListPopOver.swift
//  PAL
//
//  Created by i-Verve on 02/06/21.
//

import UIKit
protocol SubCategoryDelegate{
    func saveSubject(strText : NSString,strID : NSInteger)
    func saveChildInfo(childInfo: ChildInfoModel)
}
class SubcategoryListPopOver: UIViewController, UITableViewDelegate, UITableViewDataSource  {

   
    @IBOutlet weak var tblSubjectList: UITableView!
    
    //MARK:- Local variable
    var isStudent = Bool()
    var childId = Int()
    var subjectID = Int()
    var subCategoryId = [Int]()
    var arrSubcategoryList = [WorkbookListModel]()
    var arrsubCategory : [String?] = []
    var delegate : SubCategoryDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        arrsubCategory.append("See All")
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
            self.delegate?.saveSubject(strText: arrsubCategory[indexPath.row]! as NSString, strID: subCategoryId[indexPath.row])
          
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
   
    
//    func APICallGetWorkbookList() {
//
//        var params: [String: Any] = [ : ]
//        params["childId"] = self.childId
//        params["pageIndex"] = 0
//        params["isFive"] = 0
//        params["subjectId"] = self.subjectID
//        params["subCategoryId"] = self.subCategoryId
//
//        APIManager.shared.callPostApi(parameters: params, reqURL: APIEndpoint.getParentChildWorksheetsList, showLoader: true) { (jsonData, error) in
//            APIManager.hideLoader()
//            if jsonData != nil {
//                if let userData = ListResponse(JSON: jsonData!.dictionaryObject!){
//                    if let status = userData.status, status == 1{
//                        if let linkTeacher = userData.WorkbookList {
//                            self.arrSubcategoryList = linkTeacher
//                            self.tblSubjectList.reloadData()
//                        }
//
//                        else{
//                            if let msg = jsonData?[APIKey.message].string {
//                                showAlert(title: APP_NAME, message: msg)
//                            }
//                        }
//                        if self.arrSubcategoryList.count > 0{
//                            self.tblSubjectList.backgroundView = nil
//                        }
//                        else{
//
//                        }
//                    }
//                    else{
//                        if let msg = jsonData?[APIKey.message].string {
//                            showAlert(title: APP_NAME, message: msg)
//                        }
//                    }
//                }
//            }
//        }
//    }

}
