//
//  User.swift
//  PAL
//
//  Created by i-Phone7 on 23/11/20.
//

import Foundation
import ObjectMapper

struct User : Mappable {
    var userId : Int?
    var accessToken : String?
    var firstName : String?
    var lastName : String?
    var suburb : String?
    var userType : Int?
    var isCardAdded : Int?
    var teacher_Id : String?
    var schoolId : Int?
    var schoolName : String?
    var email : String?
    var referralCode : String?
    var childCount : Int?
    var workbookId : Int?
    var childInfo : [ChildInfoModel]?

    init() {

    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        userId <- map["userId"]
        accessToken <- map["accessToken"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        suburb <- map["suburb"]
        userType <- map["userType"]
        isCardAdded <- map["isCardAdded"]
        teacher_Id <- map["teacher_Id"]
        schoolId <- map["schoolId"]
        schoolName <- map["schoolName"]
        childCount <- map["childCount"]
        email <- map["email"]
        referralCode <- map["referralCode"]
        childInfo <- map["childData"]
        workbookId <- map["workbookId"]
    }
}
