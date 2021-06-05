//
//  ChartNetworkManager.swift
//  StockQuotes
//
//  Created by Ekaterina on 29.03.21.
//

import Foundation
import Alamofire

final class ChartNetworkManager {
    
    func getChart(ticker: String, to: requestType, completion: @escaping ()->()) {
        
        var resolution = "D"
        let today = Date()
        request = to
        
        var dayFrom = TimeInterval()
        var dayTo = TimeInterval()
        
        switch to {
        case .month:
            resolution = "W"
            dayFrom = today.startOfMonth.timeIntervalSince1970
            dayTo = today.endOfMonth.timeIntervalSince1970
        case .week:
            resolution = "D"
            dayFrom = today.startOfWeek(using: Calendar.current).timeIntervalSince1970
            dayTo = today.timeIntervalSince1970
        case .year:
            let year = Calendar.current.component(.year, from: Date())
            let firstDayOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1))!

            dayFrom = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))!.timeIntervalSince1970
            dayTo = Calendar.current.date(byAdding: .day, value: -1, to: firstDayOfNextYear)!.timeIntervalSince1970
            resolution = "M"
    }

        let url = URL(string: "https://finnhub.io/api/v1/stock/candle?symbol=\(ticker)&resolution=\(resolution)&from=\(Int(dayFrom))&to=\(Int(dayTo))&token=\(finnhubToken)")!
        
        
        AF.request(url).responseData { (response) in
            guard let data = response.value else { return }
            let decoder = JSONDecoder()
            do {
                if let value = try decoder.decode(ModelForChart.self, from: data).c {
                    valueChartArray = value
                }
                if let time = try decoder.decode(ModelForChart.self, from: data).t {
                    createTimeChartArray(from: time)
                }
                completion()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        
    }
}
