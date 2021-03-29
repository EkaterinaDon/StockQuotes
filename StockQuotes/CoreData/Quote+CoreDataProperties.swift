//
//  Quote+CoreDataProperties.swift
//  StockQuotes
//
//  Created by Ekaterina on 27.03.21.
//
//

import Foundation
import CoreData


extension Quote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
        return NSFetchRequest<Quote>(entityName: "Quote")
    }

    @NSManaged public var currency: String?
    @NSManaged public var longName: String?
    @NSManaged public var regularMarketDayHigh: Float
    @NSManaged public var regularMarketDayLow: Float
    @NSManaged public var symbol: String?

}

extension Quote : Identifiable {

}
