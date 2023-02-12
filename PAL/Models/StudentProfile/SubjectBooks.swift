import Foundation
import ObjectMapper

struct SubjectBooks : Mappable {
    var subjectId : Int?
    var subjectName : String?
    var teacherName : String?
    var teacherId : String?
    var subCategory : String?
    var subCategoryId : Int?
    var worksheetId : Int?
    var pdfThumb : String?
    var pdfURl : String?
    var pdfImages : [String]?
    var worksheetName : String?
    var startDate : String?
    var endDate : String?
    var instruction : [String]?
    var voiceinstruction : [String]?
    var eraser : String?
    var spellChecker : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        subjectId <- map["subjectId"]
        subjectName <- map["subjectName"]
        teacherName <- map["teacherName"]
        teacherId <- map["teacherId"]
        subCategory <- map["subCategory"]
        subCategoryId <- map["subCategoryId"]
        worksheetId <- map["worksheetId"]
        pdfThumb <- map["pdfThumb"]
        pdfURl <- map["pdfURl"]
        pdfImages <- map["pdfImages"]
        worksheetName <- map["worksheetName"]
        startDate <- map["startDate"]
        endDate <- map["endDate"]
        instruction <- map["instruction"]
        eraser <- map["eraser"]
        spellChecker <- map["spellChecker"]
        voiceinstruction <- map["voiceinstruction"]
    }

}
