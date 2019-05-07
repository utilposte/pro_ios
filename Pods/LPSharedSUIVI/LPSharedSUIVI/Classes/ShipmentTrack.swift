//
//  TrackShipment.swift
//  LaPostePro
//
//  Created by Matthieu Lemonnier on 01/08/2018.
//  Copyright © 2018 App Mobile. All rights reserved.
//

import Foundation

public class RootTrack : Codable {
    public var response : ResponseTrack?
}

public class ResponseTrack : Codable {
    public var returnCode : Int?
    public var errorMessage : String?
    public var lang : String?
    public var level : String?
    public var num : String?
    public var holder : String?
    public var shipment : ShipmentTrack?
}

public  class ShipmentTrack: Codable {
    public var idShip : String?
    public var product : String?
    public var isFinal : Bool?
    public var deliveryCity : String?
    public var deliveryDate : String?
    public var deliveryMode : String?
    public var estimateDate : String?
    public var phDate : String?
    public var geoCover : String?
    public var urlDetail : String?
    public var events : EventTrack?
}

public class EventTrack : Codable {
    public var event : [DetailEventTrack]?
}

public class DetailEventTrack : Codable {
    public var order : Int?
    public var date : String?
    public var label : String?
    public var siteName : String?
//    public var removalPoint : String?
    public var isDiffPoint : Bool?
    public var displayPoint : Bool?
    public var deliveryChoice : Int?
}
