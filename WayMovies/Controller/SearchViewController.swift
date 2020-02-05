//
//  SearchViewController2.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/27/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    // The height of the search bar at the top of the screen
    private let searchBarHeight:CGFloat = 40
    
    // The list of search items retreived from the API
    private var searchItems = [TVItem]()
    
    
    // The collection which displays the list of search items
    private var searchCollection:SearchCollection = {
        let collection = SearchCollection()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    // The table which displays categorized search suggestions
    private let suggestionTable:UITableView = {
        let table = UITableView()
        table.rowHeight = 40
        table.separatorStyle = .singleLine
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        return table
    }()
    
    // The background of the view
    private let backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // The search bar on top of the screen under the navigation bar
    private let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // The navigation bar on top of the screen
    private func setUpNavBar() {
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: green]
        self.navigationController!.navigationBar.tintColor = translucent_green
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorites", style: .done, target: self, action: #selector(viewFavorites))
    }
    
    init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        setUpNavBar()
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createElementsAndConstraints()
        setUpDelegates()
    }
    
    /**
     Sets delegates
     */
    private func setUpDelegates() {
        searchBar.delegate = self
        searchCollection.navDelegate = self
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
        suggestionTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    /**
     Adds all elements to the subview and calls constraining helper methods.
     */
    private func createElementsAndConstraints() {
        view.addSubview(backgroundView)
        view.addSubview(searchBar)
        view.addSubview(searchCollection)
        view.addSubview(suggestionTable)
        suggestionTable.isHidden = true
        backgroundViewConstraints()
        searchBarConstraints()
        searchCollectionConstraints()
        suggestionTableConstraints()
    }
    
    /**
      Sets up constraints for the collection
    */
    private func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            searchCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchCollection.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    /**
      Sets up constraints for the background view
    */
    private func backgroundViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    /**
      Sets up constraints for the search bar
    */
    private func searchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight)
        ])
    }
    
    /**
      Sets up constraints for the background view
    */
    private func suggestionTableConstraints() {
        NSLayoutConstraint.activate([
            suggestionTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            suggestionTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            suggestionTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            suggestionTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /**
     Applies the results of the search call to the collection within this view
     `Parameter searchItems: The list of items retrieved from the API search`
     */
    func applySearch(searchItems: [TVItem]) {
        self.searchItems = searchItems
        searchCollection.applySearch(searchItems: searchItems)
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc func viewFavorites(sender: UIBarButtonItem) {
        navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
}

extension SearchViewController: NavigationDelegate {
    /**
     Called when the cell is tapped to navigate to the details page of the item
     */
    func cellTapped(_ item: TVItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    /**
     Searches TMDB based on the categorized search option selected
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.text == "" {
            return
            
            
        }
        switch indexPath.row {
        case 0:
            Request.searchMovie(searchTerms: searchBar.text!) { [weak self] result in
            switch result {
                 case .failure(let error):
                     print(error)
                 case .success(let items):
                    self?.searchCollection.applySearch(searchItems: items)
                 }
             }
            searchBar.text = ""
            suggestionTable.isHidden = true
        case 1:
            Request.searchShows(searchTerms: searchBar.text!) { [weak self] result in
            switch result {
                 case .failure(let error):
                     print(error)
                 case .success(let items):
                    self?.searchCollection.applySearch(searchItems: items)
                 }
             }
            searchBar.text = ""
            suggestionTable.isHidden = true
        case 2:
            Request.searchPeople(searchTerms: searchBar.text!) { [weak self] result in
            switch result {
                 case .failure(let error):
                     print(error)
                 case .success(let items):
                    self?.searchCollection.applySearch(searchItems: items)
                 }
             }
            searchBar.text = ""
            suggestionTable.isHidden = true
        default:
            searchBar.text = ""
            suggestionTable.isHidden = true
        }
    }
    
    /**
     Returns the number of suggested categorized search options
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /**
     Returns a tableview cell with a suggested categorized search
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! //1.
        cell.backgroundColor = .white
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "\(searchBar.text ?? "") in Movies"
        case 1:
            cell.textLabel?.text = "\(searchBar.text ?? "") in TV Shows"
        case 2:
            cell.textLabel?.text = "\(searchBar.text ?? "") in People"
        default:
            cell.textLabel?.text = "Enter Search Terms"
        }
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    /**
     Shows the categorized search suggestions when text is being edited and hides when editing stops
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            suggestionTable.reloadData()
            suggestionTable.isHidden = false
        } else {
            suggestionTable.isHidden = true
        }
    }
    
    /**
     Hides the suggestion table when the search cancel button is tapped
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        suggestionTable.isHidden = true
    }
    
    /**
     Searches the TMDB when the search button is clicked
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Request.searchMulti(searchTerms: searchBar.text!) { [weak self] result in
        switch result {
             case .failure(let error):
                 print(error)
             case .success(let items):
                self?.searchCollection.applySearch(searchItems: items)
             }
         }
        searchBar.text = ""
    }
}
