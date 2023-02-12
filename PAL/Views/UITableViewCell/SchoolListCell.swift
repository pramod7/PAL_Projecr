//
//  SchoolListCell.swift
//  PAL
//
//  Created by i-Phone7 on 23/11/20.
//

import UIKit

class SchoolListCell: UITableViewCell {
    
    //MARK: outlet variable
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var lblSchoolName: UILabel!{
        didSet{
            lblSchoolName.font = UIFont.Font_WorkSans_Regular(fontsize: 14)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
