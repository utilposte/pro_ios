//
//  GetCLData.swift
//  LPColissimo
//
//  Created by LaPoste on 05/10/2018.
//

import UIKit

public struct GetCLData : CLAPIRequest{
    public typealias Response = [CLCountry]
    
    public var resourceName: String {
        return "getInitData"
    }
    
    // Parameters
    public let name: String?
    public let nameStartsWith: String?
    public let limit: Int?
    public let offset: Int?
    
    // Note that nil parameters will not be used
    public init(name: String? = nil,
                nameStartsWith: String? = nil,
                limit: Int? = nil,
                offset: Int? = nil) {
        self.name = name
        self.nameStartsWith = nameStartsWith
        self.limit = limit
        self.offset = offset
    }
    
}

