//
//  ColorSelectionVC.swift
//  PAL
//
//  Created by i-Verve on 27/11/20.
//

import UIKit

class ColorSelectionVC: UIViewController {
    
    @IBOutlet weak var objCollection: UICollectionView!
    @IBOutlet weak var lblChoosecolor: UILabel!
    let colorArray = [UIColor(named: "Color_Yellow"),UIColor(named: "Color_white"),UIColor(named: "Color_Red"),UIColor(named: "Color_purple"),UIColor(named: "Color_Orange"),UIColor(named: "Color_Magenta"),UIColor(named: "Color_Green"),UIColor(named: "Color_cyan"),UIColor(named: "Color_Brown"),UIColor(named: "Color_Blue"),UIColor(named: "Color_Black"),UIColor(named: "Color_lightSky"),UIColor(named: "Color_physics"), UIColor(named: "Color_chemistry"),UIColor(named: "Color_appTheme"),UIColor(named: "Color_English"),UIColor(named: "Color_Science")]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.20)
        lblChoosecolor.font = UIFont.Font_ProductSans_Regular(fontsize: 30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.20)
    }

    @objc func buttonClicked(sender:UIButton) {
        self.objCollection.reloadData()
    }

    @IBAction func btnDismisssClick(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
extension ColorSelectionVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewsubjectCollectionViewCell", for: indexPath) as! AddNewsubjectCollectionViewCell
        cell.ObjView.backgroundColor = colorArray[indexPath.item]
        cell.ObjView.layer.cornerRadius = cell.ObjView.layer.frame.width/2
        cell.ObjView.layer.borderWidth = 0.5
        cell.ObjView.layer.borderColor = UIColor.black.cgColor
        cell.btnSelected.tag = indexPath.item
        cell.btnSelected.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        if indexPath.item == 0
        {
            cell.imgselect.isHidden = false
        }else{
            cell.imgselect.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                return CGSize(width: 90, height: 90)
    }
    
   
    
    
}
