//
//  APIRequest.swift
//  LPColissimo
//
//  Created by Khaled El Abed on 05/10/2018.
//

import UIKit

/// All requests must conform to this protocol
/// - Discussion: You must conform to Encodable too, so that all stored public parameters
///   of types conforming this protocol will be encoded as parameters.
public protocol CLAPIRequest: Encodable {
    /// Response (will be wrapped with a DataContainer)
    associatedtype Response: Decodable
    
    /// Endpoint for this request (the last part of the URL)
    var resourceName: String { get }
}
