import Foundation
import ObjectMapper

struct SchoolListModel : Mappable {
	var schoolId : Int?
	var schoolName : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

        schoolId <- map["schoolId"]
        schoolName <- map["schoolName"]
	}
}
