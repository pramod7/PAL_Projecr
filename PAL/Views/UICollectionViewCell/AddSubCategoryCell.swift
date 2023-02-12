
import UIKit

class AddSubCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCategoryName: UILabel!{
        didSet{
            self.lblCategoryName.font = UIFont.Font_WorkSans_Regular(fontsize: 17)
        }
    }
    @IBOutlet weak var btnRemove: UIButton!
    
    //MARK:- block
    var btnRemoveCategoryCompletion : (()->())?
    var btnRemoveVocieCategoryCompletion : (()->())?
    
    //MARK:- btn Click
    @IBAction func btnRemoveClick(_ sender: UIButton) {
        btnRemoveCategoryCompletion?()
    }
    
    @IBAction func btnRemoveVoiceClick(_ sender: UIButton) {
        btnRemoveVocieCategoryCompletion?()
    }
}
