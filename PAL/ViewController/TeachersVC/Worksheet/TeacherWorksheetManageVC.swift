//
//  TeacherWorksheetManageVC.swift
//  PAL
//
//  Created by Pramod Yadav on 03/01/22.
//

import UIKit
import PencilKit
import CoreData
import SQLite3
import SwiftyJSON
import ObjectMapper
import SDWebImage
import AVFoundation
import Alamofire
import SystemConfiguration

class TeacherWorksheetManageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: -
    @IBOutlet weak var objCollection: UICollectionView!
    
    // MARK: - Local Variable
    
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.itemSize = CGSize(width:  view.frame.width, height: view.frame.height)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _flowLayout.scrollDirection = .horizontal
        _flowLayout.minimumInteritemSpacing = 0
        _flowLayout.minimumLineSpacing = 0
        return _flowLayout
    }
    var studentId = Int()
    var objMarkingInfo = Marking()
    var btnJumpPage = UIButton()
    var btnComplete = UIButton()
    var objWorksheetData = [WorksheetData]()
    var worksheetImgIndex = 0
    var arrStoredPath = [[String:Any]]()
    var arrImgCount = [String]()
    var currentJumpIndex = 0
    var barInstruction = UIBarButtonItem()
    var barCompleteWorksheet = UIBarButtonItem()
    var barJumpToPage = UIBarButtonItem()
    var eraser = Int()
    var spellCheck = Int()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.objCollection.collectionViewLayout = flowLayout
        
        if let nav = self.navigationController {
            if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
                , colorName.trim.count > 0{
                nav.navigationBar.barTintColor = UIColor.hexStringToUIColor(colorName)
            }
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Teacher Worksheet", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            
            let btnInstruct = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
            btnInstruct.imageView?.contentMode = .scaleAspectFit
            let imgInstruct = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgInstruct.image = UIImage(named: "Icon_Instruction")
            btnInstruct.addSubview(imgInstruct)
            btnInstruct.addTarget(self, action: #selector(btnInstructionClick), for: .touchUpInside)
            self.barInstruction = UIBarButtonItem(customView: btnInstruct)
            
            self.btnComplete = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
            self.btnComplete.imageView?.contentMode = .scaleAspectFit
            let imgTemp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgTemp.image = UIImage(named: "Icon_SaveWorksheet")
            self.btnComplete.addSubview(imgTemp)
            self.btnComplete.addTarget(self, action: #selector(btnSavedWorksheetClick), for: .touchUpInside)
            self.barCompleteWorksheet = UIBarButtonItem(customView: self.btnComplete)
            
            self.btnJumpPage = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
            let imgTemp2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imgTemp2.image = UIImage(named: "Selection")
            self.btnJumpPage.addSubview(imgTemp2)
            self.btnJumpPage.addTarget(self, action: #selector(btnJumpPageClick), for: .touchUpInside)
            self.barJumpToPage = UIBarButtonItem(customView: self.btnJumpPage)
            
            if self.objMarkingInfo.pdfImage?.count ?? 0 > 1 {
                self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]//barCompleteWorksheet
            }
            else{
                self.navigationItem.rightBarButtonItems = [barCompleteWorksheet, barInstruction]
            }
        }
        APIManager.showPopOverLoader(view: self.view)
        DispatchQueue.main.async {
            self.CheckFolder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
        
    // MARK: - Other Method
    func clearTempFolder() {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("TeacherWorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.objMarkingInfo.worksheetId ?? 0)")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: bFolder.path) {
            try! fileManager.removeItem(atPath: bFolder.path)
        }
        else{
            
        }
    }
    
    func UpdateScreenshotDocumentDirectory(image: UIImage, index: Int) {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("TeacherWorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.objMarkingInfo.worksheetId ?? 0)")
        let cFolder = bFolder.appendingPathComponent("TeacherScreenshot")
        let GFolder = cFolder.appendingPathComponent("TeacherAllScreenshot")
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: GFolder.path) {
            try! fileManager.createDirectory(atPath: GFolder.path, withIntermediateDirectories: true, attributes: nil)
        }
        if index > 9 {
            let url1 = NSURL(string: GFolder.path)
            let imagePath1 = url1!.appendingPathComponent("\(index).jpeg")
            let urlString1: String = imagePath1!.absoluteString
            let imageData1 = image.jpegData(compressionQuality: 0.5)
            
            fileManager.createFile(atPath: urlString1 as String, contents: imageData1, attributes: nil)
        }else{
            let url1 = NSURL(string: GFolder.path)
            let imagePath1 = url1!.appendingPathComponent("0\(index).jpeg")
            let urlString1: String = imagePath1!.absoluteString
            let imageData1 = image.jpegData(compressionQuality: 0.5)
            
            fileManager.createFile(atPath: urlString1 as String, contents: imageData1, attributes: nil)
        }
    }
    
    // Save images from api to Document directory
    func saveImageDocumentDirectory(image: UIImage, name: String, index: Int){
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("TeacherWorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.objMarkingInfo.worksheetId ?? 0)")
        let cFolder = bFolder.appendingPathComponent("TeacherScreenshot")
        let dFolder = bFolder.appendingPathComponent("TeacherImages")
        let eFolder = bFolder.appendingPathComponent("TeacherSubMetaData")
        let GFolder = cFolder.appendingPathComponent("TeacherAllScreenshot")
        let fFolder = eFolder.appendingPathComponent(name)
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dFolder.path) {
            try! fileManager.createDirectory(atPath: dFolder.path, withIntermediateDirectories: true, attributes: nil)
        }
        
        if !fileManager.fileExists(atPath: cFolder.path) {
            try! fileManager.createDirectory(atPath: cFolder.path, withIntermediateDirectories: true, attributes: nil)
        }
        if !fileManager.fileExists(atPath: eFolder.path) {
            try! fileManager.createDirectory(atPath: eFolder.path, withIntermediateDirectories: true, attributes: nil)
        }
        if !fileManager.fileExists(atPath: fFolder.path) {
            try! fileManager.createDirectory(atPath: fFolder.path, withIntermediateDirectories: true, attributes: nil)
        }
        
        if !fileManager.fileExists(atPath: GFolder.path) {
            try! fileManager.createDirectory(atPath: GFolder.path, withIntermediateDirectories: true, attributes: nil)
        }
        if index > 9 {
            let url = NSURL(string: dFolder.path)
            let imagePath = url!.appendingPathComponent("\(index).jpeg")
            let urlString: String = imagePath!.absoluteString
            
            let url1 = NSURL(string: GFolder.path)
            let imagePath1 = url1!.appendingPathComponent("\(index).jpeg")
            let urlString1: String = imagePath1!.absoluteString
            
            print("TeacherImgPath \(urlString)")
            print("TeacherImgPath \(urlString1)")
            let imageData1 = image.jpegData(compressionQuality: 0.5)
            fileManager.createFile(atPath: urlString1 as String, contents: imageData1, attributes: nil)
            
            let imageData = image.jpegData(compressionQuality: 0.5)
            fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
            
        }
        else{
            let url = NSURL(string: dFolder.path)
            let imagePath = url!.appendingPathComponent("0\(index).jpeg")
            let urlString: String = imagePath!.absoluteString
            
            let url1 = NSURL(string: GFolder.path)
            let imagePath1 = url1!.appendingPathComponent("0\(index).jpeg")
            let urlString1: String = imagePath1!.absoluteString
            
            print("TeacherImgPath \(urlString)")
            print("TeacherImgPath \(urlString1)")
            let imageData1 = image.jpegData(compressionQuality: 0.5)
            fileManager.createFile(atPath: urlString1 as String, contents: imageData1, attributes: nil)
            
            let imageData = image.jpegData(compressionQuality: 0.5)
            fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
        }
    }
    
    // Check image and screeshot available in temprory folder if not than download these content there.
    func CheckFolder(){
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("TeacherWorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.objMarkingInfo.worksheetId ?? 0)")
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: bFolder.path) {
            self.imgDownload()
        }
        else{
            self.getImageFromDoc()
            let seconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.loadData()
                self.objCollection.reloadData()
                APIManager.hideLoader()
            }
        }
    }
    
    func getImageFromDoc(){
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = documentsUrl.appendingPathComponent("TeacherWorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.objMarkingInfo.worksheetId ?? 0)")
        let eFolder = bFolder.appendingPathComponent("TeacherImages")
        let cFolder = bFolder.appendingPathComponent("TeacherScreenshot")
        let dFolder = cFolder.appendingPathComponent("TeacherAllScreenshot")
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let ScreenShotContents = try FileManager.default.contentsOfDirectory(at: dFolder, includingPropertiesForKeys: nil)
            let imgContents = try FileManager.default.contentsOfDirectory(at: eFolder, includingPropertiesForKeys: nil)
            
            var a = Int()
            for i in ScreenShotContents{
                var disc = [String :Any]()
                disc = ["images" : "" , "screenshot" : i.path]
                self.arrStoredPath.append(disc)
                
            }
            for j in imgContents{
                self.arrStoredPath[a].updateValue(j.path, forKey: "images")
                a = a + 1
            }
        } catch {
            print(error)
        }
    }
    
    func imgDownload() {
        let dispatchGroup = DispatchGroup()
        let imgURL = self.objMarkingInfo.pdfImage?[self.worksheetImgIndex] ?? ""
        dispatchGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let imageURL = URL(string: imgURL) {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        if let image = UIImage(data: imageData) {
                            self.worksheetImgIndex = self.worksheetImgIndex + 1
                            dispatchGroup.leave()
                            self.saveImageDocumentDirectory(image: image , name: "Teacher directory \(self.worksheetImgIndex)", index: self.worksheetImgIndex)
                        }
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main){
            if self.self.objMarkingInfo.pdfImage?.count != self.worksheetImgIndex{
                self.imgDownload()
            }
            else{
                self.getImageFromDoc()
                let seconds = 2.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.loadData()
                    self.objCollection.reloadData()
                    APIManager.hideLoader()
                }
            }
        }
    }
    
    // add images and screenshots into DataModel (WorksheetData)
    
    func loadData() {
        
        print("Before re-order",self.arrStoredPath)
        self.arrStoredPath.sort{
            ((($0 as Dictionary<String, Any>)["screenshot"] as? String)!) < ((($1 as Dictionary<String, Any>)["screenshot"] as? String)!)
        }
        print("After re-order",self.arrStoredPath)
        let jsonString = self.arrStoredPath.toJSONString()
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        
        do {
            let people = try decoder.decode([WorksheetData].self, from: jsonData)
            print("\(people).......modaldata")
            self.objWorksheetData.append(contentsOf: people)
        } catch {
            print(error.localizedDescription)
        }
    }
        
    @objc func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnInstructionClick(_ sender: Any) {
        
        if  self.objMarkingInfo.instruction?.count ?? 0 > 0 || self.objMarkingInfo.voiceinstruction?.count ?? 0 > 0 {
            let objNext = InstructionVC.instantiate(fromAppStoryboard: .Student)
            if let arrins =  self.objMarkingInfo.instruction{
                objNext.arrInstruction = arrins
            }
            if let arrvocieins =  self.objMarkingInfo.voiceinstruction{
                objNext.arrvoiceInstruction = arrvocieins
            }
            objNext.modalPresentationStyle = UIModalPresentationStyle.automatic
            self.present(objNext, animated: true, completion: nil)
        }
        else{
            showAlert(title: APP_NAME, message: "Teacher had not added Instruction for this worksheet.")
        }
    }
    
    @objc func btnSavedWorksheetClick(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let complete = UIAlertAction(title: "Complete", style: .default) {(action) in
            self.submitWorksheet()
        }
        let reAssign = UIAlertAction(title: "Re-assign", style: .default) {(action) in
            let nextVC =  AddInstructionVC.instantiate(fromAppStoryboard: .Teacher)
            nextVC.objMarking = self.objMarkingInfo
            nextVC.objWorksheetData = self.objWorksheetData
            nextVC.studentId = self.studentId
            nextVC.isReassign = true
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        let Cancel = UIAlertAction(title: Messages.CANCEL, style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        complete.setValue(UIColor.darkGray, forKey: "titleTextColor")
        reAssign.setValue(UIColor.darkGray, forKey: "titleTextColor")
        Cancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(complete)
        alert.addAction(reAssign)
        alert.addAction(Cancel)
        if let popover = alert.popoverPresentationController {
            alert.preferredContentSize = CGSize(width: 400,height: 360)
            popover.permittedArrowDirections = .up
            popover.sourceView = self.btnComplete
            popover.sourceRect = self.btnComplete.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func btnJumpPageClick(_ sender: Any) {
        if self.objMarkingInfo.pdfImage?.count ?? 0 > 1 {
            self.arrImgCount.removeAll()
            
            var count = 0
            for _ in 0...self.objMarkingInfo.pdfImage!.count - 1{
                count = count + 1
                self.arrImgCount.append("\(count)")
            }
            print(self.arrImgCount)
            let nextVC = Size_ColorSelectionVC.instantiate(fromAppStoryboard: .Student)
            nextVC.isFromSize = false
            nextVC.isfromSelection = true
            nextVC.SelctedIndex = currentJumpIndex
            nextVC.arrcount = self.arrImgCount
            nextVC.dismisssSize = { (count) in
                DispatchQueue.main.async {
                    if self.currentJumpIndex < self.arrImgCount.count {
                        let pageSize = self.view.bounds.size
                        let contentOffset = CGPoint(x: Int(pageSize.width) * (count-1), y: 0)
                        self.objCollection.setContentOffset(contentOffset, animated: true)
                        self.currentJumpIndex = count-1
                    }
                    else{
                        print("Crash point")
                    }
                }
            }
            let nav = UINavigationController(rootViewController: nextVC)
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                let int = self.arrImgCount.count
                nextVC.preferredContentSize = CGSize(width: 80,height: int*50)
                popover.permittedArrowDirections = .up
                popover.sourceView = self.btnJumpPage
                popover.sourceRect = self.btnJumpPage.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
        }
    }

//    //MARK: - API Call
    func submitWorksheet(){

        var arrimgset = [UIImage]()

        //Sort array in accesing order.
        self.objWorksheetData.sort { $0.screenshot ?? "" < $1.screenshot ?? "" }
        for i in self.objWorksheetData{
            arrimgset.append(UIImage(contentsOfFile: i.screenshot ?? "")!)
        }
        
        print(self.objMarkingInfo.eraser)
        print(self.objMarkingInfo.spellChecker)
        var iseraser = 0
        var spellChecker = 0
        if self.objMarkingInfo.eraser == nil
        {
            iseraser = 0
        }else{
            iseraser = self.objMarkingInfo.eraser ?? 0
        }
        
        if self.objMarkingInfo.spellChecker == nil
        {
            spellChecker = 0
        }else{
            spellChecker = self.objMarkingInfo.spellChecker ?? 0
        }

        var params: [String: Any] = [ : ]
        params["studentId"] = self.studentId
        params["subjectId"] = self.objMarkingInfo.subjectId
        params["teacherId"] = Preferance.user.userId ?? 0
        params["subCategoryId"] = self.objMarkingInfo.subCategoryId
        params["worksheetId"] = self.objMarkingInfo.worksheetId
        params["pdfImages[]"] = arrimgset //pdfImages
        params["eraser"] =  iseraser
        params["spellChecker"] = spellChecker
        params["isCompleted"] = "1"
        params["instruction"] = self.objMarkingInfo.instruction ?? []
        params["deviceType"] = MyApp.device_type

        APIManager.shared.callPostWithMultiPartApi(reqURL: URLs.APIURL + getUserTye() + reAssignCompletedWorksheet, parameters: params, showLoader: true) { (jsonData, error) in
            if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject ?? [String:Any]()){
                if let status = userData.status, status == 1{
                    self.tabBarController?.tabBar.isHidden = false
                    self.clearTempFolder()
                    if let viewControllers = self.navigationController?.viewControllers{
                        for controller in viewControllers{
                            if controller is TeacherDashboardVC{
                                
                                self.navigationController?.popToViewController(controller, animated: true)
                            }
                        }
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    if let msg = jsonData?[APIKey.message].string {
                        showAlert(title: APP_NAME, message: msg)
                    }
                }
            }
        }
    }
    
    
    
    
    // MARK: - CollectionView delegate methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objWorksheetData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCollectionViewCell", for: indexPath) as! ThumbnailCollectionViewCell
        cell.imageView.image = UIImage(contentsOfFile: self.objWorksheetData[indexPath.row].screenshot ?? "")
        cell.imageView.backgroundColor = .white
        cell.imageView.contentMode = .scaleToFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let objNext = TeacherWorksheetWritingVC.instantiate(fromAppStoryboard: .Teacher)
        objNext.selectedIndex = indexPath.row + 1
        objNext.imgBackground = UIImage(contentsOfFile: self.objWorksheetData[indexPath.row].screenshot ?? "") ?? UIImage()
        //        objNext.ImagePath = self.ImagePath
        //        objNext.screenPath = self.ScreenPath
        objNext.worksheetId = self.objMarkingInfo.worksheetId ?? 0
        objNext.teacherName = self.objMarkingInfo.teacherName ?? ""
        objNext.isoffline = 0
        //        objNext.UniqueID = Int(stringValue) ?? 0
        objNext.subjectId = self.objMarkingInfo.subjectId ?? 0
        objNext.teacherId = self.objMarkingInfo.teacherId ?? "0"
        objNext.subCategoryId = self.objMarkingInfo.subCategoryId ?? 0
        if let img = UIImage(contentsOfFile: self.objWorksheetData[indexPath.row].screenshot ?? "") {
            objNext.imgBackground = img
        }
        //objNext.assigntype = self.objMarkingInfo.assign
        objNext.eraser = self.objMarkingInfo.eraser ?? 0//Int(self.objMarkingInfo.eraser ?? "0") ?? 0
        objNext.spellChecker = self.objMarkingInfo.spellChecker ?? 0//Int(self.objMarkingInfo.spellChecker ?? "0") ?? 0
        objNext.strWorksheet = self.objMarkingInfo.worksheetName ?? ""
        objNext.dismissimg = { (str,id,uniqId) in
            DispatchQueue.main.async {
                self.UpdateScreenshotDocumentDirectory(image: str, index: id + 1)
                self.objCollection.reloadData()
            }
        }
        self.navigationController?.pushViewController(objNext, animated: true)
    }
    
    //MARK: - scrollView delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        var previousPage: Int = 0
        let pageWidth: CGFloat = scrollView.frame.size.width
        let fractionalPage = Float(scrollView.contentOffset.x / pageWidth)
        let page: Int = lround(Double(fractionalPage))
        if previousPage != page {
            previousPage = page
        }
        print("CurrentPage : \(previousPage)")
        self.currentJumpIndex = previousPage
        if (previousPage == self.objWorksheetData.count - 1 ) { //it's your last cell
            //Show jump to page button only when there are more than one images
            //Show save worksheet button only when worksheet is in edit mode
            if self.objMarkingInfo.pdfImage?.count ?? 0 > 1 {
                self.navigationItem.rightBarButtonItems = [barJumpToPage, barCompleteWorksheet, barInstruction]
            }
            else{
                self.navigationItem.rightBarButtonItems = [barCompleteWorksheet, barInstruction]
            }
        }
        else{
            if self.objMarkingInfo.pdfImage?.count ?? 0 > 1 {
                self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]
            }
        }
    }
}
