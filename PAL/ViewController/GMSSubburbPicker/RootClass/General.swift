//
//  General.swift
//
//
//  Created by i-Verve on 20/04/21.
//

import Foundation
import UIKit

class General {
    var title: String = ""
    var image: String = ""
    var showImage: Bool = true
    var isLastIndex: Bool = false
    var isFirstIndex: Bool = false
    var font: UIFont = UIFont.Font_WorkSans_Meduim(fontsize: 14)
    var textColor: UIColor = .red
    
    init(title: String, image: String = "", showImage: Bool = true) {
        self.title = title
        self.image = image
        self.showImage = showImage
    }
}


//--- For Set Days of The Week ---
class Days {
    var title: String = ""
    var image: String = ""
    var showDayTime: Bool = false
    var isLastIndex: Bool = false
    var isFirstIndex: Bool = false
    var font: UIFont = UIFont.Font_WorkSans_Meduim(fontsize: 18)
    var textColor: UIColor = .red
    
    init(title: String, image: String = "", showDayTime: Bool = false) {
        self.title = title
        self.image = image
        self.showDayTime = showDayTime
    }
}


//--- For Menu types ---
class MenuDetails {
    var title: String = ""
    var itemCount: String = ""
    var type: String = ""
    var image: String = ""
    var isLastIndex: Bool = false
    var isFirstIndex: Bool = false
    
    init(title: String, itemCount: String, type: String, image: String = "") {
        self.title = title
        self.itemCount = itemCount
        self.type = type
        self.image = image
    }
}
