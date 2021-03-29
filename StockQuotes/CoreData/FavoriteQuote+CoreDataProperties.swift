//
//  FavoriteQuote+CoreDataProperties.swift
//  StockQuotes
//
//  Created by Ekaterina on 28.03.21.
//
//

import Foundation
import CoreData


extension FavoriteQuote {

    @nonobjc public class func fetchRequestFavorite() -> NSFetchRequest<FavoriteQuote> {
        return NSFetchRequest<FavoriteQuote>(entityName: "FavoriteQuote")
    }

    @NSManaged public var currency: String?
    @NSManaged public var longName: String?
    @NSManaged public var regularMarketDayHigh: Float
    @NSManaged public var regularMarketDayLow: Float
    @NSManaged public var symbol: String?

}

extension FavoriteQuote : Identifiable {

}
