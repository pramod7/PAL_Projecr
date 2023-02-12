//
//  SubjectTilesInfoCell.swift
//  PAL
//
//  Created by i-Phone7 on 26/11/20.
//

import UIKit

class SubjectTilesInfoCell: UICollectionViewCell {
    
    //MARK: - Outlet variable
    @IBOutlet weak var imgProgress: UIImageView!
    @IBOutlet weak var imgMarking: UIImageView!{
        didSet{
            imgMarking.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var lblSubjectName: UILabel!{
        didSet{
            lblSubjectName.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    @IBOutlet weak var lblTeacherName: UILabel!{
        didSet{
            lblTeacherName.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
        }
    }
    @IBOutlet weak var lblTeacherId: UILabel!{
        didSet{
            lblTeacherId.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
        }
    }
    @IBOutlet weak var lblDate: UILabel!{
        didSet{
            lblDate.font = UIFont.Font_WorkSans_Regular(fontsize: 10)
        }
    }
    @IBOutlet weak var viewBack: UIView!{
        didSet{
            viewBack.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var nslcBigImgWidth: NSLayoutConstraint!{
        didSet{
            nslcBigImgWidth.isActive = DeviceType.IS_IPHONE ? true:false
        }
    }
    @IBOutlet weak var nslcBigImgHeight: NSLayoutConstraint!{
        didSet{
            nslcBigImgHeight.isActive = DeviceType.IS_IPHONE ? true:false
        }
    }
    @IBOutlet weak var lblTeacherHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTeacherIDHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDatebottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
