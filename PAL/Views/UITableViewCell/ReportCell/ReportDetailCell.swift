//
//  ReportDetailCell.swift
//  PAL
//
//  Created by i-Verve on 23/11/20.
//

import UIKit

class ReportDetailCell: UITableViewCell {

    //MARK:- Outlet variable
    @IBOutlet weak var viewShadow: UIView!{
        didSet{
            viewShadow.ShadowWithRadius(Radius: 10, shadowRadius: 5, ShadowOpacity: 0.2, offsetWidth: Int(1.0), offsetHeight: Int(1.0))
        }
    }
    @IBOutlet weak var endViewShadow: UIView!{
        didSet{
            endViewShadow.ShadowWithRadius(Radius: 10, shadowRadius: 5, ShadowOpacity: 0.2, offsetWidth: Int(1.0), offsetHeight: Int(1.0))
        }
    }
    @IBOutlet weak var lblCharcteristicsName: UILabel!{
        didSet{
            lblCharcteristicsName.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
        }
    }
    @IBOutlet weak var lblCharcteristicsDesc: UILabel!{
        didSet{
            lblCharcteristicsDesc.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
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
