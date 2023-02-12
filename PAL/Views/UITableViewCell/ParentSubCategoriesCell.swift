//
//  ParentSubCategoriesCell.swift
//  
//
//  Created by i-Verve on 10/11/20.
//

import UIKit

class ParentSubCategoriesCell: UITableViewCell {
    
    //MARk:-Outlet variable
    @IBOutlet weak var btnEye: UIButton!{
        didSet{
            btnEye.imageView?.setImageColor(color: UIColor(named: "Color_lightSky")!)
            btnEye.imageView?.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var objView: UIView!{
        didSet{
            self.objView.borderShadowAllSide(Radius: (DeviceType.IS_IPHONE) ? 15: 5)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        lblDate.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
        self.btnSelect.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 12)
        self.btnSelect.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
