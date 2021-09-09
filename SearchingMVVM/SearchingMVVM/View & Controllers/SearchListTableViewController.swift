//
//  SearchListTableViewController.swift
//  SearchingMVVM
//
//  Created by Ankita on 09.09.21.
//

import UIKit

class SearchListTableViewController: UITableViewController {
    private let cellId = "Cell"
    private let searchController = UISearchController()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    lazy var searchViewModel: AppSearchViewModel? = {
        AppSearchViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.title = "Search"
        self.view.backgroundColor = .black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.backgroundColor = .black
        
        setupSearchBar()
        setupLoadingIndicator()
        setupObserver()
        
    }
    
    fileprivate func setupObserver() {
        searchViewModel?.appResults.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        // control indicator behaviour
        searchViewModel?.isSearching.bind { [weak self] isSearching in
            guard let isSearching = isSearching else { return }
            DispatchQueue.main.async {
                isSearching ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.isHidden = !isSearching
            }
        }
    }
    
    fileprivate func setupLoadingIndicator() {
        loadingIndicator.color = .lightGray
        view.addSubview(loadingIndicator)
    }
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchViewModel?.appResults.value?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        cell.textLabel?.text = searchViewModel?.appResults.value?[indexPath.row].trackName
        cell.detailTextLabel?.text = searchViewModel?.appResults.value?[indexPath.row].description

        return cell
    }
}

extension SearchListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchViewModel?.performSearch(searchText)
    }
}
