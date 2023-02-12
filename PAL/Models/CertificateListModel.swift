import Foundation
import ObjectMapper

struct CertificateListModel : Mappable {
	var certificateId : Int?
	var certificateName : String?
    var pdfUrl : String?
    var studentName : String?
	var certificateType : Int?
	var date : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		certificateId <- map["certificateId"]
		certificateName <- map["certificateName"]
		certificateType <- map["certificateType"]
        pdfUrl <- map["pdfUrl"]
        studentName <- map["studentName"]
		date <- map["date"]
	}
}

struct CertificateTypeListModel : Mappable {
    var certificateType : Int?
    var certificateName : String?
    var certificateImage : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        certificateType <- map["certificateType"]
        certificateName <- map["certificateName"]
        certificateImage <- map["certificateImage"]
    }
}
