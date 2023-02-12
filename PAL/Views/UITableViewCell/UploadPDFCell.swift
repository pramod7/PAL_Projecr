//
//  UploadPDFCell.swift
//  PAL
//
//  Created by i-Phone7 on 25/11/20.
//

import UIKit

class UploadPDFCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var imgDocType: UIImageView!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var lblDocName: UILabel!{
        didSet{
            lblDocName.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        }
    }
    @IBOutlet weak var lblDocSize: UILabel!{
        didSet{
            lblDocSize.font = UIFont.Font_WorkSans_Meduim(fontsize: 14)
        }
    }
    @IBOutlet weak var lblProgress: UILabel!{
        didSet{
            lblProgress.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
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
