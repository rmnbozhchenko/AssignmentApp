//
//  File.swift
//  AssignmentApp
//
//  Created by Roman Bozhchenko on 22/07/2023.
//

import Foundation

struct ApiResult<Value: Decodable>: Decodable {
    let value: Value?
    let errorMessages: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.value = try container.decodeIfPresent(Value.self, forKey: .data)
        
        var errorMessages: [String] = []
        let errors = try container.decodeIfPresent([Error].self, forKey: .errors)
        if let errors = errors {
            errorMessages.append(contentsOf: errors.map { $0.message })
        }
        
        self.errorMessages = errorMessages
    }
}

private extension ApiResult {
    enum CodingKeys: String, CodingKey {
        case data
        case errors
    }
    
    struct Error: Decodable {
        let message: String
    }
}
