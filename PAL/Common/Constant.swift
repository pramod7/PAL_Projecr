//
//  Constant.swift
//  Specialz
//
//  Created by i-Phone13 on 04/04/19.
//  Copyright © 2019 i-Verve. All rights reserved.
//

import UIKit

var arrChild = [[String: Any]]()
//var isFromSignUp = Bool()
var isCHildrenCount = Bool()
//var getUserTye() = String()
let applicationName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
let APP_NAME = "PAL"
let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
let popoverWidth = 400
let imgWorksheetPlaceholder = UIImage(named: "Icon_Back_white")!
let imgWorksheetIconPlaceholder = UIImage(named: "Icon_Placeholder1")!
var isLoggedIn: Bool {
    if (UserDefaults.standard.value(forKey: UserDefaultsKeys.userData) as? [String: Any]) != nil {
        return true
    }
    else {
        return false
    }
}

struct Preferance {
    static var user: User = User()
}

//MARK: - Screen Size Info
struct ScreenSize{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType{
    static let IS_IPHONE            = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7_8      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P_8P   = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X_Xs       = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_Xs_Max     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XR         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    
    static let IS_IPAD                     = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_iPad_Pro_12_9_inch       = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024
    static let IS_iPad_Pro_10_5_inch       = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1112
    static let IS_iPad_Pro_9_7_inch       = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 768
}

//MARK: -  Application details
struct MyApp{
    static let udid = UIDevice.current.identifierForVendor!.uuidString
    static let applicationVersionWithBuildVersion = AppVersion + "(" + BuildVersion + ")"
    static let versionCode = AppVersion  //old name :- applicationVersion
    static let osVersion = UIDevice.current.systemVersion
    static let platform = "iOS"
    static let device_type = "1"
    static let mobileName = UIDevice.current.name  //old name :- device_name
}

var AppVersion:String{
    get{
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
}

var BuildVersion:String{
    get{
        return (Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String)!
    }
}

struct BaseURL{
    static let strCDUURL               = "https://pal.clouddownunder.com.au/api/v1/"
    
    static let strCDUTermsPrivacyURL   = "https://pal.clouddownunder.com.au/"
}



struct URLs{
    // ******* Dev URL *******
    //    static let APIURL = BaseURL.strDevURL
    //    static let APITermsPrivacyURL = BaseURL.strDevTermsPrivacyURL
    
    // ******* QA URL *******
    //   static let APIURL = BaseURL.strQaURL
    //    static let APITermsPrivacyURL = BaseURL.strQaTermsPrivacyURL
    
    // ******* CDU URL *******
    static let APIURL = BaseURL.strCDUURL
    static let APITermsPrivacyURL = BaseURL.strCDUTermsPrivacyURL
}

let preLogin                        = "preLogin"
let login                           = "login"
let signUp                          = "signup"
let forgotPassword                  = "forgotpassword"
let getSchoolList                   = "getSchoolList"  
let getTips                         = "getTip"
let getFAQs                         = "getFaq"
let doLogout                        = "logout"
let changePassword                  = "changePassword"
let getProfile                      = "profile"
let updateProfile                   = "updateProfile"
let studentList                     = "studentList"
let getCertificare                  = "getCertificateList"
let addProgress                     = "addProgressReport"
let subjectList                     = "subjectList"
let addSubject                      = "addSubject"
let deleteSub                       = "deleteSubject"
let getCertificateList              = "getCertificateList"
let addProgressReport               = "addProgressReport"
let getColorCode                    = "getColorCode"
let getFavList                      = "getFavouriteList"
let getCertificateType              = "getCertificateType"
let getChildCertifiList             = "getChildCertificatesList"
let getAllCertificateList           = "getAllCertificateList"
let getReportCardList               = "getReportCardsList"
let getReportDetaill                = "getReportDetail"
let shareFeedback                   = "shareFeedback"
let getChildList                    = "getChildList"
let addEditChild                    = "addEditChild"
let deleteChild                     = "deleteChild"
let getTeacherLinkList              = "getTeacherLinkList"
let teacherLinkUnlink               = "teacherLinkUnlink"
let getStudentInfoById              = "getStudentInfoById"
let getStudentProfile               = "getStudentProfile"
let getParentChildWorksheetsList    = "getParentChildWorksheetsList"
let getSubjectsForWorkbooks         = "getSubjectsForWorkbooks"
let getSubjectWorksheetList         = "getSubjectWorksheetList"
let createCertificate               = "createCertificate"
let doTeacherWorkSheetAssign        = "teacherWorkSheetAssign"
let doFavourite                     = "doFavourite"
let interviewRequest                = "interviewRequest"
let getSubjectBooksList             = "getSubjectBooksList"
let getStudentWorksheetList         = "getStudentWorksheetList"
let getWeeklyWorksheet              = "getWeeklyWorksheet"
let getStudentSubjectList           = "getStudentSubjectList"
let submitWorkSheet                 = "submitWorkSheet"
let reAssignCompletedWorksheet      = "reAssignCompletedWorksheet"
let getArchive                      = "getArchiveList"
let getMarkingTeacherList           = "getMarkingWorksheetList"
let createWorkbook                  = "createWorkBook"
let getWorkbook                     = "getWorkbook"
let createPage                      = "createPage"
let renameWorksheet                 = "renameWorksheet"
let uploadWorksheet                 = "uploadWorksheet"
let getArchiveSubject               = "getArchiveSubject"
let getYearList                     = "getYearList"
let getNotifications                = "getNotifications"
let deleteWorksheets                = "deleteWorksheet"
let getInetrviewRequest             = "parent/getInetrviewRequest"

struct APIEndpoint
{
    static let getTeacherTerms         = "terms/teacher"
    static let getParentTerms          = "terms/parent"
    static let getStudentTerms         = "terms/student"
    
    static let getTeacherPrivacy       = "privacy-policy/teacher"
    static let getParentPrivacy        = "privacy-policy/parent"
    static let getStudentPrivacy       = "privacy-policy/student"
}
//9724497900
//8140979002
//MARK: - Keys
struct RequestKeys{
    //MARK: GENERAL KEYS
    static let status           = "status"
    static let message          = "message"
    static let errorCode        = "error"
    static let data             = "data"
    static let deviceType       = "deviceType"
    static let deviceToken      = "deviceToken"
}

struct APIKey{
    static let status               = "status"
    static let message              = "message"
    static let errorCode            = "error"
    static let data                 = "data"
}

struct LocalKeys {
    static let googleMapKey                   = "AIzaSyBJZENwjqmVMozLwynQ8h98h2Y3kaHULrQ"
    static let status                         = "status"
    static let data                           = "data"
    static let message                        = "message"
    static let password                       = "password"
    static let isLogin                        = "isLogin"
    static let errorCode                      = "error"
    static let latitude                       = "latitude"
    static let longitude                      = "longitude"
    static let isFeature                      = "isFeature"
}

struct GoogleKey{
    static let googleAPIKey                 =  "AIzaSyAtwvvJgLQCz6ilvbXkUSFcB_02kE_dyf4"
}

struct AppPermission{
    static let notificationMssg       =   "We highly recommend enabling notification from settings so you won't miss any notification from PAL."
}

struct UserDefaultsKeys{
    static let DeviceId             = "DeviceId"
    static let DeviceToken          = "DeviceToken"
    static let FCMToken             = "FCMToken"
    static let navColor             = "navColor"
    static let userData             = "userData"
}

struct Placeholder{
    static let subjectImg             = "Icon_Placeholder"
}

struct NotificatonType
{
    static let NotificationFromAdmin = 15
    static let NewWorksheetParents = 11
    static let CertificateParents = 7
    static let CompletedMarkingParents = 3
    static let AssignedWorksheetParents = 1
    static let ReassignedWorksheetParents = 4
    static let ReportParents = 9
    static let NewWorksheetStudent = 8
    static let CertificateStudent = 90
    static let CompletedMarkingStudent = 5
    static let AssignedWorksheetStudent = 2
    static let ReassignedWorksheetStudent = 6
    static let ReportStudent = 10
    static let ReAssignCompletedWorksheetTeacher = 13
}


//ViewController Titles
struct ScreenTitle {
    
    static let ReferAFrnnd            = "Refer A Friend".localized
    static let Notifications          = "Notifications".localized
    static let Certificates           = "Certificates".localized
    static let Certificate            = "Certificate".localized
    static let SignUp                 = "Sign Up".localized
    static let StudentSetUp           = "Student Profiles".localized
    static let EditProfile            = "Edit Profile".localized
    static let Workbooks              = "WorkBooks".localized
    static let Profile                = "Profile".localized
    static let SubCategory            = "Sub Categories".localized
    static let EditSubject            = "Edit Subject".localized
    static let AddNewSubj             = "Add New Subject".localized
    static let ChangePass             = "Change Password".localized
    static let ProgressReport         = "Progress Report".localized
    static let ReportCard             = "Report Card".localized
    static let ReportCards            = "Report Cards".localized
    static let ProgressCard           = "Progress Report".localized
    static let AddNewCard             = "Add New Card".localized
    static let Subjects               = "Subjects".localized
    static let TopicList              = "Topic List".localized
    static let Settings               = "Settings".localized
    static let Students               = "Students".localized
    static let SubjectBooks           = "Subject Books".localized
}

//ViewController Text
struct ScreenText {
    
    static let alreadyAccount            = "Already have an account?".localized
    static let dontAccount               = "Don't have an account?".localized
    static let EmailSent                 = "Email has been sent to your registered email address.".localized
    static let StudentDelete             = "Are you sure want to delete,".localized
    static let DeleteCard                = "Are you sure want to delete card?".localized
    static let AddNew                    = "Add new".localized
    static let ChildAddMssg              = "You have not added Student, Please go to Setup Student Profile and add Student.".localized
    static let TeacherSignUpWarMssg      = "Please wait patiently for admin to verify your account before you can login.".localized
    static let childToolTip              = "We are collecting information from our users to better understand the needs of the children so we can improve and enhance the platform in the future.".localized
}

//All Messages
struct Messages {
    
    static let YES            = "YES".localized
    static let NO             = "NO".localized
    static let OK             = "OK".localized
    static let CANCEL         = "Cancel".localized
    static let SETTING        = "Setting".localized
    static let Logout         = "Logout".localized
    static let NOTNOW         = "NotNow".localized
    static let NOINTERNET     = "No internet connection available.".localized
    static let TIMEOUT        = "Request timed out.".localized
    static let NWLOST         = "Network connection lost.".localized
    static let HOSTUNAV       = "Host not available.".localized
    static let Gallary        = "Choose new photo from gallery".localized
    static let Camera         = "Take new photo".localized
}

struct Validation {
    
    static let ShareNow                     = "Share now functionality not supported in simulator.".localized
    static let MailComposer                 = "Mail composer is not supported in simulator.".localized
    static let Print                        = "Print option will be available soon.".localized
    static let ForgotPass                   = "Email has been sent to your registered email address.".localized
    static let iPadTCompatible               = "Application Can be used Only in iPad as you are TEACHER.".localized
    static let iPadSCompatible               = "Application Can be used Only in iPad as you are STUDENT.".localized
    static let enterCategory                = "Please enter Category Name.".localized
    static let enterEmail                   = "Please enter an Email.".localized
    static let enterValidEmail              = "Please enter valid Email.".localized
    static let enterPassword                = "Please enter Password.".localized
    static let enterMinPassword             = "Password should be of minimum Six characters.".localized
    static let enterMinNewPassword          = "New Password should be of minimum Six characters.".localized
    static let enterMinCnfPassword          = "Confirm Password should be of minimum Six characters.".localized
    static let validPassword                = "Password must contain at least one uppercase, lowercase, numeric value, special character and should not be less than Six characters.".localized
    static let firstnameEmoji               = "Firstname can't contain emojis.".localized
    static let lastnameEmoji                = "Lastname can't contain emojis.".localized
    static let passwordEmoji                = "Password can't contain emojis.".localized
    static let passwordNewEmoji             = "New Password can't contain emojis.".localized
    static let EmailValidation              = "Please enter valid Email.".localized
    static let ConfirmPassword              = "Please enter Confirm Password.".localized
    static let PasswordConfirmPswNotMatch   = "Password and Confirm Password does not match.".localized
    static let enterMinLengthNewPassword    = "Password should be of minimum Six characters.".localized
    
    static let confirmPasswordNotMatch      = "Password and confirm password does not match.".localized
    static let NewConfirmPasswordNotMatch   = "New Password and Confirm Password does not match.".localized
    static let oldConfirmPasswordnosameMatch = "Old password and New Password should not be same.".localized
    
    static let TermsMssg                    = "Please accept Terms & Conditions and Privacy Policy.".localized
    
    static let enterConfirmPassword         = "Please enter Confirm Password.".localized
    static let oldPassIncorrect             = "Old Password is incorrect.".localized
    static let enterOldPassword             = "Please enter Old password.".localized
    static let enterNewPassword             = "Please enter New Password.".localized
    static let enterFirstname               = "Please enter First Name.".localized
    static let enterLastName                = "Please enter Last Name.".localized
    static let enterPassCode                = "Please enter Passcode.".localized
    static let enterSuburb                  = "Please enter Suburb.".localized
    static let enterChildrenCount           = "Please select Children count to linked in account.".localized
    static let selectSchool                 = "Please select School.".localized
    static let enterusername                = "Please enter User Name.".localized
    static let enterTeacherID               = "Please enter TeacherID.".localized
    static let enterBirthdate               = "Please select date of birth.".localized
    static let enterMoreCharacterFirstName  = "First Name should have at least 2 characters.".localized
    static let enterMoreCharacterLastName   = "Last Name should have at least 2 characters.".localized
    
    static let categoryName                 = "Please add sub-category.".localized
    static let studentName                  = "Please select Student.".localized
    static let subjectName                  = "Please select Subject.".localized
    static let enterDate                    = "Please select Date.".localized
    static let enterTime                    = "Please select Time.".localized
    static let subjectNameError             = "Subject Name should have at least 2 characters.".localized
    static let progressMssg                 = "Please enter Progress.".localized
    static let progressMssgError            = "Progress should have at least 2 characters.".localized
    static let participationMssg            = "Please enter Participation.".localized
    static let participationMssgError       = "Participation should have at least 2 characters.".localized
    static let behaviourMssg                = "Please enter Behaviour.".localized
    static let behaviourMssgError           = "Behaviour should have at least 2 characters.".localized
    static let attentionMssg                = "Please enter Attention.".localized
    static let attentionMssgError           = "Attention should have at least 2 characters.".localized
    static let generalNotesMssg             = "Please enter General Notes.".localized
    static let generalNotesMssgError        = "General Notes should have at least 2 characters.".localized
    static let selectStudent                = "Please select at-least one student.".localized
    static let subWorksheetSelect           = "Please select worksheet type.".localized
    static let selectSubjectCatName         = "Category name already added.".localized
    static let CardHolder                   = "Please enter Card Holder Name.".localized
    static let CardNumber                   = "Please enter Card Number.".localized
    static let CardExpMonth                 = "Please enter Card Expiry Month.".localized
    static let CardExpMonthProper           = "Card Expiry Month is not proper.".localized
    static let CardExpYear                  = "Please enter Card Expiry Year.".localized
    static let CardCVV                      = "Please enter Card CVV.".localized
    static let LogOut                       = "Are you sure want to Logout?".localized
    static let feedTitle                    = "Please enter Feature.".localized
    static let feedDesc                     = "Please enter Experience.".localized
    static let ExperienceDesclength         = "Experience should be of minimum 20 characters.".localized
    static let FeatureDesclength            = "Feature should be of minimum 20 characters.".localized
    static let subClr                       = "Please select subject cover color.".localized
    static let subCover                     = "Please select subject cover image.".localized
    static let worksheetAssign              = "Worksheet assign succesfully.".localized
    static let worksheetSave                = "Did you completed worksheet is yes than it will submit to teacher.".localized
    
}
