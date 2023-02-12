
import Foundation
import ObjectMapper

struct PersonalInfo : Mappable {
    var studentId : String?
    var studentName : String?
    var student_Id : String?
    var dob : String?
    var age : Int?
    var gender : String?
    var parentName : String?
    var parentId : Int?
    var parentEmail : String?

    init() {

    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        studentId <- map["studentId"]
        studentName <- map["studentName"]
        student_Id <- map["student_Id"]
        dob <- map["dob"]
        age <- map["age"]
        gender <- map["gender"]
        parentName <- map["parentName"]
        parentId <- map["parentId"]
        parentEmail <- map["parentEmail"]
    }

}
