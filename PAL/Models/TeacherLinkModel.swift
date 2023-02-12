import Foundation
import ObjectMapper

struct TeacherLinkModel : Mappable {
	var linkStatus : Int?
	var teacherId : Int?
	var teacherName : String?
    var teacher_Id : String?
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

        linkStatus <- map["linkStatus"]
        teacherId <- map["teacherId"]
        teacherName <- map["teacherName"]
        teacher_Id <- map["teacher_Id"]
	}
}
