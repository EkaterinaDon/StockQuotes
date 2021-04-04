//
//  ViewController.swift
//  StockQuotes
//
//  Created by Ekaterina on 23.02.21.
//

import UIKit

var favoriteQuotes: [FavoriteQuote] = []

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
    var model = [Model]()
    var favorites: [Quote] = []
    var quoteData = [Quote]()
    var filteredQuotes: [Quote] = []
    
    let storeStack = CoreDataStack()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.loadData()
        favoriteQuotes = storeStack.loadFavoritesFromCoreData()
    }
    
    // MARK: UI
    
    func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(showFavorites))
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
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
    
    // MARK: Load Data
    
    func loadData() {
        if defaults.bool(forKey: "FirstLaunch") == true {
            self.quoteData = storeStack.loadFromCoreData()
            network.loadData { [weak self] data in
                guard let self = self else { return }
                self.model = data
                //self.quoteData = self.storeStack.loadFromCoreData()
                self.tableView.reloadData()
            }
            defaults.setValue(true, forKey: "FirstLaunch")
        } else {
            print("FirstLaunch")
            network.loadData { [weak self] data in
                guard let self = self else { return }
                self.model = data
                self.tableView.reloadData()
            }
            defaults.setValue(true, forKey: "FirstLaunch")
        }
    }
    
    @objc func showFavorites() {
        let favoriteQuotesViewController = FavoriteQuotesViewController()
        navigationController?.pushViewController(favoriteQuotesViewController, animated: true)
    }
    
    // MARK: Search
    
    func filterByNamesForQuotes(_ searchText: String) {
        filteredQuotes = quoteData.filter { (quote: Quote) -> Bool in
            return (quote.longName?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
    
    func filterByTickerForQuotes(_ searchText: String) {
        filteredQuotes = quoteData.filter { (quote: Quote) -> Bool in
            return (quote.symbol?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if defaults.bool(forKey: "FirstLaunch") == true && !isFiltering {
            return quoteData.count
        } else if isFiltering {
            return filteredQuotes.count
        } else {
            return model.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let cell = dequeuedCell as? StocksTableViewCell else { return dequeuedCell }
        
        if defaults.bool(forKey: "FirstLaunch") == true && !isFiltering {
            cell.configure(with: quoteData[indexPath.row])
        } else if isFiltering {
            cell.configure(with: filteredQuotes[indexPath.row])
        } else {
            cell.configure(with: model[indexPath.row])
        }
        
        cell.favoriteButton.addTarget(self, action: #selector(addToFavorites(favoriteButton:)), for: .touchUpInside)
        return cell
    }
    
    @objc func addToFavorites(favoriteButton: UIButton) {
        
        guard let indexPath = tableView.indexPathForRow(at: favoriteButton.convert(favoriteButton.frame.origin, to: tableView)) else { return }
        
//        if favoriteButton.isSelected == true {
//            favoriteButton.isSelected = false
//            storeStack.deleteFromFavoritesForButton(quote: quoteData[indexPath.row])
//        } else {
//            favoriteButton.isSelected = true
//            if defaults.bool(forKey: "FirstLaunch") == true {
//                storeStack.saveToFavorites(model: quoteData[indexPath.row])
//            } else {
//                storeStack.saveToFavoritesFirstLaunch(model: model[indexPath.row])
//            }
//        }
       // favoriteQuotes = storeStack.loadFavoritesFromCoreData()
        
        if favoriteQuotes.contains(where: { $0.symbol == quoteData[indexPath.row].symbol }) {
            favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
            favoriteQuotes = favoriteQuotes.filter { $0.symbol == quoteData[indexPath.row].symbol }
            storeStack.deleteFromFavoritesForButton(quote: quoteData[indexPath.row])
        } else {
            favoriteButton.setImage(UIImage(named: "filledHeart"), for: .normal)
            storeStack.saveToFavorites(model: quoteData[indexPath.row])
        }
        favoriteQuotes = storeStack.loadFavoritesFromCoreData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chartViewController = ChartViewController()
        chartViewController.quote = quoteData[indexPath.row]
        self.navigationController?.pushViewController(chartViewController, animated: true)
    }
}

// MARK: UISearchResultsUpdating

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if searchBar.selectedScopeButtonIndex == 0 {
            filterByNamesForQuotes(searchBar.text!)
        }
        filterByTickerForQuotes(searchBar.text!)
    }
}

// MARK: UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
}
