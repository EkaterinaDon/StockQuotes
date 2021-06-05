//
//  Quote+CoreDataProperties.swift
//  
//
//  Created by Ekaterina on 3.05.21.
//
//

import Foundation
import CoreData


extension Quote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
        return NSFetchRequest<Quote>(entityName: "Quote")
    }

    @NSManaged public var currency: String?
    @NSManaged public var logo: String?
    @NSManaged public var longName: String?
    @NSManaged public var symbol: String?
    @NSManaged public var logoImage: Data?

}
