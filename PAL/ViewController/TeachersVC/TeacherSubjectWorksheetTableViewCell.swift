//
//  TeacherSubjectWorksheetTableViewCell.swift
//  PAL
//
//  Created by i-Verve on 25/11/20.
//

import UIKit

class TeacherSubjectWorksheetTableViewCell: UITableViewCell {
    
    //MARK: Outlet Variable
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        }
    }
    @IBOutlet weak var lblDate: UILabel!{
        didSet{
            lblDate.font = UIFont.Font_ProductSans_Regular(fontsize: 14)
        }
    }
    @IBOutlet weak var lblPratice: UILabel!{
        didSet{
            lblPratice.font = UIFont.Font_ProductSans_Regular(fontsize: 10)
        }
    }
    @IBOutlet weak var objView: UIView!{
        didSet{
            objView.ShadowWithRadius(Radius: 5, shadowRadius: 5, ShadowOpacity: 0.2, offsetWidth: Int(1.0), offsetHeight: Int(1.0))
        }
    }
    @IBOutlet weak var objViewPratice: UIView!{
        didSet{
            objViewPratice.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnAssign: UIButton!{
        didSet{
            self.btnAssign.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
            self.btnAssign.layer.cornerRadius = 5
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
