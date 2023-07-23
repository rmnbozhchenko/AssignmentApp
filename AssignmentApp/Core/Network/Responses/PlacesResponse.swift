struct PlacesResponse: Decodable {
    let places: EdgesResponse
}

extension PlacesResponse {
    struct EdgesResponse: Decodable {
        let edges: [EdgeResponse]
    }
    
    struct EdgeResponse: Decodable {
        let node: NodeResponse
    }
    
    struct NodeResponse: Decodable {
        let id: String
        let legacyId: String
        let name: String
        let gps: Coordinates
    }
    
    struct Coordinates: Decodable {
        let latitude: Double
        let longitude: Double
        
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
    }
}
