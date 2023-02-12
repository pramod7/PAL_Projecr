//
//  weekSelectionCell.swift
//  PAL
//
//  Created by i-Verve on 04/12/20.
//

import UIKit

class weekSelectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblWeek: UILabel!{
        didSet{
            self.lblWeek.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        }
    }
    
    @IBOutlet weak var objView: UIView!{
        didSet{
            self.objView.layer.borderWidth = 1
            self.objView.layer.borderColor = UIColor.kApp_Sky_Color().cgColor
        }
    }
}
