//
//  NetworkManager.swift
//  StockQuotes
//
//  Created by Ekaterina on 25.02.21.
//

import Foundation
import Alamofire

let finnhubToken = "c0tnocv48v6qoe9bkvlg"
let mboumToken = "hw88SeMXOPZ30whU4PYqJXnAVBxpMXnLYyEYDsobkt2Mul5PizVtXhuhgw2u"
var price: [String:Float] = [:]
var priceChange: [String:Float] = [:]

final class NetworkManager {
    
//    func loadData(completion: @escaping ()->()) {
//         let url = URL(string: "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=\(finnhubToken)")!
//
//        AF.request(url).responseData { (response) in
//            guard let data = response.value else { return }
//            let decoder = JSONDecoder()
//            do {
//                let parsed = try decoder.decode([Model].self, from: data)
//                CoreDataStack.sharedInstance.saveToCoreData(models: parsed)
//                completion()
//            } catch {
//                debugPrint(error.localizedDescription)
//            }
//        }
//    }
   
    func loadData(completion: @escaping ()->()) {
         let urlMboum = URL(string: "https://mboum.com/api/v1/co/collections/?list=most_actives&start=1&apikey=\(mboumToken)")!
        AF.request(urlMboum).responseData { (response) in
            guard let data = response.value else { return }
            let decoder = JSONDecoder()
            do {
                if let parsed = try decoder.decode(MboumModel.self, from: data).mQuotes {
                    CoreDataStack.sharedInstance.saveToCoreData(models: parsed)
                    completion()
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func getLogo(quote: Quote) {
        guard let symbol = quote.symbol else { return }
        let url = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=\(symbol.uppercased())&token=\(finnhubToken)")!
            AF.request(url).responseData { [weak self] (response) in
                guard let data = response.value, let self = self else { return }
                let decoder = JSONDecoder()
                do {
                    if let logo = try decoder.decode(Model.self, from: data).logo {
                        CoreDataStack.sharedInstance.saveLogoToCoreData(symbol: symbol, logo: logo)
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
                CoreDataStack.sharedInstance.saveLogoImageToCoreData(symbol: symbol, image: image)
            }
        }
    }
    
    func getQuotes(quote: Quote) {
        guard let symbol = quote.symbol else { return }
            AF.request("https://finnhub.io/api/v1/quote?symbol=\(symbol.uppercased())&token=\(finnhubToken)").responseData { [weak self] (response) in
                guard let data = response.value, let self = self else { return }
                let decoder = JSONDecoder()
                do {
                    if let current = try decoder.decode(Model.self, from: data).currentPrice,
                       let previouse = try decoder.decode(Model.self, from: data).previousClosePrice {
                        price[symbol] = current
                        priceChange[symbol] = self.calculateChanges(current: current, previous: previouse)
                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
    }
    
    func calculateChanges(current: Float, previous: Float) -> Float {
        let result = ((current - previous)/previous)*100
        return result
    }
    
}
