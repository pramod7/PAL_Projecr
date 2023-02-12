//
//  CanvasViewController.swift
//  Planner
//
//  Created by Andrea Clare Lam on 31/08/2020.
//  Copyright © 2020 Andrea Clare Lam. All rights reserved.
//

import UIKit
import PencilKit
import SQLite3
import SwiftyJSON
import AVFoundation
import Speech
//import Foundation

protocol passData {
    func delegatePass(img:UIImage)
}

class EditWorksheetViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate ,UINavigationControllerDelegate,CanvasUpdate, AVSpeechSynthesizerDelegate, SFSpeechRecognizerDelegate,UITextViewDelegate, SchoolListDelegate {
    
    //MARK: - Local Variable
    var drawingIndex: Int = 0
    var drawing = PKDrawing()
    let canvasWidth: CGFloat = 768
    let canvasOverscrollHeight: CGFloat = 500
    var dismissimg : ((UIImage,Int,Int,UIImage) -> Void)?
    var setColor = UIColor()
    var setWidth = 0
    var setPen = false
    var setPencil = false
    var setEraser = false
    var panRecognizer: UIPanGestureRecognizer?
    var pinchRecognizer: UIPinchGestureRecognizer?
    var rotateRecognizer: UIRotationGestureRecognizer?
    var gestureRecognizer = UILongPressGestureRecognizer()
    var imgBackground = UIImage()
    var imgViewTag : Int = 0
    var arrTempImage = [[String: Any]]()
    var arrDBMetaDataImg = [[String:Any]]()
    var arrDBMetaDataImgTemp = [[String:Any]]()
    var arrInstructions = [String]()
    var arrVoiceInstructions = [String]()
    var ImagePath = ""
    var screenPath = ""
    var lastRotation : CGFloat = 0
    var worksheetId = 0
    var teacherName = ""
    var UniqueID = 0
    var isoffline = 0
    var subjectId = 0
    var teacherId = ""
    var subCategoryId = 0
    var assigntype = 0
    var eraser = 0
    var spellChecker = 0
    var currentIndex = Int()
    var strInstruction = ""
    var strVoiceInstruction = ""
    var strWorksheet = ""
    var isFromStudent = false
    var isPlaying = false
    var btnGif: UIButton = UIButton()
    var bargif = UIBarButtonItem()
    lazy var theImage = UIImage()
    lazy var texts = [String]()
    lazy var buttons = [UIButton]()
    var extractor: TextExtractor!
    let synthesizer = AVSpeechSynthesizer()
    var txt = ""
    var txtTyping = ""
    var objtextView    = UITextView()
    var objFont = UIFont.Font_EduQLDBeginner(fontsize: 12)
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-AU"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    //MARK: - Outlets
    
    @IBOutlet var pencilFingerButton: UIBarButtonItem!
    @IBOutlet var canvasView: PKCanvasView!
    @IBOutlet var clearCanvasButton: UIBarButtonItem!
    @IBOutlet weak var btnPrn: UIButton!
    @IBOutlet weak var btnPencil: UIButton!
    @IBOutlet weak var btnEraser: UIButton!
    @IBOutlet weak var btnColor: UIButton!
    @IBOutlet weak var btnSpeech: UIButton!
    @IBOutlet weak var btnFont: UIButton!
    @IBOutlet var btnImage: UIButton!
    @IBOutlet var imgCanvasBack: UIImageView!
    @IBOutlet var imgBackGroundView: UIImageView!
    @IBOutlet var objViewMain: UIView!
    @IBOutlet var objViewInner: UIView!
    @IBOutlet weak var objStickerView: JLStickerImageView!
    @IBOutlet weak var btnVoiceToText: UIButton!
    @IBOutlet var imgSpeech: UIImageView!
    @IBOutlet weak var objViewSpeech: UIView!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var lblSpeech: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var txtData: UITextView!
    @IBOutlet weak var btnAddText: UIButton!
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        self.objViewSpeech.isHidden = true
        self.imgBackGroundView.image = imgBackground
        self.setupCanvas()
        self.setupToolpicker()
        self.loadCanvas()
        self.imgSpeech.isHidden = true
        if let nav = self.navigationController{
            if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
                , colorName.trim.count > 0{
                nav.navigationBar.barTintColor = UIColor.hexStringToUIColor(colorName)
            }
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Edit Worksheet", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            
        }
        
        btnMic.setTitle("", for: [])
        btnClose.setTitle("", for: [])
        self.panRecognizer?.delegate = self
        self.imgViewTag = 0
        
        if self.eraser == 0{
            self.btnEraser.isHidden = true
        }
        else{
            self.btnEraser.isHidden = false
        }
        
        if isFromStudent{
            NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationOver(notification:)), name: Notification.Name("NotificationOver"), object: nil)
            
            if isPlaying {
                btnGif = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
                let imgTemp3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "Pal Transperent", withExtension: "gif")!)
                let jeremyGif = UIImage.sd_image(withGIFData: imageData)
                imgTemp3.image = jeremyGif
                imgTemp3.contentMode = .scaleAspectFit
                btnGif.addSubview(imgTemp3)
                btnGif.addTarget(self, action: #selector(btnsettingClick), for: .touchUpInside)
                bargif = UIBarButtonItem(customView: btnGif)
                self.navigationItem.rightBarButtonItems = [bargif]
            }
        }
        
        self.txtData.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        var strImgGet = ""
        for i in self.arrDBMetaDataImg {
            
            let getImage = UIImageView()
            strImgGet = (i["frame"] as? String)!
            getImage.frame = realRect(str: strImgGet)
            let ss = i["image"] as? String
            getImagee(imageViews: getImage, pathh: ss ?? "")
            //                let angle =  i["angle"]
            //                let tr = CGAffineTransform.identity.rotated(by: angle as! CGFloat)
            //              getImage.transform = tr
            getImage.backgroundColor = .lightGray
            getImage.contentMode = .scaleAspectFill
            getImage.isUserInteractionEnabled = true
            gestureRecognizer.delegate = self
            var panGester: UIPanGestureRecognizer?
            var pinchGester: UIPinchGestureRecognizer?
            var rotateGester: UIRotationGestureRecognizer?
            var longPressGester = UILongPressGestureRecognizer()
            longPressGester = UILongPressGestureRecognizer(target: self, action: #selector(self.imgLongPressed(_:)))
            panGester = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
            pinchGester = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(recognizer:)))
            rotateGester = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotate(recognizer:)))
            getImage.addGestureRecognizer(panGester!)
            getImage.addGestureRecognizer(rotateGester!)
            getImage.addGestureRecognizer(pinchGester!)
            getImage.addGestureRecognizer(longPressGester)
            let imgX = getImage.frame.origin.x;
            let imgY = getImage.frame.origin.y;
            let imgWidth = getImage.frame.width
            let imgHight = getImage.frame.height
            
            let lineRect = CGRect(x: imgX, y: imgY, width: imgWidth, height: imgHight)
            
            getImage.tag = imgViewTag
            imgViewTag = imgViewTag + 1
            let rectAsString = NSCoder.string(for: lineRect)
            let getteddict = ["image": ss ?? "", "frame" : rectAsString, "isImage" : "1" ]
            self.arrTempImage.append(getteddict)
            print("\(self.arrTempImage)........................after getting andf add new ")
            self.imgCanvasBack.addSubview(getImage)
            
            getImage.becomeFirstResponder()
        }
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Configure the SFSpeechRecognizer object already
        // stored in a local member variable.
        speechRecognizer.delegate = self
        
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.btnMic.isEnabled = true
                case .denied:
                    self.btnMic.isEnabled = false
                case .restricted:
                    self.btnMic.isEnabled = false
                case .notDetermined:
                    self.btnMic.isEnabled = false
                default:
                    self.btnMic.isEnabled = false
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _: JLStickerLabelView = objStickerView.currentlyEditingLabel {
            objStickerView.currentlyEditingLabel.hideEditingHandlers()
        }
        updateCanvasAndImage()
        let screenshot = objViewMain.screenshot
        let Backscreenshot = objViewInner.screenshot
        if let _ = self.dismissimg{
            self.dismissimg!(screenshot, drawingIndex - 1, UniqueID, Backscreenshot)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        objStickerView.cleanup()
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    //MARK: - Canvas func
    func updateCanvasAndImage() {
        let result = WorksheetDBManager.shared.check(drawindex: UniqueID)
        updateAndSaveCanvas(result: result)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        updateCanvasAndImage()
        let screenshot = objViewMain.screenshot
        let Backscreenshot = objViewInner.screenshot
        if let _ = self.dismissimg{
            self.dismissimg!(screenshot, drawingIndex - 1, UniqueID, Backscreenshot)
        }
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        //    updateContentSizeForDrawing()
    }
    
    //MARK: - btn Click
    @objc func tapDone(sender: Any) {
        print("Done")
        
        if self.txtData.text != "TAP TO TYPE"
        {
            if self.txtData.text.count > 0
            {
            self.audioEngine.pause()
            recognitionRequest?.endAudio()
            btnVoiceToText.isEnabled = true
            self.objStickerView.addLabel()
            self.addtext(text: self.txtData.text)
            self.objViewSpeech.isHidden = true
            return
            }
        }
        self.view.endEditing(true)
    }
    
    @objc func btnsettingClick(_ sender: Any) {
    }
    
    @objc func methodOfReceivedNotificationOver(notification: Notification) {
        self.navigationItem.rightBarButtonItems = []
    }
    
    
    @objc func btnBackClick(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = false
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupCanvas() {
        canvasView.delegate = self
        canvasView.alwaysBounceVertical = true
        canvasView.allowsFingerDrawing = true
        canvasView.isScrollEnabled = false
        self.setColor = .black
        self.setWidth = 5
        self.setPen = true
        self.canvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: setColor, width: CGFloat(setWidth))
    }
    
    func updateContentSizeForDrawing() {
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + self.canvasOverscrollHeight) * canvasView.zoomScale)
        }
        else {
            contentHeight = canvasView.bounds.height
        }
        
        canvasView.contentSize = CGSize(width: canvasWidth * canvasView.zoomScale , height: contentHeight)
    }
    
    func setupToolpicker() {
        if let window = parent?.view.window,
           let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(false, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            canvasView.becomeFirstResponder()
        }
    }
    
    func loadCanvas() {
        
        let result = WorksheetDBManager.shared.check(drawindex: self.UniqueID)
        print("Fetched worksheet:\(UniqueID) info result : \(result)")
        if result.count > 0{
            if worksheetId == result[0].worksheetID && UniqueID == result[0].uniduqId{
                loadOldDrawing(result: result)
            }
            else{
                createNewCanvas()
            }
        }
        else{
            createNewCanvas()
        }
    }
    
    func canvasDoesNotExist(result: [Canvas]) -> Bool {
        if Mirror(reflecting: result).children.count == 0 {
            return true
        }
        return false
    }
    
    func createNewCanvas() {
        print("CREATING NEW CANVAS")
        
        let _ = WorksheetDBManager.shared.insert(drawindex: drawingIndex, canvasDrawing: drawing.dataRepresentation(), worksheetID: worksheetId, teacherName: teacherName, canvasMetadata: "", isoffline: isoffline, uniduqId: UniqueID,subjectId: subjectId, teacherId: teacherId, subCategoryId: subCategoryId, assigntype: assigntype, eraser: eraser, spellChecker: spellChecker, instruction: self.strInstruction, voiceInstrcution: strVoiceInstruction, worksheetName: self.strWorksheet)
        
        print("Data Inserted through Insert Query")
    }
    
    func loadOldDrawing(result: [Canvas]) {
        print("LOAD EXISTING CANVAS")
        
        let canvas = Canvas(id: result[0].id, drawindex: drawingIndex, canvasDrawing: result[0].canvasDrawing,worksheetID: worksheetId, teacherName: teacherName, uniduqId: UniqueID, canvasMetadata: result[0].canvasMetadata, isoffline: isoffline,subjectId: subjectId, teacherId: teacherId, subCategoryId: subCategoryId, assigntype: assigntype, eraser: eraser, spellChecker: spellChecker, instrcution: self.strInstruction, Voiceinstrcution: strVoiceInstruction, worksheetName: self.strWorksheet)
        
        do {
            var oldDrawing = PKDrawing()
            
            try oldDrawing = PKDrawing.init(data: canvas.canvasDrawing)
            canvasView.drawing = oldDrawing
            
            let arrGet = self.convertToDictionary(text: canvas.canvasMetadata)
            self.arrDBMetaDataImg = arrGet ?? [[String:Any]]()
            print("Canvas MetaDara : \(self.arrDBMetaDataImg)")
            self.CheckFolder()
        }
        catch {
            print("Error info: \(error)")
        }
    }
    
    func setCanvasScales() {
        let canvasScale = canvasView.bounds.width / canvasWidth
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale
    }
    
    func updateAndSaveCanvas(result: [Canvas]) {
        var arrImgUpdated = [[String:Any]]()
        let _ = arrTempImage.map { item in
            if let itemId = item["isImage"]{
                if(itemId as! String == "1"){
                    arrImgUpdated.append(item)
                }
            }
            return
        }
        if !canvasDoesNotExist(result: result) {
            if !Connectivity.isConnectedToInternet() {
                let canvas = Canvas(id: result[0].id, drawindex: drawingIndex, canvasDrawing: canvasView.drawing.dataRepresentation(), worksheetID: worksheetId, teacherName: teacherName, uniduqId: UniqueID, canvasMetadata: arrImgUpdated.toJSONString(), isoffline: 0, subjectId: subjectId, teacherId: teacherId, subCategoryId: subCategoryId, assigntype: assigntype, eraser: eraser, spellChecker: spellChecker, instrcution: self.strInstruction, Voiceinstrcution: strVoiceInstruction, worksheetName: self.strWorksheet)
                print(canvas)
                WorksheetDBManager.shared.UPDATE(canvas: canvas)
            }
            else{
                let canvas = Canvas(id: result[0].id, drawindex: drawingIndex, canvasDrawing: canvasView.drawing.dataRepresentation(), worksheetID: worksheetId, teacherName: teacherName, uniduqId: UniqueID, canvasMetadata: arrImgUpdated.toJSONString(), isoffline: 0, subjectId: subjectId, teacherId: teacherId, subCategoryId: subCategoryId, assigntype: assigntype, eraser: eraser, spellChecker: spellChecker, instrcution: self.strInstruction, Voiceinstrcution: strVoiceInstruction, worksheetName: self.strWorksheet)
                print(canvas)
                WorksheetDBManager.shared.UPDATE(canvas: canvas)
            }
            
        }
    }
    
    func canvasIsEmpty() -> Bool {
        if canvasView.drawing.bounds.isEmpty {
            return true
        }
        return false
    }
    
    //    func deleteCurrentCanvas() {
    //        let result = CanvasManager.main.check(drawindex: UniqueID)
    //        if canvasIsEmpty() {
    //            CanvasManager.main.delete(canvas: result[0])
    //        }
    //    }
    
    //MARK: - Support Method
    func convertToDictionary(text: String) -> [[String: Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func CheckTool(){
        if self.setPen{
            self.canvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: self.setColor, width: CGFloat(self.setWidth))
        }
        else if self.setPencil{
            self.canvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: self.setColor, width: CGFloat(self.setWidth))
            
        }
        else{
            self.canvasView.tool = PKEraserTool(PKEraserTool.EraserType.bitmap)
        }
    }
    
    //MARK: - support method
    func ImageFromGallery() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(image , animated: true)
    }
    
    func ImageFromCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) == true {
            checkForCameraPermission { (isPermit) in
                DispatchQueue.main.async { // Correct
                if isPermit{
                    
                        let image = UIImagePickerController()
                        image.delegate = self
                        image.sourceType = UIImagePickerController.SourceType.camera
                        self.present(image , animated: true)
                    }
                
                else{
                    cameraPermissionAlert(from: self, showCancel: true)
                }
                }
            }
        } else {
            print("Camera is not available..")
        }
    }
    
    //MARK: - Add Image on Cancas and save in Doc Directory
    // add images on canvas func
    func addImage(image: UIImage){
        
        let imageee = UIImageView()
        imageee.frame = CGRect(x: 200, y: 200, width: 400, height: 200)
        imageee.isUserInteractionEnabled = true
        imageee.backgroundColor = .lightGray
        imageee.contentMode = .scaleAspectFill
        gestureRecognizer.delegate = self
        self.gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.imgLongPressed(_:)))
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        self.pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(recognizer:)))
        self.rotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotate(recognizer:)))
        
        imageee.addGestureRecognizer(panRecognizer!)
        imageee.addGestureRecognizer(rotateRecognizer!)
        imageee.addGestureRecognizer(pinchRecognizer!)
        imageee.addGestureRecognizer(gestureRecognizer)
        imageee.image = image
        imageee.tag = imgViewTag
        canvasView.isUserInteractionEnabled = false
        self.imgCanvasBack.addSubview(imageee)
        imageee.becomeFirstResponder()
        
        let imgX = imageee.frame.origin.x;
        let imgY = imageee.frame.origin.y;
        let imgWidth = imageee.frame.width
        let imgHight = imageee.frame.height
        
        let lineRect = CGRect(x: imgX, y: imgY, width: imgWidth, height: imgHight)
        let tempPath = self.saveImageDocumentDirectory(image: image, imageName: "\(imgViewTag).jpeg", name: "\(drawingIndex)")
        
        let rectAsString = NSCoder.string(for: lineRect)
        var canvasMetaDataDisc = [String : Any]()
        canvasMetaDataDisc = ["image" : tempPath, "frame" : rectAsString, "isImage" : "1", "imgPosition" : self.arrTempImage.count]
        self.arrTempImage.append(canvasMetaDataDisc)
    }
    
    //  save added images on canvas to Document Directory
    func saveImageDocumentDirectory(image: UIImage, imageName: String, name: String) -> String{
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(self.worksheetId)")
        let cFolder = bFolder.appendingPathComponent("Screenshot")
        let dFolder = bFolder.appendingPathComponent("Images")
        let eFolder = bFolder.appendingPathComponent("SubMetaData")
        let fFolder = eFolder.appendingPathComponent(name)
        let GFolder = cFolder.appendingPathComponent("AllScreenshot")
        
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
        
        let url = NSURL(string: fFolder.path)
        let imagePath = url!.appendingPathComponent(imageName)
        let urlString: String = imagePath!.absoluteString
        let imageData = image.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
        return urlString
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // get back added images from document Directory
    func getImagee(imageViews : UIImageView , pathh : String){
        let fileManager = FileManager.default
        let imagePAth = pathh
        if fileManager.fileExists(atPath: imagePAth){
            imageViews.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("no image")
        }
    }
    
    // get cgRect string into cgRect back
    func realRect(str : String) -> CGRect {
        return NSCoder.cgRect(for: str)
    }
    
    //MARK: - Fetched canvas MeataData IMG from doc directory
    func CheckFolder(){
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootPath = docDirectory.appendingPathComponent("WorkSheetMetaData")
        print(rootPath)
        let idPath = rootPath.appendingPathComponent("\(self.worksheetId)")
        print(idPath)
        let mainPath = idPath.appendingPathComponent("SubMetaData")
        print(mainPath)
        let subMainPath = mainPath.appendingPathComponent("\(self.currentIndex + 1)")
        print(subMainPath)
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: subMainPath.path) {
            print("Path not available")
        }
        else{
            do {
                // Get the directory contents urls (including subfolders urls)
                let canvasMetaData = try FileManager.default.contentsOfDirectory(at: subMainPath, includingPropertiesForKeys: nil)
                
                var count = Int()
//                for i in canvasMetaData{
//                    print(i)
//                    self.arrDBMetaDataImg[count]["image"] = i.path
//                    count = count + 1
//                }
            } catch {
                print(error)
            }
        }
    }
    
    //MARK: - Gester func
    // images Gester func for longPress,pan,rotete,pinch
    @objc func imgLongPressed(_ sender: UILongPressGestureRecognizer?) {
        
        if sender?.state == .began {
        }
        else if sender?.state == .changed {
        }
        else if sender?.state == .ended {
            
            let alert = UIAlertController(title: "Delete?", message: "Want to Delete",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Delete",style: .default,handler: {(_: UIAlertAction!) in
                //Sign out action
                if let button = sender?.view as? UIImageView {
                    print(button.tag)
                    button.removeFromSuperview()
                    
                    self.arrTempImage[button.tag].updateValue("\(0)", forKey: "isImage")
                    print("new array \(self.arrTempImage)")
                }
                
            }))
            self.present(alert, animated: true, completion: nil)
            //print(point as Any)
        }
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        let translation = recognizer.translation(in: view)
        
        // 2
        guard let gestureView = recognizer.view else {
            return
        }
        
        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        
        let fileView = recognizer.view
        print(fileView?.frame ?? 0)
        
        if recognizer.state == .ended{
            if let button = recognizer.view as? UIImageView {
                print(button.tag)
                let imgX = button.frame.origin.x;
                let imgY = button.frame.origin.y;
                let imgWidth = button.frame.width
                let imgHight = button.frame.height
                
                let lineRect = CGRect(x: imgX, y: imgY, width: imgWidth, height: imgHight)
                
                let rectAsString = NSCoder.string(for: lineRect)
                self.arrTempImage[button.tag].updateValue(rectAsString, forKey: "frame")
                
                print("new array \(self.arrTempImage)")
            }
        }
        // 3
        recognizer.setTranslation(.zero, in: view)
        
    }
    
    // handle UIPinchGestureRecognizer
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            
            recognizer.view?.transform = (recognizer.view?.transform.scaledBy(x: recognizer.scale, y: recognizer.scale))!
            recognizer.scale = 1.0
        }
        
    }
    
    // handle UIRotationGestureRecognizer
    @objc func handleRotate(recognizer: UIRotationGestureRecognizer) {
        
        if recognizer.state == .began || recognizer.state == .changed {
            if let button = recognizer.view as? UIImageView {
                print("\(recognizer.rotation).........rrrrrrrr")
                button.transform = (button.transform.rotated(by: recognizer.rotation))
                recognizer.rotation = 0.0
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first
        {
            
        }
    }
    
    //MARK: - btn action
    
    @IBAction func btnPenClick(_ sender: Any) {
        if let _: JLStickerLabelView = objStickerView.currentlyEditingLabel {
            objStickerView.currentlyEditingLabel.hideEditingHandlers()
        }
//        objStickerView.currentlyEditingLabel.hideEditingHandlers()
        self.ClearImage()
        
        self.objViewSpeech.isHidden = true
        self.imgSpeech.isHidden = true
        canvasView.isUserInteractionEnabled = true
        self.setPen = false
        self.setPencil = true
        self.setEraser = false
        let nextVC = Size_ColorSelectionVC.instantiate(fromAppStoryboard: .Student)
        nextVC.isFromSize = true
        nextVC.dismisssSize = { (size) in
            DispatchQueue.main.async {
                self.canvasView.becomeFirstResponder()
                self.setWidth = size
                self.canvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: self.setColor, width: CGFloat(self.setWidth))
            }
        }
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            nextVC.preferredContentSize = CGSize(width: nextVC.arr.count * 80,height: 40)
            popover.permittedArrowDirections = .up
            popover.sourceView = self.btnPrn
            popover.sourceRect = self.btnPrn!.bounds
        }
        self.present(nav, animated: true, completion: nil)
        self.view.endEditing(true)
    }
    
    @IBAction func btnPencilClick(_ sender: Any) {
        if let _: JLStickerLabelView = objStickerView.currentlyEditingLabel {
            objStickerView.currentlyEditingLabel.hideEditingHandlers()
        }
        self.ClearImage()
        self.objViewSpeech.isHidden = true
        self.imgSpeech.isHidden = true
        canvasView.isUserInteractionEnabled = true
        self.setPen = true
        self.setPencil = false
        self.setEraser = false
        let vc  =  self.storyboard?.instantiateViewController(identifier: "Size_ColorSelectionVC") as! Size_ColorSelectionVC
        vc.isFromSize = true
        vc.dismisssSize = { (size) in
            DispatchQueue.main.async {
                self.canvasView.becomeFirstResponder()
                self.setWidth = size
                self.canvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: self.setColor, width: CGFloat(self.setWidth))
            }
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            vc.preferredContentSize = CGSize(width: vc.arr.count * 80,height: 40)
            popover.permittedArrowDirections = .up
            popover.sourceView = self.btnPencil
            popover.sourceRect = self.btnPencil.bounds
        }
        self.present(nav, animated: true, completion: nil)
        self.view.endEditing(true)
    }
    
    @IBAction func btnFontClick(_ sender: Any) {
        if let _: JLStickerLabelView = objStickerView.currentlyEditingLabel {
            objStickerView.currentlyEditingLabel.hideEditingHandlers()
        }
        self.ClearImage()
        self.objViewSpeech.isHidden = true
        self.imgSpeech.isHidden = true
        canvasView.isUserInteractionEnabled = true
        
        let nextVC = SchoolListVC.instantiate(fromAppStoryboard: .PopOverStoryboard)
        nextVC.delegate = self
        nextVC.isFromFont = true
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            nextVC.preferredContentSize = CGSize(width: 400,height: 360)
            popover.permittedArrowDirections = .unknown
            popover.sourceView = self.btnFont
            popover.sourceRect = self.btnFont.bounds
        }
        self.present(nav, animated: true, completion: nil)
        self.view.endEditing(true)
    }
    
    @IBAction func btnEraserClick(_ sender: Any) {
        if let _: JLStickerLabelView = objStickerView.currentlyEditingLabel {
            objStickerView.currentlyEditingLabel.hideEditingHandlers()
        }
        self.ClearImage()
        self.objViewSpeech.isHidden = true
        self.imgSpeech.isHidden = true
        canvasView.isUserInteractionEnabled = true
        self.setPen = false
        self.setPencil = false
        self.setEraser = true
        self.canvasView.tool = PKEraserTool(PKEraserTool.EraserType.bitmap)
    }
    
    @IBAction func btnColorClick(_ sender: Any) {
        if let _: JLStickerLabelView = objStickerView.currentlyEditingLabel {
            objStickerView.currentlyEditingLabel.hideEditingHandlers()
        }
        self.ClearImage()
        self.objViewSpeech.isHidden = true
        self.imgSpeech.isHidden = true
        canvasView.isUserInteractionEnabled = true
        let vc  =  self.storyboard?.instantiateViewController(identifier: "Size_ColorSelectionVC") as! Size_ColorSelectionVC
        vc.isFromSize = false
        vc.dismisss = { (Bool,color) in
            DispatchQueue.main.async {
                self.canvasView.becomeFirstResponder()
                self.setColor = color
                self.CheckTool()
            }
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            vc.preferredContentSize = CGSize(width: 380,height: 160)
            popover.permittedArrowDirections = .up
            popover.sourceView = self.btnColor
            popover.sourceRect = self.btnColor.bounds
        }
        self.present(nav, animated: true, completion: nil)
        self.view.endEditing(true)
    }
    
    @IBAction func btnImageClick(_ sender: Any) {
        if let _: JLStickerLabelView = objStickerView.currentlyEditingLabel {
            objStickerView.currentlyEditingLabel.hideEditingHandlers()
        }
        self.ClearImage()
        self.objViewSpeech.isHidden = true
        self.objStickerView.isUserInteractionEnabled = false
        self.imgCanvasBack.isUserInteractionEnabled = true
        self.imgSpeech.isHidden = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        let Camera = UIAlertAction(title: "Capture photo", style: .default) {(action) in
            self.ImageFromCamera()
        }
        let Gallery = UIAlertAction(title: "Choose from gallery", style: .default) {(action) in
            self.ImageFromGallery()
        }
        let Cancel = UIAlertAction(title: Messages.CANCEL, style: .default){(action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        Camera.setValue(UIColor.darkGray, forKey: "titleTextColor")
        Gallery.setValue(UIColor.darkGray, forKey: "titleTextColor")
        Cancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(Cancel)
        if let popover = alert.popoverPresentationController {
            alert.preferredContentSize = CGSize(width: 400,height: 360)
            popover.permittedArrowDirections = .up
            popover.sourceView = self.btnImage
            popover.sourceRect = self.btnImage.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSpeechClick(_ sender: Any) {
        if let _: JLStickerLabelView = objStickerView.currentlyEditingLabel {
            objStickerView.currentlyEditingLabel.hideEditingHandlers()
        }
        self.ClearImage()
        self.objViewSpeech.isHidden = true
        self.imgSpeech.isHidden = false
        let screenshot = objViewMain.screenshot
        self.theImage = screenshot.fixedOrientation()
        self.imgSpeech.image = screenshot.fixedOrientation()
        self.extractText()
    }
    
    @IBAction func btnVoiceToTextClicked(_ sender: Any) {
        
        self.ClearImage()
        self.objViewSpeech.isHidden = true
        self.imgSpeech.isHidden = true
        self.imgCanvasBack.isUserInteractionEnabled = false
        self.objStickerView.isUserInteractionEnabled = true
        self.btnAddText.isHidden = true
        self.btnMic.isHidden = false
        btnMic.setImage(UIImage(named: "Start"), for: UIControl.State.normal)
        txtTyping = ""
        txtData.text = "TAP TO TYPE"
        txtData.textColor = .white
        self.objViewSpeech.isHidden = false
    }
    
    @IBAction func btnMicClicked(_ sender: Any) { 
        if audioEngine.isRunning {
            audioEngine.stop()
            btnMic.isHidden = true
            btnAddText.isHidden = false
            btnMic.setImage(UIImage(named: "Start"), for: UIControl.State.normal)
        } else {
            do {
                try startRecording()
                btnMic.setImage(UIImage(named: "Stop"), for: UIControl.State.normal)
            } catch {
                print("Recording Not Available")
            }
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        
        audioEngine.stop()
        recognitionRequest?.endAudio()
        btnVoiceToText.isEnabled = true
        self.objViewSpeech.isHidden = true
        
    }
    
    @IBAction func btnAddText(_ sender: Any) {
        
        if self.txtData.text == "TAP TO TYPE"
        {
            self.audioEngine.stop()
            recognitionRequest?.endAudio()
            btnVoiceToText.isEnabled = false
            self.txtData.text = ""
            self.objViewSpeech.isHidden = true
            return
        }else{
            self.audioEngine.pause()
            recognitionRequest?.endAudio()
            btnVoiceToText.isEnabled = false
            
            self.objStickerView.addLabel()
            self.addtext(text: self.txtData.text)
//            self.txtData.text = ""
            self.objViewSpeech.isHidden = true
            return
        }
        
//        audioEngine.stop()
//        recognitionRequest?.endAudio()
//        btnVoiceToText.isEnabled = false
//
//        self.objStickerView.addLabel()
//        self.addtext(text: self.txtData.text)
//        self.txtData.text = ""
//        self.objViewSpeech.isHidden = true
        
    }
    
    
    func saveCount(strText: String) {
        
    }
    
    func saveText(objSchool: SchoolListModel) {
        
    }

    func saveFont(SelectedFont: Int) {
        if SelectedFont == 0
        {
            objFont = UIFont.Font_EduQLDBeginner(fontsize: 25)
        }else if SelectedFont == 1
        {
            objFont = UIFont.Font_EduNSWACTFoundation(fontsize: 25)
        }else if SelectedFont == 2
        {
            objFont = UIFont.Font_EduVICWANTBeginner(fontsize: 25)
        }else if SelectedFont == 3
        {
            objFont = UIFont.Font_EduSABeginner(fontsize: 25)
        }else if SelectedFont == 4
        {
            objFont = UIFont.Font_EduTASBeginner(fontsize: 25)
        }else if SelectedFont == 5
        {
            objFont = UIFont.Font_kiwischoolhandwritingregular(fontsize: 25)
        }
    }
    //MARK: Voice to Text
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [self] result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                txt = result.bestTranscription.formattedString
                if txtTyping != ""
                {
                    txtData.text = txtTyping + " " + txt
                }else{
                    txtData.text = txt
                }
                
                txtData.textColor = .white
                isFinal = result.isFinal
                print("Text \(result.bestTranscription.formattedString)")
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.btnVoiceToText.isEnabled = true
            }
        }
        
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
//        txtData.text = "TAP TO TYPE"
//        txtData.textColor = .lightGray
        // Let the user know to start talking.
        
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            btnVoiceToText.isEnabled = true
        } else {
            btnVoiceToText.isEnabled = false
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        txtTyping = textView.text
        return textView.text.count + (text.count - range.length) <= 100
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.white {
            if textView.text == "TAP TO TYPE"{
                textView.text = nil
            }
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "TAP TO TYPE"
            textView.textColor = UIColor.white
        }
    }
    
    func addtext(text:String)
    {
        //Modify the Label
        canvasView.isUserInteractionEnabled = false
        print(text)
        var data = text
        if data.count > 50
        {
            data.insert("\n", at: data.index(data.startIndex, offsetBy: 50))
        }
        
        
        objStickerView.currentlyEditingLabel.labelTextView?.MinfontSize = 15
        objStickerView.currentlyEditingLabel.labelTextView?.MaxfontSize = 33
        objStickerView.currentlyEditingLabel.labelTextView?.text = data
        objStickerView.currentlyEditingLabel.labelTextView?.isEditable = false
        objStickerView.currentlyEditingLabel.labelTextView?.backgroundColor = .clear
        objStickerView.currentlyEditingLabel.labelTextView?.textColor = self.setColor
        objStickerView.textColor = self.setColor//UIColor.black
        objStickerView.textAlpha = 1
        objStickerView.currentlyEditingLabel.closeView!.image = UIImage(named: "cancel")
        objStickerView.currentlyEditingLabel.rotateView?.image = UIImage(named: "rotate-option")
        objStickerView.currentlyEditingLabel.border?.strokeColor = UIColor.white.cgColor
        objStickerView.currentlyEditingLabel.labelTextView?.font = objFont
        objStickerView.currentlyEditingLabel.labelTextView?.becomeFirstResponder()
        objStickerView.currentlyEditingLabel.Justsetup()
        
    }
    
    //MARK: Image to text speech
    
    @objc func ClearImage() {
        // remove buttons from the view and remove the elements from the button and recognized text arrays
        buttons.forEach { (button) in
            button.removeFromSuperview()
        }
        synthesizer.stopSpeaking(at: .immediate)
        self.buttons.removeAll()
        self.texts.removeAll()
        print("Btn Count \(self.buttons.count)")
        print("Text Count \(self.texts.count)")
        // get imageView empty
        imgSpeech.image = nil
    }
    
    private func extractText() {
        // start to extract texts on the image
        extractor = TextExtractor(image: self.theImage, viewFrame: imgSpeech.frame)
        extractor.extractTextBlocks { (textblocks) in
            var counter = 0
            textblocks.forEach({ (block) in
                self.createButtonsAndTexts(blockFrame: block.frame, blockText: block.text, buttonTag: counter)
                counter += 1
            })
        }
    }
    
    private func createButtonsAndTexts(blockFrame: CGRect, blockText: String, buttonTag: Int) {
        // add block texts to show on textView
        self.texts.append(blockText)
        // create button properties for each block
        let aButton = UIButton()
        aButton.alpha = 0.7
        aButton.backgroundColor = UIColor(named: "Color_appTheme")
        aButton.tag = buttonTag
        aButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        buttons.append(aButton)
        
        print("Btn Count \(self.buttons.count)")
        print("Text Count \(self.texts.count)")
        // add buttons the main view
        DispatchQueue.main.async {
            self.view.addSubview(aButton)
            aButton.frame = blockFrame
        }
    }
    
    @objc fileprivate func buttonTapped(sender: UIButton) {
        // let the background color of the selected frame be green and others red
        self.buttons.forEach { (button) in
            button.backgroundColor = UIColor(named: "Color_appTheme")
        }
        sender.backgroundColor = .green
        // show the text on the textView
        let utterance = AVSpeechUtterance(string: texts[sender.tag])
        utterance.voice = AVSpeechSynthesisVoice(language: "en-AU") //en-IN
        utterance.pitchMultiplier = 1.2
        utterance.rate   = 0.5
        synthesizer.stopSpeaking(at: .immediate)
        MusicPlayer.instance.pause()
        synthesizer.speak(utterance)
        print(self.texts[sender.tag])
    }
    
    //MARK: - UIImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImage(image: pickedImage)
            imgViewTag = imgViewTag + 1
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: -
}
extension UIView {
    
    var screenshot: UIImage{
        
        UIGraphicsBeginImageContext(self.frame.size);
        let context = UIGraphicsGetCurrentContext();
        self.layer.render(in: context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return screenShot
    }
    
}
extension Collection where Iterator.Element == [String: Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String: Any]],
           let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}
extension UIImageView {
    /// Helper to get pre transform frame
    var originalFrame: CGRect {
        let currentTransform = transform
        transform = .identity
        let originalFrame = frame
        transform = currentTransform
        return originalFrame
    }
    
    /// Helper to get point offset from center
    func centerOffset(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x - center.x, y: point.y - center.y)
    }
    
    /// Helper to get point back relative to center
    func pointRelativeToCenter(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x + center.x, y: point.y + center.y)
    }
    
    /// Helper to get point relative to transformed coords
    func newPointInView(_ point: CGPoint) -> CGPoint {
        // get offset from center
        let offset = centerOffset(point)
        // get transformed point
        let transformedPoint = offset.applying(transform)
        // make relative to center
        return pointRelativeToCenter(transformedPoint)
    }
    
    var newTopLeft: CGPoint {
        return newPointInView(originalFrame.origin)
    }
    
    var newTopRight: CGPoint {
        var point = originalFrame.origin
        point.x += originalFrame.width
        return newPointInView(point)
    }
    
    var newBottomLeft: CGPoint {
        var point = originalFrame.origin
        point.y += originalFrame.height
        return newPointInView(point)
    }
    
    var newBottomRight: CGPoint {
        var point = originalFrame.origin
        point.x += originalFrame.width
        point.y += originalFrame.height
        return newPointInView(point)
    }
}
extension String {
    func first(char:Int) -> String {
        return String(self.prefix(char))
    }
}
extension UITextView {

    func addDoneButton(title: String, target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
