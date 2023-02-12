//
//  ReportCardCell.swift
//  PAL
//
//  Created by i-Verve on 23/11/20.
//

import UIKit

class ReportCardCell: UICollectionViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var img: UIImageView!{
        didSet{
            img.layer.borderWidth = 1
            img.backgroundColor = .clear
//            img.layer.cornerRadius = scree
        }
    }
    @IBOutlet weak var username: UILabel!{
        didSet{
            username.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
            username.textColor = .white
        }
    }
    @IBOutlet weak var lblCharcter: UILabel!{
        didSet{
            lblCharcter.font = UIFont.Font_ProductSans_Bold(fontsize: 20)
        }
    }
}
