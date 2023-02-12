//
//  NotificationCell.swift
//  PAL Design
//
//  Created by i-Phone7 on 02/11/20.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet var lblNameIndicator: UILabel!{
        didSet{
            lblNameIndicator.font =  UIFont.Font_ProductSans_Bold(fontsize: 20)
            lblNameIndicator.layer.cornerRadius = (DeviceType.IS_IPHONE) ? (ScreenSize.SCREEN_WIDTH * 0.13) / 2 :  (ScreenSize.SCREEN_WIDTH * 0.07) / 2
        }
    }
    @IBOutlet var imgUserPic: UIImageView!{
        didSet{
            imgUserPic.layer.cornerRadius = (DeviceType.IS_IPHONE) ? (ScreenSize.SCREEN_WIDTH * 0.13) / 2 :  (ScreenSize.SCREEN_WIDTH * 0.07) / 2
            imgUserPic.backgroundColor = UIColor(named: "Color_appTheme")
        }
    }
    
    @IBOutlet var lblName: UILabel!{
        didSet{
            lblName.font =  UIFont.Font_ProductSans_Regular(fontsize: 18)
        }
    }
    @IBOutlet var lblMssg: UILabel!{
        didSet{
            lblMssg.font =  UIFont.Font_ProductSans_Regular(fontsize: 15)
            lblMssg.textColor = .kPlaceholderColor()
        }
    }
    @IBOutlet var lblLine: UILabel!
    
    @IBOutlet weak var objRequestView: UIView!
    @IBOutlet weak var objRequestViewHeight: NSLayoutConstraint!
    @IBOutlet weak var objTop: NSLayoutConstraint!
    @IBOutlet weak var objBottom: NSLayoutConstraint!
    @IBOutlet weak var btnAccept: UIButton!{
        didSet{
            btnAccept.backgroundColor = .clear
            btnAccept.layer.borderWidth = 1
            btnAccept.layer.borderColor = UIColor.kbtnAgeSetup().cgColor
            btnAccept.layer.cornerRadius = 5
            btnAccept.setTitleColor(UIColor.black, for: .normal)
            btnAccept.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        }
    }
    @IBOutlet weak var btnChangeDate: UIButton!{
        didSet{
            btnChangeDate.backgroundColor = .clear
            btnChangeDate.layer.borderWidth = 1
            btnChangeDate.layer.borderColor = UIColor.kbtnAgeSetup().cgColor
            btnChangeDate.layer.cornerRadius = 5
            btnChangeDate.setTitleColor(.black, for: .normal)
            btnChangeDate.titleLabel?.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        }
    }
    
    @IBOutlet weak var txtDate: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
