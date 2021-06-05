//
//  FavoriteQuotesViewController.swift
//  StockQuotes
//
//  Created by Ekaterina on 1.03.21.
//

import UIKit

class FavoriteQuotesViewController: UIViewController {

    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }

    // MARK: TableView
    
    func configureUI() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: "StocksTableViewCell")
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.rowHeight = 55.0
        
        view.addSubview(tableView)
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension FavoriteQuotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteQuotes.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "StocksTableViewCell", for: indexPath)
        guard let cell = dequeuedCell as? StocksTableViewCell else { return dequeuedCell }
        cell.configure(with: favoriteQuotes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let favorite = favoriteQuotes[indexPath.row]
            CoreDataStack.sharedInstance.context.delete(favorite)
            CoreDataStack.sharedInstance.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realTimeDataViewController = RealTimeDataViewController()
        realTimeDataViewController.quote = favoriteQuotes[indexPath.row]
        self.navigationController?.pushViewController(realTimeDataViewController, animated: true)
    }
    
    
}
