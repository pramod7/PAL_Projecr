//
//  AllocationStudentCell.swift
//  PAL
//
//  Created by i-Verve on 07/12/20.
//

import UIKit

class AllocationStudentCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            self.lblName.font = UIFont.Font_ProductSans_Regular(fontsize: 18)
        }
    }
    @IBOutlet weak var viewCircle: UIView!{
        didSet{
            self.viewCircle.layer.cornerRadius = 25//(ScreenSize.SCREEN_WIDTH * 0.07) / 2
        }
    }
    @IBOutlet weak var lblIndicator: UILabel!{
        didSet{
            self.lblIndicator.font = UIFont.Font_ProductSans_Bold(fontsize: 18)
        }
    }
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var viewShadow: UIView! {
        didSet{
            viewShadow.layer.shadowColor = UIColor.black.cgColor
            viewShadow.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            viewShadow.layer.shadowOpacity = 0.2
            viewShadow.layer.shadowRadius = 5
        }
    }
    
    @IBOutlet weak var objBottomshadoview: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
