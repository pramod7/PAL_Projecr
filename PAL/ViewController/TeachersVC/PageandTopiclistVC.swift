//
//  PageandTopiclistVC.swift
//  PAL
//
//  Created by i-Verve on 25/11/20.
//

import UIKit

protocol PageListDelegate{
    func saveText(strText : NSString)
}

class PageandTopiclistVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: outlet variable
    @IBOutlet weak var tblPageList: UITableView!
    
    //MARK: local variable
    var delegate : PageListDelegate?
    var arrPageList = [String]()
    var isfromsubject = false
   

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        if isfromsubject {
            self.arrPageList = ["English", "Mathematics", "Biology","Chemistry","Physics","Science"]
        }else{
            self.arrPageList = ["Lined", "Grid", "Blank","Upload","Capture A Photo"]
        }
    }
    
    //MARK:- tbl delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolListCell") as! SchoolListCell
        cell.lblSchoolName?.text =  self.arrPageList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.saveText(strText: self.arrPageList[indexPath.row] as NSString)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
