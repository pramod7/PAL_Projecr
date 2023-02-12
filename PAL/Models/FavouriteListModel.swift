import Foundation
import ObjectMapper

struct FavouriteListModel : Mappable {
	var worksheetName : String?
	var worksheetId : Int?
    var subjectName : String?
    var subCategory : String?
    var subjectId : Int?
    var subCategoryId : Int?
	var date : String?
    var worksheetThumb : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

        worksheetName <- map["worksheetName"]
        subjectName <- map["subjectName"]
        subCategory <- map["subCategory"]
        worksheetId <- map["worksheetId"]
        subjectId <- map["subjectId"]
        subCategoryId <- map["subCategoryId"]
		date <- map["date"]
        worksheetThumb <- map["worksheetThumb"]
	}
}

