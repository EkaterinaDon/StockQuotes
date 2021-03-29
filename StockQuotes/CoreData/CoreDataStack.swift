//
//  CoreDataStack.swift
//  StockQuotes
//
//  Created by Ekaterina on 27.03.21.
//

import Foundation
import CoreData

class CoreDataStack {
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StockQuotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
       // let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadFromCoreData() -> [Quote] {
        
        var request = NSFetchRequest<NSFetchRequestResult>()
        request = Quote.fetchRequest()
        request.returnsObjectsAsFaults = false
        let results = try! context.fetch(Quote.fetchRequest()) as! [Quote]
        return results
    }
    
    func saveToFavorites(model: Quote) {

        let quote = NSEntityDescription.insertNewObject(forEntityName: "FavoriteQuote", into: context)
        quote.setValue(model.longName, forKey: "longName")
        quote.setValue(model.currency, forKey: "currency")
        quote.setValue(model.symbol, forKey: "symbol")
        quote.setValue(model.regularMarketDayLow, forKey: "regularMarketDayLow")
        quote.setValue(model.regularMarketDayLow, forKey: "regularMarketDayLow")
        
        let fetchRequest : NSFetchRequest<FavoriteQuote> = FavoriteQuote.fetchRequestFavorite()
        if let results = try? context.fetch(fetchRequest) {
            for result in results {
                if result.symbol != model.symbol {
                    saveContext()
                }
            }
        }
    }
    
    func saveToFavoritesFirstLaunch(model: Model) {

        let quote = NSEntityDescription.insertNewObject(forEntityName: "FavoriteQuote", into: context)
        quote.setValue(model.longName, forKey: "longName")
        quote.setValue(model.currency, forKey: "currency")
        quote.setValue(model.symbol, forKey: "symbol")
        quote.setValue(model.regularMarketDayLow, forKey: "regularMarketDayLow")
        quote.setValue(model.regularMarketDayLow, forKey: "regularMarketDayLow")
        
        let fetchRequest : NSFetchRequest<FavoriteQuote> = FavoriteQuote.fetchRequestFavorite()
        if let results = try? context.fetch(fetchRequest) {
            for result in results {
                if result.symbol != model.symbol {
                    saveContext()
                }
            }
        }
    }
    
    func loadFavoritesFromCoreData() -> [FavoriteQuote] {
        
        let fetchRequest : NSFetchRequest<FavoriteQuote> = FavoriteQuote.fetchRequestFavorite()
        let results = try! context.fetch(fetchRequest)
        return results
    }
    
    func deleteFromFavorites(quote: FavoriteQuote) {
        
        let fetchRequest : NSFetchRequest<FavoriteQuote> = FavoriteQuote.fetchRequestFavorite()
        if let results = try? context.fetch(fetchRequest) {
            for result in results {
                if result.symbol == quote.symbol {
                    context.delete(result)
                }
            }
        }
        saveContext()
    }
    
    func deleteFromFavoritesForButton(quote: Quote) {
        
        let fetchRequest : NSFetchRequest<FavoriteQuote> = FavoriteQuote.fetchRequestFavorite()
        if let results = try? context.fetch(fetchRequest) {
            for result in results {
                if result.symbol == quote.symbol {
                    context.delete(result)
                }
            }
        }
        saveContext()
    }
    
}

