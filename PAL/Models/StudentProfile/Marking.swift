import Foundation
import ObjectMapper

struct Marking : Mappable {
    var subjectId : Int?
    var subjectName : String?
    var subCategory : String?
    var subCategoryId : Int?
    var worksheetId : Int?
    var pdfThumb : String?
    var pdfURl : String?
    var worksheetName : String?
    var assignDate : String?
    var teacherId : String?
    var teacherName : String?
    var pdfImage : [String]?
    var instruction : [String]?
    var voiceinstruction : [String]?
    var eraser : Int?
    var spellChecker : Int?
    var isCompleted : Int?
    var isWorksheet : Int?
    var pdfImages: [String]?
    
    init() {

    }
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        pdfImages <- map["pdfImages"]
        isWorksheet <- map["isWorksheet"]
        subjectId <- map["subjectId"]
        subjectName <- map["subjectName"]
        subCategory <- map["subCategory"]
        subCategoryId <- map["subCategoryId"]
        worksheetId <- map["worksheetId"]
        pdfThumb <- map["pdfThumb"]
        pdfURl <- map["pdfURl"]
        worksheetName <- map["worksheetName"]
        assignDate <- map["assignDate"]
        teacherId <- map["teacherId"]
        teacherName <- map["teacherName"]
        pdfImage <- map["pdfImages"]
        instruction <- map["instruction"]
        eraser <- map["eraser"]
        spellChecker <- map["spellChecker"]
        isCompleted <- map["isCompleted"]
        voiceinstruction <- map["voiceinstruction"]
    }

}
