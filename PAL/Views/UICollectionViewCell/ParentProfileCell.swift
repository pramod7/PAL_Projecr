//
//  ParentProfileCell.swift
//  PAL
//
//  Created by i-Verve on 17/11/20.
//

import UIKit

class ParentProfileCell: UICollectionViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var imgTechaerProfile: UIImageView!{
        didSet{
            imgTechaerProfile.layer.cornerRadius = DeviceType.IS_IPHONE ? (180*0.2)/2 : ((ScreenSize.SCREEN_HEIGHT*0.2)*0.2)/2
        }
    }
    @IBOutlet weak var lblTeacherName: UILabel!{
        didSet{
            lblTeacherName.font = UIFont.Font_ProductSans_Regular(fontsize: 16)
        }
    }
    @IBOutlet weak var lblIndicatorName: UILabel!{
        didSet{
            lblIndicatorName.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        }
    }
    @IBOutlet weak var lblTeacherID: UILabel!{
        didSet{
            lblTeacherID.font = UIFont.Font_ProductSans_Regular(fontsize: 12)
        }
    }
    @IBOutlet weak var btnUnlinkTeacher: UIButton!{
        didSet{
            btnUnlinkTeacher.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 12)
        }
    }
    @IBOutlet weak var objTeacherview: UIView!
    
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblTeacherNameCellSecond: UILabel!
    @IBOutlet weak var lblTeacherIdCellSecond: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var objWorkBook: UIView!
    
    @IBOutlet weak var imgProgress: UIImageView!
    @IBOutlet weak var viewProgressReportType: UIView!
    
    @IBOutlet weak var nslcbtnLinkheight: NSLayoutConstraint!{
        didSet{
            nslcbtnLinkheight.isActive = DeviceType.IS_IPHONE ? true : false
        }
    }
    @IBOutlet weak var lblSubjectTop: NSLayoutConstraint!
    @IBOutlet weak var lblteachernameTop: NSLayoutConstraint!
    @IBOutlet weak var lblTeacherIdTop: NSLayoutConstraint!
    @IBOutlet weak var lblDateTop: NSLayoutConstraint!
    
}
