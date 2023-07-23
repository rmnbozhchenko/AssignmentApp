import Foundation

protocol ApiClient {
    func places(for queryModel: PlacesQueryModel) async throws -> PlacesResponse
    func flights(for queryModel: FlightsQueryModel) async throws -> FlightsResponses
    
    func imageUrl(for cityName: String) -> URL?
}

private enum Constants {
    static let apiEndpoint = "https://api.skypicker.com/umbrella/v2/graphql"
    static let requestHttpMethod = "POST"
    static let contentType = "Content-Type"
    static let contentTypeValue = "application/json"
    
    static let imageUrlString: (String) -> String = {
        "https://images.kiwi.com/photos/600x600/\($0).jpg"
    }
}

final class ApiClientImpl {
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let apiUrl: URL
    
    init(session: URLSession, encoder: JSONEncoder, decoder: JSONDecoder) throws {
        guard let apiUrl = URL(string: Constants.apiEndpoint) else {
            throw ApiClientError.wrongApiEndpoint
        }
        
        self.apiUrl = apiUrl
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }
}

extension ApiClientImpl: ApiClient {
    func places(for queryModel: PlacesQueryModel) async throws -> PlacesResponse {
        try await load(for: queryModel)
    }
    
    func flights(for queryModel: FlightsQueryModel) async throws -> FlightsResponses {
        try await load(for: queryModel)
    }
    
    func imageUrl(for cityName: String) -> URL? {
        URL(string: Constants.imageUrlString(cityName))
    }
}

private extension ApiClientImpl {
    private func createRequest(for queryOperaton: ApiQueryOperaton) throws -> URLRequest {
        var request = URLRequest(url: apiUrl)
        
        request.httpMethod = Constants.requestHttpMethod
        request.setValue(Constants.contentTypeValue, forHTTPHeaderField: Constants.contentType)
        
        do {
            request.httpBody = try encoder.encode(queryOperaton)
        } catch {
            throw ApiClientError.wrongEncoding
        }
        
        return request
    }
    
    private func load<Response>(for queryModel: ApiQueryModel) async throws -> Response where Response: Decodable {
        let queryOperation = ApiQueryOperaton(model: queryModel)
        
        let request = try createRequest(for: queryOperation)
        
        let responseData: Data
        do {
            // I am ommiting handling of diff status codes here, in my impl - "not nil data" it's a success case
            // It's just for time saving
            responseData = try await session.data(for: request).0
        } catch {
            throw ApiClientError.wrongDataLoading
        }
        
        // |--- Just to see JSON response in the console
        if let JSONString = String(data: responseData, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
        // ---|
        
        do {
            let result = try decoder.decode(ApiResult<Response>.self, from: responseData)
            
            if let response = result.value {
                return response
            } else {
                throw ApiClientError.wrongQueryModel
            }
        } catch {
            throw ApiClientError.wrongDecoding
        }
    }
}
