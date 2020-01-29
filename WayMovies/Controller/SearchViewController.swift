//
//  SearchViewController2.swift
//  WayMovies
//
//  Created by Hersh Nagpal on 1/27/20.
//  Copyright © 2020 Hersh Nagpal. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, NavigationDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let searchBarHeight:CGFloat = 30
    
    private var searchCollection:SearchCollection = {
        let collection = SearchCollection()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let suggestionTable:UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var searchItems = [TVItem]() {
        didSet {
            searchCollection.applySearch(searchItems: self.searchItems)
        }
    }
    
    func setUpNavBar() {
        self.navigationController!.navigationBar.barStyle = .black
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
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
    
    func setUpDelegates() {
        searchBar.delegate = self
        searchCollection.navDelegate = self
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
    }
    
    func createElementsAndConstraints() {
        view.addSubview(searchBar)
        view.addSubview(searchCollection)
        searchBarConstraints()
        searchCollectionConstraints()
    }
    
    func searchCollectionConstraints() {
        NSLayoutConstraint.activate([
            searchCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchCollection.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchCollection.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func searchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight)
        ])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Request.searchMulti(searchTerms: searchBar.text!) { [weak self] result in
        switch result {
             case .failure(let error):
                 print(error)
             case .success(let items):
                self?.searchCollection.applySearch(searchItems: items)
             }
         }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    func createSuggestionTable() {
        
    }
    
    func applySearch(searchItems: [TVItem]) {
        self.searchItems = searchItems
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func cellTapped(_ item: TVItem) {
        navigationController?.pushViewController(DetailViewController(item: item), animated: true)
    }
    
    @objc
    func viewFavorites(sender: UIBarButtonItem) {
        navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
}
