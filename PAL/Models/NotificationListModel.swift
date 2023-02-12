//
//  NotificationListModel.swift
//  PAL
//
//  Created by Akshay Shah on 06/09/22.
//

import Foundation
import ObjectMapper

struct NotificationListModel : Mappable {
    var childId : Int?
    var date : String?
    var fullName : String?
    var notificationType : Int?
    var message : String?
    var notificationId : Int?
    var subjectId : Int?
    
    var childStrugleArea : String?
    var dob : String?
    var firstName : String?
    var lastName : String?
    var gender : Int?
    var student_Id : String?
   
    var subjectCoverColor : String?
    var subjectName : String?
    
    var interviewRequestAccept : Int?
    var interviewRequestDate : String?
    var interviewRequestTeacherId : Int?
    var interviewRequestTime : String?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        
        interviewRequestAccept <- map["interviewRequestAccept"]
        interviewRequestDate <- map["interviewRequestDate"]
        interviewRequestTeacherId <- map["interviewRequestTeacherId"]
        interviewRequestTime <- map["interviewRequestTime"]
        childId <- map["childId"]
        subjectId <- map["subjectId"]
        date <- map["date"]
        fullName <- map["fullName"]
        message <- map["message"]
        notificationType <- map["notificationType"]
        notificationId <- map["notificationId"]
        
        childStrugleArea <- map["childStrugleArea"]
        dob <- map["dob"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        gender <- map["gender"]
        student_Id <- map["student_Id"]
        
        subjectCoverColor <- map["subjectCoverColor"]
        subjectName <- map["subjectName"]
    }
}
