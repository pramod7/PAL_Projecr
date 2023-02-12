//
//  StudentNewPageCell.swift
//  PAL
//
//  Created by i-Verve on 03/12/20.
//

import UIKit

class StudentNewPageCell: UICollectionViewCell {
    
    @IBOutlet weak var imgview: UIImageView!{
        didSet{
            imgview.layer.borderColor = UIColor.kAppThemeColor().cgColor
            imgview.layer.borderWidth = 0.5
            imgview.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var lblData: UILabel!{
        didSet{
            self.lblData.font = UIFont.Font_WorkSans_Regular(fontsize: 18)
        }
    }
    
    @IBOutlet weak var objviewMain: UIView!
    
}
