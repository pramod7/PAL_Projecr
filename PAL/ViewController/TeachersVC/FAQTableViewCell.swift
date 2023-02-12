//
//  FAQTableViewCell.swift
//  PAL
//
//  Created by i-Verve on 25/11/20.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var imgRotate: UIImageView!
    @IBOutlet weak var lblanswer: UILabel!{
        didSet{
            self.lblanswer.font = UIFont.Font_ProductSans_Regular(fontsize: 18)
        }
    }
    @IBOutlet weak var objView: UIView!{
        didSet{
            if DeviceType.IS_IPHONE{
                self.objView.layer.cornerRadius = 15
            }
            else{
                self.objView.layer.cornerRadius = 30
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
