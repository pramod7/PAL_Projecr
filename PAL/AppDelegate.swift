//
//  AppDelegate.swift
//  PAL
//
//  Created by i-Verve on 21/10/20.
//

import UIKit
import Firebase
import GooglePlaces
import IQKeyboardManagerSwift
import ReachabilitySwift
import FirebaseMessaging
import UserNotifications
import FirebaseCrashlytics

import AVFoundation
//https://stackoverflow.com/questions/29045147/set-background-color-of-active-tab-bar-item-in-swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {
    
    var window: UIWindow?
    var isFeature : Bool!
    var playerItem:AVPlayerItem?
    var audioPlayer: AVAudioPlayer?
    internal var shouldRotate = false
    fileprivate var _deviceToken: String = ""
    var selectedIndex: Int = 99999
    var btnSelectedVoice = false
    var deviceToken: String
    {
        get
        {
            if _deviceToken.textlength == 0
            {
                return "\(Int(Date().timeIntervalSince1970))" //"2ceac78adbfc5161d12c5da2fd764d2a541c6aab38bea2ba8bb1da8a9dc35e68"
            }
            return _deviceToken;
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSPlacesClient.provideAPIKey(GoogleKey.googleAPIKey)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Crashlytics.crashlytics()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.placeholderFont = UIFont.Font_WorkSans_Regular(fontsize: 14)
        IQKeyboardManager.shared.toolbarTintColor = UIColor(named: "Color_appTheme")
        IQKeyboardManager.shared.placeholderColor = UIColor(named: "Color_appTheme")
        if #available(iOS 13.0, *) {
            print("For OS version more than 13 navigation flow manage in scenedelegate")
        }
        else {
            self.setCustomization(application: application)
        }
        self.registerForPushNotification()
        
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            //!! IMPORTANT !!
            /*
             If you're using 3rd party libraries to play sound or generate sound you should
             set sample rate manually here.
             Otherwise you wont be able to hear any sound when you lock screen
             */
            //try AVAudioSession.sharedInstance().setPreferredSampleRate(4096)
        }
        catch
        {
            print(error)
        }
        // This will enable to show nowplaying controls on lock screen
        application.beginReceivingRemoteControlEvents()
        
        return true
        
        sleep(3)
        return true
    }
    
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return shouldRotate ? .allButUpsideDown : .portrait
    }
    
    
    //    func playSound(url:URL) {
    //        do {
    //            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
    //            try AVAudioSession.sharedInstance().setMode(.default)
    //            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    //            playerItem = AVPlayerItem(url: url as URL)
    //            player=AVPlayer(playerItem: playerItem!)
    //
    //            player?.play()
    //        } catch let error {
    //            print(error.localizedDescription)
    //        }
    //    }
    
    func play(url:URL,volume: Int) -> Void {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
            audioPlayer = nil
        }
        
        let final: Float = Float.init(volume) / 100
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
            try AVAudioSession.sharedInstance().setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.currentTime = 0
            audioPlayer?.volume = final
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("errror", error)
        }
    }
    
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK: - support method
    private func setCustomization(application: UIApplication) -> Void {
        URLCache.shared.removeAllCachedResponses()
        //changeLoadScreen()
    }
    
    func changeLoadScreen() {
        if let isFeature = Singleton.shared.get(key: LocalKeys.isFeature) as? Bool, isFeature{
            if let isLogin = Singleton.shared.get(key: LocalKeys.isLogin) as? String, isLogin == "1"{
                if let user = Singleton.shared.getUser() {
                    
                    Preferance.user = user
                    Singleton.shared.save(object: "Color_appTheme", key: UserDefaultsKeys.navColor)
                    if Preferance.user.userType == 1 || Preferance.user.userType == 2{
                        window?.rootViewController = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "PALTabBarController")
                    }
                    else {
                        window?.rootViewController = UIStoryboard.init(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "welcomeStudent")
                    }
                }
            }
            else{
                window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginNav")
            }
            window?.makeKeyAndVisible()
        }
    }
    
    //MARK:- -------- FCM --------
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        Messaging.messaging().apnsToken = deviceToken as Data
        print("Apple device token: \(deviceTokenString)")
    }
    
    // remove static FCMTOKEN later when using in device...
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //            setUserDefaultsValue(value: "Failed to get token", key: Keys.FCMToken)
        //Messaging.messaging().apnsToken = deviceToken as Data
        NSLog("Failed to get Apple device token \(error)")
    }
    
    //MARK:- MessagingDelegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        Singleton.shared.save(object: fcmToken, key: UserDefaultsKeys.FCMToken)
    }
    
    //MARK: - support method
    func registerForPushNotification() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
            if (granted) {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            else {
                //Do stuff if unsuccessful...
                let alertController = UIAlertController(title:APP_NAME, message: AppPermission.notificationMssg, preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                DispatchQueue.main.async {
                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    
    func performActionOfnotificaiton(_ userinfo: NSDictionary)
    {
        let dictapsInfo = userinfo.object_forKeyWithValidationForClass_NSDictionary(aKey: "aps")
        let notificationType = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.notification_type")
        if notificationType == "\(NotificatonType.NotificationFromAdmin)"
        {
            print("first \(notificationType)")
            
        }else if notificationType == "\(NotificatonType.CertificateParents)"{
            
            let childId = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.childId")
            let storyboard = UIStoryboard(name: "ParentDashboard", bundle: nil)
            if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "CertificateListVC") as? CertificateListVC,
                let tabBarController = self.window?.rootViewController as? UITabBarController,
                let navController = tabBarController.selectedViewController as? UINavigationController {
                conversationVC.ChildID = Int(childId)!
                conversationVC.isFromNotification = true
                navController.pushViewController(conversationVC, animated: true)
            }
            
        }else if notificationType == "\(NotificatonType.CompletedMarkingParents)"{
            
            let childId = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.childId")
            let dob = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.dob")
            let gender = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.gender")
            let FirstName = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.firstName") //cm.notification.lastName
            let LastName = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.lastName")
            let Subject = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.childStrugleArea")
            let StudnetID = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.student_Id")
            let storyboard = UIStoryboard(name: "ParentDashboard", bundle: nil)
            if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "ChildrenProfileVC") as? ChildrenProfileVC,
                let tabBarController = self.window?.rootViewController as? UITabBarController,
                let navController = tabBarController.selectedViewController as? UINavigationController {
                conversationVC.childID = Int(childId)!
                conversationVC.lblDateValue.text = dob
                conversationVC.lblUserid.text = StudnetID
                conversationVC.strugleArea = Subject
                if gender == "0"{
                    conversationVC.lblGenderValue.text = "Boy"
                }
                else{
                    conversationVC.lblGenderValue.text = "Girl"
                }
                conversationVC.lblUserName.text = FirstName + " " + LastName
                conversationVC.lblNameIndicator.text = FirstName.first?.uppercased()
                navController.pushViewController(conversationVC, animated: true)
            }
            
        }else if notificationType == "\(NotificatonType.AssignedWorksheetParents)"{
            
            let childId = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.childId")
            let dob = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.dob")
            let gender = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.gender")
            let FirstName = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.firstName") //cm.notification.lastName
            let LastName = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.lastName")
            let Subject = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.childStrugleArea") //gcm.notification.student_Id
            let StudnetID = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.student_Id")
            let storyboard = UIStoryboard(name: "ParentDashboard", bundle: nil)
            if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "ChildrenProfileVC") as? ChildrenProfileVC,
                let tabBarController = self.window?.rootViewController as? UITabBarController,
                let navController = tabBarController.selectedViewController as? UINavigationController {
                conversationVC.childID = Int(childId)!
                conversationVC.lblDateValue.text = dob
                conversationVC.lblUserid.text = StudnetID
                conversationVC.strugleArea = Subject
                if gender == "0"{
                    conversationVC.lblGenderValue.text = "Boy"
                }
                else{
                    conversationVC.lblGenderValue.text = "Girl"
                }
                conversationVC.lblUserName.text = FirstName + " " + LastName
                conversationVC.lblNameIndicator.text = FirstName.first?.uppercased()
                navController.pushViewController(conversationVC, animated: true)
            }
            
        }else if notificationType == "\(NotificatonType.ReassignedWorksheetParents)"{
            
            let childId = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.childId")
            let dob = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.dob")
            let gender = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.gender")
            let FirstName = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.firstName") //cm.notification.lastName
            let LastName = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.lastName")
            let Subject = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.childStrugleArea") //gcm.notification.student_Id
            let StudnetID = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.student_Id")
            let storyboard = UIStoryboard(name: "ParentDashboard", bundle: nil)
            if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "ChildrenProfileVC") as? ChildrenProfileVC,
                let tabBarController = self.window?.rootViewController as? UITabBarController,
                let navController = tabBarController.selectedViewController as? UINavigationController {
                conversationVC.childID = Int(childId)!
                conversationVC.lblDateValue.text = dob
                conversationVC.lblUserid.text = StudnetID
                conversationVC.strugleArea = Subject
                if gender == "0"{
                    conversationVC.lblGenderValue.text = "Boy"
                }
                else{
                    conversationVC.lblGenderValue.text = "Girl"
                }
                conversationVC.lblUserName.text = FirstName + " " + LastName
                conversationVC.lblNameIndicator.text = FirstName.first?.uppercased()
                navController.pushViewController(conversationVC, animated: true)
            }
            
        }else if notificationType == "\(NotificatonType.ReportParents)"{
            
            let childId = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.childId")
            let storyboard = UIStoryboard(name: "ParentDashboard", bundle: nil)
            if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "ParentReportCardVC") as? ParentReportCardVC,
                let tabBarController = self.window?.rootViewController as? UITabBarController,
                let navController = tabBarController.selectedViewController as? UINavigationController {
                conversationVC.childId = Int(childId)!
                navController.pushViewController(conversationVC, animated: true)
            }
            
        }else if notificationType == "\(NotificatonType.CompletedMarkingStudent)"{
            
            let subjectId = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.subjectId")
            let color = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.subjectCoverColor")
            let title = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.subjectName")
            Singleton.shared.save(object: color, key: UserDefaultsKeys.navColor)
            let homeVC = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "WorkBookStudentVC") as! WorkBookStudentVC
            homeVC.subjectId = Int(subjectId)!
            homeVC.strScreenTitle = title
            homeVC.isFromnotification = true
            let navigationController = UINavigationController(rootViewController: homeVC)
            self.window?.rootViewController = navigationController
            
        }else if notificationType == "\(NotificatonType.AssignedWorksheetStudent)"{
            
            let subjectId = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.subjectId")
            let color = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.subjectCoverColor")
            let title = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.subjectName")
                Singleton.shared.save(object: color, key: UserDefaultsKeys.navColor)
            let homeVC = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "WorkBookStudentVC") as! WorkBookStudentVC
            homeVC.subjectId = Int(subjectId)!
            homeVC.strScreenTitle = title
            homeVC.isFromnotification = true
            let navigationController = UINavigationController(rootViewController: homeVC)
            self.window?.rootViewController = navigationController
            
        }else if notificationType == "\(NotificatonType.ReassignedWorksheetStudent)"{
            
            let subjectId = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.subjectId")
            let color = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.subjectCoverColor")
            let title = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.subjectName")
            Singleton.shared.save(object: color, key: UserDefaultsKeys.navColor)
            let homeVC = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "WorkBookStudentVC") as! WorkBookStudentVC
            homeVC.subjectId = Int(subjectId)!
            homeVC.strScreenTitle = title
            homeVC.isFromnotification = true
            let navigationController = UINavigationController(rootViewController: homeVC)
            self.window?.rootViewController = navigationController
            
        }else if notificationType == "\(NotificatonType.ReAssignCompletedWorksheetTeacher)"{
            
            let childId = userinfo.object_forKeyWithValidationForClass_String(aKey: "gcm.notification.childId")
            let storyboard = UIStoryboard(name: "Teacher", bundle: nil)
            if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "StudentProfileVC") as? StudentProfileVC,
                let tabBarController = self.window?.rootViewController as? UITabBarController,
                let navController = tabBarController.selectedViewController as? UINavigationController {
                conversationVC.studentId = Int(childId)!
                conversationVC.isFromNotification = true
                navController.pushViewController(conversationVC, animated: true)
            }

        }
        
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let dict = notification.request.content.userInfo as? [String: Any], !dict.isEmpty {
            print("Payload Forground : \(dict)")
        }
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let dict = response.notification.request.content.userInfo as? [String: Any], !dict.isEmpty {
            print("Payload : \(dict)")
            self.performActionOfnotificaiton(dict as NSDictionary)
            
            let paylaod = response.notification.request.content.userInfo as NSDictionary
            
            let notifyType = paylaod.object_forKeyWithValidationForClass_Int(aKey: "gcm.notification.notificationType")
            let loanReqId = paylaod.object_forKeyWithValidationForClass_Int(aKey: "gcm.notification.loanRequestId")
            
            let state = UIApplication.shared.applicationState
            if state == .background || state == .inactive {
                print("background")
            }
            else if state == .active {
                print("foreground")
            }
            
        }
        completionHandler()
    }
}


