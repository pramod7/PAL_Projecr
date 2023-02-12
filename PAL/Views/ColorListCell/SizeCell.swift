//
//  SizeCell.swift
//  Planner
//
//  Created by i-Verve on 06/09/21.
//  Copyright © 2021 Andrea Clare Lam. All rights reserved.
//

import UIKit

class SizeCell: UICollectionViewCell {
    @IBOutlet weak var lblName:UILabel!{
        didSet{
            lblName.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        }
    }
    @IBOutlet weak var imgCell: UIImageView!
}
