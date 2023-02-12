//
//  AllocationStudentVC.swift
//  PAL
//
//  Created by i-Verve on 07/12/20.
//
//TeacherSubjectWorkSheetListVC
import UIKit

class AllocationStudentVC: UIViewController {
    
    //MARK:- Outlets variable
    @IBOutlet weak var tblAllocation: UITableView!
    @IBOutlet weak var btnAllSelect: UIButton!
    @IBOutlet weak var lblAllocateTheSubject: UILabel!{
        didSet{
            self.lblAllocateTheSubject.font = UIFont.Font_ProductSans_Bold(fontsize: 16)
        }
    }
    @IBOutlet weak var lblSelectAll: UILabel!{
        didSet{
            self.lblSelectAll.font = UIFont.Font_ProductSans_Regular(fontsize: 17)
        }
    }
    @IBOutlet weak var btnAssignWorkSheet: UIButton!{
        didSet{
            self.btnAssignWorkSheet.titleLabel?.font = UIFont.Font_ProductSans_Bold(fontsize: 15)
            self.btnAssignWorkSheet.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var nslcTBLTopSpace: NSLayoutConstraint!
    
    //MARK:- Local variable
    var arrSelectedStudent = [Int]()
    var dimissAllocateStudent : ((Int) -> Void)?
    var isfromAssign = false
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.arrSelectedStudent.append(0)
        self.arrSelectedStudent.append(2)
        self.arrSelectedStudent.append(5)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
        
    //MARK:- Button Click
    @IBAction func btnAssignWorkSheet(_ sender: Any) {
        if isfromAssign == true {
            self.dismiss(animated: true, completion: nil)
        }
        else{
            if self.arrSelectedStudent.count == 0 {
                showAlertWithBackAction(title: APP_NAME, message: Validation.selectStudent)
            }
            else {
                if let _ = self.dimissAllocateStudent{
                    self.dimissAllocateStudent!(1)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnDimissClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectAll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        self.arrSelectedStudent.removeAll()
        if sender.isSelected{
            self.imgSelected.image = UIImage(named: "Icon_Selected")
            for i in 0...14  {
                self.arrSelectedStudent.append(i)
            }
        }
        else {
            self.imgSelected.image = UIImage(named: "Icon_Non_Selected")
        }
        self.tblAllocation.reloadData()
    }
}

extension AllocationStudentVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllocationStudentCell") as! AllocationStudentCell
        if self.arrSelectedStudent.contains(indexPath.row){
            cell.imgSelect.image = UIImage(named: "Icon_Selected")
        }
        else{
            cell.imgSelect.image = UIImage(named: "Icon_Non_Selected")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrSelectedStudent.contains(indexPath.row){
            self.arrSelectedStudent = self.arrSelectedStudent.filter{ $0
                != indexPath.row }
        }
        else {
            self.arrSelectedStudent.append(indexPath.row)
        }
        if self.arrSelectedStudent.count < 15 {
            self.imgSelected.image = UIImage(named: "Icon_Non_Selected")
            self.btnAllSelect.isSelected = false
        }
        self.tblAllocation.reloadData()
    }
}
