//
//  workbookDataModel.swift
//  PAL
//
//  Created by Akshay Shah on 09/01/22.
//

import Foundation
import ObjectMapper

struct workbookDataModel : Mappable {
    
    var workbookPageId : Int?
    var workbookImageUrl : String?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        workbookPageId <- map["workbookPageId"]
        workbookImageUrl <- map["workbookImageUrl"]
    }
}
