//
//  CLFormat.swift
//  LPColissimo
//
//  Created by Khaled El Abed on 05/10/2018.
//

import UIKit

public struct CLFormat: Decodable {
    public var LLHMax: String?
    public var LLHMin: String?
    public var heightMax : String?
    public var label: String
    public var type: String
    public var additionalCost: CLPriceValue?
    
//        public var LLHMax: Int?
//        public var LLHMin: Int?
//        public var heightMax : Int?
//        public var label: String
//        public var type: String
//        public var additionalCost: CLPriceValue?

    
//    private enum CodingKeys : String, CodingKey { case LLHMax, LLHMin, heightMax,label,type,additionalCost }
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        LLHMax = try container.decode(Int.self, forKey: .LLHMax)
//        LLHMin = try container.decode(Int.self, forKey: .LLHMin)
//        heightMax = try container.decode(Int.self, forKey: .heightMax)
//        label = try container.decode(String.self, forKey: .label)
//        type = try container.decode(String.self, forKey: .type)
//
//    }
}

public struct ConvertedFormat{
    public var LLHMax: Int?
    public var LLHMin : Int?
    public var heightMax : Int?
    public var label: String
    public var type: String
    public var additionalCost: CLPriceValue?
    
    
   public init(format: CLFormat) {
        if let v = format.LLHMax {
            self.LLHMax = Int(v)
        }
        if let v = format.LLHMin {
            self.LLHMin = Int(v)
        }
        if let v = format.heightMax {
            self.heightMax = Int(v)
        }
        if let v = format.additionalCost {
            self.additionalCost = v
        }

        self.label =  format.label
        self.type = format.type
    }
    
    func toString(){
        print("👀  ConvertedFormat  test👀 ");
    }
}

//public struct AdditionalCost: Decodable{
//    var currencyIso: String
//    var value: Int
//}
