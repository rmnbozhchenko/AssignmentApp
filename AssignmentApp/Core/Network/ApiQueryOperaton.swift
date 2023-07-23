import Foundation

protocol ApiQueryModel: CustomStringConvertible {}

struct ApiQueryOperaton: Encodable {
    var model: ApiQueryModel
    
    enum CodingKeys: String, CodingKey {
        case query
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model.description, forKey: .query)
    }
}
