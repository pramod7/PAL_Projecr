//
//  PrpgressBarVC.swift
//  PAL
//
//  Created by Akshay Shah on 29/03/22.
//

import UIKit

class ProgressBarVC: UIViewController {
    
    @IBOutlet weak var objProgress: UIProgressView!
    
    var dismisssView : ((Int) -> Void)?
    var paramsPass: [String: Any] = [ : ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objProgress.transform = CGAffineTransform(scaleX: 1, y: 3)
        objProgress.layer.cornerRadius = objProgress.frame.height / 2
        objProgress.progress = 0.0
        objProgress.trackTintColor = .gray
        objProgress.progressTintColor = .blue
        objProgress.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProgressBarVC.methodOfReceivedNotification(notification:)), name: Notification.Name("ProgressNotificationIdentifier"), object: nil)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.APIUploadPDF()
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        if notification.userInfo?["IsSuccess"] as? Bool == true
        {
            if let data = notification.userInfo?["counter"] as? Double {
                print("Progress", Float(data))
                objProgress.progress = Float(data)
            }
        }
    }
    
    func APIUploadPDF() {
      
        var params: [String: Any] = [ : ]
        params["teacherId"] = Preferance.user.userId ?? 0
        params["schoolId"] = Preferance.user.schoolId ?? 0
        params["subjectId"] = paramsPass["subjectId"]
        params["categoryId"] = paramsPass["categoryId"]
        params["worksheetData"] = paramsPass["worksheetData"]
        params["worksheetName"] = paramsPass["worksheetName"]
        params["type"] = 1
   
            let objNext = ProgressBarVC.instantiate(fromAppStoryboard: .Teacher)
        objNext.modalPresentationStyle = .custom
            self.navigationController?.present(objNext, animated: false, completion: nil)
        DispatchQueue.main.async {
        APIManager.shared.callPostWithMultiPartApi(reqURL: URLs.APIURL + getUserTye() + uploadWorksheet, parameters: params, showLoader: false,isFromWorksheetupload: true) { (jsonData, error) in
            
            APIManager.hideLoader()
            if jsonData != nil {
                if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject!){
                    if let status = userData.status, status == 1{
                        if let _ = self.dismisssView{
                            self.dismisssView!(Int(0))
                        }
                        self.dismiss(animated: true, completion: nil)
//                        self.APICallGetSubjectWorkbookList()
                    }
                    else{
                        if let msg = jsonData?[APIKey.message].string {
                            showAlert(title: APP_NAME, message: msg)
                        }
                    }
                }
            }else{
                let delayTime = DispatchTime.now() + 2.0
                DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                self.dismiss(animated: true, completion: nil)
                })
            }
        }
        }
    }
    
    
}
