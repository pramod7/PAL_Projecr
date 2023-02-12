//
//  ReportCardListTableViewCell.swift
//  PAL
//
//  Created by i-Verve on 23/11/20.
//

import UIKit

class ReportCardListTableViewCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var lblSubject: UILabel!{
        didSet{
            self.lblSubject.font = UIFont.Font_ProductSans_Bold(fontsize: 18)
        }
    }
    @IBOutlet weak var lblTotal: UILabel!{
        didSet{
            self.lblTotal.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    @IBOutlet weak var btnShow: UIButton!{
        didSet{
            self.btnShow.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
            self.btnShow.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var objView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        if DeviceType.IS_IPAD {
            self.objView.layer.cornerRadius = 10
            self.btnShow.layer.cornerRadius = 5
        }
        else {
            self.objView.layer.cornerRadius = 5
            self.btnShow.layer.cornerRadius = 5
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
