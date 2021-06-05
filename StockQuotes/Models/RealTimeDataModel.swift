//
//  RealTimeDataModel.swift
//  StockQuotes
//
//  Created by Ekaterina on 5.05.21.
//

import Foundation

struct RealTimeDataModel : Codable {
    
    let data : [Datum]?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([Datum].self, forKey: .data)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
}

struct Datum : Codable {
    
    let c : [String]?
    let p : Float?
    let s : String?
    let t : Int?
    let v : Int?
    
    enum CodingKeys: String, CodingKey {
        case c = "c"
        case p = "p"
        case s = "s"
        case t = "t"
        case v = "v"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        c = try values.decodeIfPresent([String].self, forKey: .c)
        p = try values.decodeIfPresent(Float.self, forKey: .p)
        s = try values.decodeIfPresent(String.self, forKey: .s)
        t = try values.decodeIfPresent(Int.self, forKey: .t)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }
    
}
