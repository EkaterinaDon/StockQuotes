//
//  NetworkManager.swift
//  StockQuotes
//
//  Created by Ekaterina on 25.02.21.
//

import Foundation
import CoreData

final class NetworkManager {
    
    let mboumApikey = "hw88SeMXOPZ30whU4PYqJXnAVBxpMXnLYyEYDsobkt2Mul5PizVtXhuhgw2u"
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionTask?
   
    let symbol = "AAPL,ENPH,NFLX,GM,TSLA,INTC,AAL,LLY,F,WFC,TWTR,VIAC,ETSY,FCX,AMAT,LRCX,KR,OXY,STX,DISCA,PXD,SLB,ALB,LUMN,MRO,FOXA,DVN,EOG,HAL,SIVB,CNC,LB,TER,IRM,FANG,GPS,AES,URI,KMX,APA,FITB,CFG,FTI,HES,INCY,MTB,PVH,NOV,FOX,ZION"
    
    
    func loadData(complition: @escaping ([Model]) -> Void) {
        dataTask?.cancel()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "mboum.com"
        urlComponents.path = "/api/v1/qu/quote/"
        urlComponents.queryItems = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "apikey", value: mboumApikey)
        ]
        
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    debugPrint("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                } else {
                    //let httpResponse = response as? HTTPURLResponse
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            let parsed = try decoder.decode([Model].self, from: data)
                            DispatchQueue.main.async {
                                self.saveToCoreData(models: parsed)
                                complition(parsed)
                            }
                        } catch {
                            debugPrint(error.localizedDescription)
                        }
                    }
                }
            })
            
            dataTask?.resume()
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
            quote.setValue(model.regularMarketDayLow, forKey: "regularMarketDayLow")
            quote.setValue(model.regularMarketDayLow, forKey: "regularMarketDayLow")
        }
        storeStack.saveContext()
        
    }
}

