//
//  NetworkManager.swift
//  StockQuotes
//
//  Created by Ekaterina on 25.02.21.
//

import Foundation
import Alamofire
import CoreData

let finnhubToken = "c0tnocv48v6qoe9bkvlg"
var savedImages : [String:UIImage] = [:]
var price: [String:Float] = [:]
var priceChange: [String:Float] = [:]

final class NetworkManager {
    
    func loadData() {
         let url = URL(string: "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=\(finnhubToken)")!
            
        AF.request(url).responseData { [weak self] (response) in
            guard let data = response.value else { return }
            let decoder = JSONDecoder()
            do {
                let parsed = try decoder.decode([Model].self, from: data)
                self?.saveToCoreData(models: parsed)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func getLogo(quote: Quote) {
        guard let symbol = quote.symbol else { return }
            AF.request("https://finnhub.io/api/v1/stock/profile2?symbol=\(symbol.uppercased())&token=\(finnhubToken)").responseData { (response) in
                guard let data = response.value else { return }
                let decoder = JSONDecoder()
                do {
                    if let logo = try decoder.decode(Model.self, from: data).logo {
                        self.saveLogoToCoreData(symbol: symbol, logo: logo)
                        self.downloadLogo(symbol: symbol, logo: logo)
                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        
    }
        
    func downloadLogo(symbol: String, logo: String) {
        AF.request(logo).response { (data) in
            if let dataImg = data.data {
                let image = UIImage(data: dataImg)
                savedImages[symbol] = image
            }
        }
    }
    
    func getQuotes(quote: Quote) {
        guard let symbol = quote.symbol else { return }
            AF.request("https://finnhub.io/api/v1/quote?symbol=\(symbol.uppercased())&token=\(finnhubToken)").responseData { (response) in
                guard let data = response.value else { return }
                let decoder = JSONDecoder()
                do {
                    if let current = try decoder.decode(Model.self, from: data).currentPrice,
                       let previouse = try decoder.decode(Model.self, from: data).previousClosePrice {
                        price[symbol] = current
                        priceChange[symbol] = current - previouse
                    }
//                    if let previouse = try decoder.decode(Model.self, from: data).previousClosePrice {
//                        prevPrice[symbol] = previouse
//                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
    }
    
    
    // MARK: Save to Core Data
    
    let storeStack = CoreDataStack()
    
    func saveToCoreData(models: [Model]) {
        let context = storeStack.context
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Quote")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
         try context.execute(deleteRequest)
        } catch {
            let nserror = error as NSError
            debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        models.forEach { model in
            let quote = NSEntityDescription.insertNewObject(forEntityName: "Quote", into: context)
            quote.setValue(model.longName, forKey: "longName")
            quote.setValue(model.currency, forKey: "currency")
            quote.setValue(model.symbol, forKey: "symbol")
        }
        storeStack.saveContext()
        
    }
    
    func saveLogoToCoreData(symbol: String, logo: String) {
        let context = storeStack.context
        
        let request : NSFetchRequest<Quote> = Quote.fetchRequest()
        request.returnsObjectsAsFaults = false
        let results = try! context.fetch(request)
        
        results.forEach { quote in
            if quote.symbol == symbol {
                quote.logo = logo
            }
        }
        storeStack.saveContext()
        
    }
    
}
