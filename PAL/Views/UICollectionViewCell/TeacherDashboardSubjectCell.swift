//
//  TeacherDashboardSubjectCell.swift
//  PAL
//
//  Created by i-Phone7 on 27/11/20.
//

import UIKit

class TeacherDashboardSubjectCell: UICollectionViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var viewBack: UIView!{
        didSet{
            viewBack.layer.cornerRadius = 10
            viewBack.clipsToBounds = true
        }
    }
    @IBOutlet weak var imgSubjects: UIImageView!
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
        }
    }
}
