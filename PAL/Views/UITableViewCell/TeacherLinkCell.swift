//
//  TeacherLinkCell.swift
//  PAL
//
//  Created by i-Verve on 11/11/20.
//

import UIKit

class TeacherLinkCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTeacherId: UILabel!
    @IBOutlet weak var btnLink: UIButton!{
        didSet{
            btnLink.layer.cornerRadius = 5
            btnLink.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var lblnameVertical: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblName.font = UIFont.Font_ProductSans_Bold(fontsize: 17)
        self.lblTeacherId.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        self.btnLink.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
