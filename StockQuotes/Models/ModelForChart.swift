//
//  ModelForChart.swift
//  StockQuotes
//
//  Created by Ekaterina on 29.03.21.
//

import Foundation
import Charts

var request: requestType!

enum requestType {
    case week
    case month
    case year
}

var dateChartArray : [String] = []
var valueChartArray : [Float] = []

func createChartDataArray() -> [ChartDataEntry] {
    var counter = 0
    var dataArray : [ChartDataEntry] = []
    
    for dayValue in valueChartArray {
        let dataElement = ChartDataEntry(x: Double(counter), y: Double(dayValue))
        dataArray.append(dataElement)
        counter += 1
    }
    
    return dataArray
}

func createTimeChartArray(from: [Int]) {
    dateChartArray.removeAll()
    let df = DateFormatter()
    
    for element in from {
        let dateDay = Date(timeIntervalSince1970: TimeInterval.init(element))
        
        if request == requestType.year {
            df.dateFormat = "MMM"
            dateChartArray.append(df.string(from: dateDay))
        }
        else if request == requestType.month {
            df.dateFormat = "dd"
            dateChartArray.append(df.string(from: dateDay))
        }
        else if request == requestType.week {
            dateChartArray.append(dateDay.nameOfDay())
        }
    }
}

struct ModelForChart : Codable {

        let c : [Float]?
        let h : [Float]?
        let l : [Float]?
        let o : [Float]?
        let s : String?
        let t : [Int]?
        let v : [Int]?

        enum CodingKeys: String, CodingKey {
                case c = "c"
                case h = "h"
                case l = "l"
                case o = "o"
                case s = "s"
                case t = "t"
                case v = "v"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                c = try values.decodeIfPresent([Float].self, forKey: .c)
                h = try values.decodeIfPresent([Float].self, forKey: .h)
                l = try values.decodeIfPresent([Float].self, forKey: .l)
                o = try values.decodeIfPresent([Float].self, forKey: .o)
                s = try values.decodeIfPresent(String.self, forKey: .s)
                t = try values.decodeIfPresent([Int].self, forKey: .t)
                v = try values.decodeIfPresent([Int].self, forKey: .v)
        }

}
