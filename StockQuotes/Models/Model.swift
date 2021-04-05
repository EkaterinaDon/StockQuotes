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
    
//    func getLogoAndData() {
//        self.getLogo()
//    }
}
