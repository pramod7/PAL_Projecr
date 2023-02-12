//
//  SubjectWorkbookListModel.swift
//  PAL
//
//  Created by i-Verve on 07/05/21.
//

import Foundation
import ObjectMapper

struct SubjectWorkbooksListModel : Mappable {
    
    var isFavourite : Int?
    var worksheetId: Int?
    var worksheetName : String?
    var worksheetAddedDate : String?
    var worksheetThumb : String?
    var isAssign: Int?
  

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        isFavourite <- map["isFavourite"]
        worksheetAddedDate <- map["worksheetAddedDate"]
        worksheetId <- map["worksheetId"]
        worksheetName <- map["worksheetName"]
        isAssign <- map["isAssign"]
        worksheetThumb <- map["worksheetThumb"]
        
    }
}
