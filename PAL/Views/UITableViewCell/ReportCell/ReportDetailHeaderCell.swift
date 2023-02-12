//
//  ReportDetailHeaderCell.swift
//  PAL
//
//  Created by i-Verve on 23/11/20.
//

import UIKit

class ReportDetailHeaderCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var viewShadow: UIView!{
        didSet{
            viewShadow.ShadowWithRadius(Radius: 5, shadowRadius: 5, ShadowOpacity: 0.2, offsetWidth: Int(1.0), offsetHeight: Int(1.0))
        }
    }
    @IBOutlet weak var lblReportNo: UILabel!{
        didSet{
            lblReportNo.font = UIFont.Font_ProductSans_Bold(fontsize: 17)
        }
    }
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        }
    }
    @IBOutlet weak var lblDate: UILabel!{
        didSet{
            lblDate.font = UIFont.Font_WorkSans_Regular(fontsize: 15)
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
