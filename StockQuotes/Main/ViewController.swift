//
//  ViewController.swift
//  StockQuotes
//
//  Created by Ekaterina on 23.02.21.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    let network = NetworkManager()
    var filteredQuotes: [Quote] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        network.loadData {
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: UI
    
    func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(showFavorites))
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.rowHeight = 55.0
        
        view.addSubview(tableView)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.scopeButtonTitles = ["Name", "Ticker"]
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    @objc func showFavorites() {
        let favoriteQuotesViewController = FavoriteQuotesViewController()
        navigationController?.pushViewController(favoriteQuotesViewController, animated: true)
    }
    
    // MARK: Search
    
    func filterByNamesForQuotes(_ searchText: String) {
        filteredQuotes = quotes.filter { (quote: Quote) -> Bool in
            return (quote.longName?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
    
    func filterByTickerForQuotes(_ searchText: String) {
        filteredQuotes = quotes.filter { (quote: Quote) -> Bool in
            return (quote.symbol?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isFiltering {
            return quotes.count
        } else {
            return filteredQuotes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let cell = dequeuedCell as? StocksTableViewCell else { return dequeuedCell }
        
        if !isFiltering {
            cell.configure(with: quotes[indexPath.row])
        } else {
            cell.configure(with: filteredQuotes[indexPath.row])
        }
        
        cell.favoriteButton.addTarget(self, action: #selector(addToFavorites(favoriteButton:)), for: .touchUpInside)
        return cell
    }
    
    @objc func addToFavorites(favoriteButton: UIButton) {
        
        guard let indexPath = tableView.indexPathForRow(at: favoriteButton.convert(favoriteButton.frame.origin, to: tableView)) else { return }
        
        if favoriteQuotes.contains(where: { $0.symbol == quotes[indexPath.row].symbol }) {
            favoriteButton.setImage(UIImage(named: "star"), for: .normal)
            let quoteToDelete = favoriteQuotes.filter { $0.symbol == quotes[indexPath.row].symbol }
            CoreDataStack.sharedInstance.context.delete(quoteToDelete.first!)
            CoreDataStack.sharedInstance.saveContext()
        } else {
            favoriteButton.setImage(UIImage(named: "choosedStar"), for: .normal)
            CoreDataStack.sharedInstance.saveToFavorites(model: quotes[indexPath.row])
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chartViewController = ChartViewController()
        chartViewController.quote = quotes[indexPath.row]
        self.navigationController?.pushViewController(chartViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        network.getLogo(quote: quotes[indexPath.row])
        network.getQuotes(quote: quotes[indexPath.row])
    }
}

// MARK: UISearchResultsUpdating

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if searchBar.selectedScopeButtonIndex == 0 {
            filterByNamesForQuotes(searchBar.text!)
        } else if searchBar.selectedScopeButtonIndex == 1 {
            filterByTickerForQuotes(searchBar.text!)
        }
    }
}

// MARK: UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
}
