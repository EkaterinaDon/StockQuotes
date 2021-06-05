//
//  CoreDataStack.swift
//  StockQuotes
//
//  Created by Ekaterina on 27.03.21.
//

import UIKit
import CoreData

var quotes: [Quote] {
    let request = NSFetchRequest<Quote>(entityName: "Quote")
    
    let array = try? CoreDataStack.sharedInstance.context.fetch(request)
    
    if array != nil {
        return array!
    }
    
    return []
}

var favoriteQuotes: [FavoriteQuote] {
    let request = NSFetchRequest<FavoriteQuote>(entityName: "FavoriteQuote")
    
    let sortDescriptor = NSSortDescriptor(key: "symbol", ascending: true)
    request.sortDescriptors = [sortDescriptor]
    
    let array = try? CoreDataStack.sharedInstance.context.fetch(request)
    
    if array != nil {
        return array!
    }
    
    return []
}

class CoreDataStack {
    
    static let sharedInstance = CoreDataStack()
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
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
    
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Save to Core Data
    
//    func saveToCoreData(models: [Model]) {
//
//        let request : NSFetchRequest<Quote> = Quote.fetchRequest()
//        request.returnsObjectsAsFaults = false
//        let results = try! context.fetch(request)
//
//    var filtered: [Model] = []
//
//    models.forEach { (model) in
//        filtered = models.filter({_ in !results.contains(where: {$0.symbol == model.symbol })})
//    }
//
//    print(filtered.count)
//    filtered.forEach { (model) in
//        let quote = Quote(context: context)
//        quote.symbol = model.symbol
//        quote.longName = model.longName
//        quote.currency = model.currency
//    }
//        saveContext()
//    }
    
    func saveToCoreData(models: [MQuote]) {
        
        let request : NSFetchRequest<Quote> = Quote.fetchRequest()
        request.returnsObjectsAsFaults = false
        let results = try! context.fetch(request)
        
        var filtered: [MQuote] = []
        
        if !results.isEmpty {
            models.forEach { (model) in
                filtered = models.filter({_ in !results.contains(where: {$0.symbol == model.symbol })})
            }
            debugPrint(filtered.count)
            filtered.forEach { (model) in
                let quote = Quote(context: context)
                quote.symbol = model.symbol
                quote.longName = model.longName
                quote.currency = model.currency
            }
        } else {
            models.forEach { (model) in
                let quote = Quote(context: context)
                quote.symbol = model.symbol
                quote.longName = model.longName
                quote.currency = model.currency
            }
        }
        
        saveContext()
    }
    
    func saveLogoToCoreData(symbol: String, logo: String) {
        
        let request : NSFetchRequest<Quote> = Quote.fetchRequest()
        request.returnsObjectsAsFaults = false
        let results = try! context.fetch(request)
        
        results.forEach { quote in
            if quote.symbol == symbol {
                quote.logo = logo
            }
        }
        saveContext()
        
    }
    
    func saveLogoImageToCoreData(symbol: String, image: UIImage?) {
        guard let image = image else { return }
        let request : NSFetchRequest<Quote> = Quote.fetchRequest()
        request.returnsObjectsAsFaults = false
        let results = try! context.fetch(request)
        
        results.forEach { quote in
            if quote.symbol == symbol {
                quote.logoImage = image.jpegData(compressionQuality: 1)
            }
        }
        saveContext()
        
    }
    
    func saveToFavorites(model: Quote) {

        let quote = NSEntityDescription.insertNewObject(forEntityName: "FavoriteQuote", into: context)
        quote.setValue(model.longName, forKey: "longName")
        quote.setValue(model.currency, forKey: "currency")
        quote.setValue(model.symbol, forKey: "symbol")
        quote.setValue(model.logo, forKey: "logo")
        quote.setValue(model.logoImage, forKey: "logoImage")
        
        let fetchRequest : NSFetchRequest<FavoriteQuote> = FavoriteQuote.fetchRequestFavorite()
        if let results = try? context.fetch(fetchRequest) {
            for result in results {
                if result.symbol != model.symbol {
                    saveContext()
                }
            }
        }
    }
    
    // MARK: - Delete From Core Data
    
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

