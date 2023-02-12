//
//  SubjectWorkSheetCell.swift
//  PAL
//
//  Created by i-Verve on 26/11/20.
//

import UIKit

class SubjectWorkSheetCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet var btnfav: UIButton!
    @IBOutlet var imgfav: UIImageView!
    @IBOutlet var imgdelete: UIImageView!
    @IBOutlet var btndelete: UIButton!
    @IBOutlet var imgPreview: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblDate.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
        }
    }
    @IBOutlet var lblSubjectName: UILabel!{
        didSet{
            lblSubjectName.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        }
    }
    
    @IBOutlet weak var lblDate: UILabel!{
        didSet{
            lblDate.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
        }
    }
    @IBOutlet weak var objView: UIView!
    @IBOutlet weak var objViewPratice: UIView!{
        didSet{
            objViewPratice.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnAssign: UIButton!{
        didSet{
            btnAssign.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
            btnAssign.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnUnAssign: UIButton!{
        didSet{
            btnUnAssign.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
            btnUnAssign.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var btnMarking: UIButton!{
        didSet{
            btnMarking.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 10)
            btnMarking.btnUnSelectBorder()
        }
    }
    @IBOutlet weak var btnPratice: UIButton!{
        didSet{
            btnPratice.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 10)
            btnPratice.btnUnSelectBorder()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
               
        objView.ShadowWithRadius(Radius: 5, shadowRadius: 5, ShadowOpacity: 0.2, offsetWidth: Int(1.0), offsetHeight: Int(1.0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
