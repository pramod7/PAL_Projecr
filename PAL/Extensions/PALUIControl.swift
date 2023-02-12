//
//  PALUIControl.swift
//  PAL
//
//  Created by i-Phone7 on 15/07/20.
//  Copyright © 2020 i-Phone7. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

private var kAssociationKeyMaxLength: Int = 0

//MARK: - ActivityController
extension UIActivityIndicatorView {
    
    func activityView() {
        self.color = UIColor(named: "Color_appTheme")
        self.hidesWhenStopped = true
    }
}

//MARK: - UIButton
extension UIButton {
    
    func btnCornerRedius() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.kAppThemeColor().cgColor
    }
    
    func btnUnSelectBorder() {
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.kbtnAgeSetup().cgColor
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.black, for: .normal)
    }
    
    func btnSelectedSetup(color: UIColor){
        self.backgroundColor = color
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.white, for: .normal)
        self.isSelected = true
    }
    
    func btnCornerRediusCommon() {
        self.layer.cornerRadius = self.frame.size.height / 2
    }
}

extension UICollectionViewFlowLayout {
    var flowLayoutTeacher: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
//        _flowLayout.itemSize = CGSize(width: (ScreenSize.SCREEN_WIDTH - 40) / 3.5 , height: teacherCellHeight)
        _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        _flowLayout.minimumInteritemSpacing = 20
        _flowLayout.minimumLineSpacing = 20
        return _flowLayout
    }
}

extension String {
    static var bundle = Bundle.main
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: String.bundle, value: "", comment: "")
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
    
    var trim : String {
        get {
            return self.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
    
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    var textlength: Int {
        get {
            return (self as NSString).length
        }
    }
    
    var isValidName: Bool {
        let emailRegEx = "[A-Z-a-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var isValidPassword: Bool {
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        return passwordValidation.evaluate(with: self)
    }
    
    var isValidAccountNumber: Bool {
           let PHONE_REGEX = "^[0-9]{12}$";
           let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
           let result =  phoneTest.evaluate(with: self)
           return result
       }
       var isValidAcoountName: Bool {
           let PHONE_REGEX = "^\\w{2,}$";
           let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
           let result =  phoneTest.evaluate(with: self)
           return result
       }
       
       var isValidRoutingNumber: Bool {
           let PHONE_REGEX = "^[0-9]{9}$";
           let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
           let result =  phoneTest.evaluate(with: self)
           return result
       }
       
       var isValidAddress: Bool {
           let REGEX = "^[a-z0-9'._ /\\-\\s]{2,20}$"
           let test = NSPredicate(format: "SELF MATCHES %@", REGEX)
           let result =  test.evaluate(with: self)
           return result
       }
       
       var isValidCity: Bool {
           let REGEX = "^\\w{2,}$";
           let test = NSPredicate(format: "SELF MATCHES %@", REGEX)
           let result =  test.evaluate(with: self)
           return result
       }
       var isValidZipcode: Bool {
           let PHONE_REGEX = "^[0-9]{6}$";
           let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
           let result =  phoneTest.evaluate(with: self)
           return result
       }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
       let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
       label.numberOfLines = 0
       label.text = self
       label.font = font
       label.sizeToFit()
       return label.frame.height
    }
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F1E6...0x1F1FF: // Flags
                return true
            default:
                continue
            }
        }
        return false
    }
   
    }

//MARK: - UIImageView
extension UIImageView {
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    public func imageFromURL(_ urlString : String, placeHolder : UIImage){
        if let str = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed){
            if let url = URL(string: str) {
                self.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.sd_setImage(with: url, placeholderImage: placeHolder, options: SDWebImageOptions(rawValue: 8), completed: { (image, error, cacheType, imageURL) in
                })//.refreshCached
            }
        }
    }
}

//MARK: - UIImage
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }
        return self
    }
}

extension UILabel{
    func navTitle(strText: String, titleColor: UIColor) {
        self.text = strText
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = .center
        self.textColor = titleColor
        self.font = UIFont.Font_ProductSans_Bold(fontsize: 18)
    }
}

extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }

    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        selectedTextRange = selection
    }
    
    func setRightPaddingWithImage(placeholderTxt: String, img : UIImage, fontSize: CGFloat, isLeftPadding:Bool){
        if isLeftPadding{
            setLeftPaddingPoints()
        }
        let imgHW:CGFloat = (DeviceType.IS_IPHONE) ? 20 :40
        let imgY = (self.frame.size.height / 2) - (imgHW / 2)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: (DeviceType.IS_IPHONE) ? 40 : 40, height: self.frame.size.height))
//        paddingView.backgroundColor = .red
        let imgv = UIImageView(frame:  CGRect(x: 0, y: imgY, width: imgHW, height: imgHW))
        imgv.image = img
       // imgv.backgroundColor = .cyan
        imgv.contentMode = UIView.ContentMode.scaleAspectFit
        imgv.isUserInteractionEnabled = false
        paddingView.isUserInteractionEnabled = false
        paddingView.addSubview(imgv)
        self.rightView = paddingView
        self.rightViewMode = .always
        
        placeholder = placeholderTxt
        backgroundColor = .clear
//        let attributes = [
//            NSAttributedString.Key.foregroundColor: Colors.appGray,
//            NSAttributedString.Key.font : Font.Regular.of(size: 14)
//        ]
//        attributedPlaceholder = NSAttributedString(string: placeholderTxt, attributes:attributes)
        
    }
   
    func setLeftPaddingPoints(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
    func addPlaceholder(strPlaceholder: String){
        let placeholderLabel = UILabel()
        placeholderLabel.text = strPlaceholder
        placeholderLabel.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 999
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(named: "Color_lightGrey_112")
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
    }
    
    func checkPlaceholder(){
        if let placeholderLabel = self.viewWithTag(999) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
}

extension UIViewController {
        
    func showAlertWithBackAction(title : String?, message : String?, isBack: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.5333333333, green: 0.5960784314, blue: 0.9019607843, alpha: 1)
        alert.addAction(UIAlertAction(title: Messages.OK, style: .default) { action in
            if isBack{
                self.navigationController?.popViewController(animated: true)
            }
        })
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}

extension Int {
    var switchNumber: Int {
        return self == 0 ? 1 : 0
    }
}

//MARK: - Date
extension Date{
    
    var inThePast: Bool {
        return timeIntervalSinceNow < 0
    }
    
    var minimumUserDate: Date {
        return Calendar.current.date(byAdding: .year, value: -100, to: Date())!
    }
    
    var maximumUserDate: Date {
        return Calendar.current.date(byAdding: .year, value: -5, to: Date())!
    }
    
    static func today() -> Date {
        return Date()
    }
    
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next, weekday, considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous, weekday, considerToday: considerToday)
    }
    
    var year: Int? {
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year], from: self)
        return currentComponents.year
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}

//MARK: - cutome delegate
class CustomTextFieldDelegate : NSObject, UITextFieldDelegate {

    static let sharedInstance:CustomTextFieldDelegate = CustomTextFieldDelegate();
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing ...")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            if self.textField == textField || self.txtLastName == textField{
//                do {
//                    let regex = try NSRegularExpression(pattern: ".*[^A-Za-z' ].*", options: [])
//                    if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
//                        return false
//                    }
//                }
//                catch {
//                    print("ERROR")
//                }
//            }
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z' ].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                return false
            }
        }
        catch {
            print("ERROR")
        }
        return true
    }
   //... other methods
} //F.E.
