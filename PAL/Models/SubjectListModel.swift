import Foundation
import ObjectMapper

struct SubjectListModel : Mappable {
	var subjectId : Int?
	var studentName : String?
	var subjectName : String?
    var teahcerName : String?
	var subjectCover : String?
	var subjectCoverColor : String?
	var subCategory : [SubjectSubCategoryModel]?

    init?() {

    }
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {
        teahcerName <- map["teahcerName"]
		subjectId <- map["subjectId"]
		studentName <- map["studentName"]
		subjectName <- map["subjectName"]
		subjectCover <- map["subjectCover"]
		subjectCoverColor <- map["subjectCoverColor"]
        subCategory <- map["category"]
	}
}

struct SubjectSubCategoryModel : Mappable {
    var subCategoryId : Int?
    var subCategory : String?

    init?() {

    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        subCategoryId <- map["subCategoryId"]
        subCategory <- map["subCategory"]
    }
}
