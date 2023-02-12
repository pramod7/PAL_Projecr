//
//  AddNewsubjectCollectionViewCell.swift
//  PAL
//
//  Created by i-Verve on 26/11/20.
//

import UIKit

class AddNewsubjectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ObjView: UIView!{
        didSet{
            ObjView.layer.cornerRadius = ObjView.layer.frame.width/2
            ObjView.layer.borderWidth = 0.5
            ObjView.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var imgselect: UIImageView!
    @IBOutlet weak var btnSelected: UIButton!
}
