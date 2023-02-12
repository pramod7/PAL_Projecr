import Foundation
struct WorksheetData : Codable {
    
	let images : String?
	let screenshot : String?

	enum CodingKeys: String, CodingKey {

		case images = "images"
		case screenshot = "screenshot"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		images = try values.decodeIfPresent(String.self, forKey: .images)
		screenshot = try values.decodeIfPresent(String.self, forKey: .screenshot)
	}

}
