//
//  TaskListCollectionViewCell.swift
//  PAL
//
//  Created by i-Verve on 01/12/20.
//

import UIKit

class TaskListCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var lblSubject: UILabel!{
        didSet{
            lblSubject.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet var lblSubcategory: UILabel!{
        didSet{
            lblSubcategory.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet var lblWorksheetName: UILabel!{
        didSet{
            lblWorksheetName.font = UIFont.Font_ProductSans_Regular(fontsize: 12)
        }
    }
    @IBOutlet weak var lblTeacherName: UILabel!{
        didSet{
            lblTeacherName.font = UIFont.Font_ProductSans_Regular(fontsize: 12)
        }
    }
    @IBOutlet weak var imgview: UIImageView!{
        didSet{
            imgview.layer.cornerRadius = 10
            imgview.layer.shadowColor = UIColor.black.cgColor
            imgview.layer.shadowOffset = CGSize(width: 20, height: 20)
            imgview.layer.shadowOpacity = 0.7
            imgview.layer.shadowRadius = 5.0
        }
    }
    @IBOutlet weak var lblDate: UILabel!{
        didSet{
            lblDate.font = UIFont.Font_ProductSans_Regular(fontsize: 12)
        }
    }
    @IBOutlet weak var objviewMain: UIView!{
        didSet{
            objviewMain.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var objViewCircle: UIView!{
        didSet{
            objViewCircle.layer.cornerRadius = objViewCircle.frame.size.height/2
        }
    }
    @IBOutlet var lblChar: UILabel!{
        didSet{
            lblChar.font = UIFont.Font_ProductSans_Regular(fontsize: 12)
        }
    }
}
