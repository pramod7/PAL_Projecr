//
//  SubjectTilesInfoiPadCell.swift
//  PAL
//
//  Created by i-Phone7 on 26/11/20.
//

import UIKit

class SubjectTilesInfoiPadCell: UICollectionViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var imgProgress: UIImageView!
    @IBOutlet weak var imgMarking: UIImageView!
    @IBOutlet weak var lblSubjectName: UILabel!{
        didSet{
            lblSubjectName.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
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
            viewBack.layer.cornerRadius = 5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
