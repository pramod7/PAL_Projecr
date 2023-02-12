//
//  APIManager.swift
//  PAL
//
//  Created by i-Phone7 on 23/11/20.
//


import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD
import PDFKit

class APIManager {
    
    class var shared : APIManager {
        struct Static {
            static let instance : APIManager = APIManager()
        }
        return Static.instance
    }
    
    //MARK: - show loader
    static func showLoader() -> Swift.Void {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.3843137255, green: 0.737254902, blue: 0.8392156863, alpha: 1))           //Ring Color
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1))        //HUD Color
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.5))    //Background Color
        SVProgressHUD.setMinimumDismissTimeInterval(0.7)
        SVProgressHUD.show()
    }
    
    //MARK: - hide loader
    static func hideLoader()  -> Swift.Void{
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            UIApplication.shared.endIgnoringInteractionEvents()
            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.3843137255, green: 0.737254902, blue: 0.8392156863, alpha: 1))
            SVProgressHUD.dismiss()
        }
    }
    
    static func showPopOverLoader(view: UIView) -> Swift.Void {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)//
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.3843137255, green: 0.737254902, blue: 0.8392156863, alpha: 1))           //Ring Color
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1))        //HUD Color
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.0))    //Background Color
        SVProgressHUD.setContainerView(view)
        SVProgressHUD.setMinimumDismissTimeInterval(0.7)
        SVProgressHUD.show()
    }
    
    //MARK: - Get API Call
    func callGetApi(reqURL: String, showLoader: Bool, callBack:@escaping (_ dataFromServer: JSON?, _ error:Error?) -> Void){
        
        if !Connectivity.isConnectedToInternet() {
            showAlert(title: APP_NAME, message: Messages.NOINTERNET)
            return
        }
        
        var headers: HTTPHeaders!
        if let token = Preferance.user.accessToken, token.count > 0 {
            headers = [
                .accept("application/json"),
                .authorization(bearerToken: "\(token)")
            ]
        } else {
            headers = [
                .accept("application/json")
            ]
        }
        
        print("URL : \(reqURL)")
        print("header : \(String(describing: headers))")
        print("parameters : Blank")
        
        if showLoader {
            APIManager.showLoader()
        }
        AF.request(reqURL, method: .get, headers: headers).responseJSON { response in
            if showLoader {
                APIManager.hideLoader()
            }
            
            print(response)
            
            switch response.result {
            case .success(let value):
                let finalJson = JSON(value)
                self.sessionReset(json: finalJson)
                callBack(finalJson,nil)
                
            case .failure(let error):
                callBack(nil,error)
                print("\nResponse ERROR:\n",error.localizedDescription)
            }
        }
    }
    
    //MARK: - Post API Call
    func callPostApi(parameters: [String:Any], reqURL: String, showLoader: Bool, vc: UIViewController, callBack:@escaping (_ data: JSON?, _ error:String?) -> Void){
        
        if !Connectivity.isConnectedToInternet() {
            let alert = UIAlertController(title: APP_NAME, message: Messages.NOINTERNET, preferredStyle: .alert)
            alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                NotificationCenter.default.post(name: Notification.Name("NoInterNet"), object: nil)
            })
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
           
//            showAlert(title: APP_NAME, message: Messages.NOINTERNET)
            return
        }
        
        var headers: HTTPHeaders!
        if let token = Preferance.user.accessToken, token.count > 0 {
            headers = [
                .accept("application/json"),
                .authorization(bearerToken: "\(token)")
            ]
        } else {
            headers = [
                .accept("application/json")
            ]
        }
        
        print("Req URL : \(reqURL)")
        print("Req Header : \(String(describing: headers))")
        print("Req Params : \(parameters)")
        
        if showLoader {
            APIManager.showPopOverLoader(view: vc.view)
//            APIManager.showLoader()
        }
        AF.request(reqURL, method: .post , parameters: parameters, headers: headers).responseJSON { response in
            if showLoader {
                APIManager.hideLoader()
            }
            print("Response Params : \(response)")
            
            switch response.result {
            case .success(let value):
                let finalJson = JSON(value)
                self.sessionReset(json: finalJson)
                callBack(finalJson,"")
                
            case .failure(let error):
                switch response.result {
                            case .success(let value):
                                let finalJson = JSON(value)
                                self.sessionReset(json: finalJson)
                                callBack(finalJson,"")
                            case .failure(let error):
                                print("Response ERROR:",error.localizedDescription)
                                var strTempError = ""
                                if let urlError = error.underlyingError as? URLError {
                                    switch urlError.code {
                                    case .networkConnectionLost:
                                        strTempError = Messages.NWLOST
                                    case .cannotConnectToHost:
                                        strTempError = Messages.HOSTUNAV
                                    case .timedOut:
                                        strTempError = Messages.TIMEOUT
                                    case .notConnectedToInternet:
                                        strTempError = Messages.NOINTERNET
                                    default:
                                        strTempError = error.localizedDescription
                                    }
                                }
                                callBack(nil, strTempError)
                            }
                callBack(nil,error.localizedDescription)
                print("\nResponse ERROR:\n",error.localizedDescription)
            }
        }
    }
    
    //MARK: - Multipart API Call
    func callPostWithMultiPartApi(reqURL: String, parameters: [String:Any],showLoader: Bool,isFromWorksheetupload: Bool = false, callBack:@escaping (_ data: JSON?, _ error:String?) -> Void){
        
        if !Connectivity.isConnectedToInternet() {
            showAlert(title: APP_NAME, message: Messages.NOINTERNET)
            return
        }
        
        var headers: HTTPHeaders!
        if let token = Preferance.user.accessToken, token.count > 0 {
            headers = [
                .accept("application/json"),
                .authorization(bearerToken: "\(token)")
            ]
        }
        
        print("URL : \(reqURL)")
        print("header : \(String(describing: headers))")
        print("parameters : \(parameters)")
        
        if showLoader {
            APIManager.showLoader()
        }
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                print(key)
                if value is PDFDocument
                {
                    var imageData = Data()
                    imageData = ((value as AnyObject).dataRepresentation())!
                    print(imageData)
                    multipartFormData.append(imageData, withName: "worksheetData", fileName:"swift_file.pdf", mimeType: "application/pdf")
                }
                else if value is String {
                    multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                else if value is Int {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                else if value is UIImage {
                    let image = value as? UIImage
                    let imgDataTemp = (image?.jpegData(compressionQuality: 0.7) as Data?)!//
                    multipartFormData.append(imgDataTemp, withName: key, fileName: "coverPic.jpeg", mimeType: "image/jpeg")
                }
                else if (key == "data"){
                    let tmg = try! JSONSerialization.data(withJSONObject:value, options: [])
                    multipartFormData.append(tmg, withName: key)
                }
                else if (key == "instruction"){
                    let tmg = try! JSONSerialization.data(withJSONObject:value, options: [])
                    multipartFormData.append(tmg, withName: key)
                }
                else if (key == "voiceinstruction[]"){
                    let arrTemp = value as! [String]
                    var count = 0
                    if arrTemp.count > 0
                    {
                        for i in arrTemp
                        {


//                            guard let path = Bundle.main.path(forResource: "sampleaudio", ofType: "mp3") else {
//                                      print("Sound file not found")
//                                      return
//                                    }
//                                    let url = URL(fileURLWithPath: path)
//                                    do {
//                                      let fileData = try Data(contentsOf: url)
////                                      storedURL = saveDataFile(data: fileData, fileName: "test.mp3", folderName: "testFolder")
//                                        multipartFormData.append(fileData, withName: key, fileName:"sampleaudio", mimeType: "audio/mpeg")
////                                      print("File Writing on View -> Success \(storedURL.absoluteString) ")
//                                    } catch {
//
//                                    }
                            let uploadAudioURL = i
//                            let fileName = i.lastPathComponent
                            let voiceData = try? Data(contentsOf: URL(fileURLWithPath: uploadAudioURL))
//
//
//                            if let base64String = try? Data(contentsOf: URL(fileURLWithPath: uploadAudioURL)).base64EncodedString() {
//                                print(base64String)
//                            }
//                            let myBase64Data = voiceData!.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
//                            print(myBase64Data)
//                            let resultData = NSData(base64Encoded: voiceData!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
//                            print(resultData)
                            multipartFormData.append(voiceData!, withName: key, fileName:"\(count).m4a", mimeType: "audio/m4a")
//
////                            multipartFormData.append(URL(string:i)!, withName: key, fileName: "\(count).m4a", mimeType: "audio/x-m4a")
                            count = count + 1
                        }
                    }
                }
                else if value is [UIImage]{
                    let arrTemp = value as! [UIImage]
                    
                    var count = 0
                    for i in arrTemp{
                        let imgDataTemp = (i.jpegData(compressionQuality: 1.0) as Data?)!
                        if count <= 9 {
                            print("Img Name : 0\(count).jpeg")
                            multipartFormData.append(imgDataTemp, withName: key, fileName: "0\(count).jpeg", mimeType: "image/jpeg")
                        }
                        else{
                            print("Img Name : \(count).jpeg")
                            multipartFormData.append(imgDataTemp, withName: key, fileName: "\(count).jpeg", mimeType: "image/jpeg")
                        }
                        count = count + 1
                    }
                }
            }            
        }, to: reqURL, method: .post, headers: headers)
            .uploadProgress(closure: { (progress) in
                if isFromWorksheetupload
                {
                    print(progress.fractionCompleted)
                    var params: [String: Any] = [ : ]
                    params["counter"] = progress.fractionCompleted
                    params["IsSuccess"] = true
                    NotificationCenter.default.post(name: Notification.Name("ProgressNotificationIdentifier"), object: nil, userInfo: params)
                }
            })
        .responseJSON { (response) in
            APIManager.hideLoader()
            print(response)
          
            switch response.result {
            case .success(let value):
                let finalJson = JSON(value)
                self.sessionReset(json: finalJson)
                callBack(finalJson,"")
            case .failure(let error):
                switch response.result {
                            case .success(let value):
                                let finalJson = JSON(value)
                                self.sessionReset(json: finalJson)
                                callBack(finalJson,"")
                            case .failure(let error):
                                print("Response ERROR:",error.localizedDescription)
                                var strTempError = ""
                                if let urlError = error.underlyingError as? URLError {
                                    switch urlError.code {
                                    case .networkConnectionLost:
                                        strTempError = Messages.NWLOST
                                    case .cannotConnectToHost:
                                        strTempError = Messages.HOSTUNAV
                                    case .timedOut:
                                        strTempError = Messages.TIMEOUT
                                    case .notConnectedToInternet:
                                        strTempError = Messages.NOINTERNET
                                    default:
                                        strTempError = error.localizedDescription
                                    }
                                }
                                callBack(nil, strTempError)
                            }
                callBack(nil,error.localizedDescription)
                print("\nResponse ERROR:\n",error.localizedDescription)
            }
        }
    }
    
    //MARK: - Custom POST API
    func callPostAPI(url: String, parameters: [String : Any]?, showLoader shouldShow: Bool, completionHandler: (( Bool, NSDictionary?, String?) -> Void)?) {
        
        if !Connectivity.isConnectedToInternet() {
            showAlert(title: APP_NAME, message: Messages.NOINTERNET)
            return
        }
        
        print("Req URL : \(url)")
        print("Req Params : \(parameters ?? [:])")
        
        if shouldShow { // At this step due to concurrent load on server causes error with code :: -1005
            APIManager.showLoader()
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90.0)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.addValue("Bearer \(Preferance.user.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        if parameters != nil {
            let postData = try? JSONSerialization.data(withJSONObject: parameters ?? ([String : Any]() as Any), options: [])
            request.httpBody = postData
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if shouldShow {
                APIManager.hideLoader()
            }
            if (error != nil) {
                print("RESPONSE ERROR  :  \(error!.localizedDescription)")
                if let validHandler = completionHandler {
                    validHandler(false, nil, error!.localizedDescription)
                }
            }
            else {
                do {
                    if let dictResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
                        print("RESPONSE PARAM : \(String(describing: dictResponse))")
                        let status: Int = dictResponse.object_forKeyWithValidationForClass_Int(aKey: "status")
                        let strErrorMessage : String = dictResponse.object_forKeyWithValidationForClass_String(aKey: "message")
                        let dataDictionary = dictResponse.object_forKeyWithValidationForClass_NSDictionary(aKey: "data")
                        if status == 1{
                            if let validHandler = completionHandler {
                                validHandler(true, dataDictionary, strErrorMessage)
                            }
                        }
                        else{
                            if let validHandler = completionHandler {
                                validHandler(false, nil, strErrorMessage)
                            }
                        }
                    } else {
                        if let validHandler = completionHandler {
                            validHandler(false, nil, nil)
                        }
                    }
                } catch let error as NSError {
                    if let validHandler = completionHandler {
                        let strErrorMessage : String = error.localizedDescription
                        validHandler(false, nil, strErrorMessage)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    
    
    
    
    //MARK: - Support Method
    func sessionReset(json :JSON) {
        if let userData = ListResponse(JSON: json.dictionaryObject ?? [String:Any]()){
//            WorksheetDBManager.shared.truncateDB()
//            clearStudentTempDir()
//            clearTeacherTempDir()
            if let status = userData.status, status == 2{
                resetSessionData()
                self.navigateToLogin()
            }
            else if let status = userData.status, status == 3{
                resetSessionData()
                self.navigateToLogin()
            }
            else if let status = userData.status, status == 4{
                resetSessionData()
                self.navigateToLogin()
            }
        }
    }
    
    func navigateToLogin() {
        let loginVC = LoginVC.instantiate(fromAppStoryboard: .Main)
        let nav = UINavigationController(rootViewController: loginVC)
        UIApplication.shared.keyWindow?.rootViewController = nav
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
