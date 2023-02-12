//
//  SubjectBookListModel.swift
//  PAL
//
//  Created by i-Verve on 25/05/21.
//

import Foundation
import ObjectMapper

struct SubjectBooksList : Mappable {
    
    
    var message : String?
    var startDate : String?
    var endDate : String?
    var status: Int?
    var worksheetId: Int?
    var worksheetName : String?
    var pdfThumb: String?
    var pdfURl: String?
    var subCategory : String?
    var subCategoryId : Int?
    var subjectId : Int?
    var subjectName : String?
    var teacherId : String?
    var teacherName : String?
    var assign_type : Int?
    var pdfImages : [String]?
    var instruction : [String]?
    var voiceinstruction : [String]?
    var eraser : Int?
    var spellChecker : Int?
    var isComplete : Int?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        message <- map["message"]
        status <- map["status"]
        voiceinstruction <- map["voiceinstruction"]
        startDate <- map["startDate"]
        endDate <- map["endDate"]
        worksheetId <- map["worksheetId"]
        worksheetName <- map["worksheetName"]
        pdfThumb <- map["pdfThumb"]
        pdfURl <- map["pdfURl"]
        subCategory <- map["subCategory"]
        subCategoryId <- map["subCategoryId"]
        subjectId <- map["subjectId"]
        subjectName <- map["subjectName"]
        teacherId <- map["teacherId"]
        teacherName <- map["teacherName"]
        assign_type <- map["assign_type"]
        pdfImages <- map["pdfImages"]
        instruction <- map["instruction"]
        eraser <- map["eraser"]
        spellChecker <- map["spellChecker"]
        isComplete <- map["isComplete"]
    }
}
