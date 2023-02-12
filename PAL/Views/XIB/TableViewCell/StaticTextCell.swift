//
//  StaticTextCell.swift
//  PAL
//
//  Created by i-Phone7 on 26/11/20.
//

import UIKit

class StaticTextCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = UIFont.Font_ProductSans_Bold(fontsize: 18)
        }
    }
    @IBOutlet weak var btnAction: UIButton!{
        didSet{
            btnAction.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
        }
    }
    @IBOutlet weak var btnActionArrow: UIButton!
    @IBOutlet weak var nslcViewWidth: NSLayoutConstraint!{
        didSet{
            nslcViewWidth.isActive = DeviceType.IS_IPHONE ? true:false
        }
    }
    
    //MARK:- btn Click
    @IBAction func btnSeeAllClick(_ sender: Any) {
        btnSeeAllCompletion?()
    }
    
    //MARK:- block
    var btnSeeAllCompletion : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
