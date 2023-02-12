//
//  TeacherWorksheetWritingVC.swift
//  PAL
//
//  Created by Andrea Clare Lam on 31/08/2020.
//  Copyright © 2020 Andrea Clare Lam. All rights reserved.
//

import UIKit
import PencilKit
import SwiftyJSON
//import Foundation

class TeacherWorksheetWritingVC: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate , UINavigationControllerDelegate, CanvasUpdate {
    
    //MARK: - Local Variable
    var selectedIndex: Int = 0
    var drawing = PKDrawing()
    let canvasWidth: CGFloat = 768
    let canvasOverscrollHeight: CGFloat = 500
    var dismissimg : ((UIImage,Int,Int) -> Void)?
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
    var canvasMetaDataDisc = [String : Any]()
    var isImage = Int()
    var arrImgUpdated = [[String:Any]]()
    var arrImgGet = [[String:Any]]()
    var arrInstructions = [String]()
    var strImgGet = ""
    var imgPath = String()
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
    var eraser: Int = 0
    var spellChecker: Int = 0
    var strInstruction = ""
    var strWorksheet = ""
    
    //MARK: - Outlets
    @IBOutlet var pencilFingerButton: UIBarButtonItem!
    @IBOutlet var objCanvasView: PKCanvasView!
    @IBOutlet var clearCanvasButton: UIBarButtonItem!
    @IBOutlet weak var btnPencilColor: UIButton!
    @IBOutlet weak var btnPencil: UIButton!
    @IBOutlet weak var btnEraser: UIButton!
    @IBOutlet weak var btnAudio: UIButton!
    @IBOutlet var btnImageSelection: UIButton!
    @IBOutlet var imgCanvasBack: UIImageView!
    @IBOutlet var objViewMain: UIView!
    @IBOutlet var nslcStackViewWidth: NSLayoutConstraint!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgCanvasBack.image = self.imgBackground
        self.setupCanvas()
        self.setupToolpicker()
        
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
        
        //StackView item settings
        self.btnAudio.isHidden = true
        self.btnImageSelection.isHidden = true
        self.nslcStackViewWidth.constant = 3 * 140
        
//        self.btnEraser.backgroundColor = .red
//        self.btnPencilColor.backgroundColor = .yellow
//        self.btnPencil.backgroundColor = .magenta
        self.panRecognizer?.delegate = self
        self.imgViewTag = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        for i in arrImgGet {
            
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
            isImage = 1
            imgViewTag = imgViewTag + 1
            let rectAsString = NSCoder.string(for: lineRect)
            let getteddict = ["image": ss ?? "", "frame" : rectAsString, "isImage" : "\(isImage)" ]
            arrTempImage.append(getteddict)
            print("\(arrTempImage)........................after getting andf add new ")
            self.objCanvasView.addSubview(getImage)
            
            getImage.becomeFirstResponder()
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let screenshot = objViewMain.screenshot
        if let _ = self.dismissimg{
            self.dismissimg!(screenshot, self.selectedIndex - 1, UniqueID)
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Canvas func
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print("canvasViewDrawingDidChange")
    }
    
    @objc func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupCanvas() {
        self.objCanvasView.delegate = self
        self.objCanvasView.alwaysBounceVertical = true
        self.objCanvasView.allowsFingerDrawing = true
        self.objCanvasView.isScrollEnabled = false
        self.setColor = .black
        self.setWidth = 5
        self.setPen = true
        self.objCanvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: setColor, width: CGFloat(setWidth))
    }
    
    func updateContentSizeForDrawing() {
        let drawing = self.objCanvasView.drawing
        let contentHeight: CGFloat
        
        if !drawing.bounds.isNull {
            contentHeight = max(self.objCanvasView.bounds.height, (drawing.bounds.maxY + self.canvasOverscrollHeight) * self.objCanvasView.zoomScale)
        }
        else {
            contentHeight = self.objCanvasView.bounds.height
        }
        
        self.objCanvasView.contentSize = CGSize(width: self.canvasWidth * self.objCanvasView.zoomScale , height: contentHeight)
    }
    
    func setupToolpicker() {
        if let window = parent?.view.window,
           let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(false, forFirstResponder: self.objCanvasView)
            toolPicker.addObserver(self.objCanvasView)
            self.objCanvasView.becomeFirstResponder()
        }
    }
    
    func canvasDoesNotExist(result: [Canvas]) -> Bool {
        if Mirror(reflecting: result).children.count == 0 {
            return true
        }
        return false
    }
    
    func setCanvasScales() {
        let canvasScale = self.objCanvasView.bounds.width / self.canvasWidth
        self.objCanvasView.minimumZoomScale = canvasScale
        self.objCanvasView.maximumZoomScale = canvasScale
        self.objCanvasView.zoomScale = canvasScale
    }
    
    func canvasIsEmpty() -> Bool {
        if self.objCanvasView.drawing.bounds.isEmpty {
            return true
        }
        return false
    }
    
    //MARK: - Canvas Update
    func updateCanvasAndImage() {
        print("updateCanvasAndImage")
    }
        
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
            self.objCanvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: self.setColor, width: CGFloat(self.setWidth))
        }
        else if self.setPencil{
            self.objCanvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: self.setColor, width: CGFloat(self.setWidth))
        }
        else{
            self.objCanvasView.tool = PKEraserTool(PKEraserTool.EraserType.bitmap)
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
        
        self.objCanvasView.addSubview(imageee)
        imageee.becomeFirstResponder()
        print(imageee.tag)
        print(imgViewTag)
        
        let imgX = imageee.frame.origin.x;
        let imgY = imageee.frame.origin.y;
        let imgWidth = imageee.frame.width
        let imgHight = imageee.frame.height
        
        let lineRect = CGRect(x: imgX, y: imgY, width: imgWidth, height: imgHight)
        saveImageDocumentDirectory(image: image, imageName: "SubImage_10_\(imgViewTag).jpeg", name: "\(self.selectedIndex)")
        
        isImage = 1
        let rectAsString = NSCoder.string(for: lineRect)
        
        canvasMetaDataDisc = ["image": imgPath, "frame" : rectAsString, "isImage" : "\(isImage)"]
        
        arrTempImage.append(canvasMetaDataDisc)
        
        print("\(arrTempImage)")
        print(imgPath)
        
    }
    
    //  save added images on canvas to Document Directory
    
    func saveImageDocumentDirectory(image: UIImage, imageName: String, name: String) {
        
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(worksheetId)")
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
        imgPath = urlString
        let imageData = image.jpegData(compressionQuality: 0.5)
        print(imgPath)
        
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
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
                    print(self.canvasMetaDataDisc)
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
    //MARK: - btn action
    
    @IBAction func btnPenClick(_ sender: Any) {
        self.setPen = false
        self.setPencil = true
        self.setEraser = false
        let nextVC = Size_ColorSelectionVC.instantiate(fromAppStoryboard: .Student)
        nextVC.isFromSize = true
        nextVC.dismisssSize = { (size) in
            DispatchQueue.main.async {
                self.objCanvasView.becomeFirstResponder()
                self.setWidth = size
                self.objCanvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: self.setColor, width: CGFloat(self.setWidth))
            }
        }
        let nav = UINavigationController(rootViewController: nextVC)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            nextVC.preferredContentSize = CGSize(width: nextVC.arr.count * 80,height: 40)
            popover.permittedArrowDirections = .up
            popover.sourceView = self.btnPencil
            popover.sourceRect = self.btnPencil!.bounds
        }
        self.present(nav, animated: true, completion: nil)
        self.view.endEditing(true)
    }
    
    @IBAction func btnPencilClick(_ sender: Any) {
        self.setPen = true
        self.setPencil = false
        self.setEraser = false
        let vc  =  self.storyboard?.instantiateViewController(identifier: "Size_ColorSelectionVC") as! Size_ColorSelectionVC
        vc.isFromSize = true
        vc.dismisssSize = { (size) in
            DispatchQueue.main.async {
                self.objCanvasView.becomeFirstResponder()
                self.setWidth = size
                self.objCanvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: self.setColor, width: CGFloat(self.setWidth))
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
    
    @IBAction func btnEraserClick(_ sender: Any) {
        self.setPen = false
        self.setPencil = false
        self.setEraser = true
        self.objCanvasView.tool = PKEraserTool(PKEraserTool.EraserType.bitmap)
    }
    
    @IBAction func btnColorClick(_ sender: Any) {
        let objNext = Size_ColorSelectionVC.instantiate(fromAppStoryboard: .Student)
        objNext.isFromSize = false
        objNext.dismisss = { (Bool,color) in
            DispatchQueue.main.async {
                self.objCanvasView.becomeFirstResponder()
                self.setColor = color
                self.CheckTool()
            }
        }
        let nav = UINavigationController(rootViewController: objNext)
        nav.modalPresentationStyle = .popover
        if let popover = nav.popoverPresentationController {
            objNext.preferredContentSize = CGSize(width: 380,height: 160)
            popover.permittedArrowDirections = .up
            popover.sourceView = self.btnPencilColor
            popover.sourceRect = self.btnPencilColor.bounds
        }
        self.present(nav, animated: true, completion: nil)
        self.view.endEditing(true)
    }
    
    @IBAction func btnImageClick(_ sender: Any) {
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
            popover.sourceView = self.btnImageSelection
            popover.sourceRect = self.btnImageSelection.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSpeechClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InstructionVC") as! InstructionVC
        vc.modalPresentationStyle = UIModalPresentationStyle.automatic
        self.present(vc, animated: true, completion: nil)
        
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
