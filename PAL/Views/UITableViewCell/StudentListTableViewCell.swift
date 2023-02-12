//
//  StudentListTableViewCell.swift
//  PAL
//
//  Created by i-Verve on 25/11/20.
//

import UIKit

class StudentListTableViewCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var lblIndicatorName: UILabel!{
        didSet{
            self.lblIndicatorName.font = UIFont.Font_ProductSans_Bold(fontsize: 18)
        }
    }
    @IBOutlet weak var lblStudentName: UILabel!{
        didSet{
            self.lblStudentName.font = UIFont.Font_ProductSans_Regular(fontsize: 18)
        }
    }
    @IBOutlet weak var lblStudentId: UILabel!{
        didSet{
            self.lblStudentId.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet weak var imgWheels: UIImageView!
    
    @IBOutlet weak var imgList: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBOutlet weak var viewCircleWidth: NSLayoutConstraint!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
