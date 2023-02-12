//
//  CertificateInfoVC.swift
//  PAL
//
//  Created by i-Verve on 20/11/20.
//

import UIKit
import MessageUI
import WebKit
class CertificateInfoVC: UIViewController,MFMailComposeViewControllerDelegate, WKNavigationDelegate,WKUIDelegate {
    
    //MARK:- Outlet variable
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnShare: UIButton!{
        didSet{
            
            self.btnShare.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        }
    }
    @IBOutlet weak var wkWebView: WKWebView!{
        didSet{
            
            
        }
    }
    
    @IBOutlet var wkWebViewRight: NSLayoutConstraint!
    @IBOutlet var wkWebViewLeft: NSLayoutConstraint!
    @IBOutlet var nslcbtnDownloadHight: NSLayoutConstraint!
    @IBOutlet var nslcbtnDownloadWidth: NSLayoutConstraint!
    @IBOutlet var btnDownloadLeft: NSLayoutConstraint!
    @IBOutlet var btnShareRight: NSLayoutConstraint!
    @IBOutlet var nslcbtnShareWidth: NSLayoutConstraint!
    @IBOutlet var nslcbtnShareHight: NSLayoutConstraint!
    
    //MARK:- local variable
    var isCertificateType = Int()//1:Participation 2:Improvement 3:Excellence
    var IsString = ""
    var pdfURL: URL!
    var childName = String()
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        let request = URLRequest(url: URL(string:IsString)!)
     
        self.wkWebView.load(request)
     //   wkWebView.backgroundColor = .white
        wkWebView.navigationDelegate = self
       self.setupCertificateDetails()
        if let nav = self.navigationController{
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: ScreenTitle.Certificate, titleColor: .white)
            self.navigationItem.titleView = titleLabel
            self.navigationItem.rightBarButtonItems = setRightButtonWithTarget(self, action: #selector(EditClicked(_:)), imageName: "Icon_Print")
            
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: "Icon_Back_white"), for: .normal)
            btnBack.addTarget(self, action: #selector(BackClicked), for: .touchUpInside)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }
        btnShare.btnShareSetup()
        btnDownload.btnSelectedSetup(color: UIColor.kAppThemeColor())
    }
        
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(ScreenSize.SCREEN_HEIGHT)
        print(ScreenSize.SCREEN_WIDTH)
        APIManager.showLoader()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    //MARK:- support method
    func setupCertificateDetails() {

        self.btnDownload.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        btnShare.btnShareSetup()
        btnDownload.btnSelectedSetup(color: UIColor.kAppThemeColor())

        if DeviceType.IS_IPHONE{
            self.btnShareRight.constant = 20
            self.wkWebViewLeft.constant = 20
            self.wkWebViewRight.constant = 20
            self.btnDownloadLeft.constant = 20
            nslcbtnDownloadHight.constant = 40
            nslcbtnDownloadWidth.constant = 150
            self.nslcbtnShareHight.constant = 40
            self.nslcbtnShareWidth.constant = 150
        }
        else{
        }
    }
    
    //MARK:- btn click
    @objc func EditClicked(_ sender: Any){
     //   let url = URL(string:IsString)!
//        if UIPrintInteractionController.canPrint(url) {
//            let printInfo = UIPrintInfo(dictionary: nil)
//            printInfo.jobName = url.lastPathComponent
//            printInfo.outputType = .photo
//
//            let printController = UIPrintInteractionController.shared
//            printController.printInfo = printInfo
//            printController.showsNumberOfCopies = false
//            printController.printingItem = url
//            printController.present(animated: true, completionHandler: nil)
//          }
        showAlert(title: APP_NAME, message: Validation.Print)
    }
    
    @objc func BackClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShareClick(_ sender: Any) {
        #if targetEnvironment(simulator)
          // your simulator code
        showAlert(title: APP_NAME, message: Validation.MailComposer)
        #else
          // your real device code
        self.sendEmail()
        #endif
    }
    @IBAction func btnDownloadClick(_ sender: Any) {
        
        guard let url = URL(string: IsString) else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func setBackgroundWhite(subviews: [UIView]) {
        for subview in subviews {
            subview.backgroundColor = .white
            setBackgroundWhite(subviews: subview.subviews)
        }
    }
    func sendEmail() {
//        if MFMailComposeViewController.canSendMail() {
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            mail.setToRecipients(["test@test.com"])
//            mail.setMessageBody("<p>Yoy are using one of awesome app!</p>", isHTML: true)
//            self.present(mail, animated: true)
//        } else {
//            // show failure alert
//        }
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["test@gmail.com"])
            mail.setSubject("\(childName)_Certificate")
            mail.setMessageBody(IsString, isHTML: true)
            mail.mailComposeDelegate = self
            present(mail, animated: true)
        }
        else {
            print("Email cannot be sent")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
     //   controller.dismiss(animated: true)
        if let _ = error {
            self.dismiss(animated: true, completion: nil)
        }
        switch result {
        case .cancelled:
            print("Cancelled")
            break
        case .sent:
            print("Mail sent successfully")
            break
        case .failed:
            print("Sending mail failed")
            break
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- WKNavigationDelegate
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        APIManager.hideLoader()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        APIManager.hideLoader()
        self.wkWebView.isOpaque = false
        self.wkWebView.backgroundColor = UIColor.clear
        self.wkWebView.scrollView.backgroundColor = UIColor.clear
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        APIManager.hideLoader()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension UIButton {
    func btnShareSetup(){
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.kbtnAgeSetup().cgColor
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.black, for: .normal)
    }
}
extension CertificateInfoVC:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      //  let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        if #available(iOS 14.0, *) {
            let now = Date()
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "hh:mm:ss a"
                let dateString = formatter.string(from: now)
                print(dateString)
            let name = "\(childName)_\(dateString)"
            let destinationURL = documentsPath.appendingPathComponent(name, conformingTo: .pdf)
         
            try? FileManager.default.removeItem(at: destinationURL)
            // copy from temp to Document
            do {
                try FileManager.default.copyItem(at: location, to: destinationURL)
                self.pdfURL = destinationURL
            } catch let error {
                print("Copy Error: \(error.localizedDescription)")
            }
        } else {
            print("not save")
        }
        
    }
}
