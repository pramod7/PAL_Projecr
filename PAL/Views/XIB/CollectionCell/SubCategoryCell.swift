//
//  SubCategoryCell.swift
//  PAL
//
//  Created by i-Verve on 28/05/21.
//

import UIKit

class SubCategoryCell: UICollectionViewCell {
    
    @IBOutlet var imgSubCategory: UIImageView!{
        didSet{
            imgSubCategory.layer.backgroundColor = UIColor.white.cgColor
            imgSubCategory.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet var view: UIView!{
        didSet{
            view.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet var lblSubjectName: UILabel!
    {
        didSet{
            lblSubjectName.font = UIFont.Font_ProductSans_Bold(fontsize: 17)
        }
    }
    @IBOutlet var lblSubCategoryName: UILabel!
    {
        didSet{
            lblSubCategoryName.font = UIFont.Font_ProductSans_Bold(fontsize: 12)
        }
    }
    @IBOutlet var lblWorkbookName: UILabel!
    {
        didSet{
            lblWorkbookName.font = UIFont.Font_ProductSans_Bold(fontsize: 12)
        }
    }
    @IBOutlet var lblTeacherName: UILabel!
    {
        didSet{
            lblTeacherName.font = UIFont.Font_ProductSans_Bold(fontsize: 12)
        }
    }
    @IBOutlet var lblTeacherId: UILabel!
    {
        didSet{
            lblTeacherId.font = UIFont.Font_ProductSans_Bold(fontsize: 12)
        }
    }
    @IBOutlet var lblDate: UILabel!
    {
        didSet{
            lblDate.font = UIFont.Font_ProductSans_Bold(fontsize: 12)
        }
    }
    
}
