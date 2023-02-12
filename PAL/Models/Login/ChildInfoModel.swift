import Foundation
import ObjectMapper

struct ChildInfoModel : Mappable {
	var childId : Int?
	var firstName : String?
	var lastName : String?
	var student_Id : String?
	var dob : String?
	var gender : String?
	var yearOldChild : String?
	var childStrugleArea : String?
	var otherDescription : String?
	var teacherLinkId : String?

    init?() {

    }
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		childId <- map["childId"]
		firstName <- map["firstName"]
		lastName <- map["lastName"]
        student_Id <- map["student_Id"]
		dob <- map["dob"]
		gender <- map["gender"]
		yearOldChild <- map["yearOldChild"]
		childStrugleArea <- map["childStrugleArea"]
		otherDescription <- map["otherDescription"]
		teacherLinkId <- map["teacherLinkId"]
	}
}
