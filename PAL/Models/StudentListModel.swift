import Foundation
import ObjectMapper

struct StudentListModel : Mappable {
	var studentId : Int?
	var studentName : String?
	var student_Id : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		studentId <- map["studentId"]
		studentName <- map["studentName"]
		student_Id <- map["student_Id"]
	}

}
