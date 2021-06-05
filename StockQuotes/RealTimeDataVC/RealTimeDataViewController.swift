//
//  RealTimeDataViewController.swift
//  StockQuotes
//
//  Created by Ekaterina on 5.05.21.
//

import UIKit

class RealTimeDataViewController: UIViewController {
    
    private var dataView: RealTimeDataViewModel {
        return self.view as! RealTimeDataViewModel
    }
    
    var webSocketConnection: WebSocketConnection!
    var quote: FavoriteQuote!
    var realTimeData: [Datum] = []
    var newPrice: String? {
        didSet {
            dataView.priceLabel.text = newPrice
        }
    }
    var time: String? {
        didSet {
            dataView.timeLabel.text = time
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        dataView.tickerLabel.text = "\(quote.symbol ?? "")"
        guard let image = quote.logoImage else { return }
        dataView.logoImageView.image = UIImage(data: image)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        webSocketConnection = WebSocketTaskConnection(url: URL(string: "wss://ws.finnhub.io?token=c0tnocv48v6qoe9bkvlg")!)
        webSocketConnection.delegate = self
        
        webSocketConnection.connect()
        if let symbol = quote.symbol {
            let string = "{\"type\":\"subscribe\",\"symbol\":\"\(symbol)\"}"
            webSocketConnection.send(text: string)
        }
    }
    
    override func loadView() {
        self.view = RealTimeDataViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webSocketConnection.disconnect()
    }
    
    func updatePrice() {
        DispatchQueue.main.async {
            if let newPrice = self.realTimeData.first?.p {
                self.newPrice = String(newPrice) + " USD"
            }
        }
    }
    
    func dateUpdate() {
        DispatchQueue.main.async {
            if let newDate = self.realTimeData.first?.t {
                self.time = self.convertDate(dateValue: newDate)
            }
        }
    }
    
    func convertDate(dateValue: Int) -> String {
        let truncatedTime = Int(dateValue / 1000)
        let date = Date(timeIntervalSince1970: TimeInterval(truncatedTime))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.string(from: date)
    }
    
}

extension RealTimeDataViewController: WebSocketConnectionDelegate {
    func onConnected(connection: WebSocketConnection) {
        debugPrint("Connected")
    }
    
    func onDisconnected(connection: WebSocketConnection, error: Error?) {
        if let error = error {
            debugPrint("Disconnected with error:\(error)")
        } else {
            debugPrint("Disconnected normally")
        }
    }
    
    func onError(connection: WebSocketConnection, error: Error) {
        debugPrint("Connection error:\(error)")
    }
    
    func onMessage(connection: WebSocketConnection, text: String) {
        do {
            let decoder = JSONDecoder()
            if let result = try decoder.decode(RealTimeDataModel.self, from: Data(text.utf8)).data {
                DispatchQueue.main.async {
                    self.realTimeData = result
                    self.updatePrice()
                    self.dateUpdate()
                    //debugPrint(self.realTimeData as Any)
                }
            }
        } catch  {
            debugPrint("error is \(error.localizedDescription)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.webSocketConnection.send(text: text)
        }
    }
    
    func onMessage(connection: WebSocketConnection, data: Data) {
        debugPrint("Data message: \(data)")
    }
}
