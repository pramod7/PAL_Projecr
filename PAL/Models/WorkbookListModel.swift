//
//  WorkbookListModel.swift
//  PAL
//
//  Created by i-Verve on 05/05/21.
//

import Foundation
import ObjectMapper

struct WorkbookListModel : Mappable {
    
    
    var message : String?
    var status: Int?
    var worksheetsId: Int?
    var worksheetName : String?
    var pdfThumb: String?
    var pdfURl: String?
    var subCategory : String?
    var subCategoryId : Int?
    var subjectId : Int?
    var subjectName : String?
    var teacherId : Int?
    var teacher_Id : String?
    var teacherName : String?
    var worksheetsAssignDate : String?
    var isMarking : Int?
    var pdfImage : [String]?
    var instruction : [String]?
    var voiceinstruction : [String]?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        message <- map["message"]
        status <- map["status"]
        worksheetsId <- map["worksheetsId"]
        worksheetName <- map["worksheetName"]
        pdfThumb <- map["pdfThumb"]
        pdfURl <- map["pdfURl"]
        subCategory <- map["subCategory"]
        subCategoryId <- map["subCategoryId"]
        subjectId <- map["subjectId"]
        subjectName <- map["subjectName"]
        teacherId <- map["teacherId"]
        teacher_Id <- map["teacher_Id"]
        teacherName <- map["teacherName"]
        worksheetsAssignDate <- map["worksheetsAssignDate"]
        isMarking <- map["isMarking"]
        pdfImage <- map["pdfImages"]
        instruction <- map["instruction"]
        voiceinstruction <- map["voiceinstruction"]
    }
}
