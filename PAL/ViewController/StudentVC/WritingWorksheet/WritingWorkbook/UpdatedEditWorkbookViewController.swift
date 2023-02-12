//
//  UpdatedEditWorkbookViewController.swift
//  
//
//  Created by Akshay Shah on 09/01/22.
//

import UIKit
import PencilKit
import SwiftyJSON

class UpdatedEditWorkbookViewController: UIViewController , PKCanvasViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Local Variable
    var drawingIndex: Int = 0
    var drawing = PKDrawing()
    let canvasWidth: CGFloat = 768
    let canvasOverscrollHeight: CGFloat = 500
    var dismissimg : ((workbookDataModel) -> Void)?
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
    var strImgGet = ""
    var imgPath = String()
    var ImagePath = ""
    var screenPath = ""
    var lastRotation : CGFloat = 0
    var worksheetId = 0
    var teacherName = ""
    var UniqueID = 0
    var isoffline = 0
    var WorkbookId = 0
    var workbookPageId = 0
    var teacherId = ""
    var subCategoryId = 0
    var assigntype = 0
    var eraser = 0
    var spellChecker = 0
    var arrworkbook = [workbookDataModel]()
    
    // MARK: - Outlets
    @IBOutlet var canvasView: PKCanvasView!
    @IBOutlet weak var btnPrn: UIButton!
    @IBOutlet weak var btnPencil: UIButton!
    @IBOutlet weak var btnEraser: UIButton!
    @IBOutlet weak var btnColor: UIButton!
    @IBOutlet var btnImage: UIButton!
    @IBOutlet var imgCanvasBack: UIImageView!
    @IBOutlet var objViewMain: UIView!

    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgCanvasBack.image = imgBackground
        setupCanvas()
        setupToolpicker()
       
        if let nav = self.navigationController{
            if let colorName = Singleton.shared.get(key: UserDefaultsKeys.navColor) as? String
               , colorName.trim.count > 0{
                nav.navigationBar.barTintColor = UIColor.hexStringToUIColor(colorName)
            }
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Edit Workbook", titleColor: .white)
            self.navigationItem.titleView = titleLabel
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
            
        }
        
        panRecognizer?.delegate = self
        imgViewTag = 0
        
    }
    
        
    // MARK: - Canvas func
    @objc func btnBackClick(_ sender: Any) {
        self.APICallCreatePage()
    }
    
    //MARK: - Canvas Function
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
    
    func setCanvasScales() {
        let canvasScale = canvasView.bounds.width / canvasWidth
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale
    }
    
    func canvasIsEmpty() -> Bool {
        if canvasView.drawing.bounds.isEmpty {
            return true
        }
        return false
    }
    
    // MARK: - other func
    
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
    
    func CheckTool()
    {
        if self.setPen
        {
            self.canvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: self.setColor, width: CGFloat(self.setWidth))
        }else if self.setPencil
        {
            self.canvasView.tool = PKInkingTool.init(PKInkingTool.InkType.pencil, color: self.setColor, width: CGFloat(self.setWidth))
        }else
        {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImage(image: pickedImage)
            imgViewTag = imgViewTag + 1
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - API Call
    func APICallCreatePage(){
        let screenshot = objViewMain.screenshot
        var params: [String: Any] = [ : ]
        params["workbookId"] = WorkbookId
        params["studentId"] = Preferance.user.userId
        params["workbookPageId"] = workbookPageId
        params["workbookImage"] = screenshot
        
        APIManager.showPopOverLoader(view: self.view)
        APIManager.shared.callPostWithMultiPartApi(reqURL: URLs.APIURL + getUserTye() + createPage, parameters: params, showLoader: false) { (jsonData, error) in
            APIManager.hideLoader()
            if jsonData != nil {
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let value = userData.workBookInfo {
                            let objWorkBook = value
                            if let _ = self.dismissimg{
                                self.dismissimg!(objWorkBook)
                            }
                            self.navigationController?.popViewController(animated: true)
                        }
                        else{

                        }
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
      
        self.canvasView.addSubview(imageee)
        imageee.becomeFirstResponder()
        print(imageee.tag)
        print(imgViewTag)
        
        let imgX = imageee.frame.origin.x;
        let imgY = imageee.frame.origin.y;
        let imgWidth = imageee.frame.width
        let imgHight = imageee.frame.height
        
        let lineRect = CGRect(x: imgX, y: imgY, width: imgWidth, height: imgHight)

        let rectAsString = NSCoder.string(for: lineRect)
        
        canvasMetaDataDisc = ["image": imgPath, "frame" : rectAsString, "isImage" : "\(isImage)"]
        
        arrTempImage.append(canvasMetaDataDisc)

        print("\(arrTempImage)")
        print(imgPath)
        
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
    

    // MARK: - Gester func
    
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
    
    // MARK: - btn action
    @IBAction func btnPenClick(_ sender: Any) {
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
    
    @IBAction func btnEraserClick(_ sender: Any) {
        self.setPen = false
        self.setPencil = false
        self.setEraser = true
        self.canvasView.tool = PKEraserTool(PKEraserTool.EraserType.bitmap)
    }
    
    @IBAction func btnColorClick(_ sender: Any) {
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InstructionVC") as! InstructionVC
        vc.modalPresentationStyle = UIModalPresentationStyle.automatic
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
