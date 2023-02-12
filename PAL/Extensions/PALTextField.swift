//
//  PALTextField.swift
//  Fishy
//
//  Created by i-Verve on 31/10/20.
//  Copyright © 2020 PAL. All rights reserved.
//
import Foundation
import UIKit

class PALTextField: UITextField {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
        
    func commonInit(){
        self.autocorrectionType = .no
        self.font = (DeviceType.IS_IPHONE) ? UIFont.Font_WorkSans_Regular(fontsize: 15) : UIFont.Font_WorkSans_Regular(fontsize: 18)
        self.placeHolderColor = UIColor.kPlaceholderColor()
        self.textColor = UIColor.kTextFieldColorColor()
    }
    
    func setLeftIcon(_ icon: UIImage) {
      let padding = 10
      let size = 20

      let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding+16, height: size))
      let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
      iconView.contentMode = .scaleAspectFit
      iconView.image = icon
      outerView.addSubview(iconView)

      leftView = outerView
      leftViewMode = .always
    }
    
    func setRightIcon(_ icon: UIImage) {
      let padding = 15
      let size = 20

      let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding+5, height: size))
        outerView.backgroundColor = UIColor.clear
      let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
      iconView.contentMode = .scaleAspectFit
      iconView.image = icon
      outerView.addSubview(iconView)

      rightView = outerView
      rightViewMode = .always
    }
    
    @IBInspectable override var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
   
}

