import Foundation
import ObjectMapper

//MARK:- Tips
struct TipsModel : Mappable {
	var tip : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

        tip <- map["tip"]
	}
}

//MARK:- FAQ
struct FAQModel : Mappable {
    var faqQuestion : String?
    var faqAnswer : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        faqQuestion <- map["FAQQuestion"]
        faqAnswer <- map["FAQAnswer"]
    }
}

//MARK:- StudentWorkAssign
struct StudentWorkAssign : Mappable {
    var assigned : [SubjectBooksList]?
    var WorkDone : [SubjectBooksList]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        assigned <- map["assigned"]
        WorkDone <- map["WorkDone"]
    }
}


struct YearList : Mappable
{
    var year = [String]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        year <- map["years"]
    }
    
    
}
