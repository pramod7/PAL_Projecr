//
//  workBookstudentCell.swift
//  PAL
//
//  Created by i-Verve on 02/12/20.
//

import UIKit

class workBookstudentCell: UICollectionViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var lblData: UILabel!{
        didSet{
            lblData.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet weak var objView: UIView!{
        didSet{
            objView.layer.cornerRadius = 10
        }
    }
    @IBOutlet var imgView: UIImageView!
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
    @IBOutlet var lblName: UILabel!{
        didSet{
            lblName.font = UIFont.Font_ProductSans_Regular(fontsize: 13)
        }
    }
}
