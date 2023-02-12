//
//  SettingCell.swift
//  PAL
//
//  Created by i-Verve on 29/10/20.
//

import UIKit

class SettingCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var imgIndicator: UIImageView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    @IBOutlet weak var objView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if  Preferance.user.userType == 1 {
            self.objView.layer.borderWidth = 1
            self.objView.layer.borderColor = UIColor.kAppThemeColor().cgColor
            self.objView.layer.cornerRadius = 10
        }
        else {
            self.imgIndicator.image = UIImage(named: "icon_Next_Arrow")
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
