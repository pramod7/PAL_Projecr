//
//  SelectCategoryParentCell.swift
//  PAL
//
//  Created by i-Verve on 23/10/20.
//

import UIKit

class SelectCategoryParentCell: UITableViewCell {
    
    //MARK:- Outlet Varoable
    @IBOutlet weak var objView: UIView!{
        didSet {
            objView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var imgForword: UIImageView!{
        didSet{
            imgForword.transform = imgForword.transform.rotated(by: .pi)
        }
    }
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblData: UILabel!{
        didSet{
            lblData.font = DeviceType.IS_IPHONE ? UIFont.Font_ProductSans_Bold(fontsize: 16) : UIFont.Font_ProductSans_Bold(fontsize: 14)
        }
    }
    /*@IBOutlet weak var imgViewWidth: NSLayoutConstraint!{
        didSet {
            if DeviceType.IS_IPHONE{
                imgViewWidth.isActive = true
            }
            else{
                imgViewWidth.isActive =  false
            }
        }
    }
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!{
        didSet {
            if DeviceType.IS_IPHONE{
                mainViewWidth.isActive = true
            }
            else{
                mainViewWidth.isActive =  false
            }
        }
    }
    @IBOutlet weak var lblDataleading: NSLayoutConstraint!
    @IBOutlet weak var imgTrelling: NSLayoutConstraint!*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
