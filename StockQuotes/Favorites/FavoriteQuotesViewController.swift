//
//  FavoriteQuotesViewController.swift
//  StockQuotes
//
//  Created by Ekaterina on 1.03.21.
//

import UIKit

class FavoriteQuotesViewController: UIViewController {

    var tableView = UITableView()
    let storeStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        favoriteQuotes = storeStack.loadFavoritesFromCoreData()
        self.tableView.reloadData()
                
    }

    // MARK: TableView
    
    func configureUI() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(FavoriteQuotesTableViewCell.self, forCellReuseIdentifier: "FavoriteQuotesCell")
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        view.addSubview(tableView)
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension FavoriteQuotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteQuotes.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteQuotesCell", for: indexPath)
        guard let cell = dequeuedCell as? FavoriteQuotesTableViewCell else { return dequeuedCell }
        cell.configure(with: favoriteQuotes[indexPath.row])
        let image = savedImages[favoriteQuotes[indexPath.row].symbol!]
        cell.companyImageView.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            storeStack.deleteFromFavorites(quote: favoriteQuotes[indexPath.row])
            favoriteQuotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
}
