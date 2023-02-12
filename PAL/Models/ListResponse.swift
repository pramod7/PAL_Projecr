//
//  ListResponse.swift
//  PAL
//
//  Created by i-Phone7 on 23/11/20.
//

import Foundation
import ObjectMapper

struct ListResponse : Mappable {
    var status : Int?
    var message : String?
    
    var studentList : [StudentListModel]?
    var subjectList : [SubjectListModel]?
    var certificateList : [CertificateListModel]?
    var parentCertificateList : [ParentCertificateListModel]?
    var NotificationList : [NotificationListModel]?
    var certificateTypeList : [CertificateTypeListModel]?
    var favList : [FavouriteListModel]?
    var schoolList : [SchoolListModel]?
    var colorList : [ColorListModel]?
    var reportList : [ReportCardListModel]?
    var reportDetailList : [ReportCardDetailListModel]?
    var childInfo : [ChildInfoModel]?
    var teacherLink : [TeacherLinkModel]?
    var tips : [TipsModel]?
    var faq : [FAQModel]?
    var WorkbookList : [WorkbookListModel]?
    var SubjectBooksList : [SubjectBooksList]?
    var studentWorkbooklist : [SubjectBooksList]?
    var subjectsForWorkbook : [SubjectsForWorkbooksModel]?
    var subjectWrokbookList : [SubjectWorkbooksListModel]?
    var newStudentWorkBook : StudentWorkAssign?
    var yearList : [YearList]?
    var workbookData : [workbookDataModel]?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        NotificationList <- map["data"]
        yearList <- map["data"]
        studentList <- map["data"]
        subjectList <- map["data"]
        certificateList <- map["data"]
        parentCertificateList <- map["data"]
        certificateTypeList <- map["data"]
        favList <- map["data"]
        schoolList <- map["data"]
        colorList <- map["data"]
        reportList <- map["data"]
        reportDetailList <- map["data"]
        childInfo <- map["data"]
        teacherLink <- map["data"]
        tips <- map["data"]
        faq <- map["data"]
        WorkbookList <- map["data"]
        subjectsForWorkbook <- map["data"]
        subjectWrokbookList <- map["data"]
        SubjectBooksList <- map["subjectBooks"]
        studentWorkbooklist <- map["data"]
        newStudentWorkBook <- map["data"]
        workbookData <- map["data"]
    }
}
