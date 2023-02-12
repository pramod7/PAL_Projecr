//
//  ViewController.swift
//  Planner
//
//  Created by Andrea Clare Lam on 30/08/2020.
//  Copyright © 2020 Andrea Clare Lam. All rights reserved.
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

class WorksheetViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
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
    var imgItemIndex = 0
    var imgBackground = UIImage()
    var objWorksheetData = [WorksheetData]()
    var imgPath = ""
    var ScPath = ""
    var arr = [UIImage]()
    var ImagePath = ""
    var ScreenPath = ""
    var arrStoredPath = [[String:Any]]()
    var imgStr = ""
    var screenShotStr = ""
    var btnGif: UIButton = UIButton()
    var btnSerach: UIButton = UIButton()
    var btnSaveWorksheet: UIButton = UIButton()
    var btnInstruct: UIButton = UIButton()
    var arrCount = [String]()
    var arrInstruction = [String]()
    var arrvoiceInstruction = [String]()
    var count = 0
    var currentIndex = 0
    var SelctedIndex = 0
    var isMarking = 0
    var arrAllImg : [String]?
    let img = UIImageView()
    var workSheetId = 0
    var teacherName = ""
    var uniqueID = 0
    var barSaveWorksheet = UIBarButtonItem()
    var barInstruction = UIBarButtonItem()
    var barJumpToPage = UIBarButtonItem()
    var bargif = UIBarButtonItem()
    var subjectId = 0
    var teacherId = ""
    var strInstruction = ""
    var worksheetName = ""
    var strWorksheet = ""
    var subCategoryId = 0
    var assign_type = 0
    var eraser = 0
    var spellChecker = 0
    var isOffline = Int()//By this we can identify worksheet is in edit mode(0) or final saved(1)
//    var result = CanvasManager.main.GetData()
    var objuniqId = 0
    var objId = 0
    var isFromStudent = false
    var isFromOffline = false
    var isPlaying = false
    var isLast = false
    var numberOfRecords = 0
    var arrVoiceInstructionStr = [String]()
    var arrVoiceInstruction = [Int]()
    var arridVoiceInstruction = [Int]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.objCollection.collectionViewLayout = flowLayout
        self.rightNavItem()
        if let nav = self.navigationController {
            if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
                , colorName.trim.count > 0{
                nav.navigationBar.barTintColor = UIColor.hexStringToUIColor(colorName)
            }
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Worksheet", titleColor: .white)
            self.navigationItem.titleView = titleLabel
        }
        let stringValue = String(self.workSheetId) + String(1)  // "\(x)\(l)"
        let result = WorksheetDBManager.shared.check(drawindex: Int(stringValue) ?? 0)
        if result.count > 0 {
            self.isOffline = result[0].isoffline
        }
        APIManager.showPopOverLoader(view: self.view)
        DispatchQueue.main.async {
            self.CheckFolder()
        }
//        if isFromOffline == false{
//
//        }
        
        
    }
        
    // MARK: - Other Method
    func clearTempFolder() {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.workSheetId)")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: bFolder.path) {
            try! fileManager.removeItem(atPath: bFolder.path)
        }else{
            
        }
    }
    
    func UpdateScreenshotDocumentDirectory(image: UIImage, index: Int) {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.workSheetId)")
        let cFolder = bFolder.appendingPathComponent("Screenshot")
        let GFolder = cFolder.appendingPathComponent("AllScreenshot")
        
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
    
    func UpdateBackGroundDocumentDirectory(image: UIImage, index: Int) {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.workSheetId)")
        let cFolder = bFolder.appendingPathComponent("Images")
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: cFolder.path) {
            try! fileManager.createDirectory(atPath: cFolder.path, withIntermediateDirectories: true, attributes: nil)
        }
        if index > 9 {
            let url1 = NSURL(string: cFolder.path)
            let imagePath1 = url1!.appendingPathComponent("\(index).jpeg")
            let urlString1: String = imagePath1!.absoluteString
            let imageData1 = image.jpegData(compressionQuality: 0.5)
            
            fileManager.createFile(atPath: urlString1 as String, contents: imageData1, attributes: nil)
        }else{
            let url1 = NSURL(string: cFolder.path)
            let imagePath1 = url1!.appendingPathComponent("0\(index).jpeg")
            let urlString1: String = imagePath1!.absoluteString
            let imageData1 = image.jpegData(compressionQuality: 0.5)
            
            fileManager.createFile(atPath: urlString1 as String, contents: imageData1, attributes: nil)
        }
    }
    
    func removeallfile()
    {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.workSheetId)")
        let cFolder = bFolder.appendingPathComponent("AudioRecording")
    
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: cFolder,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs where fileURL.pathExtension == "m4a" {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }
    
    
    //MARK: - Support Method
    func downloadFile(str:String)
    {
        if let audioUrl = URL(string: str) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let aFolder = documentsDirectoryURL.appendingPathComponent("WorkSheetMetaData")
            let bFolder = aFolder.appendingPathComponent("\(self.workSheetId)")
            let cFolder = bFolder.appendingPathComponent("AudioRecording")
            // lets create your destination file url
            let fileManager = FileManager.default
            
            if !fileManager.fileExists(atPath: cFolder.path) {
                try! fileManager.createDirectory(atPath: cFolder.path, withIntermediateDirectories: true, attributes: nil)
            }
            
            let destinationUrl = cFolder.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
           
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                        do {
                            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                            let documentDirectory = URL(fileURLWithPath: path)
                            self.numberOfRecords += 1
                            let fileName = destinationUrl.lastPathComponent
                            print(fileName)
                            let originPath = cFolder.appendingPathComponent(fileName)
                            let destinationPath = cFolder.appendingPathComponent("\(self.numberOfRecords).m4a")
                            print(destinationPath)
                            let filepath = destinationPath.absoluteString.dropFirst(7)
                            let stripped = filepath //String(filepath.characters.dropFirst(7))
                            print(stripped)
                            self.arrVoiceInstructionStr.append(String(stripped))
                            
                            try FileManager.default.moveItem(at: originPath, to: destinationPath)
//                            self.arrVoiceInstructionStr.append(String(destinationPath))
                            self.arrVoiceInstruction.append(self.numberOfRecords)
                            self.arridVoiceInstruction.removeAll()
                            var stri = 1
                            for _ in self.arrVoiceInstruction {
                                self.arridVoiceInstruction.append(stri)
                                stri += 1
                            }
                            DispatchQueue.main.async {
                                //
                            }
                        } catch {
                            print(error)
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
            

        }
    }
    
    func saveImageDocumentDirectory(image: UIImage, name: String, index: Int){
     
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.workSheetId)")
        let cFolder = bFolder.appendingPathComponent("Screenshot")
        let dFolder = bFolder.appendingPathComponent("Images")
        let eFolder = bFolder.appendingPathComponent("SubMetaData")
        let GFolder = cFolder.appendingPathComponent("AllScreenshot")
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
            imgPath = urlString
            
            let url1 = NSURL(string: GFolder.path)
            let imagePath1 = url1!.appendingPathComponent("\(index).jpeg")
            let urlString1: String = imagePath1!.absoluteString
            ScPath = urlString1
            
            print("imgPath \(imgPath)")
            let imageData1 = image.jpegData(compressionQuality: 0.5)
            fileManager.createFile(atPath: urlString1 as String, contents: imageData1, attributes: nil)
            
            let imageData = image.jpegData(compressionQuality: 0.5)
            fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
            
        }
        else{
            let url = NSURL(string: dFolder.path)
            let imagePath = url!.appendingPathComponent("0\(index).jpeg")
            let urlString: String = imagePath!.absoluteString
            imgPath = urlString
            
            let url1 = NSURL(string: GFolder.path)
            let imagePath1 = url1!.appendingPathComponent("0\(index).jpeg")
            let urlString1: String = imagePath1!.absoluteString
            ScPath = urlString1
            
            print("imgPath \(imgPath)")
            let imageData1 = image.jpegData(compressionQuality: 0.5)
            fileManager.createFile(atPath: urlString1 as String, contents: imageData1, attributes: nil)
            
            let imageData = image.jpegData(compressionQuality: 0.5)
            fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
        }
    }
    
    // Check image and screeshot available in temprory folder if not than download these content there.
    func CheckFolder(){
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.workSheetId)")
        
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
        let aFolder = documentsUrl.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.workSheetId)")
        let eFolder = bFolder.appendingPathComponent("Images")
        let cFolder = bFolder.appendingPathComponent("Screenshot")
        let dFolder = cFolder.appendingPathComponent("AllScreenshot")
        do {
            // Get the directory contents urls (including subfolders urls)
            let ScreenShotContents = try FileManager.default.contentsOfDirectory(at: dFolder, includingPropertiesForKeys: nil)
            let imgContents = try FileManager.default.contentsOfDirectory(at: eFolder, includingPropertiesForKeys: nil)
            
            var a = Int()
            for i in ScreenShotContents{
                var disc = [String :Any]()
                screenShotStr = i.path
                disc = ["images" : "" , "screenshot" : screenShotStr]
                arrStoredPath.append(disc)
                
            }
            for j in imgContents{
                imgStr = j.path
                arrStoredPath[a].updateValue(imgStr, forKey: "images")
                a = a + 1
            }
        } catch {
            print(error)
        }
    }
    
    func imgDownload() {
        let dispatchGroup = DispatchGroup()
        let imgURL = self.arrAllImg?[self.imgItemIndex] ?? ""
        dispatchGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                if let imageURL = URL(string: imgURL) {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        if let image = UIImage(data: imageData) {
                            self.imgItemIndex = self.imgItemIndex + 1
                            dispatchGroup.leave()
                            self.saveImageDocumentDirectory(image: image , name: "\(self.imgItemIndex)", index: self.imgItemIndex)
                        }
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main){
            if self.arrAllImg?.count != self.imgItemIndex{
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
        
        if ((self.arrAllImg?.last) != nil){
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                for i in self.arrvoiceInstruction{
                    self.downloadFile(str: i)
                }
            }
        }
    }
    
    // add images and screenshots into DataModel (WorksheetData)
    
    func loadData() {
        
        print("before",self.arrStoredPath)
        self.arrStoredPath.sort{
            ((($0 as Dictionary<String, Any>)["screenshot"] as? String)!) < ((($1 as Dictionary<String, Any>)["screenshot"] as? String)!)
        }
        
        print("after",self.arrStoredPath)
        let jsonString = self.arrStoredPath.toJSONString()
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        
        do {
            let people = try decoder.decode([WorksheetData].self, from: jsonData)
            print("\(people).......modaldata")
            self.objWorksheetData.append(contentsOf: people)
            self.rightNavItem()
        } catch {
            print(error.localizedDescription)
        }
//        DispatchQueue.main.async {
//            self.objCollection.reloadData()
//        }
    }
    
    // prepare for segue, pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let stringValue = String(uniqueID) + String(imgItemIndex)  // "\(x)\(l)"
        print(stringValue)
        if let detail = segue.destination as? EditWorksheetViewController {
            detail.drawingIndex = self.imgItemIndex
            detail.imgBackground = self.imgBackground
            detail.ImagePath = self.ImagePath
            detail.screenPath = self.ScreenPath
            detail.worksheetId = self.workSheetId
            detail.teacherName = self.teacherName
            detail.isoffline = 0
            detail.UniqueID = Int(stringValue) ?? 0
            detail.subjectId = self.subjectId
            detail.teacherId = self.teacherId
            detail.subCategoryId = self.subCategoryId
            detail.assigntype = self.assign_type
            detail.eraser = self.eraser
            detail.spellChecker = self.spellChecker
            detail.strInstruction = self.arrInstruction.joined(separator: ",")
            detail.strVoiceInstruction = self.arrvoiceInstruction.joined(separator: ",")
            detail.arrInstructions = self.arrInstruction
            detail.arrVoiceInstructions = self.arrvoiceInstruction
            detail.isFromStudent = true
            detail.isPlaying = isPlaying
            detail.strWorksheet = self.worksheetName
            detail.currentIndex = self.imgItemIndex - 1
            detail.dismissimg = { (str,id,uniqId,back) in
                DispatchQueue.main.async {
                    self.UpdateScreenshotDocumentDirectory(image: str, index: id + 1)
                    self.UpdateBackGroundDocumentDirectory(image: back, index: id + 1)
                    self.objuniqId = uniqId
                    self.objCollection.reloadData()
                }
            }
        }
    }
    
    func rightNavItem(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationPlay(notification:)), name: Notification.Name("NotificationPlay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationOver(notification:)), name: Notification.Name("NotificationOver"), object: nil)
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        self.btnInstruct = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        self.btnInstruct.imageView?.contentMode = .scaleAspectFit
        let imgInstruct = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgInstruct.image = UIImage(named: "Icon_Instruction")
        self.btnInstruct.addSubview(imgInstruct)
        self.btnInstruct.addTarget(self, action: #selector(btnInstructionClick), for: .touchUpInside)
        barInstruction = UIBarButtonItem(customView: self.btnInstruct)
        
        self.btnSaveWorksheet = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        self.btnSaveWorksheet.imageView?.contentMode = .scaleAspectFit
        self.btnSaveWorksheet.setTitle("Submit", for: .normal)
        self.btnSaveWorksheet.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)

//        let imgTemp = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        imgTemp.image = UIImage(named: "Icon_SaveWorksheet")
//        self.btnSaveWorksheet.addSubview(imgTemp)
        self.btnSaveWorksheet.addTarget(self, action: #selector(btnSavedWorksheetClick), for: .touchUpInside)
        barSaveWorksheet = UIBarButtonItem(customView: self.btnSaveWorksheet)
        
        btnSerach = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        let imgTemp2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgTemp2.image = UIImage(named: "Selection")
        btnSerach.addSubview(imgTemp2)
        btnSerach.addTarget(self, action: #selector(btnsettingClick), for: .touchUpInside)
        barJumpToPage = UIBarButtonItem(customView: btnSerach)
        
        
        btnGif = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        let imgTemp3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "Pal Transperent", withExtension: "gif")!)
        let jeremyGif = UIImage.sd_image(withGIFData: imageData)
        imgTemp3.image = jeremyGif
        imgTemp3.contentMode = .scaleAspectFit
        btnGif.addSubview(imgTemp3)
        btnGif.addTarget(self, action: #selector(btnsettingClick), for: .touchUpInside)
        bargif = UIBarButtonItem(customView: btnGif)
        
        //Show jump to page button only when there are more than one images
        //Show save worksheet button only when worksheet is in edit mode
//        if self.isMarking == 2{
        if self.arrAllImg?.count ?? 0 > 1 {
                if self.isOffline == 0 {
                    self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]//barColorPadButton
                }
                else{
                    self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]
                }
            }
            else{
                if self.isOffline == 0 {
                    if assign_type == 1{
                        self.navigationItem.rightBarButtonItems = [barInstruction]
                    }else{
                        self.navigationItem.rightBarButtonItems = [barSaveWorksheet, barInstruction]
                    }
                  
                }
                else{
                    self.navigationItem.rightBarButtonItems = [barInstruction]
                }
            }
//        }
//        else{
//            if self.arrAllImg?.count ?? 0 > 1 {
//                self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]//barColorPadButton
//            }
//        }
    }
    
    //MARK: - btn Click
    @objc func methodOfReceivedNotificationPlay(notification: Notification) {
        isPlaying = true
        if self.arrAllImg?.count ?? 0 > 1 {
            if isLast{
                if self.isOffline == 0
                {
                    self.navigationItem.rightBarButtonItems = [barJumpToPage, barSaveWorksheet, barInstruction, bargif]
                }else{
                    self.navigationItem.rightBarButtonItems = [barJumpToPage, barSaveWorksheet, barInstruction, bargif]
                }
            }else{
                if self.isOffline == 0 {
                    self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction, bargif]//barColorPadButton
                }
                else{
                    self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction, bargif]
                }
            }
            }
            else{
                if self.isOffline == 0 {
                    if assign_type == 1{
                        self.navigationItem.rightBarButtonItems = [barInstruction,bargif]
                    }else{
                        self.navigationItem.rightBarButtonItems = [barSaveWorksheet, barInstruction,bargif]
                    }
                }
                else{
                    self.navigationItem.rightBarButtonItems = [barInstruction,bargif]
                }
            }
    }
    
    @objc func methodOfReceivedNotificationOver(notification: Notification) {
        isPlaying = false
        if self.arrAllImg?.count ?? 0 > 1 {
            if isLast{
                if self.isOffline == 0
                {
                    self.navigationItem.rightBarButtonItems = [barJumpToPage, barSaveWorksheet, barInstruction]
                }else{
                    self.navigationItem.rightBarButtonItems = [barJumpToPage, barSaveWorksheet, barInstruction]
                }
            }else{
                if self.isOffline == 0 {
                    self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]//barColorPadButton
                }
                else{
                    self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]
                }
            }
            }
            else{
                if self.isOffline == 0 {
                    self.navigationItem.rightBarButtonItems = [barSaveWorksheet, barInstruction]
                }
                else{
                    self.navigationItem.rightBarButtonItems = [barInstruction]
                }
            }
        
    }
    
    @objc func btnBackClick(_ sender: Any) {
        MusicPlayer.instance.pause()
        appdelegate.btnSelectedVoice = false
        appdelegate.selectedIndex = 99999
        NotificationCenter.default.post(name: Notification.Name("NotificationSpeech"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnInstructionClick(_ sender: Any) {
        
        if self.arrInstruction.count > 0 || self.arrvoiceInstruction.count > 0{
        let nextVC = InstructionVC.instantiate(fromAppStoryboard: .Student)
            nextVC.arrInstruction = self.arrInstruction
            nextVC.arrvoiceInstruction = self.arrvoiceInstruction
            nextVC.isFromStudent = isFromStudent
            nextVC.workSheetId = workSheetId
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            let int = self.arrInstruction.count
            let int1 = self.arrvoiceInstruction.count
            if self.arrInstruction.count == 0
            {
                if self.arrvoiceInstruction.count > 5
                {
                    nextVC.preferredContentSize = CGSize(width: 250,height: 120 + 300)
                }else{
                    nextVC.preferredContentSize = CGSize(width: 250,height: 120 + int1*60)
                }                
            }else{
            if self.arrInstruction.count > 5
            {
                nextVC.preferredContentSize = CGSize(width: 250,height: 120 + 300)
            }else{
                nextVC.preferredContentSize = CGSize(width: 250,height: 120 + int*60)
            }}
            popover.permittedArrowDirections = .up
            popover.sourceView = self.btnInstruct
            popover.sourceRect = self.btnInstruct.bounds
        }
        self.present(nav, animated: true, completion: nil)
        self.view.endEditing(true)
        }
        else{
            showAlert(title: APP_NAME, message: "Teacher had not added Instruction for this worksheet.")
        }
        
//        if self.arrInstruction.count > 0 || self.arrvoiceInstruction.count > 0{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InstructionVC") as! InstructionVC
//            vc.arrInstruction = self.arrInstruction
//            vc.arrvoiceInstruction = self.arrvoiceInstruction
//            vc.modalPresentationStyle = UIModalPresentationStyle.automatic
//            self.present(vc, animated: true, completion: nil)
//        }
//        else{
//            showAlert(title: APP_NAME, message: "Teacher had not added Instruction for this worksheet.")
//        }
    }
    
    @objc func btnSavedWorksheetClick(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME, message: Validation.worksheetSave, preferredStyle: .actionSheet)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        
        let yes = UIAlertAction(title: Messages.YES, style: .default) {(action) in
            self.submitWorksheet()
        }
        let no = UIAlertAction(title: Messages.NO, style: .default) {(action) in
            self.navigationController?.popViewController(animated: true)
        }
        let Cancel = UIAlertAction(title: Messages.CANCEL, style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        yes.setValue(UIColor.darkGray, forKey: "titleTextColor")
        no.setValue(UIColor.darkGray, forKey: "titleTextColor")
        Cancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(yes)
        alert.addAction(no)
        alert.addAction(Cancel)
        if let popover = alert.popoverPresentationController {
            alert.preferredContentSize = CGSize(width: 400,height: 360)
            popover.permittedArrowDirections = .up
            popover.sourceView = self.btnSaveWorksheet
            popover.sourceRect = self.btnSaveWorksheet.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func btnsettingClick(_ sender: Any) {
        if self.objWorksheetData.count  > 1 {
            count = 0
            arrCount.removeAll()
            for _ in 0...self.objWorksheetData.count - 1{
                count = count + 1
                arrCount.append("\(count)")
                print(arrCount.count)
            }
            let nextVC = Size_ColorSelectionVC.instantiate(fromAppStoryboard: .Student)
            nextVC.isFromSize = false
            nextVC.isfromSelection = true
            nextVC.SelctedIndex = SelctedIndex
            nextVC.arrcount = arrCount
            nextVC.dismisssSize = { (count) in
                DispatchQueue.main.async {
                    self.SelctedIndex = count - 1
                    if self.currentIndex < self.arrCount.count {
                        let pageSize = self.view.bounds.size
                        let contentOffset = CGPoint(x: Int(pageSize.width) * (count-1), y: 0)
                        self.objCollection.setContentOffset(contentOffset, animated: true)
                        self.currentIndex = count-1
                    }
                    else{
                        print("Crash point")
                    }
                }
            }
            let nav = UINavigationController(rootViewController: nextVC)
            nav.modalPresentationStyle = .popover
            if let popover = nav.popoverPresentationController {
                let int = arrCount.count
                nextVC.preferredContentSize = CGSize(width: 80,height: int*50)
                popover.permittedArrowDirections = .up
                popover.sourceView = self.btnSerach
                popover.sourceRect = self.btnSerach.bounds
            }
            self.present(nav, animated: true, completion: nil)
            self.view.endEditing(true)
        }
    }
        
    //MARK: - API Call
    func submitWorksheet(){
        
        if !Connectivity.isConnectedToInternet() {
            let strInstructions = self.arrInstruction.joined(separator: ",")
            let strVoiceInstructions = self.arrvoiceInstruction.joined(separator: ",")
            let result = WorksheetDBManager.shared.GetData()
            let newArray = result.filter{$0.worksheetID == self.workSheetId}
            var count = 1
            for _ in newArray{
                let stringValue = String(self.workSheetId) + String(count)  // "\(x)\(l)"
                let canvas = Canvas(id: result[self.objId].id, drawindex: self.imgItemIndex, canvasDrawing: result[self.objId].canvasDrawing, worksheetID: self.workSheetId, teacherName: teacherName, uniduqId: Int(stringValue) ?? 0, canvasMetadata: result[self.objId].canvasMetadata, isoffline: 1, subjectId: subjectId, teacherId: teacherId, subCategoryId: subCategoryId, assigntype: assign_type, eraser: eraser, spellChecker: spellChecker, instrcution: strInstructions, Voiceinstrcution: strVoiceInstructions, worksheetName: self.strWorksheet)
                print(canvas)
                WorksheetDBManager.shared.updateOffilieStatus(canvas: canvas)
                count = count + 1
            }
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: Date())
        
        //Sort array in accesing order.
        self.objWorksheetData.sort { $0.screenshot ?? "" < $1.screenshot ?? "" }
        var arrimgset = [UIImage]()
        for i in self.objWorksheetData{
            arrimgset.append(UIImage(contentsOfFile: i.screenshot ?? "")!)
        }
                
        var params: [String: Any] = [ : ]
        params["subjectId"] = subjectId
        params["teacherId"] = teacherId
        params["subCategoryId"] = subCategoryId
        params["worksheetId"] = self.workSheetId
        params["submitDate"] = dateString
        params["assign_type"] = assign_type
        params["eraser"] = eraser
        params["spellChecker"] = spellChecker
        params["pdfImages[]"] = arrimgset //pdfImages
        params["deviceType"] = MyApp.device_type
        APIManager.shared.callPostWithMultiPartApi(reqURL: URLs.APIURL + getUserTye() + submitWorkSheet, parameters: params, showLoader: true) { (jsonData, error) in
            
           if jsonData != nil{
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject ?? [String:Any]()){
                    if let status = userData.status, status == 1{
                        WorksheetDBManager.shared.delete(drawindex: self.workSheetId)
                        self.clearTempFolder()
                        self.removeallfile()
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
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isOffline == 0 {
            self.imgItemIndex = indexPath.row + 1
            self.objId = self.imgItemIndex
            self.imgBackground = UIImage(contentsOfFile: self.objWorksheetData[indexPath.row].images ?? "") ?? UIImage()
            self.performSegue(withIdentifier: "toCanvas", sender: nil)
        }
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
        self.SelctedIndex = previousPage
   
        if (previousPage == self.objWorksheetData.count - 1 ) { //it's your last cell
            //Show jump to page button only when there are more than one images
            //Show save worksheet button only when worksheet is in edit mode
            if self.objWorksheetData.count > 1 {
                isLast = true
                if isPlaying == true
                {
                    if assign_type == 1{
                        self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction, bargif]
                    }else{
                        self.navigationItem.rightBarButtonItems = [barJumpToPage, barSaveWorksheet, barInstruction, bargif]
                    }
                    
                }else{
                    if assign_type == 1{
                        self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]
                    }else{
                        self.navigationItem.rightBarButtonItems = [barJumpToPage, barSaveWorksheet, barInstruction]
                    }
                    
                }
                
                
                
            }
            else{
                isLast = true
                if isPlaying == true
                {
                    if assign_type == 1{
                        self.navigationItem.rightBarButtonItems = [barInstruction, bargif]
                    }else{
                        self.navigationItem.rightBarButtonItems = [barSaveWorksheet, barInstruction, bargif]
                    }
                }else{
                    if assign_type == 1{
                        self.navigationItem.rightBarButtonItems = [barInstruction]
                    }else{
                        self.navigationItem.rightBarButtonItems = [barSaveWorksheet, barInstruction]
                    }
                   
                }
            }
        }
        else{
            isLast = false
            if isPlaying == true
            {
                self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction, bargif]
            }else{
                self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]
            }
        }

        
//        if self.objWorksheetData.count > 1 {
//            if self.isOffline == 0 {
//                self.navigationItem.rightBarButtonItems = [barJumpToPage, barSaveWorksheet, barInstruction]//barColorPadButton
//            }
//            else{
//                self.navigationItem.rightBarButtonItems = [barJumpToPage, barInstruction]
//            }
//        }
//        else{
//            if self.isOffline == 0 {
//                self.navigationItem.rightBarButtonItems = [barSaveWorksheet, barInstruction]
//            }
//            else{
//                self.navigationItem.rightBarButtonItems = [ barInstruction]
//            }
//        }
    }
}
