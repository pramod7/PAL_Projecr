//
//  Size&ColorSelectionVC.swift
//  Planner
//
//  Created by i-Verve on 06/09/21.
//  Copyright © 2021 Andrea Clare Lam. All rights reserved.
//

import UIKit

class Size_ColorSelectionVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlet
    @IBOutlet weak var objCollection: UICollectionView!
    
    // MARK: - Local Variable
    
    var arr = ["5","10","15"]
    var arrimg = [UIImage(named: "Pencil_Thin"),UIImage(named: "Pencil_Medium"),UIImage(named: "Pencil_Thick")]
    var arrEraser = [UIImage(named: "Eraser_Thin"),UIImage(named: "Eraser_Medium"),UIImage(named: "Eraser_Thick")]
    var isFromSize = false
    var dismisss : ((Bool,UIColor) -> Void)?
    var dismisssSize : ((Int) -> Void)?
    var arrColors = [UIColor]()
    var isfromSelection = false
    var arrcount = [String]()
    var SelctedIndex = 0
    
    
    var flowLayoutColor: UICollectionViewFlowLayout {
        let flowLayoutColor = UICollectionViewFlowLayout()
        flowLayoutColor.sectionInset = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 20)
        flowLayoutColor.scrollDirection = .horizontal
        flowLayoutColor.minimumInteritemSpacing = 20
        flowLayoutColor.minimumLineSpacing = 20
        return flowLayoutColor
    }
    var flowLayoutvertical: UICollectionViewFlowLayout {
        let flowLayoutvertical = UICollectionViewFlowLayout()
        flowLayoutvertical.sectionInset = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 20)
        flowLayoutvertical.scrollDirection = .vertical
        flowLayoutvertical.minimumInteritemSpacing = 20
        flowLayoutvertical.minimumLineSpacing = 20
        return flowLayoutvertical
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isfromSelection {
            self.objCollection.collectionViewLayout = flowLayoutvertical
        }
        else{
            self.objCollection.collectionViewLayout = flowLayoutColor
        }
        self.navigationController?.isNavigationBarHidden = true
        if #available(iOS 13.0, *) {
            //737373, bb001f, F78303, FED6A0, FDFF6D, 579BE7, 0242A4,
            //A00188, DA009D, 010101, 602A10, 398243, 85C13F
            arrColors = [UIColor(hexString: "737373"),UIColor(hexString: "bb001f"), UIColor(hexString: "F78303"), UIColor(hexString: "FED6A0") ,UIColor(hexString: "FDFF6D"), UIColor(hexString: "579BE7"), UIColor(hexString: "0242A4") , UIColor(hexString: "A00188") , UIColor(hexString: "DA009D") , UIColor(hexString: "010101") , UIColor(hexString: "602A10") , UIColor(hexString: "398243") ,UIColor(hexString: "85C13F")]
        } else {
            // Fallback on earlier versions
        }
        
        self.objCollection.showsHorizontalScrollIndicator = false
        self.objCollection.showsVerticalScrollIndicator = false
    }
    
    // MARK: - btn action
    @objc func btnColorClick(btnColor : UIButton) {
        if let _ = self.dismisss{
            self.dismisss!(true, arrColors[btnColor.tag])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - CollectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isfromSelection{
            return arrcount.count
        }
        else{
            return isFromSize ? self.arr.count : self.arrColors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.isfromSelection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath) as! SizeCell
            print((Int(self.arrcount[indexPath.row]) ?? 0))
            let number = (Int(self.arrcount[indexPath.row]) ?? 0) + 0
            cell.lblName.text = "\(number)"
            if indexPath.row == SelctedIndex{
                cell.imgCell.layer.borderWidth = 1
                cell.imgCell.layer.borderColor = UIColor.black.cgColor
            }
            return cell
        }
        else{
            if isFromSize{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath) as! SizeCell
                cell.lblName.text = ""
                cell.imgCell.image = arrimg[indexPath.row]
                return cell
            }
            else{
                let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorListCell", for: indexPath) as! ColorListCell
                cellA.contentView.corner(cellA.contentView.frame.size.width/2, borderColor: .white, borderWidth: 2.0)
                cellA.contentView.backgroundColor = self.arrColors[indexPath.row]
                return cellA
            }
        }
        //  return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isfromSelection{
            if let _ = self.dismisssSize{
                self.dismisssSize!(Int(arrcount[indexPath.row]) ?? 0)
            }
            self.dismiss(animated: true, completion: nil)
        }
        else{
            if isFromSize{
                if let _ = self.dismisssSize{
                    self.dismisssSize!(Int(arr[indexPath.row]) ?? 0)
                }
                self.dismiss(animated: true, completion: nil)
            }
            else{
                if let _ = self.dismisss{
                    self.dismisss!(true, arrColors[indexPath.row])
                }
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
}

// MARK: - Extensions

extension UIView {
    func corner(_ radius: CGFloat, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) {
        var layer = CALayer()
        layer = self.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = borderWidth {
            layer.borderWidth = borderWidth
        }
    }
}
