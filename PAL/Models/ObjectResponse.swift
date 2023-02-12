//
//  User.swift
//  PAL
//
//  Created by i-Phone7 on 23/11/20.
//

import Foundation
import ObjectMapper

struct ObjectResponse : Mappable {
    var message : String?
    var status : Int?
    var user : User?
    var childInfo : ChildInfoModel?
    var personalInfo : PersonalInfo?
    var workBookInfo : workbookDataModel?
    var subjectBooks : [SubjectBooks]?
    var marking : [Marking]?
    var Archivemarking : [Marking]?
    var progressSubjects : [ProgressSubjects]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        Archivemarking <- map["data"]
        user <- map["data"]
        childInfo <- map["data"]
        personalInfo <- map["personalInfo"]
        workBookInfo <- map["data"]
        subjectBooks <- map["subjectBooks"]
        marking <- map["marking"]
        progressSubjects <- map["progressSubjects"]
    }
}
