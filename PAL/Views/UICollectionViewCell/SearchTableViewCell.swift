//
//  SearchTableViewCell.swift
//  PAL
//
//  Created by i-Phone on 20/04/21.
//  Copyright © 2021 i-Verve. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Outlet Variable
    @IBOutlet weak var labelText: UILabel!{
        didSet{
            labelText.font = UIFont.Font_WorkSans_Regular(fontsize: 16)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        labelText.textColor = .black
        
    }
    
    // MARK: - CustomMethods
    func configure(searchTableVM: SearchTableVM) -> Void {
        labelText.text = searchTableVM.text
    }
}
