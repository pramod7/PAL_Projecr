//
//  AddInstructionVC.swift
//  PAL
//
//  Created by i-Verve on 23/09/21.
//

import UIKit
import AVFoundation

class AddInstructionVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, AVAudioRecorderDelegate {
    
    
    //MARK: - Outlets
    @IBOutlet var collectionInstructionView: UICollectionView!
    @IBOutlet var collectionVoiceInstructionView: UICollectionView!
    @IBOutlet var txtInstruction : PALTextField!
    @IBOutlet var collectionHightConstrain: NSLayoutConstraint!
    @IBOutlet var collectionVoiceHeightConstrain: NSLayoutConstraint!
    @IBOutlet var btnAssignWorksheet : UIButton!{
        didSet{
            self.btnAssignWorksheet.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
            self.btnAssignWorksheet.layer.cornerRadius = 5
        }
    }
    @IBOutlet var btnAdd : UIButton!{
        didSet{
            btnAdd.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
            btnAdd.layer.cornerRadius = 20
        }
    }
    @IBOutlet var btnVoiceAdd : UIButton!{
        didSet{
            btnVoiceAdd.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
            btnVoiceAdd.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var objSwitchEraser: UISwitch!
    @IBOutlet weak var objSwitchSepllchecker: UISwitch!
    
    
    //MARK: - Varible
    //Re-Assign Part
    var recordingSession : AVAudioSession!    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var numberOfRecords = 0
    var arrVoiceInstruction = [Int]()
    var arridVoiceInstruction = [Int]()
    var objWorksheetData = [WorksheetData]()
    var objMarking = Marking()
    var arrInstruction = [String]()
//    var arrvoiceInstruction = [String]()
    var studentId = Int()
    
    //Fresh Assign Part
    var studentIds = String() //Multiple Ids
    var isReassign = Bool()
    var worksheet_id = Int()
    var subjectId = Int()
    var categoryId = Int()
    var assigntype = Int()
    var assigned_by = Int()
    var strStartOfWeek = String()
    var strEndOfWeek = String()
    var isFromFav = Bool()
    var isEraser = 0
    var isspellChecker = 0
    var dismissInstruction : (([String],Int,Int) -> Void)?
    var arrVoiceInstructionStr = [String]()
    
    //MARK: - view LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.navTitle(strText: "Add Instruction", titleColor: .white)
        
        self.navigationItem.titleView = titleLabel
        let btnBack: UIButton = UIButton()
        btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        print(getDirectory())
        self.collectionInstructionView.delegate = self
        self.collectionInstructionView.dataSource = self
        self.collectionVoiceInstructionView.delegate = self
        self.collectionVoiceInstructionView.dataSource = self
        if self.isReassign {
            self.arrInstruction = self.objMarking.instruction ?? []
            self.isEraser = self.objMarking.eraser  ?? 0//Int(self.objMarking.eraser ?? "0") ?? 0
            self.isspellChecker = self.objMarking.spellChecker ?? 0//Int(self.objMarking.spellChecker ?? "0") ?? 0
            for i in self.objMarking.voiceinstruction ?? []
            {
                self.downloadFile(str: i)
            }
            if self.isEraser == 1 {
                self.objSwitchEraser.isOn = true
            }
            else{
                self.objSwitchEraser.isOn = false
            }
        }else{
            self.isEraser = 1
            self.objSwitchEraser.isOn = true
        }
        

        if self.isspellChecker == 1 {
            self.objSwitchSepllchecker.isOn = true
        }
        else{
            self.objSwitchSepllchecker.isOn = false
        }
        
        recordingSession = AVAudioSession.sharedInstance()
        removeAllVoiceInstaruction()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission
            {
                print("ACCEPTED")
            }
        }
    }
    
    //Function that gets path to directoary
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func removeAllVoiceInstaruction()
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs where fileURL.pathExtension == "m4a" {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }
    
    //MARK: - Button Action
    @IBAction func SwitchEraseChanged(sender: UISwitch) {
        if self.objSwitchEraser.isOn {
            self.isEraser = 1
        }
        else {
            self.isEraser = 0
        }
    }
    
    @IBAction func SwitchSepllcheckerChanged(sender: UISwitch) {
        if self.objSwitchSepllchecker.isOn {
            self.isspellChecker = 1
        }
        else {
            self.isspellChecker = 0
        }
    }
    
    @IBAction func btnAssignworkSheet(_ sender: Any) {
        
        if self.isReassign{
            self.APICallReAssignWorksheet()
        }
        else{
            self.APICallAssignWorksheet()
//            self.UploadRequest()
        }
    }
    
    @objc func btnBackClick() {
        self.removeallfile()
        self.navigationController?.popViewController(animated: true)
    }
       
    @IBAction func btnAddClick(_ sender: Any){
        self.arrInstruction.append(txtInstruction.text?.trim  ?? "")
        //            let arrTemp = self.arrInstruction.filter { $0.localizedCaseInsensitiveContains(self.txtInstruction.text!.trim) }
        //                arrInstruction.append(contentsOf: arrTemp)
        let formatter = NumberFormatter()
        formatter.numberStyle = .none

        self.collectionInstructionView.reloadData()
        self.txtInstruction.text?.removeAll()
    }
    
    @IBAction func btnVoiceAddClick(_ sender: Any) {
        if audioRecorder == nil
        {
            numberOfRecords += 1
            arrVoiceInstruction.append(numberOfRecords)
            arridVoiceInstruction.removeAll()
            var stri = 1
            for _ in arrVoiceInstruction {
                arridVoiceInstruction.append(stri)
                stri += 1
            }
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC), AVSampleRateKey : 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

            do
            {
                let filepath = filename.absoluteString.dropFirst(7)
                let stripped = filepath //String(filepath.characters.dropFirst(7))
                print(stripped)
                self.arrVoiceInstructionStr.append(String(stripped))
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                // Configure AVAudioSession
                                do {
                                    try self.recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
                                } catch {
                                    assertionFailure("Failed to configure `AVAAudioSession`: \(error.localizedDescription)")
                                }
                audioRecorder.delegate = self                
                audioRecorder.record(forDuration: 60.00)
            }
            catch
            {
                print("Recoding Fails")
            }
        }else
        {
            audioRecorder.stop()
            collectionVoiceInstructionView.reloadData()
            audioRecorder = nil
        }
    }
    
    //MARK: - Support Method
    func downloadFile(str:String)
    {
        if let audioUrl = URL(string: str) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
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
                            let originPath = documentDirectory.appendingPathComponent(fileName)
                            let destinationPath = documentDirectory.appendingPathComponent("\(self.numberOfRecords).m4a")
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
                                self.collectionVoiceInstructionView.reloadData()
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
    
    func removeInstruction(index: Int) {
        self.arrInstruction.remove(at: index)
        self.collectionInstructionView.reloadData()
        print(self.arrInstruction)
    }
    
    func removeVoiceInstruction(index: Int) {
       
        self.clearPerticularFile(fileNameToDelete: "\(arrVoiceInstruction[index]).m4a")
        
    }
    
    func removeallfile()
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs where fileURL.pathExtension == "m4a" {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }
    
    func clearTempFolder() {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("TeacherWorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.objMarking.worksheetId ?? 0)")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: bFolder.path) {
            try! fileManager.removeItem(atPath: bFolder.path)
        }
        else{
            
        }
    }
    
    func clearPerticularFile(fileNameToDelete:String)
    {
        var filePath = ""
        // Fine documents directory on device
         let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("Local path = \(filePath)")
            arrVoiceInstructionStr = arrVoiceInstructionStr.filter { $0 != filePath }
            print(arrVoiceInstructionStr)
        } else {
            print("Could not find local directory to store file")
            return
        }
        do {
             let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
                self.arrVoiceInstruction.removeAll()
                self.arridVoiceInstruction.removeAll()
                
                self.collectionVoiceInstructionView.reloadData()
                self.GetVoiceInstaruction()
            } else {
                self.collectionVoiceInstructionView.reloadData()
                print("File does not exist")
            }
         
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    func GetVoiceInstaruction()
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs where fileURL.pathExtension == "m4a" {
            
                let name = URL(fileURLWithPath: fileURL.path).lastPathComponent
                let substring1 = name.dropLast(4)
                print(substring1)
                print(name)
                self.arrVoiceInstruction.append(Int(substring1) ?? 0)
//                var stri = 1
//                for _ in arrVoiceInstruction {
//                    arridVoiceInstruction.append(stri)
//                    stri += 1
//                }
//                self.collectionVoiceInstructionView.reloadData()
            }
        } catch  {
            print(error)
            
        }
        var stri = 1
        for _ in arrVoiceInstruction {
            arridVoiceInstruction.append(stri)
            stri += 1
        }
        self.collectionVoiceInstructionView.reloadData()
    }
    
    //MARK: - API Call
    func APICallReAssignWorksheet(){
        
        var arrimgset = [UIImage]()
        
        //Sort array in accesing order.
        self.objWorksheetData.sort { $0.screenshot ?? "" < $1.screenshot ?? "" }
        for i in self.objWorksheetData{
            arrimgset.append(UIImage(contentsOfFile: i.screenshot ?? "")!)
        }
        
        if self.studentId == 0 {
            print("StudentId is 0")
            return
        }
        
//        var base = String()
//
//        for i in self.arrVoiceInstructionStr
//        {
//            if let base64String = try? Data(contentsOf: URL(fileURLWithPath: i)).base64EncodedString() {
//                print(base64String)
//                base = base64String
//            }
//        }
        

        
        var params: [String: Any] = [ : ]
        params["studentId"] = self.studentId
        params["subjectId"] = self.objMarking.subjectId
        params["teacherId"] = Preferance.user.userId ?? 0
        params["subCategoryId"] = self.objMarking.subCategoryId
        params["worksheetId"] = self.objMarking.worksheetId
        params["pdfImages[]"] = arrimgset //pdfImages
        params["eraser"] =  self.isEraser
        params["spellChecker"] = self.isspellChecker
        params["isCompleted"] = "0"
        params["instruction"] = self.arrInstruction
        params["voiceinstruction[]"] = arrVoiceInstructionStr
        params["deviceType"] = MyApp.device_type
        
        APIManager.showPopOverLoader(view: self.view)
        APIManager.shared.callPostWithMultiPartApi(reqURL: URLs.APIURL + getUserTye() + reAssignCompletedWorksheet, parameters: params, showLoader: false) { (jsonData, error) in
            APIManager.hideLoader()
            if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject ?? [String:Any]()){
                if let status = userData.status, status == 1{
                    self.clearTempFolder()
                    self.removeallfile()
                    let alert = UIAlertController(title: APP_NAME, message: userData.message, preferredStyle: .alert)
                    alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
                    let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: {action in
                        if let viewControllers = self.navigationController?.viewControllers{
                            for controller in viewControllers{
                                if controller is TeacherDashboardVC{
                                    self.navigationController?.popToViewController(controller, animated: true)
                                }
                            }
                        }
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(btnOK)
                    self.present(alert, animated: true, completion: nil)

                }
                else{
                    if let msg = jsonData?[APIKey.message].string {
                        showAlert(title: APP_NAME, message: msg)
                    }
                }
            }
        }
    }
    
    func APICallAssignWorksheet(){
        
        print(getDirectory())
//        var base = String()
//        var strvoicearr = [String]()
//        for i in self.arrVoiceInstructionStr
//        {
//            if let base64String = try? Data(contentsOf: URL(fileURLWithPath: i)).base64EncodedString() {
////                print(base64String)
//                strvoicearr.append(base64String)
//                base = base64String
//            }
//        }
            print(self.arrVoiceInstructionStr)
        var params: [String: Any] = [ : ]
        params["studentId"] = self.studentIds
        params["worksheet_id"] = self.worksheet_id
        params["subjectId"] = self.subjectId
        params["category_id"] = self.categoryId
        params["assign_type"] = self.assigntype
        params["assign_status"] = 1
        params["assigned_by"] = (Preferance.user.userType == 0) ?2:1
        params["startDate"] = self.strStartOfWeek//self.startDate
        params["endDate"] = self.strEndOfWeek//self.endDate
        params["instruction"] = self.arrInstruction
        params["eraser"] = 1
        params["spellChecker"] = self.isspellChecker
        params["device_type"] = 1
        params["reAssign"] = 0
        params["voiceinstruction[]"] = self.arrVoiceInstructionStr
        
        
        APIManager.showPopOverLoader(view: self.view)
        APIManager.shared.callPostWithMultiPartApi(reqURL: URLs.APIURL + getUserTye() + doTeacherWorkSheetAssign, parameters: params, showLoader: false) { (jsonData, error) in
            APIManager.hideLoader()
            if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject ?? [String:Any]()){
                if let status = userData.status, status == 1{
                    self.clearTempFolder()
                    self.removeallfile()
                    let alert = UIAlertController(title: APP_NAME, message: userData.message, preferredStyle: .alert)
                    alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
                    let btnOK = UIAlertAction(title: Messages.OK, style: .default, handler: {action in
                        if self.isFromFav {
                            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                            for aViewController in viewControllers {
                                if aViewController is FavouriteVC {
                                    self.navigationController!.popToViewController(aViewController, animated: true)
                                }
                            }
                        }
                        else {
                            if let viewControllers = self.navigationController?.viewControllers{
                                for controller in viewControllers{
                                    if controller is TeacherDashboardVC{
                                        self.navigationController?.popToViewController(controller, animated: true)
                                    }
                                }
                            }
                        }
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(btnOK)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    if let msg = jsonData?[APIKey.message].string {
                        showAlert(title: APP_NAME, message: msg)
                    }
                }
            }
        }
    }
    
    //https://pal.clouddownunder.com.au/api/v1/teacher/teacherWorkSheetAssign
//    func UploadRequest() {
//
//        let myUrl = NSURL(string: "https://pal.clouddownunder.com.au/api/v1/teacher/teacherWorkSheetAssign");
//        let request = NSMutableURLRequest(url:myUrl! as URL);
//        request.httpMethod = "POST";
//
//        var base = String()
//        var strvoicearr = [String]()
//        for i in self.arrVoiceInstructionStr
//        {
//            if let base64String = try? Data(contentsOf: URL(fileURLWithPath: i)).base64EncodedString() {
//                print(base64String)
//                strvoicearr.append(base64String)
//                base = base64String
//            }
//        }
//
//        var params: [String: Any] = [ : ]
//        params["studentId"] = self.studentIds
//        params["worksheet_id"] = self.worksheet_id
//        params["subjectId"] = self.subjectId
//        params["category_id"] = self.categoryId
//        params["assign_type"] = self.assigntype
//        params["assign_status"] = 1
//        params["assigned_by"] = (Preferance.user.userType == 0) ?2:1
//        params["startDate"] = self.strStartOfWeek//self.startDate
//        params["endDate"] = self.strEndOfWeek//self.endDate
//        params["instruction[]"] = self.arrInstruction
//        params["eraser"] = self.isEraser
//        params["spellChecker"] = self.isspellChecker
//        params["reAssign"] = 0
////        params["voiceinstruction[]"] = base
//
//        let boundary = generateBoundaryString()
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(Preferance.user.accessToken ?? "")", forHTTPHeaderField: "Authorization")
//        var passData = Data()
//        for i in self.arrVoiceInstructionStr
//        {
//            if let strData = try? Data(contentsOf: URL(fileURLWithPath: i)){
//                print(strData)
//                passData = strData
//            }
//        }
//        print(params)
//        request.httpBody = createBodyWithParameters(parameters: params, filePathKey: "voiceinstruction[]", imageDataKey: passData as NSData, boundary: boundary, imgKey: "audio") as Data
//        print(request)
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {
//            data, response, error in
//
//                if error != nil {
//                    print("error=\(error!)")
//                    return
//                }
//
////                print response
//                print("response = \(response!)")
//            print("data = \(data!)")
////            print("error = \(error!)")
//
//                // print reponse body
//                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                print("response data = \(responseString!)")
//
//            }
//
//            task.resume()
//        }
    
    func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData, boundary: String, imgKey: String) -> NSData {
            let body = NSMutableData();

            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
            }

            let filename = "\(imgKey).m4a"
            let mimetype = "audio/m4a"

            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey as Data)
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)--\r\n")

            return body
        }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionInstructionView {
            return arrInstruction.count
        }
        else if collectionView == self.collectionVoiceInstructionView {
            return arrVoiceInstruction.count
        }
        return  0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddSubCategoryCell", for: indexPath) as! AddSubCategoryCell
        if collectionView == self.collectionInstructionView {
            cell.lblCategoryName.text = self.arrInstruction[indexPath.row]
            cell.lblCategoryName.textColor = .black
            let height = collectionInstructionView.collectionViewLayout.collectionViewContentSize.height
            if height > 500{
                collectionHightConstrain.constant = (ScreenSize.SCREEN_HEIGHT > 1000) ?500:600
            }
            else{
                collectionHightConstrain.constant = height
            }
            view.layoutIfNeeded()
            cell.btnRemoveCategoryCompletion = {
                self.removeInstruction(index: indexPath.row)
            }
            cell.lblCategoryName.backgroundColor = .clear
        }
        else if collectionView == self.collectionVoiceInstructionView {
            cell.lblCategoryName.text = "Recording \(arridVoiceInstruction[indexPath.row])"
            cell.lblCategoryName.textColor = .black
            let height = collectionVoiceInstructionView.collectionViewLayout.collectionViewContentSize.height
            if height > 500{
                collectionVoiceHeightConstrain.constant = (ScreenSize.SCREEN_HEIGHT > 1000) ?500:600
            }
            else{
                collectionVoiceHeightConstrain.constant = height
            }
            view.layoutIfNeeded()
            cell.btnRemoveVocieCategoryCompletion = {
                self.removeVoiceInstruction(index: indexPath.row)
            }
            cell.lblCategoryName.backgroundColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddSubCategoryCell", for: indexPath) as! AddSubCategoryCell
        if collectionView == self.collectionVoiceInstructionView {
            let path = getDirectory().appendingPathComponent("\(arrVoiceInstruction[indexPath.row]).m4a")
            do
            {
                print(path)
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer.play()
            }catch
            {
                
            }
        }
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        if self.collectionInstructionView == collectionView{
    //            let referencelabel = UILabel()
    //            referencelabel.text = self.arrInstruction[indexPath.row]
    //            referencelabel.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
    //            let size = referencelabel.intrinsicContentSize
    //
    //            if referencelabel.text?.count ?? 0 <= 5 {
    //                return CGSize.init(width: size.width + 50, height: size.height + 15)
    //            }
    //            else if (referencelabel.text?.count)! > 5 && (referencelabel.text?.count)! <= 10 {
    //                return CGSize.init(width: size.width + 60, height: size.height + 15)
    //            }
    //            else {
    //                return CGSize.init(width: size.width + 60, height: size.height + 15)
    //            }
    //        }
    //        else {
    //            return CGSize(width: 40, height: 60)
    //        }
    //    }
}
extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
