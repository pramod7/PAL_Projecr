//
//  SingleStaticLineCell.swift
//  PAL Design
//
//  Created by i-Phone7 on 02/11/20.
//

import UIKit

class SingleStaticLineCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet var nslcLeadingSpace: NSLayoutConstraint!{
        didSet{
            if DeviceType.IS_IPHONE {
                nslcLeadingSpace.isActive = true
            }
            else {
                nslcLeadingSpace.isActive = false
            }
        }
    }
    @IBOutlet var lblText: UILabel!{
        didSet{
            lblText.textColor = .kApp_Sky_Color()
            lblText.font = UIFont.Font_ProductSans_Regular(fontsize: 17) 
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
