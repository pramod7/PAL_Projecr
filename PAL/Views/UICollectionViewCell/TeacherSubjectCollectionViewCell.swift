//
//  TeacherSubjectCollectionViewCell.swift
//  PAL
//
//  Created by i-Verve on 24/11/20.
//

import UIKit

class TeacherSubjectCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var imgSubject: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgEditIcon: UIImageView!
    @IBOutlet weak var objView: UIView!{
        didSet{
            objView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var lblSubjectname: UILabel!{
        didSet{
            lblSubjectname.font = UIFont.Font_ProductSans_Bold(fontsize: 22)
        }
    }
    @IBOutlet weak var lblteachername: UILabel!{
        didSet{
            lblteachername.font = UIFont.Font_WorkSans_Meduim(fontsize: 15)
        }
    }
}
