
import Foundation
import ObjectMapper

struct ProgressSubjects : Mappable {
    public var subjectId : Int?
    public var subjectName : String?
    public var reportAddedDate : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		subjectId <- map["subjectId"]
		subjectName <- map["subjectName"]
        reportAddedDate <- map["subCategory"]
	}
}
