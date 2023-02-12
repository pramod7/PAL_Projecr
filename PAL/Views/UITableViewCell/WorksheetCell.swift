//
//  WorksheetCell.swift
//  PAL
//
//  Created by i-Phone7 on 25/11/20.
//

import UIKit

class WorksheetCell: UITableViewCell {

    //MARk:-Outlet variable
    @IBOutlet weak var btnEye: UIButton!{
        didSet{
            btnEye.imageView?.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var btnFav: UIButton!{
        didSet{
            btnFav.imageView?.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var btnDownload: UIButton!{
        didSet{
            btnDownload.imageView?.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!{
        didSet{
            lblName.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        }
    }
    @IBOutlet weak var ArchivelblName: UILabel!{
        didSet{
            ArchivelblName.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
        }
    }
    @IBOutlet weak var lblDate: UILabel!{
        didSet{
            lblDate.font = UIFont.Font_WorkSans_Regular(fontsize: 12)
        }
    }
    @IBOutlet weak var objView: UIView!{
        didSet{
            self.objView.borderShadowAllSide(Radius: (DeviceType.IS_IPHONE) ? 15: 5)
        }
    }
    
    //MARK:- btn Click
    @IBAction func btnDownloadClick(_ sender: Any) {
        btnDownlaodCompletion?()
    }
    
    @IBAction func btnEyeClick(_ sender: Any) {
        btnEyeCompletion?()
    }
    
    @IBAction func btnFavClick(_ sender: Any) {
        btnFavCompletion?()
    }
    
    //MARK:- block
    var btnDownlaodCompletion : (()->())?
    var btnEyeCompletion : (()->())?
    var btnFavCompletion : (()->())?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
