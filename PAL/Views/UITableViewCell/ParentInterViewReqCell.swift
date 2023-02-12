//
//  ParentInterViewReqCell.swift
//  PAL
//
//  Created by i-Phone7 on 26/11/20.
//

import UIKit

class ParentInterViewReqCell: UITableViewCell {

    //MARK:- Outlet variable
    @IBOutlet weak var imgView: UIImageView!{
        didSet{
            imgView.layer.cornerRadius = (ScreenSize.SCREEN_WIDTH * 0.055) / 2
        }
    }
    @IBOutlet weak var lblNameIndicator: UILabel!{
        didSet{
            lblNameIndicator.font = UIFont.Font_ProductSans_Bold(fontsize: 17)
        }
    }
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
        }
    }
    @IBOutlet weak var lblEmail: UILabel!{
        didSet{
            lblEmail.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
        }
    }
    @IBOutlet weak var btnInterViewReq: UIButton!{
        didSet{
            btnInterViewReq.titleLabel?.font = UIFont.Font_ProductSans_Regular(fontsize: 15)
            btnInterViewReq.layer.cornerRadius = 5
        }
    }
    
    //MARK:- btn Click
    @IBAction func btnInreViewRqCalled(_ sender: Any) {
        btnInterViewReqCompletion?()
    }
    
    //MARK:- block
    var btnInterViewReqCompletion : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- methods
    func configureCell() {
       // self.lblNameIndicator.text = "R"
        self.lblNameIndicator.textColor = .white
//        UIGraphicsBeginImageContext(self.lblNameIndicator.frame.size)
//        UIGraphicsBeginImageContextWithOptions(self.lblNameIndicator.bounds.size, false, UIScreen.main.scale)
//        self.lblNameIndicator.layer.render(in: UIGraphicsGetCurrentContext()!)
//        self.imgView.image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.lblNameIndicator.textColor = .clear
    }
}
