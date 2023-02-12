//
//  UIView+Extension.swift
//  Bike Check
//
//  Created by i-Phone7 on 22/11/19.
//  Copyright © 2019 i-Phone7. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func setCornerRediusOnly(shadowRadius radius:CGFloat, backColor: UIColor) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.backgroundColor = backColor
    }
 
    func borderShadow() {
        self.layer.cornerRadius = CGFloat(15)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
    }
    
    func borderShadowAllSide(Radius: CGFloat) {
        self.layer.cornerRadius = CGFloat(Radius)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4.0
    }
    
    func bottomCornerRediusWithShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 20, height: 20)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .bottomRight ], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.mask = rectShape
    }
    
    func ShadowWithRadius(Radius: CGFloat, shadowRadius: CGFloat, ShadowOpacity: Float, offsetWidth: Int, offsetHeight: Int) {
        self.layer.cornerRadius = Radius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = ShadowOpacity
        self.layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
        self.layer.shadowRadius = shadowRadius
    }
    
    func roundTopCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        layer.maskedCorners = corners
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    //Add Shadow layer with All corner reduis
    func shadowWithCornerReduisAndRect(cornerReduis: CGFloat, layerColor:UIColor, width:CGFloat, height:CGFloat) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight], cornerRadii: CGSize(width: cornerReduis, height: cornerReduis)).cgPath
        shadowLayer.fillColor = layerColor.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 5
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
//    @IBInspectable
//    var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//        }
//    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius:CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    @IBInspectable
    var shadowOffset : CGSize{
        
        get{
            return layer.shadowOffset
        }set{
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable var shadowOpacity:CGFloat {
        set {
            layer.shadowOpacity = Float(newValue)
        }
        get {
            return CGFloat(layer.shadowOpacity)
        }
    }
}
