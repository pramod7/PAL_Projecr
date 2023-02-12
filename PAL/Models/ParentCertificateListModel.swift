//
//  ParentCertificateListModel.swift
//  PAL
//
//  Created by i-Verve on 01/06/21.
//

import Foundation
import ObjectMapper

struct ParentCertificateListModel : Mappable {
    var certificateId : Int?
    var pdfURl : String?
    var childName : String?
    var certificateType : Int?
    var certificateCreatedDate : String?
    var childId : Int?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        certificateId <- map["certificateId"]
        certificateType <- map["certificateType"]
        pdfURl <- map["pdfURl"]
        childName <- map["childName"]
        childId <- map["childId"]
        certificateCreatedDate <- map["certificateCreatedDate"]
    }
}
