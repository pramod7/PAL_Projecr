//
//  SetupStudentProfileCell.swift
//  PAL
//
//  Created by i-Verve on 06/11/20.
//

import UIKit

class SetupStudentProfileCell: UITableViewCell {
    
    //MARK:- Outlet variable
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTechaerName: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var lblIndicator: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.layer.cornerRadius = (DeviceType.IS_IPHONE) ? ((ScreenSize.SCREEN_WIDTH) * 0.1)/2 : ((ScreenSize.SCREEN_WIDTH) * 0.07)/2
        lblTechaerName.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
        lblId.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
        lblIndicator.font = UIFont.Font_ProductSans_Bold(fontsize: 20)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
