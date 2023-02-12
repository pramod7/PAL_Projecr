//
//  TipsTableViewCell.swift
//  PAL
//
//  Created by i-Verve on 24/11/20.
//

import UIKit

class TipsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var objjView: UIView!
    @IBOutlet weak var lblData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblData.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        objjView.layer.cornerRadius = objjView.layer.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
