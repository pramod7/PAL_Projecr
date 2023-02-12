//
//  CertificateCell.swift
//  PAL
//
//  Created by i-Verve on 11/11/20.
//

import UIKit

class CertificateCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = UIFont.Font_ProductSans_Bold(fontsize: 18)
        }
    }
    @IBOutlet weak var lblDate: UILabel!{
        didSet{
            lblDate.font = UIFont.Font_WorkSans_Meduim(fontsize: 12)
        }
    }
    @IBOutlet weak var lblCertificate: UILabel!{
        didSet{
            lblCertificate.font = UIFont.Font_WorkSans_Meduim(fontsize: 15)
        }
    }
    @IBOutlet weak var objView: UIView!{
        didSet{
            objView.layer.cornerRadius = DeviceType.IS_IPHONE ? 5:10
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
