import Foundation
import ObjectMapper

struct ReportCardListModel : Mappable {
	var reportId : Int?
	var subjectName : String?
	var subjectId : Int?
	var totalReport : Int?

    init?() {

    }
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

        reportId <- map["reportId"]
        subjectName <- map["subjectName"]
        subjectId <- map["subjectId"]
        totalReport <- map["totalReport"]
	}
}

struct ReportCardDetailListModel : Mappable {
    var reportId : Int?
    var subjectName : String?
    var reportDate : String?
    var reportCreatedBy : String?
    var progress : String?
    var attention : String?
    var behaviour : String?
    var generalNotes : String?
    var participation : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        reportId <- map["reportId"]
        subjectName <- map["subjectName"]
        reportDate <- map["reportDate"]
        reportCreatedBy <- map["reportCreatedBy"]
        progress <- map["progress"]
        attention <- map["attention"]
        behaviour <- map["behaviour"]
        generalNotes <- map["generalNotes"]
        participation <- map["participation"]
    }
}
