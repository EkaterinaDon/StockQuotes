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
        let regularMarketDayHigh : Float?
        let regularMarketDayLow : Float?
        let symbol : String?
        

        enum CodingKeys: String, CodingKey {
                case currency = "currency"
                case longName = "longName"
                case regularMarketDayHigh = "regularMarketDayHigh"
                case regularMarketDayLow = "regularMarketDayLow"
                case symbol = "symbol"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                currency = try values.decodeIfPresent(String.self, forKey: .currency)
                longName = try values.decodeIfPresent(String.self, forKey: .longName)
                regularMarketDayHigh = try values.decodeIfPresent(Float.self, forKey: .regularMarketDayHigh)
                regularMarketDayLow = try values.decodeIfPresent(Float.self, forKey: .regularMarketDayLow)
                symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        }
}
