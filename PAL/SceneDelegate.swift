//
//  SceneDelegate.swift
//  PAL
//
//  Created by i-Verve on 21/10/20.
//

import UIKit

protocol CanvasUpdate{
    func updateCanvasAndImage()
}

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var arrStoredPath = [[String:Any]]()
    var objWorksheetData = [WorksheetData]()
    var arrOfflineData = [Canvas]()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        (UIApplication.shared.delegate as? AppDelegate)?.self.window = window
        guard let _ = (scene as? UIWindowScene) else { return }
        self.changeLoadScreen()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
       
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
       
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
       
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        self.fetchFromDB()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
     
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    //MARK: - support method
    func changeLoadScreen() {
        
        if let isFeature = Singleton.shared.get(key: LocalKeys.isFeature) as? Bool, isFeature{
            if let isLogin = Singleton.shared.get(key: LocalKeys.isLogin) as? String, isLogin == "1"{
                if let user = Singleton.shared.getUser() {
                    Preferance.user = user
                    Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)
                    if !Connectivity.isConnectedToInternet() {
                        if Preferance.user.userType == 1 || Preferance.user.userType == 2{
                            window?.rootViewController = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "PALTabBarController")
                        }
                        else{
                            let result = WorksheetDBManager.shared.GetData()
                            if result.count > 0{
                                Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)
                                window?.rootViewController = UIStoryboard.init(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "OfflineStudentData")
                            }
                            else{
                                window?.rootViewController = UIStoryboard.init(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "welcomeStudent")
                            }
                        }
                    }else{
                    if Preferance.user.userType == 1 || Preferance.user.userType == 2{
                        window?.rootViewController = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "PALTabBarController")
                    }
                    else {
                        window?.rootViewController = UIStoryboard.init(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "welcomeStudent")
                    }
                }
                }
            }
            else{
                window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNav")
            }
            window?.makeKeyAndVisible()
        }
        
//        if !Connectivity.isConnectedToInternet() {
//            if Preferance.user.userType == 1 || Preferance.user.userType == 2{
//                window?.rootViewController = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "PALTabBarController")
//            }
//            else{
//                let result = WorksheetDBManager.shared.GetData()
//                if result.count > 0{
//                    Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)
//                    window?.rootViewController = UIStoryboard.init(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "OfflineStudentData")
//                }
//                else{
//                    window?.rootViewController = UIStoryboard.init(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "welcomeStudent")
//                }
//            }
//        }
//        else{
//            if let isFeature = Singleton.shared.get(key: LocalKeys.isFeature) as? Bool, isFeature{
//                if let isLogin = Singleton.shared.get(key: LocalKeys.isLogin) as? String, isLogin == "1"{
//                    if let user = Singleton.shared.getUser() {
//                        Preferance.user = user
//                        Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)
//                        if Preferance.user.userType == 1 || Preferance.user.userType == 2{
//                            window?.rootViewController = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "PALTabBarController")
//                        }
//                        else {
//                            window?.rootViewController = UIStoryboard.init(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "welcomeStudent")
//                        }
//                    }
//                }
//                else{
//                    window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNav")
//                }
//                window?.makeKeyAndVisible()
//            }
//        }
    }
    
    //MARK: - Worksheet upload method
    // called every time interval from the timer
    @objc func fetchFromDB() {
        
        let result = WorksheetDBManager.shared.GetData()
        for i in result{
            if i.isoffline == 1{
//                var disc = [String :Any]()
//                disc = ["subjectId" : i.subjectId , "teacherId" : i.teacherId , "subCategoryId" : i.subCategoryId , "worksheetId" : i.worksheetID , "assign_type" : i.assigntype , "eraser" : i.eraser , "spellChecker" : i.spellChecker]
                self.arrOfflineData.append(i)
            }
        }
        print(self.arrOfflineData)
        let delayTime = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
            if self.arrOfflineData.count > 0{
                self.CheckFolder(sheetId: self.arrOfflineData[0].worksheetID)
            }
        })
    }
    
    //MARK: - Get Images from Database
    func CheckFolder(sheetId:Int){
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(sheetId)")
        
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: bFolder.path) {
        }
        else{
            self.getImageFromDoc(sheetId: sheetId)
            let seconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.loadData()
            }
        }
    }
    
    func getImageFromDoc(sheetId:Int){
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = documentsUrl.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(sheetId)")
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
    
    func loadData() {
        
        self.arrStoredPath.sort{
            ((($0 as Dictionary<String, AnyObject>)["screenshot"] as? String)!) < ((($1 as Dictionary<String, AnyObject>)["screenshot"] as? String)!)
        }
        
        let jsonString = self.arrStoredPath.toJSONString()
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        
        do {
            let people = try decoder.decode([WorksheetData].self, from: jsonData)
            print("\(people).......modaldata")
            objWorksheetData.append(contentsOf: people)
        } catch {
            print(error.localizedDescription)
        }
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.SubmitWorksheet()
        }
    }
    
    
    func SubmitWorksheet(){
        if !Connectivity.isConnectedToInternet() {
            return
        }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: Date())
        
        var arrImg = [UIImage]()
        for i in objWorksheetData{
            arrImg.append(UIImage(contentsOfFile: i.screenshot ?? "")!)
        }
        var params: [String: Any] = [ : ]
        params["subjectId"] = self.arrOfflineData[0].subjectId
        params["teacherId"] = self.arrOfflineData[0].teacherId
        params["subCategoryId"] = self.arrOfflineData[0].subCategoryId
        params["worksheetId"] = self.arrOfflineData[0].worksheetID
        params["submitDate"] = dateString
        params["assign_type"] = self.arrOfflineData[0].assigntype
        params["eraser"] = self.arrOfflineData[0].eraser
        params["spellChecker"] = self.arrOfflineData[0].spellChecker
        params["pdfImages[]"] = arrImg //pdfImages
                
        APIManager.shared.callPostWithMultiPartApi(reqURL: URLs.APIURL + getUserTye() + submitWorkSheet, parameters: params, showLoader: false) { (jsonData, error) in
            if let userData = ObjectResponse(JSON: jsonData!.dictionaryObject ?? [String:Any]()){
                if let status = userData.status, status == 1{
                    let workSheetId = self.arrOfflineData[0].worksheetID
                    WorksheetDBManager.shared.delete(drawindex: workSheetId)
                    self.clearTempFolder(sheetId: workSheetId)
                    
                    self.arrOfflineData = self.arrOfflineData.filter{$0.worksheetID != self.arrOfflineData[0].worksheetID}
                    if self.arrOfflineData.count > 0 {
                        self.CheckFolder(sheetId: self.arrOfflineData[0].worksheetID)
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
    
    // Remove Images from Document Directory
    func clearTempFolder(sheetId:Int) {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let aFolder = docDirectory.appendingPathComponent("WorkSheetMetaData")
        let bFolder = aFolder.appendingPathComponent("\(sheetId)")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: bFolder.path) {
            try! fileManager.removeItem(atPath: bFolder.path)
        }
        else{
            
        }
    }
}
