import Foundation
import ObjectMapper

struct ColorListModel : Mappable {
	var subjectCoverColor : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {
        subjectCoverColor <- map["subjectCoverColor"]
	}
}
