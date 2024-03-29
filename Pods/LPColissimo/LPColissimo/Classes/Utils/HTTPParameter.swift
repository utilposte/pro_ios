//
//  HTTPParameter.swift
//  FBSnapshotTestCase
//
//  Created by LaPoste on 05/10/2018.
//

import UIKit

// Utility type so that we can decode any type of HTTP parameter
// Useful when we have mixed types in a HTTP request
enum HTTPParameter: CustomStringConvertible, Decodable {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else {
            throw ColissimoError.decoding
        }
    }
    
    var description: String {
        switch self {
        case .string(let string):
            return string
        case .bool(let bool):
            return String(describing: bool)
        case .int(let int):
            return String(describing: int)
        case .double(let double):
            return String(describing: double)
        }
    }
}


/// Dumb error to model simple errors
/// In a real implementation this should be more exhaustive
public enum ColissimoError: Error {
    case encoding
    case decoding
    case server(message: String)
}
