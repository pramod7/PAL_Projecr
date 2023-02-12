//
//  CertificateSelectionVC.swift
//  PAL
//
//  Created by i-Verve on 19/05/21.
//

import UIKit

protocol CertificateSelectionListDelegate{
    func CertificateSelection(strText : NSString,strID : NSInteger)
}

class CertificateSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblStudentList: UITableView!
    @IBOutlet weak var lblNoStudent: UILabel!{
        didSet{
            self.lblNoStudent.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
        }
    }
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    
    var isPopOver = Bool()
    var arrChildrenCount = [String]()
    var logoImages: [UIImage] = []
    
    var delegate : CertificateSelectionListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBarHeight.constant = 0
        if let nav = self.navigationController {
            nonTransparentNav(nav: nav)
            
            let titleLabel = UILabel()
            titleLabel.navTitle(strText: "Certificate Type", titleColor: .white)
            self.navigationItem.titleView = titleLabel
        }
        
        self.arrChildrenCount = ["Excellence", "Improvement", "Participation"]
       
        logoImages += [UIImage(named: "Icon_excellence")!,UIImage(named: "Icon_improvement")!,UIImage(named: "Icon_participation")!]
    }
    
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return self.arrChildrenCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentListTableViewCell") as! StudentListTableViewCell
        
        cell.lblStudentName.text = self.arrChildrenCount[indexPath.row]
        cell.imgList.image = self.logoImages[indexPath.row]
        if self.isPopOver{
            cell.viewCircle.layer.cornerRadius = 25
            cell.viewCircleWidth.constant = 50
            cell.lblIndicatorName.font = UIFont.Font_ProductSans_Bold(fontsize: 14)
            cell.lblIndicatorName.text = "Certificate Type"
        }
        else{
            cell.viewCircle.layer.cornerRadius = (ScreenSize.SCREEN_WIDTH * 0.07) / 2
            cell.viewCircleWidth.constant = (ScreenSize.SCREEN_WIDTH * 0.07)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.CertificateSelection(strText:self.arrChildrenCount[indexPath.row] as NSString, strID: indexPath.row + 1)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

  

}
