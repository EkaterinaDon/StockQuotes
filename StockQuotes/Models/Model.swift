//
//  Model.swift
//  StockQuotes
//
//  Created by Ekaterina on 26.02.21.
//

import Foundation

struct Model : Codable {
    
    let currency : String?
    let longName : String?
    let currentPrice : Float?
    let previousClosePrice : Float?
    let symbol : String?
    let logo: String?
    
    enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case longName = "description"
        case currentPrice = "c"
        case previousClosePrice = "pc"
        case symbol = "symbol"
        case logo = "logo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        longName = try values.decodeIfPresent(String.self, forKey: .longName)
        currentPrice = try values.decodeIfPresent(Float.self, forKey: .currentPrice)
        previousClosePrice = try values.decodeIfPresent(Float.self, forKey: .previousClosePrice)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
    }
    
}

struct MboumModel : Codable {
    
    let mQuotes : [MQuote]?
    
    enum CodingKeys: String, CodingKey {
        case mQuotes = "quotes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mQuotes = try values.decodeIfPresent([MQuote].self, forKey: .mQuotes)
    }
}

struct MQuote : Codable {
        
        let displayName : String?
        let longName : String?
        let shortName : String?
        let currency : String?
        let symbol : String?
        
        enum CodingKeys: String, CodingKey {
                case currency = "currency"
                case displayName = "displayName"
                case longName = "longName"
                case shortName = "shortName"
                case symbol = "symbol"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                currency = try values.decodeIfPresent(String.self, forKey: .currency)
                displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
                longName = try values.decodeIfPresent(String.self, forKey: .longName)
                shortName = try values.decodeIfPresent(String.self, forKey: .shortName)
                symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        }

}
