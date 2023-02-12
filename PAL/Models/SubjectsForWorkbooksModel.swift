//
//  SubjectsForWorkbooksModel.swift
//  PAL
//
//  Created by i-Verve on 05/05/21.
//

import Foundation
import ObjectMapper

struct SubjectsForWorkbooksModel : Mappable {
    
    
  var message : String?
  var status: Int?
  var teacher_Id : String?
  var teacherName : String?
  var worksheetsAssignDate : String?
  var subjectId : Int?
  var studentName : String?
  var subjectName : String?
  var subjectCover : String?
  var subjectCoverColor : String?
  var subCategory : [SubjectSubCategoryModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        message <- map["message"]
        status <- map["status"]
        teacher_Id <- map["teacher_Id"]
        teacherName <- map["teacherName"]
        worksheetsAssignDate <- map["worksheetsAssignDate"]
        subjectId <- map["subjectId"]
        studentName <- map["studentName"]
        subjectName <- map["subjectName"]
        subjectCover <- map["subjectCover"]
        subjectCoverColor <- map["subjectCoverColor"]
        subCategory <- map["category"]
        
    }
}
