//
//  OfflineStudentDataVC.swift
//  PAL
//
//  Created by i-Verve on 03/12/21.
//

import UIKit

class OfflineStudentDataVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlet Variable
    @IBOutlet weak var tblWorkSheet: UITableView!
    
    //MARK: - Local variable
    var arrList = [Int]()
    var arroffline = [Int]()
    var arrCanvasReports = [Canvas]()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            nav.navigationBar.tintColor = .kAppThemeColor()
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Worksheets", titleColor: .white)
            self.navigationItem.titleView = titleLabel
        }
        self.arrCanvasReports = WorksheetDBManager.shared.GetData()
        for i in self.arrCanvasReports{
            self.arroffline.append(i.worksheetID)
        }
        self.arroffline.removeDuplicates()
    }
    
    //MARK: - tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arroffline.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorksheetCell") as! WorksheetCell
        cell.lblName.text = self.arrCanvasReports[indexPath.row].worksheetName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let newArray = self.arrCanvasReports.filter{$0.worksheetID == self.arroffline[indexPath.row]}
        //        let newOffline = newArray.filter{$0.isoffline == 1}
        //
        //        if newOffline.count == 0 {
        let nextVc = WorksheetViewController.instantiate(fromAppStoryboard: .Student)
        nextVc.workSheetId = self.arroffline[indexPath.row]
        nextVc.uniqueID = self.arroffline[indexPath.row]
        nextVc.teacherName = self.arrCanvasReports[indexPath.row].teacherName
        nextVc.teacherId = self.arrCanvasReports[indexPath.row].teacherId
        nextVc.subCategoryId = self.arrCanvasReports[indexPath.row].subCategoryId
        nextVc.assign_type = self.arrCanvasReports[indexPath.row].assigntype
        nextVc.eraser = self.arrCanvasReports[indexPath.row].eraser
        nextVc.spellChecker = self.arrCanvasReports[indexPath.row].spellChecker
        nextVc.subjectId = self.arrCanvasReports[indexPath.row].subjectId
        nextVc.strWorksheet = self.arrCanvasReports[indexPath.row].worksheetName
        nextVc.isFromStudent = true
        nextVc.isFromOffline = true
        //nextVc.isOffline = self.arrCanvasReports[indexPath.row].isoffline
        let arrTemp = self.arrCanvasReports[indexPath.row].instrcution.components(separatedBy: [","])
        nextVc.arrInstruction = arrTemp
        let arrTempVoice = self.arrCanvasReports[indexPath.row].Voiceinstrcution.components(separatedBy: [","])
        nextVc.arrvoiceInstruction = arrTempVoice
        self.navigationController?.pushViewController(nextVc, animated: true)
        //        }
        //        else{
        //            return
        //        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
